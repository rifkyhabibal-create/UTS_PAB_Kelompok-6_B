import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final double headerHeight;

  const AppBackground({super.key, required this.child, this.headerHeight = 220});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: AppColors.background)),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: headerHeight,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, AppColors.tealDark, AppColors.teal],
                ),
              ),
              child: CustomPaint(
                painter: _GelombangPainter(),
                size: Size.infinite,
              ),
            ),
          ),
        ),

        Positioned.fill(child: child),
      ],
    );
  }
}

class _GelombangPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width * 0.92, 0), 100,
        Paint()..color = const Color(0x0FFFFFFF));

    for (int i = 0; i < 3; i++) {
      final garis = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Color.fromRGBO(255, 255, 255, 0.10 + i * 0.04);
      final y = size.height * (0.50 + i * 0.13);
      final jalur = Path()
        ..moveTo(0, y)
        ..cubicTo(size.width * 0.25, y - 36, size.width * 0.55, y + 36,
            size.width, y - 14);
      canvas.drawPath(jalur, garis);
    }

    final kuning = Paint()..color = const Color(0xFFF6D042);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(24, size.height - 20, 44, 4),
        const Radius.circular(2),
      ),
      kuning,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
