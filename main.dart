import 'package:flutter/material.dart';
import 'screens/pilih_peran_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RuangKuApp());
}

class RuangKuApp extends StatelessWidget {
  const RuangKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuangKu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const PilihPeranScreen(),
    );
  }
}
