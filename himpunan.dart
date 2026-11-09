
import 'package:flutter/material.dart';

enum Himpunan {
  himasi('HIMASI', Color(0xFF7DD3FC)), // biru muda
  himatenlis('HIMATENLIS', Color(0xFF111827)), // hitam
  himaben('HIMABEN', Color(0xFFDC2626)), // merah
  himaka('HIMAKA', Color(0xFF8B5E3C)), // coklat
  hme('HME', Color(0xFF1E3A8A)), // biru tua
  hmi('HMI', Color(0xFF16A34A)); // hijau

  final String nama;
  final Color warna;
  const Himpunan(this.nama, this.warna);
}
