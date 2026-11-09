import 'package:flutter/material.dart';
import '../data/data_store.dart';
import '../models/peminjaman.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/info_row.dart';
import '../widgets/status_badge.dart';

class DetailPengajuanScreen extends StatefulWidget {
  final Peminjaman data;
  const DetailPengajuanScreen({super.key, required this.data});

  @override
  State<DetailPengajuanScreen> createState() => _DetailPengajuanScreenState();
}

class _DetailPengajuanScreenState extends State<DetailPengajuanScreen> {
  Peminjaman get p => widget.data; 

  void _mulaiTinjau() {
    setState(() => p.status = StatusPengajuan.ditinjau);
    tampilSnack(context, 'Status berubah: Ditinjau');
  }

  void _setujui() {
    if (DataStore.cariBentrok(p) != null) {
      tampilSnack(context, 'Tidak bisa disetujui: jadwal bentrok', error: true);
      return;
    }
    setState(() => DataStore.terbitkanND(p)); 
    tampilSnack(context, 'Disetujui. Nota Dinas ${p.nomorND} diterbitkan');
  }

  Future<void> _tolak() async {
    final alasan = await showDialog<String>(
      context: context,
      builder: (_) => const _DialogTolak(),
    );
    if (alasan == null) return; // dibatalkan
    setState(() {
      p.status = StatusPengajuan.ditolak;
      p.alasanTolak = alasan;
    });
    if (!mounted) return;
    tampilSnack(context, 'Pengajuan ditolak');
  }

  Widget _panelBentrok(Peminjaman? bentrok) {
    final warna = bentrok != null ? AppColors.ditolak : AppColors.disetujui;
    final pesan = bentrok != null
        ? 'BENTROK. ${bentrok.lokasi} pada ${formatTanggal(bentrok.tanggal)} '
            'jam ${bentrok.jam} sudah dipakai ${bentrok.himpunan.nama} '
            '(${bentrok.acara}). Pengajuan tidak dapat disetujui.'
        : 'Tempat dan jam tersedia. Tidak ada jadwal yang bentrok.';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warna.withAlpha(30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: warna.withAlpha(120)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(bentrok != null ? Icons.warning_amber_rounded : Icons.check_circle,
              color: warna),
          const SizedBox(width: 10),
          Expanded(
            child: Text(pesan,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _kartuNotaDinas() {
    return GlassCard(
      opacity: 0.92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 6,
                  height: 22,
                  decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 8),
              const Text('NOTA DINAS',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2)),
            ],
          ),
          const Divider(height: 22),
          InfoRow(label: 'Nomor', nilai: p.nomorND ?? '-'),
          InfoRow(
              label: 'Tanggal terbit',
              nilai: p.tanggalND == null ? '-' : formatTanggal(p.tanggalND!)),
          InfoRow(label: 'Kepada', nilai: 'Ketua ${p.himpunan.nama}'),
          const InfoRow(label: 'Perihal', nilai: 'Persetujuan peminjaman tempat'),
          InfoRow(label: 'Acara', nilai: p.acara),
          InfoRow(label: 'Tempat', nilai: p.lokasi),
          InfoRow(label: 'Waktu', nilai: '${formatTanggal(p.tanggal)}, ${p.jam}'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.disetujui.withAlpha(35),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text('STATUS: DISETUJUI',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.disetujui)),
          ),
        ],
      ),
    );
  }

  Widget _aksi(Peminjaman? bentrok) {
    switch (p.status) {
      case StatusPengajuan.diajukan:
        return ElevatedButton.icon(
          onPressed: _mulaiTinjau,
          icon: const Icon(Icons.manage_search),
          label: const Text('Mulai Tinjau'),
        );
      case StatusPengajuan.ditinjau:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      bentrok == null ? AppColors.disetujui : Colors.grey,
                ),
                onPressed: _setujui,
                child: const Text('Setujui'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  foregroundColor: AppColors.ditolak,
                  side: const BorderSide(color: AppColors.ditolak),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _tolak,
                child: const Text('Tolak'),
              ),
            ),
          ],
        );
      case StatusPengajuan.disetujui:
        return const SizedBox.shrink(); 
      case StatusPengajuan.ditolak:
        return GlassCard(
          blur: false,
          opacity: 0.85,
          child: Text('Alasan penolakan: ${p.alasanTolak ?? '-'}',
              style: const TextStyle(color: AppColors.ditolak)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final belumFinal = p.status == StatusPengajuan.diajukan ||
        p.status == StatusPengajuan.ditinjau;
    final bentrok = belumFinal ? DataStore.cariBentrok(p) : null;

    return Scaffold(
      body: AppBackground(
        headerHeight: 170,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text('Detail Pengajuan',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  children: [
                    GlassCard(
                      opacity: 0.82,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    color: p.himpunan.warna,
                                    shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(p.himpunan.nama,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                              ),
                              StatusBadge(status: p.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(p.acara,
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w800)),
                          const Divider(height: 22),
                          InfoRow(
                              icon: Icons.calendar_month_outlined,
                              label: 'Tanggal',
                              nilai: formatTanggal(p.tanggal)),
                          InfoRow(
                              icon: Icons.schedule,
                              label: 'Jam',
                              nilai: p.jam),
                          InfoRow(
                              icon: Icons.place_outlined,
                              label: 'Tempat',
                              nilai: p.lokasi),
                          InfoRow(
                              icon: Icons.groups_outlined,
                              label: 'Peserta',
                              nilai: '${p.jumlahPeserta} orang'),
                          InfoRow(
                              icon: Icons.notes,
                              label: 'Keperluan',
                              nilai: p.keperluan),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    GlassCard(
                      opacity: 0.82,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Dokumen persyaratan',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          InfoRow(
                              icon: Icons.picture_as_pdf_outlined,
                              label: 'SPK',
                              nilai: p.fileSpk),
                          InfoRow(
                              icon: Icons.picture_as_pdf_outlined,
                              label: 'SPH',
                              nilai: p.fileSph),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (belumFinal) ...[
                      _panelBentrok(bentrok),
                      const SizedBox(height: 12),
                    ],

                    _aksi(bentrok),

                    if (p.status == StatusPengajuan.disetujui) _kartuNotaDinas(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogTolak extends StatefulWidget {
  const _DialogTolak();

  @override
  State<_DialogTolak> createState() => _DialogTolakState();
}

class _DialogTolakState extends State<_DialogTolak> {
  final _formKey = GlobalKey<FormState>();
  final _alasanCtrl = TextEditingController();

  @override
  void dispose() {
    _alasanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tolak pengajuan'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _alasanCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Alasan penolakan',
            alignLabelWithHint: true,
          ),
          validator: (v) => (v == null || v.trim().length < 5)
              ? 'Alasan wajib diisi (min. 5 karakter)'
              : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _alasanCtrl.text.trim());
            }
          },
          child: const Text('Tolak pengajuan',
              style: TextStyle(color: AppColors.ditolak)),
        ),
      ],
    );
  }
}
