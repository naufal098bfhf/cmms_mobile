import 'package:flutter/material.dart';

import '../../../../models/tugas_darurat_admin_model.dart';
import '../../../../services/api_service.dart';

class TugasDaruratEditPage extends StatefulWidget {

  final TugasDaruratAdminModel tugas;
  final String token;
  final String userName;

  const TugasDaruratEditPage({
    super.key,
    required this.tugas,
    required this.token,
    required this.userName,
  });

  @override
  State<TugasDaruratEditPage> createState() =>
      _TugasDaruratEditPageState();
}

class _TugasDaruratEditPageState
    extends State<TugasDaruratEditPage> {

  // =====================================================
  // COLOR
  // =====================================================

  static const primaryColor =
      Color(0xFFC81414);

  // =====================================================
  // DATA
  // =====================================================

  List mekanikData = [];

  List equipmentData = [];

  List<int> selectedMekanik = [];

  int? selectedEquipment;

  String? tagNumber;

  DateTime? tglMulai;

  DateTime? tglSelesai;

  bool loading = false;

  String status = "pending";

  // =====================================================
  // CONTROLLER
  // =====================================================

  final eqClass =
      TextEditingController();

  final bom =
      TextEditingController();

  final taskList =
      TextEditingController();

  final lokasi =
      TextEditingController();

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {

    super.initState();

    eqClass.text =
        widget.tugas.eqClass;

    bom.text =
        widget.tugas.bom;

    taskList.text =
        widget.tugas.taskList;

    lokasi.text =
        widget.tugas.lokasi;

    status =
        widget.tugas.status;

    tglMulai =
        DateTime.tryParse(
      widget.tugas.tglMulai,
    );

    tglSelesai =
        DateTime.tryParse(
      widget.tugas.tglSelesai,
    );



selectedMekanik = [];

    loadData();
  }

  // =====================================================
  // LOAD DATA
  // =====================================================

  Future<void> loadData() async {

    try {

      setState(() {
        loading = true;
      });

      final users =
          await ApiService.getUsers(
        widget.token,
      );

      final eq =
          await ApiService.getEquipment(
        widget.token,
      );

      final mekanik =
          users.where(
        (u) =>
            u['role']
                .toString()
                .toLowerCase() ==
            'mekanik',
      ).toList();

      int? eqId;
int? mekanikId;

try {

  final foundEq = eq.firstWhere(
    (e) => e['name'].toString() == widget.tugas.equipment,
  );

  eqId = foundEq['id'];

} catch (_) {}

try {

  final foundMekanik = mekanik.firstWhere(
    (m) =>
        m['name'].toString().trim().toLowerCase() ==
        widget.tugas.namaMekanik.trim().toLowerCase(),
  );

  mekanikId = foundMekanik['id'];

} catch (_) {}

      setState(() {

  mekanikData = mekanik;

  equipmentData = eq;

  selectedEquipment = eqId;

  tagNumber = widget.tugas.tagNumber;

  if (mekanikId != null) {
    selectedMekanik = [mekanikId];
  }

  loading = false;
});

    } catch (e) {

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Gagal load data: $e",
          ),
        ),
      );
    }
  }

  // =====================================================
  // DATE PICKER
  // =====================================================

  Future<void> pickDate(
    bool mulai,
  ) async {

    final picked =
        await showDatePicker(

      context: context,

      initialDate:
          DateTime.now(),

      firstDate:
          DateTime(2020),

      lastDate:
          DateTime(2100),
    );

    if (picked != null) {

      setState(() {

        if (mulai) {

          tglMulai =
              picked;

        } else {

          tglSelesai =
              picked;
        }
      });
    }
  }

  // =====================================================
  // SUBMIT
  // =====================================================

  Future<void> submit() async {

    try {

      if (selectedEquipment ==
              null ||
          selectedMekanik
              .isEmpty) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Lengkapi data",
            ),
          ),
        );

        return;
      }

      if (tglMulai == null ||
          tglSelesai == null) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Pilih tanggal",
            ),
          ),
        );

        return;
      }

      // =====================================================
