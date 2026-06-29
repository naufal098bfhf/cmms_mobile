class TugasTetapMekanikModel {

  final int id;

  final String pemberiTugas;

  final String jenisTugas;

  final String? hariMingguan;

  final String? tanggalBulanan;

  final String? tanggalTahunan;

  final String namaMekanik;

  final String equipment;

  final String tagNumber;

  final String eqClass;

  final String bom;

  final String taskList;

  final String lokasi;

  final String status;

  final bool validasiMp;

  final String? buktiFoto;

  final int mekanikId;

  TugasTetapMekanikModel({
    required this.id,
    required this.pemberiTugas,
    required this.jenisTugas,
    required this.hariMingguan,
    required this.tanggalBulanan,
    required this.tanggalTahunan,
    required this.namaMekanik,
    required this.equipment,
    required this.tagNumber,
    required this.eqClass,
    required this.bom,
    required this.taskList,
    required this.lokasi,
    required this.status,
    required this.validasiMp,
    required this.buktiFoto,
    required this.mekanikId,
  });

  factory TugasTetapMekanikModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TugasTetapMekanikModel(

      id: int.tryParse(
            json['id'].toString(),
          ) ??
          0,

      pemberiTugas:
          json['pemberi_tugas']
                  ?.toString() ??
              '',

      jenisTugas:
          json['jenis_tugas']
                  ?.toString() ??
              '',

      hariMingguan:
          json['hari_mingguan']
              ?.toString(),

      tanggalBulanan:
          json['tanggal_bulanan']
              ?.toString(),

      tanggalTahunan:
          json['tanggal_tahunan']
              ?.toString(),

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

      validasiMp:
          json['validasi_mp'] == 1 ||
          json['validasi_mp'] == true,

      buktiFoto:
          json['bukti_foto']
              ?.toString(),

      mekanikId:
          int.tryParse(
                json['mekanik_id']
                    .toString(),
              ) ??
              0,
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'id': id,

      'pemberi_tugas':
          pemberiTugas,

      'jenis_tugas':
          jenisTugas,

      'hari_mingguan':
          hariMingguan,

      'tanggal_bulanan':
          tanggalBulanan,

      'tanggal_tahunan':
          tanggalTahunan,

      'nama_mekanik':
          namaMekanik,

      'equipment':
          equipment,

      'tag_number':
          tagNumber,

      'eq_class':
          eqClass,

      'bom':
          bom,

      'task_list':
          taskList,

      'lokasi':
          lokasi,

      'status':
          status,

      'validasi_mp':
          validasiMp,

      'bukti_foto':
          buktiFoto,

      'mekanik_id':
          mekanikId,
    };
  }
}