class DashboardMekanikModel {
  final int jumlahEquipment;
  final int tugasHariIni;
  final int tugasPending;
  final int tugasSelesai;
  final List<Tugas> tugas;

  DashboardMekanikModel({
    required this.jumlahEquipment,
    required this.tugasHariIni,
    required this.tugasPending,
    required this.tugasSelesai,
    required this.tugas,
  });

  factory DashboardMekanikModel.fromJson(Map<String, dynamic> json) {
    return DashboardMekanikModel(
      jumlahEquipment: json['jumlah_equipment'] ?? 0,
      tugasHariIni: json['tugas_hari_ini'] ?? 0,
      tugasPending: json['tugas_pending'] ?? 0,
      tugasSelesai: json['tugas_selesai'] ?? 0,
      tugas: (json['tugas'] ?? [])
          .map<Tugas>((e) => Tugas.fromJson(e))
          .toList(),
    );
  }
}

class Tugas {
  final String jenis;
  final String pemberiTugas;
  final String tglMulai;
  final String tglSelesai;
  final String equipment;
  final String lokasi;
  final String status;

  Tugas({
    required this.jenis,
    required this.pemberiTugas,
    required this.tglMulai,
    required this.tglSelesai,
    required this.equipment,
    required this.lokasi,
    required this.status,
  });

  factory Tugas.fromJson(Map<String, dynamic> json) {
    return Tugas(
      jenis: json['jenis'] ?? '',
      pemberiTugas: json['pemberi_tugas'] ?? '',
      tglMulai: json['tgl_mulai'] ?? '',
      tglSelesai: json['tgl_selesai'] ?? '-',
      equipment: json['equipment'] ?? '',
      lokasi: json['lokasi'] ?? '',
      status: json['status'] ?? '',
    );
  }
}