// VALIDASI TANGGAL TIDAK BOLEH TERLEWAT
// =====================================================

final today = DateTime.now();

final batasHariIni = DateTime(
  today.year,
  today.month,
  today.day,
);

final tanggalMulai = DateTime(
  tglMulai!.year,
  tglMulai!.month,
  tglMulai!.day,
);

if (tanggalMulai.isBefore(batasHariIni)) {

  ScaffoldMessenger.of(context).showSnackBar(

    SnackBar(

      content: const Text(
        "Tugas tidak bisa diperbarui karena tanggal sudah terlewat.",
      ),

      backgroundColor: Colors.red,

      behavior: SnackBarBehavior.floating,

      margin: const EdgeInsets.all(16),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );

  return;
}

      setState(() {
        loading = true;
      });

      final eq =
          equipmentData
              .cast<Map<String, dynamic>>()
              .firstWhere(

        (e) =>
            e['id'] ==
            selectedEquipment,

        orElse: () => {

          'name': '-',

          'tag_number': '-',
        },
      );

      for (var mekanikId
          in selectedMekanik) {

        final mekanik =
            mekanikData
                .cast<Map<String, dynamic>>()
                .firstWhere(

          (m) =>
              m['id'] ==
              mekanikId,

          orElse: () => {
            'name': 'Mekanik'
          },
        );

        await ApiService
            .updateTugasDarurat(

          widget.tugas.id,

          {

            "pemberi_tugas":
                widget.userName,

            "tgl_mulai":
                tglMulai!
                    .toIso8601String(),

            "tgl_selesai":
                tglSelesai!
                    .toIso8601String(),

            "mekanik_id":
                mekanikId,

            "nama_mekanik":
                mekanik['name'],

            "equipment_id":
                selectedEquipment,

            "equipment":
                eq['name'],

            "tag_number":
                eq['tag_number'],

            "eq_class":
                eqClass.text,

            "bom":
                bom.text,

            "task_list":
                taskList.text,

            "lokasi":
                lokasi.text,

            "status":
                status,
          },

          widget.token,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Tugas berhasil diperbarui",
          ),

          backgroundColor:
              Colors.green,
        ),
      );

      Navigator.pop(
        context,
        true,
      );

    } catch (e) {

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Gagal update: $e",
          ),
        ),
      );
    }
  }

  // =====================================================
  // SECTION
  // =====================================================

  Widget section(
    String title,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        top: 18,
        bottom: 14,
      ),

      child: Align(

        alignment:
            Alignment.centerLeft,

        child: Text(

          title,

          style:
              const TextStyle(

            fontSize: 18,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // INPUT
  // =====================================================

  Widget inputField(
    String hint,
    TextEditingController c, {

    int maxLines = 1,
  }) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: TextField(

        controller: c,

        maxLines: maxLines,

        decoration:
            InputDecoration(

          hintText: hint,

          filled: true,

          fillColor:
              Colors.white,

          border:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              18,
            ),

            borderSide:
                BorderSide.none,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // READONLY
  // =====================================================

  Widget readonly(
    String title,
    String value,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: TextField(

        readOnly: true,

        controller:
            TextEditingController(
          text: value,
        ),

        decoration:
            InputDecoration(

          labelText: title,

          filled: true,

          fillColor:
              Colors.white,

          border:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              18,
            ),

            borderSide:
                BorderSide.none,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // UI
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xFFF4F6FA,
      ),

      appBar: AppBar(

  leading: IconButton(

    icon: const Icon(
      Icons.arrow_back,
      color: Colors.white,
    ),

    onPressed: () {

      Navigator.pop(context, false);
    },
  ),

  elevation: 0,

  centerTitle: true,

  backgroundColor: primaryColor,

  title: const Text(

    "Edit Tugas Darurat",

    style: TextStyle(

      fontWeight: FontWeight.bold,

      color: Colors.white,
    ),
  ),
),
      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : SingleChildScrollView(

              padding:
                  const EdgeInsets.all(
                18,
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  // =====================================================
                  // INFORMASI DASAR
                  // =====================================================

                  section(
                    "Informasi Dasar",
                  ),

                  readonly(
                    "Pemberi Tugas",
                    widget.userName,
                  ),

                  // =====================================================
                  // TANGGAL
                  // =====================================================

                  Row(

                    children: [

                      Expanded(

                        child:
                            GestureDetector(

                          onTap: () =>
                              pickDate(
                            true,
                          ),

                          child: Container(

                            padding:
                                const EdgeInsets
                                    .all(
                              18,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  Colors.white,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                            ),

                            child:
                                Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                const Text(

                                  "Tanggal Mulai",

                                  style:
                                      TextStyle(

                                    fontSize:
                                        12,

                                    color:
                                        Colors.grey,
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(

                                  tglMulai ==
                                          null

                                      ? "-"

                                      : tglMulai!
                                          .toString()
                                          .split(
                                              " ")[0],

                                  style:
                                      const TextStyle(

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Expanded(

                        child:
                            GestureDetector(

                          onTap: () =>
                              pickDate(
                            false,
                          ),

                          child: Container(

                            padding:
                                const EdgeInsets
                                    .all(
                              18,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  Colors.white,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                            ),

                            child:
                                Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                const Text(

                                  "Tanggal Selesai",

                                  style:
                                      TextStyle(

                                    fontSize:
                                        12,

                                    color:
                                        Colors.grey,
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(

                                  tglSelesai ==
                                          null

                                      ? "-"

                                      : tglSelesai!
                                          .toString()
                                          .split(
                                              " ")[0],

                                  style:
                                      const TextStyle(

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // =====================================================
                  // PERSONEL
                  // =====================================================

                  section(
                    "Penugasan Personel",
                  ),

                  Container(

                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets
                            .all(
                      18,
                    ),

                    decoration:
                        BoxDecoration(

                      color:
                          Colors.white,

                      borderRadius:
                          BorderRadius
                              .circular(
                        22,
                      ),
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Wrap(

                          spacing: 8,

                          runSpacing: 8,

                          children:
                              selectedMekanik
                                  .map((id) {

                            final mekanik =
                                mekanikData
                                    .cast<Map<String, dynamic>>()
                                    .firstWhere(

                              (m) =>
                                  m['id'] ==
                                  id,

                              orElse: () => {
                                'name':
                                    'Mekanik'
                              },
                            );

                            return Container(

                              padding:
                                  const EdgeInsets
                                      .symmetric(

                                horizontal:
                                    12,

                                vertical:
                                    8,
                              ),

                              decoration:
                                  BoxDecoration(

                                color:
                                    primaryColor
                                        .withOpacity(
                                  0.08,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  12,
                                ),
                              ),

                              child: Row(

                                mainAxisSize:
                                    MainAxisSize
                                        .min,

                                children: [

                                  Text(

                                    mekanik[
                                        'name'],

                                    style:
                                        const TextStyle(

                                      fontWeight:
                                          FontWeight
                                              .w600,

                                      color:
                                          primaryColor,
                                    ),
                                  ),

                                  const SizedBox(
                                    width:
                                        8,
                                  ),

                                  GestureDetector(

                                    onTap:
                                        () {

                                      setState(() {

                                        selectedMekanik
                                            .remove(
                                          id,
                                        );
                                      });
                                    },

                                    child:
                                        const Icon(

                                      Icons
                                          .close,

                                      size:
                                          18,

                                      color:
                                          primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        DropdownButtonHideUnderline(

                          child:
                              DropdownButton<
                                  int>(

                            value:
                                null,

                            isExpanded:
                                true,

                            hint:
                                const Text(
                              "Pilih mekanik...",
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),

                            icon:
                                const Icon(
                              Icons
                                  .keyboard_arrow_down,
                            ),

                            items:
                                mekanikData
                                    .where(
                              (m) {

                                return !selectedMekanik
                                    .contains(
                                  m['id'],
                                );
                              },
                            ).map<
                                    DropdownMenuItem<
                                        int>>(
                              (m) {

                                return DropdownMenuItem<
                                    int>(

                                  value:
                                      m['id'],

                                  child:
                                      Text(
                                    m['name'],
                                  ),
                                );
                              },
                            ).toList(),

                            onChanged:
                                (val) {

                              if (val ==
                                  null) {
                                return;
                              }

                              if (selectedMekanik
                                  .contains(
                                val,
                              )) {
                                return;
                              }

                              setState(() {

                                selectedMekanik
                                    .add(
                                  val,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // =====================================================
                  // EQUIPMENT
                  // =====================================================

                  section(
                    "Equipment",
                  ),

                  DropdownButtonFormField(

                    value:
                        selectedEquipment,

                    decoration:
                        InputDecoration(

                      labelText:
                          "Pilih Equipment",

                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),
                    ),

                    items:
                        equipmentData.map<
                                DropdownMenuItem>(
                      (e) {

                        return DropdownMenuItem(

                          value:
                              e['id'],

                          child: Text(
                            e['name'],
                          ),
                        );
                      },
                    ).toList(),

                    onChanged: (val) {

                      final eq =
                          equipmentData
                              .cast<Map<String, dynamic>>()
                              .firstWhere(

                        (e) =>
                            e['id'] ==
                            val,

                        orElse: () => {

                          'tag_number': '-',
                        },
                      );

                      setState(() {

                        selectedEquipment =
                            val;

                        tagNumber =
                            eq['tag_number']
                                .toString();
                      });
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  readonly(
                    "Tag Number",
                    tagNumber ?? "-",
                  ),

                  // =====================================================
                  // DETAIL
                  // =====================================================

                  section(
                    "Detail Pekerjaan",
                  ),

                  inputField(
                    "EQ Class",
                    eqClass,
                  ),

                  inputField(
                    "BoM",
                    bom,
                  ),

                  inputField(
                    "Task List",
                    taskList,
                    maxLines: 4,
                  ),

                  inputField(
                    "Lokasi",
                    lokasi,
                  ),

                  // =====================================================
                  // STATUS
                  // =====================================================

                  section(
                    "Status",
                  ),

                  DropdownButtonFormField<String>(

                    value: status,

                    decoration:
                        InputDecoration(

                      labelText:
                          "Status",

                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),
                    ),

                    items: const [

                      DropdownMenuItem(
                        value:
                            "pending",
                        child:
                            Text(
                          "Release Order",
                        ),
                      ),

                      DropdownMenuItem(
                        value:
                            "dikerjakan",
                        child:
                            Text(
                          "Dikerjakan",
                        ),
                      ),

                      DropdownMenuItem(
                        value:
                            "selesai",
                        child:
                            Text(
                          "Selesai",
                        ),
                      ),
                    ],

                    onChanged:
                        (val) {

                      setState(() {

                        status =
                            val!;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // =====================================================
// BUTTON
// =====================================================

Row(

  children: [

    Expanded(

      child: ElevatedButton(

        style: ElevatedButton.styleFrom(

          backgroundColor: primaryColor,

          elevation: 0,

          padding: const EdgeInsets.all(18),

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(18),
          ),
        ),

        onPressed: loading ? null : submit,

        child: loading

            ? const SizedBox(

                width: 22,

                height: 22,

                child: CircularProgressIndicator(

                  color: Colors.white,

                  strokeWidth: 2,
                ),
              )

            : const Text(

                "Simpan",

                style: TextStyle(

                  color: Colors.white,

                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ),

    const SizedBox(width: 12),

    Expanded(

      child: OutlinedButton(

        style: OutlinedButton.styleFrom(

          padding: const EdgeInsets.all(18),

          side: const BorderSide(

            color: primaryColor,
          ),

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(18),
          ),
        ),

        onPressed: () {

          Navigator.pop(context, false);
        },

        child: const Text(

          "Batal",

          style: TextStyle(

            color: primaryColor,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
),

const SizedBox(height: 30),

                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
    );
  }
}