import 'package:flutter/material.dart';
import '../models/peminjaman.dart';

class StatusBadge extends StatelessWidget {
  final StatusPengajuan status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.warna.withAlpha(40), 
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color.lerp(status.warna, Colors.black, 0.35), 
        ),
      ),
    );
  }
}
