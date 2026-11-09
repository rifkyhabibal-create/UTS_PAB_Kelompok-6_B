import 'package:flutter/material.dart';
import '../models/himpunan.dart';
import '../models/peminjaman.dart';
import '../utils/format.dart';

class DataStore {
  static const List<String> kategoriTempat = [
    'Ruang Kelas',
    'Lobby Depan',
    'Lobby Belakang',
    'Taman Depan',
    'Taman Belakang',
    'Parkiran Depan',
    'Parkiran Belakang',
  ];
  static final List<Peminjaman> semua = _buatDummy();
  static final Set<Himpunan> filterHimpunan = Himpunan.values.toSet();
  static int _urutND = 0;
  static List<Peminjaman> milik(Himpunan h) =>
      semua.where((p) => p.himpunan == h).toList().reversed.toList();
  static List<Peminjaman> acaraPada(DateTime hari,
      {String? kategori, String tempat = ''}) {
    final hasil = semua
        .where((p) =>
            p.status == StatusPengajuan.disetujui &&
            DateUtils.isSameDay(p.tanggal, hari) &&
            filterHimpunan.contains(p.himpunan) &&
            p.cocokTempat(kategori, tempat))
        .toList();
    hasil.sort((a, b) => menit(a.mulai).compareTo(menit(b.mulai)));
    return hasil;
  }

  static Peminjaman? cariBentrok(Peminjaman p) {
    for (final o in semua) {
      if (o.id != p.id &&
          o.status == StatusPengajuan.disetujui &&
          p.bentrokDengan(o)) {
        return o;
      }
    }
    return null;
  }

  static String idBaru() => 'p${DateTime.now().microsecondsSinceEpoch}';

  static void tambah(Peminjaman p) => semua.add(p);

  static void terbitkanND(Peminjaman p) {
    final now = DateTime.now();
    _urutND++;
    p.nomorND = '${_urutND.toString().padLeft(3, '0')}/ND/RuangKu/'
        '${bulanRomawi[now.month - 1]}/${now.year}';
    p.tanggalND = now;
    p.status = StatusPengajuan.disetujui;
  }

  static TimeOfDay _jam(String s) {
    final b = s.split(':');
    return TimeOfDay(hour: int.parse(b[0]), minute: int.parse(b[1]));
  }

  static Peminjaman _acara(String id, Himpunan h, String acara, int hariKe,
      String mulai, String selesai, String kategori, String tempat, int peserta) {
    return Peminjaman(
      id: id,
      himpunan: h,
      acara: acara,
      tanggal: hanyaTanggal(DateTime.now()).add(Duration(days: hariKe)),
      mulai: _jam(mulai),
      selesai: _jam(selesai),
      kategori: kategori,
      tempat: tempat,
      jumlahPeserta: peserta,
      keperluan: 'Kegiatan $acara oleh ${h.nama}',
      fileSpk: 'SPK_${h.nama}.pdf',
      fileSph: 'SPH_${h.nama}.pdf',
    );
  }

  static List<Peminjaman> _buatDummy() {
    final disetujui = <Peminjaman>[
      _acara('p1', Himpunan.himasi, 'Seminar Nasional', 2, '08:00', '10:00', 'Ruang Kelas', 'A.101', 80),
      _acara('p2', Himpunan.hme, 'Workshop Arduino', 2, '10:30', '12:00', 'Lobby Depan', 'Lobby Utama', 40),
      _acara('p3', Himpunan.hmi, 'Kajian Rutin', 2, '13:00', '15:00', 'Taman Belakang', 'Gazebo', 30),
      _acara('p4', Himpunan.himaben, 'Bazar Kampus', 4, '09:00', '16:00', 'Parkiran Depan', 'Parkir Mobil', 150),
      _acara('p5', Himpunan.himatenlis, 'Lomba Desain', 4, '08:00', '12:00', 'Ruang Kelas', 'B.201', 60),
      _acara('p6', Himpunan.himaka, 'Pelatihan K3', 7, '09:00', '11:00', 'Lobby Belakang', 'Selasar', 50),
      _acara('p7', Himpunan.himasi, 'Rapat Kerja', 7, '13:00', '15:00', 'Taman Depan', 'Gazebo', 25),
    ];
    for (final p in disetujui) {
      terbitkanND(p); 
    }

    final menunggu = <Peminjaman>[
      _acara('p8', Himpunan.himaben, 'Bazar Mini', 2, '09:00', '11:00', 'Ruang Kelas', 'A.101', 20),
      _acara('p9', Himpunan.hmi, 'Diskusi Panel', 5, '10:00', '12:00', 'Ruang Kelas', 'A.102', 45),
    ];
    return [...disetujui, ...menunggu];
  }
}
