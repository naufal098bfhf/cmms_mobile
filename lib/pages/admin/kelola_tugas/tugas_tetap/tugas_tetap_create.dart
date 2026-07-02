import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';

class TugasTetapCreatePage extends StatefulWidget {

  final String token;
  final String userName;

  const TugasTetapCreatePage({
    super.key,
    required this.token,
    required this.userName,
  });

  @override
  State<TugasTetapCreatePage> createState() =>
      _TugasTetapCreatePageState();
}

class _TugasTetapCreatePageState
    extends State<TugasTetapCreatePage> {

  // ======================================================
  // COLOR
  // ======================================================

  static const primaryColor =
      Color(0xFFC81414);

  // ======================================================
  // DATA
  // ======================================================

  String? jenisTugas;

  String? hari;

  int? tanggalBulanan;

  DateTime? tanggalTahunan;

  List<dynamic> mekanikData = [];

  List<int> selectedMekanik = [];

  List<dynamic> equipmentData = [];

  int? selectedEquipment;

  String? tagNumber;

  // ======================================================
  // CONTROLLER
  // ======================================================

  final eqClass =
      TextEditingController();

  final bom =
      TextEditingController();

  final taskList =
      TextEditingController();

  final lokasi =
      TextEditingController();

  // ======================================================
  // INIT
  // ======================================================

  @override
  void initState() {

    super.initState();

    loadData();
  }

  // ======================================================
  // LOAD DATA
  // ======================================================

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

  // ======================================================
  // SUBMIT
  // ======================================================

  void submit() async {

    if (jenisTugas == null ||
        selectedMekanik.isEmpty ||
        selectedEquipment == null ||
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
        ),
      );

      return;
    }

    final eq =
        equipmentData.firstWhere(
      (e) =>
          e['id'] ==
          selectedEquipment,
    );

    for (var mekanikId
        in selectedMekanik) {

      final mekanik =
          mekanikData.firstWhere(
        (m) =>
            m['id'] ==
            mekanikId,
      );

      Map<String, dynamic>
          data = {

        "pemberi_tugas":
            widget.userName,

        "jenis_tugas":
            jenisTugas,

        "repeat_type":
            jenisTugas,

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
      };

      // ======================================================
      // MINGGUAN
      // ======================================================

      if (jenisTugas ==
          "mingguan") {

        data[
            "hari_mingguan"] =
            hari;

        data[
            "repeat_value"] =
            hari;
      }

      // ======================================================
      // BULANAN
      // ======================================================

      else if (jenisTugas ==
          "bulanan") {

        data[
            "tanggal_bulanan"] =
            tanggalBulanan;

        data[
            "repeat_value"] =
            tanggalBulanan;
      }

      // ======================================================
      // TAHUNAN
      // ======================================================

      else {

        data[
            "tanggal_tahunan"] =
            tanggalTahunan
                ?.toIso8601String();

        data[
            "repeat_value"] =
            tanggalTahunan
                .toString();
      }

      await ApiService
          .createTugasTetap(
        data,
        widget.token,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(

      const SnackBar(
        content: Text(
          "Tugas berhasil dibuat",
        ),
      ),
    );

    Navigator.pop(context);
  }

  // ======================================================
  // SECTION TITLE
  // ======================================================

  Widget sectionTitle(
    String title,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 14,
        top: 10,
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

  // ======================================================
  // INPUT FIELD
  // ======================================================

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

  // ======================================================
  // READONLY
  // ======================================================

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

  // ======================================================
  // UI
  // ======================================================

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

          "Tambah Tugas Tetap",

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

          children: [

            // ======================================================
            // INFORMASI DASAR
            // ======================================================

            sectionTitle(
              "Informasi Dasar",
            ),

            readonly(
              "Pemberi Tugas",
              widget.userName,
            ),

            // ======================================================
            // JENIS TUGAS
            // ======================================================

            DropdownButtonFormField(

              value: jenisTugas,

              decoration:
                  InputDecoration(

                labelText:
                    "Jenis Tugas",

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
                  value: "mingguan",
                  child:
                      Text(
                    "Mingguan",
                  ),
                ),

                DropdownMenuItem(
                  value: "bulanan",
                  child:
                      Text(
                    "Bulanan",
                  ),
                ),

                DropdownMenuItem(
                  value: "tahunan",
                  child:
                      Text(
                    "Tahunan",
                  ),
                ),
              ],

              onChanged: (val) {

                setState(() {

                  jenisTugas = val;
                });
              },
            ),

            const SizedBox(
              height: 18,
            ),

            // ======================================================
            // MINGGUAN
            // ======================================================

            if (jenisTugas ==
                "mingguan")

              DropdownButtonFormField(

                value: hari,

                decoration:
                    InputDecoration(

                  labelText:
                      "Pilih Hari",

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

                items: [

                  "senin",
                  "selasa",
                  "rabu",
                  "kamis",
                  "jumat",
                  "sabtu",
                  "minggu"

                ].map((e) {

                  return DropdownMenuItem(
                    value: e,
                    child:
                        Text(e),
                  );
                }).toList(),

                onChanged: (val) {

                  setState(() {

                    hari = val;
                  });
                },
              ),

            // ======================================================
            // BULANAN
            // ======================================================

            if (jenisTugas ==
                "bulanan")

              Container(

                width:
                    double.infinity,

                margin:
                    const EdgeInsets.only(
                  bottom: 16,
                ),

                child: ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.white,

                    foregroundColor:
                        Colors.black,

                    elevation: 0,

                    padding:
                        const EdgeInsets.all(
                      18,
                    ),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  onPressed: () async {

                    final picked =
                        await showDatePicker(

                      context: context,

                      initialDate:
                          DateTime.now(),

                      firstDate:
                          DateTime(2024),

                      lastDate:
                          DateTime(2100),
                    );

                    if (picked != null) {

                      setState(() {

                        tanggalBulanan =
                            picked.day;
                      });
                    }
                  },

                  child: Text(

                    tanggalBulanan == null

                        ? "Pilih Tanggal"

                        : "Tanggal $tanggalBulanan",
                  ),
                ),
              ),

            // ======================================================
            // TAHUNAN
            // ======================================================

            if (jenisTugas ==
                "tahunan")

              Container(

                width:
                    double.infinity,

                margin:
                    const EdgeInsets.only(
                  bottom: 16,
                ),

                child: ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.white,

                    foregroundColor:
                        Colors.black,

                    elevation: 0,

                    padding:
                        const EdgeInsets.all(
                      18,
                    ),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  onPressed: () async {

                    final picked =
                        await showDatePicker(

                      context: context,

                      initialDate:
                          DateTime.now(),

                      firstDate:
                          DateTime(2024),

                      lastDate:
                          DateTime(2100),
                    );

                    if (picked != null) {

                      setState(() {

                        tanggalTahunan =
                            picked;
                      });
                    }
                  },

                  child: Text(

                    tanggalTahunan == null

                        ? "Pilih Kalender"

                        : tanggalTahunan
                            .toString()
                            .split(" ")[0],
                  ),
                ),
              ),

            // ======================================================
            // PERSONEL
            // ======================================================

            sectionTitle(
              "Penugasan Personel",
            ),

            Container(

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

                boxShadow: [

                  BoxShadow(

                    color:
                        Colors.black
                            .withOpacity(
                      0.03,
                    ),

                    blurRadius: 10,

                    offset:
                        const Offset(
                      0,
                      4,
                    ),
                  ),
                ],
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const Text(

                    "Mekanik",

                    style: TextStyle(

                      fontWeight:
                          FontWeight.w600,

                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Container(

                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      14,
                    ),

                    decoration:
                        BoxDecoration(

                      border: Border.all(
                        color:
                            Colors.grey
                                .shade300,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        14,
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
                                    .firstWhere(
                              (m) =>
                                  m['id'] ==
                                  id,
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
                                            .remove(
                                          id,
                                        );
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
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // ======================================================
            // EQUIPMENT
            // ======================================================

            sectionTitle(
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

              items: equipmentData
                  .map<
                      DropdownMenuItem>(
                (e) {

                  return DropdownMenuItem(

                    value: e['id'],

                    child: Text(
                      e['name'],
                    ),
                  );
                },
              ).toList(),

              onChanged: (val) {

                final eq =
                    equipmentData
                        .firstWhere(
                  (e) =>
                      e['id'] ==
                      val,
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

            // ======================================================
            // DETAIL
            // ======================================================

            sectionTitle(
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
              height: 28,
            ),

            // ======================================================
            // BUTTON
            // ======================================================

            SizedBox(

              width:
                  double.infinity,

              height: 58,

              child:
                  ElevatedButton(

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
                    submit,

                child:
                    const Text(

                  "Simpan Tugas",

                  style: TextStyle(

                    fontSize: 16,

                    color: Colors.white,

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