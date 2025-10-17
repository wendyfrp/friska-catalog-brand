import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'order_confirmed_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPayment = 'MasterCard';
  int _selectedShippingIndex = 0;
  double _voucherDiscount = 0.0;

  final List<Map<String, dynamic>> _shippingOptions = [
    {'label': 'Standard (3-5 hari)', 'fee': 12000.0},
    {'label': 'Express (1-2 hari)', 'fee': 30000.0},
  ];

  String _format(double v) => 'IDR ${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final subtotal = cart.totalPrice;
    final shippingFee = _shippingOptions[_selectedShippingIndex]['fee'] as double;
    final total = subtotal + shippingFee - _voucherDiscount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text('Checkout', style: TextStyle(color: Colors.black87)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Address card
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('Rumah Kedua (+6281234567899)\nJalan Bunga No 7, RT 02 RW 01\nKOTA BARU\nJAWA BARAT\nINDONESIA, 12345'),
                        ],
                      ),
                    ),
                    TextButton(onPressed: () {
                      // buka halaman edit alamat / profile jika ada
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit alamat belum diimplementasi')));
                    }, child: const Text('Edit')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Shipping options
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: const Text('Shipping Options'),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {}, // optional expand
                  ),
                  const Divider(height: 1),
                  ...List.generate(_shippingOptions.length, (i) {
                    final opt = _shippingOptions[i];
                    return RadioListTile<int>(
                      value: i,
                      groupValue: _selectedShippingIndex,
                      onChanged: (v) => setState(() => _selectedShippingIndex = v ?? 0),
                      title: Text(opt['label']),
                      secondary: Text(_format(opt['fee'] as double)),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Voucher row
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.confirmation_num_outlined),
                title: const Text('Voucher'),
                subtitle: Text(_voucherDiscount > 0 ? '-${_format(_voucherDiscount)}' : 'Punya voucher?'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  // contoh input voucher sederhana
                  final code = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      final ctrl = TextEditingController();
                      return AlertDialog(
                        title: const Text('Masukkan kode voucher'),
                        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'KODEVOUCHER')),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                          TextButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('Gunakan')),
                        ],
                      );
                    },
                  );
                  if (code != null && code.isNotEmpty) {
                    // demo: kalau kode = "DISKON12" beri potongan 12000
                    setState(() {
                      if (code.toUpperCase() == 'DISKON12') _voucherDiscount = 12000.0;
                      else _voucherDiscount = 0.0;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voucher diterapkan')));
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // Payment methods
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(leading: const Icon(Icons.credit_card_outlined), title: const Text('Payment Methods'), trailing: const Text('View more')),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    value: 'MasterCard',
                    groupValue: _selectedPayment,
                    onChanged: (v) => setState(() => _selectedPayment = v ?? _selectedPayment),
                    title: Row(children: [
                      // simple icon placeholder
                      Container(width: 36, height: 20, color: Colors.red, margin: const EdgeInsets.only(right: 8)),
                      const Text('MasterCard'),
                    ]),
                  ),
                  RadioListTile<String>(
                    value: 'PayPal',
                    groupValue: _selectedPayment,
                    onChanged: (v) => setState(() => _selectedPayment = v ?? _selectedPayment),
                    title: Row(children: [
                      Container(width: 36, height: 20, color: Colors.blue, margin: const EdgeInsets.only(right: 8)),
                      const Text('PayPal'),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Summary
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _buildSummaryRow('Subtotal', _format(subtotal)),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Shipping', _format(shippingFee)),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Voucher Applied', '-${_format(_voucherDiscount)}', valueColor: Colors.red),
                    const Divider(height: 18),
                    _buildSummaryRow('TOTAL PAYMENT', _format(total), isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Place order
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: subtotal <= 0
                    ? null
                    : () {
                        // simple place order flow: clear cart and show success
                        showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Konfirmasi Pesanan'),
                            content: const Text('Lanjutkan proses pembayaran?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(c), child: const Text('Batal')),
                              TextButton(
                                onPressed: () {
                                  // clear cart lalu buka halaman konfirmasi pesanan
                                  Provider.of<CartProvider>(context, listen: false).clear();
                                  Navigator.pop(c); // tutup dialog
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const OrderConfirmedPage()),
                                  );
                                },
                                child: const Text('Place Order'),
                              ),
                            ],
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDDB24A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Place Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: valueColor ?? Colors.black)),
      ],
    );
  }
}