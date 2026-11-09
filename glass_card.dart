import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double opacity; 
  final bool blur; 
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 22,
    this.opacity = 0.7,
    this.blur = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bentuk = BorderRadius.circular(radius);

    Widget isi = Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, opacity),
        borderRadius: bentuk,
        border: Border.all(color: const Color(0xCCFFFFFF)),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: bentuk,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    if (blur) {
      isi = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: isi,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: bentuk,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0B3A4F),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: bentuk, child: isi),
    );
  }
}
