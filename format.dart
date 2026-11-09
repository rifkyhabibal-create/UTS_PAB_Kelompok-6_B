import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const List<String> namaBulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];
const List<String> bulanSingkat = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];
const List<String> bulanRomawi = [
  'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII'
];

String formatJam(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

String formatTanggal(DateTime d) =>
    '${d.day} ${bulanSingkat[d.month - 1]} ${d.year}';

DateTime hanyaTanggal(DateTime d) => DateTime(d.year, d.month, d.day);

int menit(TimeOfDay t) => t.hour * 60 + t.minute;

String normalisasi(String s) =>
    s.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

void tampilSnack(BuildContext context, String pesan, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(pesan),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? AppColors.ditolak : AppColors.navy,
      ),
    );
}
