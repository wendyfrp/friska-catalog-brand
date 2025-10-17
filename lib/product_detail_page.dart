// lib/product_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Ganti dengan path file yang sesuai di proyek Anda
import 'models/product_model.dart';
import 'providers/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.imageUrl,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: double.infinity,
                    height: 260,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // title / category / rating
            Text(product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(product.category, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(width: 12),
                const Icon(Icons.star, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                Text('${product.rating} • ${product.reviews}', style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 16),

            // price
            Text('Rp ${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 16),

            // description
            const Text('Keterangan Produk', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              product.description, // <-- BAGIAN INI TELAH DIUBAH
              style: const TextStyle(color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 24),

            // add to cart + buy now
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditambahkan ke wishlist')));
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Wishlist'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).add(product);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.title} ditambahkan ke keranjang')));
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Tambah ke Keranjang'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).add(product);
                  Navigator.pushNamed(context, '/checkout');
                },
                child: const Text('Beli Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}