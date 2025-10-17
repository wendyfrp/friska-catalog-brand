// Lokasi file: lib/voucher_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/voucher_model.dart'; // Pastikan path ini benar

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Voucher> vouchers = [
      Voucher(
        title: 'Up to\n25% OFF',
        subtitle: 'Package discount coupon',
        code: 'ST-V2586',
        startColor: const Color(0xFFF96D5B),
        endColor: const Color(0xFFF44D3A),
      ),
      Voucher(
        title: 'Get up to\n40% OFF',
        subtitle: 'Discount on first order',
        code: 'FO-404030',
        startColor: const Color(0xFF0D5F45),
        endColor: const Color(0xFF193D31),
      ),
      Voucher(
        title: 'Up to\n15% OFF',
        subtitle: 'Package discount coupon',
        code: 'UP15-586',
        startColor: const Color(0xFF2E65B9),
        endColor: const Color(0xFF1E3A71),
      ),
      Voucher(
        title: 'Up to\n5% OFF',
        subtitle: 'Package discount coupon',
        code: 'UP5-E586',
        startColor: const Color(0xFF38A155),
        endColor: const Color(0xFF1D5A2E),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        return VoucherCard(voucher: vouchers[index]);
      },
    );
  }
}

class VoucherCard extends StatelessWidget {
  final Voucher voucher;

  const VoucherCard({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ClipPath(
        clipper: VoucherClipper(holeRadius: 10),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [voucher.startColor, voucher.endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                bottom: -40,
                child: Transform.rotate(
                  angle: -0.5,
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 180,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          voucher.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          voucher.subtitle,
                          style: TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: voucher.code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Kode "${voucher.code}" berhasil disalin!'),
                            backgroundColor: Colors.teal,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.content_copy, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              voucher.code,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherClipper extends CustomClipper<Path> {
  final double holeRadius;
  VoucherClipper({required this.holeRadius});
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - holeRadius, 0)
      ..arcToPoint(Offset(size.width, 0), clockwise: false, radius: const Radius.circular(1))
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);
    for (int i = 1; i <= 10; i++) {
      path.addOval(Rect.fromCircle(center: Offset(size.width * 0.7, (size.height / 11) * i), radius: 3));
    }
    path.close();
    path.fillType = PathFillType.evenOdd;
    return path;
  }
  @override
  bool shouldReclip(VoucherClipper oldClipper) => true;
}