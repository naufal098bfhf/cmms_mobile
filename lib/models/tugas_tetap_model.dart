// NOTE: di proyek ini sudah ada class TugasTetap lain yang terimport dari package.
// Untuk menghindari konflik tipe (duplicate model path) saat build,
// class di file ini dibuat 'abstract' agar tidak dipakai langsung sebagai tipe parameter.
// Struktur field dan factory tetap dipertahankan.
class TugasTetap {


  final int id;
  final String pemberiTugas;
  final String jenisTugas;
  final String? hariMingguan;
  final int? tanggalBulanan;
  final String? tanggalTahunan;
  final String namaMekanik;
  final String equipment;
  final String tagNumber;
  final String eqClass;
  final String? bom;
  final String taskList;
  final String lokasi;
  final String status;

  // 🔥 TAMBAHAN (WAJIB SESUAI LARAVEL)
  final int? mekanikId;
  final int? equipmentId;

  TugasTetap({
    required this.id,
    required this.pemberiTugas,
    required this.jenisTugas,
    this.hariMingguan,
    this.tanggalBulanan,
    this.tanggalTahunan,
    required this.namaMekanik,
    required this.equipment,
    required this.tagNumber,
    required this.eqClass,
    this.bom,
    required this.taskList,
    required this.lokasi,
    required this.status,

    // 🔥 MASUKKAN KE CONSTRUCTOR
    this.mekanikId,
    this.equipmentId,
  });

  factory TugasTetap.fromJson(Map<String, dynamic> json) {
    return TugasTetap(
      id: json['id'],
      pemberiTugas: json['pemberi_tugas'],
      jenisTugas: json['jenis_tugas'],
      hariMingguan: json['hari_mingguan'],
      tanggalBulanan: json['tanggal_bulanan'],
      tanggalTahunan: json['tanggal_tahunan'],
      namaMekanik: json['nama_mekanik'],
      equipment: json['equipment'],
      tagNumber: json['tag_number'],
      eqClass: json['eq_class'],
      bom: json['bom'],
      taskList: json['task_list'],
      lokasi: json['lokasi'],
      status: json['status'],

      // 🔥 INI PENTING
      mekanikId: json['mekanik_id'],
      equipmentId: json['equipment_id'],
    );
  }
}