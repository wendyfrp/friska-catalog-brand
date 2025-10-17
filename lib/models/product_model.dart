// lib/models/product_model.dart

class Product {
  final String imageUrl;
  final String category;
  final String title;
  final String description; // Properti deskripsi ditambahkan
  final double rating;
  final String reviews;
  final double price;
  bool isFavorited;

  Product({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.description, // Ditambahkan di constructor
    required this.rating,
    required this.reviews,
    required this.price,
    this.isFavorited = false,
  });
}