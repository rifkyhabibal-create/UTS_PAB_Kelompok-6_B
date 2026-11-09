import 'package:flutter/material.dart';
import '../data/data_store.dart';
import '../models/himpunan.dart';
import '../models/peminjaman.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'glass_card.dart';

class KalenderRuang extends StatefulWidget {
  final String? filterKategori;
  final String filterTempat;

  const KalenderRuang({super.key, this.filterKategori, this.filterTempat = ''});

  @override
  State<KalenderRuang> createState() => _KalenderRuangState();
}

class _KalenderRuangState extends State<KalenderRuang> {
  late DateTime _bulan; 
  DateTime? _dipilih; 

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _bulan = DateTime(now.year, now.month);
  }

  void _geserBulan(int arah) {
    setState(() => _bulan = DateTime(_bulan.year, _bulan.month + arah));
  }

  void _pilihTanggal(DateTime hari) {
    setState(() => _dipilih = hari);
    final acara = DataStore.acaraPada(hari,
        kategori: widget.filterKategori, tempat: widget.filterTempat);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SheetAcara(
        hari: hari,
        acara: acara,
        filterTempat: widget.filterTempat,
      ),
    );
  }

  Widget _filterHimpunan() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: Himpunan.values.map((h) {
        final aktif = DataStore.filterHimpunan.contains(h);
        return GestureDetector(
          onTap: () => setState(() {
            if (aktif) {
              DataStore.filterHimpunan.remove(h);
            } else {
              DataStore.filterHimpunan.add(h);
            }
          }),
          child: AnimatedOpacity(
            opacity: aktif ? 1 : 0.4,
            duration: const Duration(milliseconds: 150),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xA6FFFFFF),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xCCFFFFFF)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(color: h.warna, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text(h.nama,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _selTanggal(DateTime hari, DateTime hariIni) {
    final acara = DataStore.acaraPada(hari,
        kategori: widget.filterKategori, tempat: widget.filterTempat);
    final himpunanHariIni =
        Himpunan.values.where((h) => acara.any((a) => a.himpunan == h)).toList();

    final lewat = hari.isBefore(hariIni);
    final adalahHariIni = DateUtils.isSameDay(hari, hariIni);
    final terpilih = _dipilih != null && DateUtils.isSameDay(_dipilih, hari);

    return GestureDetector(
      onTap: () => _pilihTanggal(hari),
      child: Container(
        decoration: BoxDecoration(
          color: terpilih ? Colors.white : const Color(0x66FFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: adalahHariIni
              ? Border.all(color: AppColors.navy, width: 1.5)
              : terpilih
                  ? Border.all(color: AppColors.teal, width: 1.5)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${hari.day}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: lewat ? const Color(0xFF9DB3BF) : AppColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final h in himpunanHariIni.take(3))
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(color: h.warna, shape: BoxShape.circle),
                    ),
                  if (himpunanHariIni.length > 3)
                    const Text('+', style: TextStyle(fontSize: 10, height: 1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hariIni = hanyaTanggal(DateTime.now());
    final jumlahHari = DateTime(_bulan.year, _bulan.month + 1, 0).day; 
    final offset = DateTime(_bulan.year, _bulan.month, 1).weekday - 1; 
    const namaHari = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => _geserBulan(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                '${namaBulan[_bulan.month - 1]} ${_bulan.year}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              onPressed: () => _geserBulan(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        _filterHimpunan(),
        const SizedBox(height: 10),

        Row(
          children: namaHari
              .map((h) => Expanded(
                    child: Center(
                      child: Text(h,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSoft)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 6),

        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 0.85,
          children: List.generate(offset + jumlahHari, (i) {
            if (i < offset) return const SizedBox.shrink();
            final hari = DateTime(_bulan.year, _bulan.month, i - offset + 1);
            return _selTanggal(hari, hariIni);
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          'Titik warna = himpunan yang memakai tempat pada tanggal itu. '
          'Ketuk tanggal untuk melihat jam dan tempatnya.',
          style: TextStyle(fontSize: 11, color: AppColors.textSoft),
        ),
      ],
    );
  }
}

class _SheetAcara extends StatelessWidget {
  final DateTime hari;
  final List<Peminjaman> acara;
  final String filterTempat;

  const _SheetAcara({
    required this.hari,
    required this.acara,
    required this.filterTempat,
  });

  @override
  Widget build(BuildContext context) {
    final tinggiMaks = MediaQuery.of(context).size.height * 0.65;
    final cekTempat = filterTempat.trim().isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GlassCard(
          opacity: 0.92,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: tinggiMaks),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x330B3A4F),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${hari.day} ${namaBulan[hari.month - 1]} ${hari.year}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  acara.isEmpty
                      ? 'Belum ada acara pada tanggal ini'
                      : '${acara.length} acara pada tanggal ini',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSoft),
                ),

                if (cekTempat) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (acara.isEmpty ? AppColors.disetujui : AppColors.diajukan)
                          .withAlpha(35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          acara.isEmpty ? Icons.check_circle : Icons.event_busy,
                          size: 18,
                          color: acara.isEmpty
                              ? AppColors.disetujui
                              : AppColors.diajukan,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            acara.isEmpty
                                ? '"$filterTempat" KOSONG pada tanggal ini'
                                : '"$filterTempat" TERPAKAI (${acara.length} acara)',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                Flexible(
                  child: acara.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('Semua tempat kosong. Silakan ajukan peminjaman.'),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: acara.length,
                          separatorBuilder: (_, __) => const Divider(height: 20),
                          itemBuilder: (_, i) => _ItemAcara(p: acara[i]),
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

class _ItemAcara extends StatelessWidget {
  final Peminjaman p;
  const _ItemAcara({required this.p});

  Widget _baris(IconData ikon, String teks) {
    return Row(
      children: [
        Icon(ikon, size: 15, color: AppColors.textSoft),
        const SizedBox(width: 6),
        Expanded(child: Text(teks, style: const TextStyle(fontSize: 13))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.himpunan.nama,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSoft)),
                Text(p.acara,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                _baris(Icons.schedule, p.jam),
                const SizedBox(height: 2),
                _baris(Icons.place_outlined, p.lokasi),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
