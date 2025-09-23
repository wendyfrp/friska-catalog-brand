import 'package:flutter/material.dart';

class DetailBajuPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const DetailBajuPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = item["color"] ?? Colors.blue;
    final Gradient gradient = LinearGradient(
      colors: [
        bgColor.withOpacity(0.7),
        Colors.white.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(item["nama"] ?? ""),
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: bgColor.withOpacity(0.08),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withOpacity(0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    item["foto"] ?? "",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported, size: 100, color: bgColor),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                item["nama"] ?? "",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: bgColor,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: bgColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item["deskripsi"] ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}