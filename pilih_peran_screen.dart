import 'package:flutter/material.dart';
import '../models/himpunan.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import 'dashboard_admin_screen.dart';
import 'dashboard_himpunan_screen.dart';

class PilihPeranScreen extends StatefulWidget {
  const PilihPeranScreen({super.key});

  @override
  State<PilihPeranScreen> createState() => _PilihPeranScreenState();
}

class _PilihPeranScreenState extends State<PilihPeranScreen> {
  Himpunan? _dipilih; // null = belum memilih

  void _masukHimpunan() {
    if (_dipilih == null) {
      tampilSnack(context, 'Pilih himpunan terlebih dahulu', error: true);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardHimpunanScreen(himpunan: _dipilih!),
      ),
    );
  }

  void _masukAdmin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DashboardAdminScreen()),
    );
  }

  Widget _chipHimpunan(Himpunan h) {
    final terpilih = _dipilih == h;
    return GestureDetector(
      onTap: () => setState(() => _dipilih = h), 
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: terpilih ? h.warna.withAlpha(40) : const Color(0xB3FFFFFF),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: terpilih ? h.warna : const Color(0x33007A8C),
            width: terpilih ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: h.warna, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(h.nama,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        headerHeight: 290,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.bolt, size: 32, color: AppColors.navy),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RuangKu',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          Text('Institut Teknologi PLN',
                              style: TextStyle(fontSize: 13, color: Color(0xCCFFFFFF))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Peminjaman ruangan dan area kampus dalam satu aplikasi.',
                  style: TextStyle(fontSize: 13.5, color: Color(0xE6FFFFFF)),
                ),
                const SizedBox(height: 34),

                GlassCard(
                  opacity: 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.groups_2_outlined, color: AppColors.tealDark),
                          SizedBox(width: 8),
                          Text('Masuk sebagai Himpunan',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('Pilih himpunan Anda, lalu ajukan peminjaman tempat.',
                          style: TextStyle(fontSize: 12.5, color: AppColors.textSoft)),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: Himpunan.values.map(_chipHimpunan).toList(),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _masukHimpunan,
                        child: Text(_dipilih == null
                            ? 'Masuk sebagai Himpunan'
                            : 'Masuk sebagai ${_dipilih!.nama}'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                GlassCard(
                  opacity: 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.admin_panel_settings_outlined,
                              color: AppColors.tealDark),
                          SizedBox(width: 8),
                          Text('Masuk sebagai Admin Kampus',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                          'Pantau pemakaian tempat, tinjau pengajuan, dan terbitkan Nota Dinas.',
                          style: TextStyle(fontSize: 12.5, color: AppColors.textSoft)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy),
                        onPressed: _masukAdmin,
                        child: const Text('Masuk sebagai Admin'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text('UTS Pemrograman Aplikasi Bergerak · Kelompok 6',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSoft)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
