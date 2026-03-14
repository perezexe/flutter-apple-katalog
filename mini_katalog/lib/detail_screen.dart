import 'package:flutter/material.dart';

import 'product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(product.image, height: 300),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("\$${product.price}", style: const TextStyle(fontSize: 20, color: Colors.green)),
                  const SizedBox(height: 20),
                  Text(product.description),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ürün sepete eklendi!")),
                      );
                    },
                    child: const Text("Sepete Ekle"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
