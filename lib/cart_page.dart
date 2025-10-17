import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'models/product_model.dart';
import 'checkout_page.dart'; // <-- import the CheckoutPage

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // local quantities per index (keeps UI responsive without changing provider)
  final Map<int, int> _quantities = {};

  int _getQty(int index) => _quantities[index] ?? 1;

  void _setQty(int index, int value) {
    setState(() {
      _quantities[index] = value.clamp(1, 999);
    });
  }

  double _calcSubtotal(List<Product> items) {
    double sum = 0;
    for (var i = 0; i < items.length; i++) {
      final qty = _getQty(i);
      sum += items[i].price * qty;
    }
    return sum;
  }

  String _formatPrice(double v) {
    // simple format, adjust as needed
    return 'IDR ${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      final items = cart.items;
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Keranjang', style: TextStyle(color: Colors.black87)),
          foregroundColor: Colors.black87,
        ),
        body: items.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    const Text('Keranjang Anda masih kosong', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: items.length + 1, // items + voucher row
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index < items.length) {
                            final product = items[index];
                            final qty = _getQty(index);
                            return _CartItemCard(
                              product: product,
                              qty: qty,
                              onQtyChanged: (newQty) => _setQty(index, newQty),
                              onRemove: () {
                                cart.remove(product);
                                // shift quantities map keys down after removal
                                setState(() {
                                  final newMap = <int, int>{};
                                  int j = 0;
                                  for (var i = 0; i < items.length; i++) {
                                    if (i == index) continue;
                                    newMap[j] = _quantities[i] ?? 1;
                                    j++;
                                  }
                                  _quantities
                                    ..clear()
                                    ..addAll(newMap);
                                });
                              },
                            );
                          } else {
                            // Voucher row
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: const Icon(Icons.confirmation_num_outlined, color: Colors.black54),
                                title: const Text('Punya voucher?'),
                                subtitle: const Text('Gunakan voucher untuk dapat potongan harga'),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () {
                                  // open voucher page if available
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Halaman voucher belum diimplementasi')));
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Summary box
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 6)),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Product', style: TextStyle(color: Colors.grey.shade600)),
                              Text('${items.length} items', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subtotal', style: TextStyle(color: Colors.grey.shade600)),
                              Text(_formatPrice(_calcSubtotal(items)), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(_formatPrice(_calcSubtotal(items)), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDDB24A),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}

class _CartItemCard extends StatelessWidget {
  final Product product;
  final int qty;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.product,
    required this.qty,
    required this.onQtyChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final double originalPrice = product.price * 1.0;
    final double discountedPrice = product.price; // adapt if you have discount logic

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.imageUrl,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(width: 84, height: 84, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      GestureDetector(onTap: onRemove, child: const Icon(Icons.close, size: 20, color: Colors.black45)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Volume : -', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // price column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IDR ${originalPrice.toStringAsFixed(0)}',
                            style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade500, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text('IDR ${discountedPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        ],
                      ),

                      // qty controls
                      Container(
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => onQtyChanged((qty - 1).clamp(1, 999)),
                              icon: const Icon(Icons.remove, size: 18),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              constraints: const BoxConstraints(),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: Text(qty.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            IconButton(
                              onPressed: () => onQtyChanged((qty + 1).clamp(1, 999)),
                              icon: const Icon(Icons.add, size: 18),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}