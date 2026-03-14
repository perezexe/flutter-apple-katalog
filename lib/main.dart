import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// API üzerinden veri çekebilmek için http paketini projeye dahil ettim.
import 'package:http/http.dart' as http; 

import 'cart_screen.dart';
import 'cart_service.dart';
import 'cart_item.dart';
import 'detail_screen.dart';
import 'favorites_service.dart';
import 'payment_screen.dart';
import 'product_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const ProductListScreen(),
        '/cart': (context) => const CartScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final product = settings.arguments as Product;
          return MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product));
        }

        if (settings.name == '/payment') {
          final total = settings.arguments as double;
          return MaterialPageRoute(builder: (_) => PaymentScreen(totalAmount: total));
        }

        return null;
      },
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String searchQuery = '';
  bool showFavoritesOnly = false;

  late final Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // Sayfa yüklenirken internetten veri çekme işlemini başlatıyorum.
    _productsFuture = _loadProducts(); 
  }

  // Ürünleri artık yerel (assets) dosyadan değil, canlı API üzerinden çekiyorum.
  Future<List<Product>> _loadProducts() async {
    try {
      final url = Uri.parse('https://wantapi.com/products.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        
        // API'den dönen JSON yapısını kontrol edip, listeyi güvenli bir şekilde alıyorum.
        List<dynamic> rawList =[];
        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          rawList = decoded['data'];
        }

        // Gelen raw (ham) verileri kendi oluşturduğum Product modelime map'liyorum.
        return rawList.map((e) {
          final apiMap = e as Map<String, dynamic>;
          
          return Product.fromJson({
            // Modelim ID'yi int bekliyor ama API string döndüğü için tip dönüşümü uyguladım.
            'id': int.tryParse(apiMap['id'].toString()) ?? 0,
            
            // API'deki "name" alanını, kendi mimarimdeki "title" alanına eşitledim.
            'title': apiMap['name'] ?? 'İsimsiz Ürün',
            
            // Fiyat bilgisini güvenli bir şekilde double türüne parse ediyorum.
            'price': double.tryParse(apiMap['price'].toString()) ?? 0.0,
            
            // Resim URL'sini doğrudan atıyorum.
            'image': apiMap['image'] ?? '',
            
            // API'de açıklama kısmı boş gelebileceği için detay ekranında çökme olmasın
            // diye varsayılan bir description metni ekledim.
            'description': apiMap['description'] ?? 'Bu ürün için henüz bir açıklama girilmemiş.',
          });
        }).toList();

      } else {
        throw Exception('Sunucu Hatası: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Olası bir internet kesintisinde uygulamanın çökmesini engellemek için hatayı yakalıyorum.
      throw Exception('Bağlantı kurulamadı, lütfen internetinizi kontrol edin.');
    }
  }

  List<Product> _filteredProducts(List<Product> products, Set<int> favorites) {
    var list = products;
    if (showFavoritesOnly) {
      list = list.where((p) => favorites.contains(p.id)).toList();
    }
    if (searchQuery.isEmpty) return list;
    return list
        .where((item) => item.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        actions:[
          IconButton(
            icon: Icon(showFavoritesOnly ? Icons.favorite : Icons.favorite_border),
            onPressed: () => setState(() => showFavoritesOnly = !showFavoritesOnly),
            tooltip: showFavoritesOnly ? 'Show all products' : 'Show favorites only',
          ),
          ValueListenableBuilder<List<CartItem>>(
            valueListenable: CartService.items,
            builder: (context, cartItems, child) {
              return IconButton(
                icon: Badge(label: Text(CartService.totalQuantity.toString()), child: const Icon(Icons.shopping_bag_outlined)),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          final products = snapshot.data ??[];
          return ValueListenableBuilder<Set<int>>(
            valueListenable: FavoritesService.instance.favorites,
            builder: (context, favorites, child) {
              final filteredProducts = _filteredProducts(products, favorites);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text('Find your perfect device.', style: TextStyle(fontSize: 18, color: Colors.black54)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search products',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onChanged: (value) => setState(() => searchQuery = value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children:[
                            Image.asset('assets/images/banner.png', fit: BoxFit.cover, height: 140, width: double.infinity,
                              errorBuilder: (c,e,s) => Container(color: Colors.blueGrey, height: 140),
                            ),
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors:[Colors.black.withAlpha((0.35 * 255).round()), Colors.black.withAlpha((0.05 * 255).round())],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const[
                                  Text('GIFT STORE', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text('%20 İNDİRİM', style: TextStyle(color: Colors.white70, fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Products', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    if (filteredProducts.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            showFavoritesOnly
                                ? 'No favorite products found.'
                                : 'No products match your search.',
                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.66,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _ProductCard(product: product);
                        },
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: product),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children:[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.black12,
                        child: const Center(child: Icon(Icons.broken_image, size: 34)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: ValueListenableBuilder<Set<int>>(
                      valueListenable: FavoritesService.instance.favorites,
                      builder: (context, favorites, child) {
                        final isFavorite = favorites.contains(product.id);
                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => FavoritesService.instance.toggleFavorite(product.id),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  // API'den gelen uzun isimlerin kart tasarımını (UI) bozmaması için
                  // maxLines sınırlandırması ve ellipsis (üç nokta) kullandım.
                  Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('₺${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}