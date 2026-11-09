import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'himpunan.dart';

enum StatusPengajuan { diajukan, ditinjau, disetujui, ditolak }
extension StatusPengajuanInfo on StatusPengajuan {
  String get label => switch (this) {
        StatusPengajuan.diajukan => 'Diajukan',
        StatusPengajuan.ditinjau => 'Ditinjau',
        StatusPengajuan.disetujui => 'Disetujui',
        StatusPengajuan.ditolak => 'Ditolak',
      };

  Color get warna => switch (this) {
        StatusPengajuan.diajukan => AppColors.diajukan,
        StatusPengajuan.ditinjau => AppColors.ditinjau,
        StatusPengajuan.disetujui => AppColors.disetujui,
        StatusPengajuan.ditolak => AppColors.ditolak,
      };
}

class Peminjaman {
  final String id;
  final Himpunan himpunan;
  final String acara;
  final DateTime tanggal; 
  final TimeOfDay mulai;
  final TimeOfDay selesai;
  final String kategori; 
  final String tempat; 
  final int jumlahPeserta;
  final String keperluan;
  final String fileSpk; 
  final String fileSph; 

  StatusPengajuan status;
  String? nomorND; 
  DateTime? tanggalND;
  String? alasanTolak;

  Peminjaman({
    required this.id,
    required this.himpunan,
    required this.acara,
    required this.tanggal,
    required this.mulai,
    required this.selesai,
    required this.kategori,
    required this.tempat,
    required this.jumlahPeserta,
    required this.keperluan,
    required this.fileSpk,
    required this.fileSph,
    this.status = StatusPengajuan.diajukan,
    this.nomorND,
    this.tanggalND,
    this.alasanTolak,
  });

  String get jam => '${formatJam(mulai)} – ${formatJam(selesai)}';
  String get lokasi => '$kategori · $tempat';

  bool bentrokDengan(Peminjaman o) =>
      DateUtils.isSameDay(tanggal, o.tanggal) &&
      kategori == o.kategori &&
      normalisasi(tempat) == normalisasi(o.tempat) &&
      menit(mulai) < menit(o.selesai) &&
      menit(o.mulai) < menit(selesai);

  bool cocokTempat(String? filterKategori, String filterTempat) {
    if (filterKategori != null && kategori != filterKategori) return false;
    final cari = normalisasi(filterTempat);
    if (cari.isNotEmpty && !normalisasi(tempat).contains(cari)) return false;
    return true;
  }
}
