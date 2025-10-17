import 'package:flutter/material.dart';

enum StarAnimationType { bounce, scale, fade }

class AnimatedStarRating extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double>? onRatingChanged;
  final StarAnimationType animationType;
  final int starCount;
  const AnimatedStarRating({
    super.key,
    this.initialRating = 0,
    this.onRatingChanged,
    this.animationType = StarAnimationType.scale,
    this.starCount = 5,
  });

  @override
  State<AnimatedStarRating> createState() => _AnimatedStarRatingState();
}

class _AnimatedStarRatingState extends State<AnimatedStarRating> {
  late double _rating;
  int? _pressedIndex;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  void _setRating(int index) {
    setState(() {
      _rating = index.toDouble();
      _pressedIndex = index;
    });
    widget.onRatingChanged?.call(_rating);
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _pressedIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (i) {
        final index = i + 1;
        final filled = index <= _rating;
        final isPressed = _pressedIndex == index;
        final scale = isPressed ? 1.4 : 1.0;
        Widget star = Icon(
          filled ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 28,
        );

        switch (widget.animationType) {
          case StarAnimationType.bounce:
            star = AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 350),
              curve: Curves.elasticOut,
              child: star,
            );
            break;
          case StarAnimationType.scale:
            star = AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: star,
            );
            break;
          case StarAnimationType.fade:
            star = AnimatedOpacity(
              opacity: isPressed ? 0.6 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: star,
            );
            break;
        }

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _setRating(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            alignment: Alignment.center,
            child: star,
          ),
        );
      }),
    );
  }
}

// helper builder untuk menampilkan bar rating + label
Widget _buildRatingRow(String label, StarAnimationType animationType) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      AnimatedStarRating(
        initialRating: 3.0,
        animationType: animationType,
        onRatingChanged: (rating) {
          // bisa disimpan / diproses jika perlu
        },
      ),
      const SizedBox(height: 24),
    ],
  );
}

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
         
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.78,
            ),
            child: SingleChildScrollView(
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

                  const SizedBox(height: 18),
                  _buildRatingRow("Rating Produk", StarAnimationType.bounce),
                  const SizedBox(height: 8), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}