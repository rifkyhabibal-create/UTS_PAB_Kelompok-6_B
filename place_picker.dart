import 'package:flutter/material.dart';
import '../data/data_store.dart';

class PlacePicker extends StatelessWidget {
  final String? kategori;
  final TextEditingController tempatController;
  final ValueChanged<String?> onKategoriChanged;
  final ValueChanged<String>? onTempatChanged;
  final bool wajib;

  const PlacePicker({
    super.key,
    required this.kategori,
    required this.tempatController,
    required this.onKategoriChanged,
    this.onTempatChanged,
    this.wajib = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          value: kategori,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: wajib ? 'Kategori tempat' : 'Filter kategori (opsional)',
            prefixIcon: const Icon(Icons.place_outlined),
          ),
          items: [
            if (!wajib)
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Semua kategori'),
              ),
            ...DataStore.kategoriTempat
                .map((k) => DropdownMenuItem<String>(value: k, child: Text(k))),
          ],
          onChanged: onKategoriChanged,
          validator: wajib
              ? (v) => v == null ? 'Kategori wajib dipilih' : null
              : null,
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: tempatController,
          onChanged: onTempatChanged,
          decoration: InputDecoration(
            labelText: wajib ? 'Tempat spesifik' : 'Filter tempat spesifik (opsional)',
            hintText: 'Contoh: A.101 atau Gazebo dekat kantin',
            prefixIcon: const Icon(Icons.edit_location_alt_outlined),
          ),
          validator: wajib
              ? (v) => (v == null || v.trim().length < 2)
                  ? 'Tempat spesifik wajib diisi (min. 2 karakter)'
                  : null
              : null,
        ),
      ],
    );
  }
}
