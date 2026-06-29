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

  factory Tugas.fromJson(
    Map<String, dynamic> json,
  ) {

    return Tugas(

      jenis:
          json['jenis']
                  ?.toString() ??
              "-",

      pemberiTugas:
          json['pemberi_tugas']
                  ?.toString() ??
              "-",

      tglMulai:
          json['tgl_mulai']
                  ?.toString() ??
              "-",

      tglSelesai:
          json['tgl_selesai']
                  ?.toString() ??
              "-",

      equipment:
          json['equipment']
                  ?.toString() ??
              "-",

      lokasi:
          json['lokasi']
                  ?.toString() ??
              "-",

      status:
          json['status']
                  ?.toString() ??
              "pending",
    );
  }

  // =========================================
  // TO JSON
  // =========================================

  Map<String, dynamic> toJson() {

    return {

      'jenis': jenis,
      'pemberi_tugas': pemberiTugas,
      'tgl_mulai': tglMulai,
      'tgl_selesai': tglSelesai,
      'equipment': equipment,
      'lokasi': lokasi,
      'status': status,
    };
  }
}

class DashboardModel {

  final int jumlahEquipment;
  final int tugasTetap;
  final int tugasDarurat;
  final int tugasSelesai;

  final List<Tugas> tugas;

  DashboardModel({

    required this.jumlahEquipment,
    required this.tugasTetap,
    required this.tugasDarurat,
    required this.tugasSelesai,
    required this.tugas,
  });

  factory DashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return DashboardModel(

      jumlahEquipment:
          _toInt(
            json['jumlahEquipment'],
          ),

      tugasTetap:
          _toInt(
            json['tugasTetap'],
          ),

      tugasDarurat:
          _toInt(
            json['tugasDarurat'],
          ),

      tugasSelesai:
          _toInt(
            json['tugasSelesai'],
          ),

      tugas:

          json['tugas'] != null

              ? List<Tugas>.from(

                  (json['tugas'] as List)

                      .map(

                        (e) => Tugas.fromJson(
                          e,
                        ),
                      ),
                )

              : [],
    );
  }

  // =========================================
  // TO JSON
  // =========================================

  Map<String, dynamic> toJson() {

    return {

      'jumlahEquipment':
          jumlahEquipment,

      'tugasTetap':
          tugasTetap,

      'tugasDarurat':
          tugasDarurat,

      'tugasSelesai':
          tugasSelesai,

      'tugas':

          tugas
              .map(
                (e) => e.toJson(),
              )
              .toList(),
    };
  }

  // =========================================
  // HELPER INT
  // =========================================

  static int _toInt(
    dynamic value,
  ) {

    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
          value.toString(),
        ) ??
        0;
  }
}