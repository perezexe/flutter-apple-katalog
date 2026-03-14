import 'package:flutter/material.dart';

import 'cart_service.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;
  const PaymentScreen({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ödeme Sayfası")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Toplam Tutar:", style: TextStyle(fontSize: 18)),
            Text('₺${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: "Kart Üzerindeki İsim", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(labelText: "Kart Numarası", border: OutlineInputBorder(), hintText: "**** **** **** ****")),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, 
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  CartService.clear();
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Başarılı!"),
                      content: const Text("Ödemeniz alınmıştır. Teşekkür ederiz."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                          child: const Text("Ana Sayfaya Dön"),
                        )
                      ],
                    ),
                  );
                }, 
                child: const Text("Şimdi Öde", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}