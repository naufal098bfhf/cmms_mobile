import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';

class TugasDaruratCreatePage extends StatefulWidget {

  final String token;
  final String userName;

  const TugasDaruratCreatePage({
    super.key,
    required this.token,
    required this.userName,
  });

  @override
  State<TugasDaruratCreatePage> createState() =>
      _TugasDaruratCreatePageState();
}

class _TugasDaruratCreatePageState
    extends State<TugasDaruratCreatePage> {

  // =====================================================
  // COLOR
  // =====================================================

  static const primaryColor =
      Color(0xFFC81414);

  // =====================================================
  // DATA
  // =====================================================

  List mekanikData = [];

  List<int> selectedMekanik = [];

  List equipmentData = [];

  int? selectedEquipment;

  String? tagNumber;

  DateTime? tglMulai;

  DateTime? tglSelesai;

  bool isLoading = false;

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

    loadData();
  }

  // =====================================================
  // LOAD DATA
  // =====================================================

  void loadData() async {

    final users =
        await ApiService.getUsers(
      widget.token,
    );

    final eq =
        await ApiService.getEquipment(
      widget.token,
    );

    setState(() {

      mekanikData =
          users.where(
        (u) =>
            u['role'] ==
            'mekanik',
      ).toList();

      equipmentData = eq;
    });
  }

  // =====================================================
  // SUBMIT
  // =====================================================

  Future<void> submit() async {

    if (selectedMekanik.isEmpty ||
        selectedEquipment == null ||
        tglMulai == null ||
        tglSelesai == null ||
        eqClass.text.isEmpty ||
        taskList.text.isEmpty ||
        lokasi.text.isEmpty) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          content: Text(
            "Lengkapi semua data",
          ),

          backgroundColor:
              Colors.red,
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

final mulai = DateTime(
  tglMulai!.year,
  tglMulai!.month,
  tglMulai!.day,
);

if (mulai.isBefore(batasHariIni)) {

  ScaffoldMessenger.of(context).showSnackBar(

    SnackBar(

      content: const Text(
        "Tugas tidak bisa ditambahkan karena tanggal sudah terlewat.",
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

      isLoading = true;
    });

    try {

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

      bool berhasil = true;

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

            'name': 'Mekanik',
          },
        );

        final response =
            await ApiService
                .createTugasDarurat({

          "pemberi_tugas":
              widget.userName,

         "tgl_mulai":
    "${tglMulai!.year.toString().padLeft(4, '0')}-"
    "${tglMulai!.month.toString().padLeft(2, '0')}-"
    "${tglMulai!.day.toString().padLeft(2, '0')}",

"tgl_selesai":
    "${tglSelesai!.year.toString().padLeft(4, '0')}-"
    "${tglSelesai!.month.toString().padLeft(2, '0')}-"
    "${tglSelesai!.day.toString().padLeft(2, '0')}",

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
              "pending",

        }, widget.token);

        if (response == null) {

          berhasil = false;
        }
      }

      if (!mounted) return;

      if (berhasil) {

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(

          const SnackBar(

            content: Text(
              "Tugas berhasil disimpan",
            ),

            backgroundColor:
                Colors.green,
          ),
        );

        await Future.delayed(
          const Duration(
            milliseconds: 700,
          ),
        );

        Navigator.pop(
          context,
          true,
        );

      } else {

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(

          const SnackBar(

            content: Text(
              "Gagal menyimpan tugas",
            ),

            backgroundColor:
                Colors.red,
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content: Text(
            "Error: $e",
          ),

          backgroundColor:
              Colors.red,
        ),
      );

    } finally {

      if (mounted) {

        setState(() {

          isLoading = false;
        });
      }
    }
  }

  // =====================================================
  // SECTION TITLE
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
  // INPUT FIELD
  // =====================================================

  Widget inputField(
    String hint,
    TextEditingController c,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: TextField(

        controller: c,

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
  // DATE PICKER
  // =====================================================

  Future<void> pickDate(
    bool isMulai,
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

        if (isMulai) {

          tglMulai = picked;

        } else {

          tglSelesai = picked;
        }
      });
    }
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

        elevation: 0,

        centerTitle: true,

        backgroundColor:
            primaryColor,

        title: const Text(

          "Tambah Tugas Darurat",

          style: TextStyle(

            fontWeight:
                FontWeight.bold,

            color: Colors.white,
          ),
        ),
      ),

      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          18,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

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

                  child: GestureDetector(

                    onTap: () =>
                        pickDate(true),

                    child: Container(

                      padding:
                          const EdgeInsets.all(
                        18,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          const Text(

                            "Tanggal Mulai",

                            style:
                                TextStyle(

                              fontSize: 12,

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

                                : tglMulai
                                    .toString()
                                    .split(" ")[0],

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

                  child: GestureDetector(

                    onTap: () =>
                        pickDate(false),

                    child: Container(

                      padding:
                          const EdgeInsets.all(
                        18,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          const Text(

                            "Tanggal Selesai",

                            style:
                                TextStyle(

                              fontSize: 12,

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

                                : tglSelesai
                                    .toString()
                                    .split(" ")[0],

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

  width: double.infinity,

  padding:
      const EdgeInsets.all(
    18,
  ),

  decoration:
      BoxDecoration(

    color: Colors.white,

    borderRadius:
        BorderRadius.circular(
      22,
    ),
  ),

  child: Column(

    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      // =====================================================
      // CHIP SELECTED
      // =====================================================

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
              'name': 'Mekanik'
            },
          );

          return Container(

            padding:
                const EdgeInsets.symmetric(

              horizontal: 12,

              vertical: 8,
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
                  MainAxisSize.min,

              children: [

                Text(

                  mekanik['name'],

                  style:
                      const TextStyle(

                    fontWeight:
                        FontWeight.w600,

                    color:
                        primaryColor,
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                GestureDetector(

                  onTap: () {

                    setState(() {

                      selectedMekanik
                          .remove(id);
                    });
                  },

                  child:
                      const Icon(

                    Icons.close,

                    size: 18,

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

      // =====================================================
      // DROPDOWN
      // =====================================================

      DropdownButtonHideUnderline(

        child:
            DropdownButton<int>(

          value: null,

          isExpanded: true,

          hint:
              const Text(
            "Pilih mekanik...",
          ),

          borderRadius:
              BorderRadius.circular(
            14,
          ),

          icon:
              const Icon(
            Icons
                .keyboard_arrow_down,
          ),

          items: mekanikData
              .where((m) {

            return !selectedMekanik
                .contains(
              m['id'],
            );
          }).map<
                  DropdownMenuItem<
                      int>>(
            (m) {

              return DropdownMenuItem<
                  int>(

                value:
                    m['id'],

                child: Text(
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
                  .add(val);
            });
          },
        ),
      ),
    ],
  ),
),

// =====================================================
// DROPDOWN
// =====================================================

DropdownButtonHideUnderline(

  child:
      DropdownButton<int>(

    value: null,

    isExpanded: true,

    hint:
        const Text(
      "Pilih mekanik...",
    ),

    borderRadius:
        BorderRadius.circular(
      14,
    ),

    icon:
        const Icon(
      Icons
          .keyboard_arrow_down,
    ),

    items: mekanikData
        .where((m) {

      return !selectedMekanik
          .contains(
        m['id'],
      );
    }).map<
            DropdownMenuItem<
                int>>(
      (m) {

        return DropdownMenuItem<
            int>(

          value:
              m['id'],

          child: Text(
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
            .add(val);
      });
    },
  ),
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
            // DETAIL PEKERJAAN
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
            ),

            inputField(
              "Lokasi",
              lokasi,
            ),

            const SizedBox(
              height: 30,
            ),

            // =====================================================
            // BUTTON
            // =====================================================

            SizedBox(

              width:
                  double.infinity,

              height: 58,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      primaryColor,

                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),

                onPressed:
                    isLoading
                        ? null
                        : submit,

                child: isLoading

                    ? const CircularProgressIndicator(
                        color:
                            Colors.white,
                      )

                    : const Text(

                        "Simpan Tugas",

                        style: TextStyle(

                          fontSize: 16,

                          color:
                              Colors.white,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}