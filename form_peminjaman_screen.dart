import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/data_store.dart';
import '../models/himpunan.dart';
import '../models/peminjaman.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/place_picker.dart';

class FormPeminjamanScreen extends StatefulWidget {
  final Himpunan himpunan;
  const FormPeminjamanScreen({super.key, required this.himpunan});

  @override
  State<FormPeminjamanScreen> createState() => _FormPeminjamanScreenState();
}

class _FormPeminjamanScreenState extends State<FormPeminjamanScreen> {
  final _formKey = GlobalKey<FormState>();

  final _acaraCtrl = TextEditingController();
  final _tempatCtrl = TextEditingController();
  final _pesertaCtrl = TextEditingController();
  final _keperluanCtrl = TextEditingController();
  final _tanggalCtrl = TextEditingController();
  final _mulaiCtrl = TextEditingController();
  final _selesaiCtrl = TextEditingController();

  String? _kategori;
  DateTime? _tanggal;
  TimeOfDay? _mulai;
  TimeOfDay? _selesai;
  String? _fileSpk; 
  String? _fileSph;

  @override
  void dispose() {
    _acaraCtrl.dispose();
    _tempatCtrl.dispose();
    _pesertaCtrl.dispose();
    _keperluanCtrl.dispose();
    _tanggalCtrl.dispose();
    _mulaiCtrl.dispose();
    _selesaiCtrl.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final hariIni = hanyaTanggal(DateTime.now());
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? hariIni,
      firstDate: hariIni, 
      lastDate: hariIni.add(const Duration(days: 365)),
    );
    if (hasil != null) {
      setState(() {
        _tanggal = hasil;
        _tanggalCtrl.text = formatTanggal(hasil);
      });
    }
  }

  Future<void> _pilihJam({required bool mulai}) async {
    final hasil = await showTimePicker(
      context: context,
      initialTime: (mulai ? _mulai : _selesai) ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (hasil != null) {
      setState(() {
        if (mulai) {
          _mulai = hasil;
          _mulaiCtrl.text = formatJam(hasil);
        } else {
          _selesai = hasil;
          _selesaiCtrl.text = formatJam(hasil);
        }
      });
    }
  }

  void _kirim() {
    if (!_formKey.currentState!.validate()) {
      tampilSnack(context, 'Periksa kembali isian yang berwarna merah', error: true);
      return;
    }

    final baru = Peminjaman(
      id: DataStore.idBaru(),
      himpunan: widget.himpunan,
      acara: _acaraCtrl.text.trim(),
      tanggal: _tanggal!,
      mulai: _mulai!,
      selesai: _selesai!,
      kategori: _kategori!,
      tempat: _tempatCtrl.text.trim(),
      jumlahPeserta: int.parse(_pesertaCtrl.text),
      keperluan: _keperluanCtrl.text.trim(),
      fileSpk: _fileSpk!,
      fileSph: _fileSph!,
    );

    final bentrok = DataStore.cariBentrok(baru);
    if (bentrok != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Jadwal bentrok'),
          content: Text(
            '${bentrok.lokasi} pada ${formatTanggal(bentrok.tanggal)} '
            'jam ${bentrok.jam} sudah dipakai oleh ${bentrok.himpunan.nama} '
            '(${bentrok.acara}). Ubah tanggal, jam, atau tempat.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
      return;
    }

    DataStore.tambah(baru);
    Navigator.pop(context, true);
  }

  Widget _kolomUnggah({
    required String label,
    required String? namaFile,
    required String namaDummy,
    required bool Function() sudahAda,
    required void Function(String) onPilih,
  }) {
    return FormField<String>(
      validator: (_) => sudahAda() ? null : '$label wajib diunggah',
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xCCFFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: field.hasError
                      ? AppColors.ditolak
                      : const Color(0x33007A8C),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    namaFile == null ? Icons.upload_file : Icons.check_circle,
                    color: namaFile == null
                        ? AppColors.textSoft
                        : AppColors.disetujui,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      namaFile ?? 'Belum ada file $label',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13.5),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      onPilih(namaDummy); 
                      field.didChange(namaDummy);
                      field.validate(); 
                    },
                    child: Text(namaFile == null ? 'Unggah' : 'Ganti'),
                  ),
                ],
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 0, 0),
                child: Text(field.errorText!,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.ditolak)),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Text('Form Peminjaman',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  child: GlassCard(
                    opacity: 0.82,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    color: widget.himpunan.warna,
                                    shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Text('Himpunan: ${widget.himpunan.nama}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 14),

                          TextFormField(
                            controller: _acaraCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Nama acara',
                              prefixIcon: Icon(Icons.event_note_outlined),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Nama acara wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          PlacePicker(
                            wajib: true,
                            kategori: _kategori,
                            tempatController: _tempatCtrl,
                            onKategoriChanged: (k) => setState(() {
                              _kategori = k;
                              _tempatCtrl.clear(); 
                            }),
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _tanggalCtrl,
                            readOnly: true,
                            onTap: _pilihTanggal,
                            decoration: const InputDecoration(
                              labelText: 'Tanggal peminjaman',
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                            ),
                            validator: (_) {
                              if (_tanggal == null) return 'Tanggal wajib dipilih';
                              if (_tanggal!.isBefore(hanyaTanggal(DateTime.now()))) {
                                return 'Tanggal tidak boleh sebelum hari ini';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _mulaiCtrl,
                                  readOnly: true,
                                  onTap: () => _pilihJam(mulai: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Jam mulai',
                                    prefixIcon: Icon(Icons.schedule),
                                  ),
                                  validator: (_) =>
                                      _mulai == null ? 'Wajib dipilih' : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _selesaiCtrl,
                                  readOnly: true,
                                  onTap: () => _pilihJam(mulai: false),
                                  decoration: const InputDecoration(
                                    labelText: 'Jam selesai',
                                    prefixIcon: Icon(Icons.schedule),
                                  ),
                                  validator: (_) {
                                    if (_selesai == null) return 'Wajib dipilih';
                                    if (_mulai != null &&
                                        menit(_selesai!) <= menit(_mulai!)) {
                                      return 'Harus setelah jam mulai';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _pesertaCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: 'Jumlah peserta',
                              prefixIcon: Icon(Icons.groups_outlined),
                            ),
                            validator: (v) {
                              final n = int.tryParse(v ?? '');
                              if (n == null || n <= 0) {
                                return 'Isi angka lebih dari 0';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _keperluanCtrl,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Keperluan peminjaman',
                              alignLabelWithHint: true,
                            ),
                            validator: (v) => (v == null || v.trim().length < 10)
                                ? 'Keperluan minimal 10 karakter'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          const Text('Dokumen persyaratan',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),

                          _kolomUnggah(
                            label: 'SPK',
                            namaFile: _fileSpk,
                            namaDummy: 'SPK_${widget.himpunan.nama}.pdf',
                            sudahAda: () => _fileSpk != null,
                            onPilih: (n) => setState(() => _fileSpk = n),
                          ),
                          const SizedBox(height: 10),

                          _kolomUnggah(
                            label: 'SPH',
                            namaFile: _fileSph,
                            namaDummy: 'SPH_${widget.himpunan.nama}.pdf',
                            sudahAda: () => _fileSph != null,
                            onPilih: (n) => setState(() => _fileSph = n),
                          ),
                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: _kirim,
                            child: const Text('Kirim pengajuan'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
