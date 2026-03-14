
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  // Dokümandaki Day 4: fromJson mantığı
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'] ?? json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}