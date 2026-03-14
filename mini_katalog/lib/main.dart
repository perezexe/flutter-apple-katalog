import 'package:flutter/material.dart';

import 'detail_screen.dart';
import 'product_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  // Örnek Veri (Normalde API'den gelecek)
  final List<Map<String, dynamic>> dummyData = const [
    {
      "id": 1,
      "title": "AirPods Pro",
      "price": 249.0,
      "description": "Gürültü engelleme özellikli kulaklık.",
      "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"
    },
    // Buraya daha fazla ürün eklenebilir
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Discover")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Yan yana 2 kart (Dokümandaki gibi)
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: dummyData.length,
        itemBuilder: (ctx, i) {
          final product = Product.fromJson(dummyData[i]);
          return GestureDetector(
            onTap: () {
              // Day 3: Navigasyon ve Argument taşıma
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(child: Image.network(product.image, fit: BoxFit.contain)),
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("\$${product.price}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}