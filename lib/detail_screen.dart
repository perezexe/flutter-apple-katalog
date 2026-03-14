import 'package:flutter/material.dart';

import 'cart_service.dart';
import 'favorites_service.dart';
import 'product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          ValueListenableBuilder<Set<int>>(
            valueListenable: FavoritesService.instance.favorites,
            builder: (context, favorites, child) {
              final isFavorite = favorites.contains(product.id);
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  FavoritesService.instance.toggleFavorite(product.id);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 240,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 240,
                  color: Colors.black12,
                  child: const Center(child: Icon(Icons.image, size: 64)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(product.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('₺${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, color: Colors.orange)),
            const SizedBox(height: 18),
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(product.description, style: const TextStyle(fontSize: 16)),
            if (product.specs.isNotEmpty) ...[
              const SizedBox(height: 18),
              const Text('Specifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...product.specs.map(
                (spec) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 18, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(child: Text(spec, style: const TextStyle(fontSize: 15, color: Colors.black87))),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  CartService.add(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product added to cart')),
                  );
                },
                child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
