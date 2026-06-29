class TugasDaruratAdminModel {

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

  TugasDaruratAdminModel({

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

    this.buktiFoto,
  });

  factory TugasDaruratAdminModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return TugasDaruratAdminModel(

      id:
          json['id'] ?? 0,

      pemberiTugas:
          json['pemberi_tugas']
                  ?.toString() ??
              '-',

      tglMulai:
          json['tgl_mulai']
                  ?.toString() ??
              '',

      tglSelesai:
          json['tgl_selesai']
                  ?.toString() ??
              '',

      namaMekanik:
          json['nama_mekanik']
                  ?.toString() ??
              '',

      equipment:
          json['equipment']
                  ?.toString() ??
              '',

      tagNumber:
          json['tag_number']
                  ?.toString() ??
              '',

      eqClass:
          json['eq_class']
                  ?.toString() ??
              '',

      bom:
          json['bom']
                  ?.toString() ??
              '',

      taskList:
          json['task_list']
                  ?.toString() ??
              '',

      lokasi:
          json['lokasi']
                  ?.toString() ??
              '',

      status:
          json['status']
                  ?.toString() ??
              'pending',

      buktiFoto:
          json['bukti_foto']
              ?.toString(),
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
    };
  }
}