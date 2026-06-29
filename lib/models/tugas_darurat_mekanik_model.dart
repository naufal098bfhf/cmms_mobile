class TugasDaruratMekanikModel {

  final int id;

  final String pemberiTugas;

  final String tglMulai;

  final String tglSelesai;

  final String namaMekanik;

  final String equipment;

  final String tagNumber;

  final String eqClass;

  final String bom;

  final String taskList;

  final String lokasi;

  final String status;

  final String? buktiFoto;

  // =====================================
  // VALIDASI MP
  // =====================================

  final bool validasiMp;

  TugasDaruratMekanikModel({

    required this.id,

    required this.pemberiTugas,

    required this.tglMulai,

    required this.tglSelesai,

    required this.namaMekanik,

    required this.equipment,

    required this.tagNumber,

    required this.eqClass,

    required this.bom,

    required this.taskList,

    required this.lokasi,

    required this.status,

    // =====================================
    // VALIDASI MP
    // =====================================

    required this.validasiMp,

    this.buktiFoto,
  });

  factory TugasDaruratMekanikModel.fromJson(
  Map<String, dynamic> json,
) {

  return TugasDaruratMekanikModel(

    id: json['id'] ?? 0,

    pemberiTugas:
        json['pemberi_tugas'] ?? '-',

    tglMulai:
        json['tgl_mulai'] ?? '',

    tglSelesai:
        json['tgl_selesai'] ?? '',

    namaMekanik:
        json['nama_mekanik'] ?? '',

    equipment:
        json['equipment'] ?? '',

    tagNumber:
        json['tag_number'] ?? '',

    eqClass:
        json['eq_class'] ?? '',

    bom:
        json['bom'] ?? '-',

    taskList:
        json['task_list'] ?? '',

    lokasi:
        json['lokasi'] ?? '',

    status:
        json['status'] ?? 'pending',

    buktiFoto:
        json['bukti_foto'],

    // FIX VALIDASI MP
    validasiMp:
        json['validasi_mp'] == 1 ||
        json['validasi_mp'] == true,
  );
}

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "pemberi_tugas":
          pemberiTugas,

      "tgl_mulai":
          tglMulai,

      "tgl_selesai":
          tglSelesai,

      "nama_mekanik":
          namaMekanik,

      "equipment":
          equipment,

      "tag_number":
          tagNumber,

      "eq_class":
          eqClass,

      "bom":
          bom,

      "task_list":
          taskList,

      "lokasi":
          lokasi,

      "status":
          status,

      "bukti_foto":
          buktiFoto,

      // =====================================
      // VALIDASI MP
      // =====================================

      "validasi_mp":
          validasiMp,
    };
  }
}
