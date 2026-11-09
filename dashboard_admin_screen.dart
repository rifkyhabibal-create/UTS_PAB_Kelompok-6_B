import 'package:flutter/material.dart';
import '../data/data_store.dart';
import '../models/peminjaman.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/kalender_ruang.dart';
import '../widgets/place_picker.dart';
import '../widgets/status_badge.dart';
import 'detail_pengajuan_screen.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  String? _kategori;
  final TextEditingController _tempatCtrl = TextEditingController();

  @override
  void dispose() {
    _tempatCtrl.dispose();
    super.dispose();
  }

  Future<void> _bukaDetail(Peminjaman p) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPengajuanScreen(data: p)),
    );
    if (!mounted) return;
    setState(() {});
  }

  Widget _ringkasan(String judul, int angka, IconData ikon) {
    return Expanded(
      child: GlassCard(
        blur: false,
        opacity: 0.8,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(ikon, color: AppColors.tealDark),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$angka',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                  Text(judul,
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textSoft)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabKalender() {
    final menunggu = DataStore.semua
        .where((p) =>
            p.status == StatusPengajuan.diajukan ||
            p.status == StatusPengajuan.ditinjau)
        .length;
    final disetujui = DataStore.semua
        .where((p) => p.status == StatusPengajuan.disetujui)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Row(
          children: [
            _ringkasan('Menunggu tinjauan', menunggu, Icons.hourglass_top),
            const SizedBox(width: 10),
            _ringkasan('Acara disetujui', disetujui, Icons.event_available),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          opacity: 0.72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pemakaian tempat',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text(
                  'Isi tempat spesifik lalu ketuk tanggal untuk melihat apakah tempat itu dipakai.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSoft)),
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
      ],
    );
  }

  Widget _tabPengajuan() {
    final daftar = [...DataStore.semua]..sort((a, b) {
        final r = a.status.index.compareTo(b.status.index);
        return r != 0 ? r : a.tanggal.compareTo(b.tanggal);
      });

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      itemCount: daftar.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final p = daftar[i];
        final belumFinal = p.status == StatusPengajuan.diajukan ||
            p.status == StatusPengajuan.ditinjau;
        final bentrok = belumFinal && DataStore.cariBentrok(p) != null;

        return GlassCard(
          blur: false,
          opacity: 0.8,
          padding: const EdgeInsets.all(14),
          onTap: () => _bukaDetail(p),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: p.himpunan.warna,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(p.himpunan.nama,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textSoft)),
                          ),
                          StatusBadge(status: p.status),
                        ],
                      ),
                      Text(p.acara,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${formatTanggal(p.tanggal)} · ${p.jam}',
                          style: const TextStyle(fontSize: 13)),
                      Text(p.lokasi,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textSoft)),
                      if (bentrok) ...[
                        const SizedBox(height: 6),
                        const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                size: 16, color: AppColors.ditolak),
                            SizedBox(width: 4),
                            Text('Bentrok dengan jadwal disetujui',
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.ditolak)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: AppBackground(
          headerHeight: 200,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dashboard',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xCCFFFFFF))),
                            Text('Admin Kampus',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xB3FFFFFF),
                  indicatorColor: AppColors.yellow,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'Kalender & Pemakaian'),
                    Tab(text: 'Pengajuan Masuk'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [_tabKalender(), _tabPengajuan()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
