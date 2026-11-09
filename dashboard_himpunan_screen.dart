import 'package:flutter/material.dart';
import '../data/data_store.dart';
import '../models/himpunan.dart';
import '../models/peminjaman.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/kalender_ruang.dart';
import '../widgets/place_picker.dart';
import '../widgets/status_badge.dart';
import 'form_peminjaman_screen.dart';

class DashboardHimpunanScreen extends StatefulWidget {
  final Himpunan himpunan; 
  const DashboardHimpunanScreen({super.key, required this.himpunan});

  @override
  State<DashboardHimpunanScreen> createState() =>
      _DashboardHimpunanScreenState();
}

class _DashboardHimpunanScreenState extends State<DashboardHimpunanScreen> {
  String? _kategori; 
  final TextEditingController _tempatCtrl = TextEditingController(); 

  @override
  void dispose() {
    _tempatCtrl.dispose(); 
    super.dispose();
  }

  Future<void> _ajukan() async {
    final berhasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPeminjamanScreen(himpunan: widget.himpunan),
      ),
    );
    if (!mounted) return;
    setState(() {}); 
    if (berhasil == true) {
      tampilSnack(context, 'Pengajuan terkirim. Status: Diajukan');
    }
  }

  Widget _header() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dashboard Himpunan',
                  style: TextStyle(fontSize: 12, color: Color(0xCCFFFFFF))),
              Text(widget.himpunan.nama,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ],
          ),
        ),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: widget.himpunan.warna,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _kartuPengajuan(Peminjaman p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        blur: false, 
        opacity: 0.8,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(p.acara,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                StatusBadge(status: p.status),
              ],
            ),
            const SizedBox(height: 6),
            Text('${formatTanggal(p.tanggal)} · ${p.jam}',
                style: const TextStyle(fontSize: 13)),
            Text(p.lokasi,
                style: const TextStyle(fontSize: 13, color: AppColors.textSoft)),

            if (p.status == StatusPengajuan.disetujui && p.nomorND != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withAlpha(70),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description_outlined, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('Nota Dinas: ${p.nomorND}',
                          style: const TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],

            if (p.status == StatusPengajuan.ditolak) ...[
              const SizedBox(height: 8),
              Text('Alasan penolakan: ${p.alasanTolak ?? '-'}',
                  style: const TextStyle(
                      fontSize: 12.5, color: AppColors.ditolak)),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pengajuanSaya = DataStore.milik(widget.himpunan);

    return Scaffold(
      body: AppBackground(
        headerHeight: 210,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                const SizedBox(height: 16),

                GlassCard(
                  opacity: 0.72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Kalender ketersediaan tempat',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      PlacePicker(
                        kategori: _kategori,
                        tempatController: _tempatCtrl,
                        onKategoriChanged: (k) => setState(() {
                          _kategori = k;
                          _tempatCtrl.clear(); 
                        }),
                        onTempatChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      KalenderRuang(
                        filterKategori: _kategori,
                        filterTempat: _tempatCtrl.text,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                ElevatedButton.icon(
                  onPressed: _ajukan,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Ajukan Peminjaman'),
                ),
                const SizedBox(height: 22),

                const Text('Pengajuan saya',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                if (pengajuanSaya.isEmpty)
                  const GlassCard(
                    blur: false,
                    opacity: 0.8,
                    child: Text(
                        'Belum ada pengajuan. Ketuk "Ajukan Peminjaman" untuk memulai.'),
                  )
                else
                  ...pengajuanSaya.map(_kartuPengajuan),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
