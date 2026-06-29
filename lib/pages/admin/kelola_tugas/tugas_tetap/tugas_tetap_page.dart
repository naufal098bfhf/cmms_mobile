import 'package:flutter/material.dart';

import '../../../../models/tugas_tetap_model.dart';
import '../../../../services/api_service.dart';
import '../../../../models/login_models.dart';

import '../../../../widgets/bottom_admin_navbar.dart';

import 'tugas_tetap_create.dart';
import 'tugas_tetap_edit.dart';

class TugasTetapPage extends StatefulWidget {

  final User user;

  const TugasTetapPage({
    super.key,
    required this.user,
  });

    @override
    State<TugasTetapPage> createState() =>
        _TugasTetapPageState();
  }

  class _TugasTetapPageState
      extends State<TugasTetapPage> {

    // ======================================================
    // COLOR
    // ======================================================

    static const primaryColor =
        Color(0xFFC81414);

    // ======================================================
    // DATA
    // ======================================================

    List<TugasTetap> allData = [];

    List<TugasTetap> filtered = [];

    bool loading = true;

    final TextEditingController search =
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

    Future<void> loadData() async {

      try {

        setState(() {
          loading = true;
        });

        final data =
            await ApiService
                .getTugasTetap();

        if (!mounted) return;

        setState(() {

          allData = data;

          filtered = data;

          loading = false;
        });

      } catch (e) {

        if (!mounted) return;

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(

          SnackBar(

            content: Text(
              "Error : $e",
            ),

            backgroundColor:
                Colors.red,
          ),
        );
      }
    }

    // ======================================================
    // SEARCH
    // ======================================================

    void doSearch(String val) {

      final q =
          val.toLowerCase();

      setState(() {

        filtered =
            allData.where((t) {

          return t.namaMekanik
                  .toLowerCase()
                  .contains(q) ||

              t.equipment
                  .toLowerCase()
                  .contains(q) ||

              t.tagNumber
                  .toLowerCase()
                  .contains(q) ||

              t.lokasi
                  .toLowerCase()
                  .contains(q);

        }).toList();
      });
    }

    // ======================================================
    // STATUS BADGE
    // ======================================================

    Widget statusBadge(
      String status,
    ) {

      Color c = Colors.orange;

      String text =
          "Release Order";

      if (status == "dikerjakan") {

        c = Colors.blue;

        text = "Dikerjakan";
      }

      if (status == "selesai") {

        c = Colors.green;

        text = "Selesai";
      }

      return Container(

        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        decoration: BoxDecoration(

          color:
              c.withOpacity(0.1),

          borderRadius:
              BorderRadius.circular(
            30,
          ),
        ),

        child: Text(

          text,

          style: TextStyle(
            color: c,
            fontWeight:
                FontWeight.bold,
            fontSize: 11,
          ),
        ),
      );
    }

    // ======================================================
    // NOTIFICATION
    // ======================================================

    void showNotif(String text) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content: Text(text),

          backgroundColor:
              Colors.green,

          behavior:
              SnackBarBehavior.floating,

          margin:
              const EdgeInsets.all(16),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      );
    }

    // ======================================================
    // DELETE
    // ======================================================

    void confirmDelete(int id) {

      showDialog(

        context: context,

        builder: (_) {

          return AlertDialog(

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            title:
                const Text(
              "Hapus Tugas",
            ),

            content:
                const Text(
              "Apakah anda yakin ingin menghapus tugas ini?",
            ),

            actions: [

              TextButton(

                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },

                child:
                    const Text(
                  "Batal",
                ),
              ),

              ElevatedButton(

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      primaryColor,
                ),

                onPressed:
                    () async {

                  Navigator.pop(
                    context,
                  );

                  await ApiService
                      .deleteTugasTetap(
                    id,
                  );

                  showNotif(
                    "Tugas berhasil dihapus",
                  );

                  loadData();
                },

                child:
                    const Text(
                  "Hapus",
                ),
              ),
            ],
          );
        },
      );
    }

    // ======================================================
    // DETAIL ITEM
    // ======================================================

    Widget detailItem(
      String title,
      String value,
      IconData icon,
    ) {

      return Container(

        margin:
            const EdgeInsets.only(
          bottom: 18,
        ),

        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(

          color:
              const Color(
            0xFFF7F7F9,
          ),

          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        child: Row(

          children: [

            Container(

              padding:
                  const EdgeInsets.all(
                12,
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
                  16,
                ),
              ),

              child: Icon(
                icon,
                color:
                    primaryColor,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(

                    title,

                    style:
                        TextStyle(
                      color:
                          Colors.grey[
                              600],
                      fontSize:
                          11,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(

                    value.isEmpty
                        ? "-"
                        : value,

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ======================================================
    // DETAIL MODAL
    // ======================================================

    void showDetail(
      TugasTetap t,
    ) {

      showModalBottomSheet(

        context: context,

        backgroundColor:
            Colors.transparent,

        isScrollControlled: true,

        builder: (_) {

          return Container(

            padding:
                const EdgeInsets.all(
              20,
            ),

            decoration:
                const BoxDecoration(

              color:
                  Colors.white,

              borderRadius:
                  BorderRadius.vertical(
                top:
                    Radius.circular(
                  32,
                ),
              ),
            ),

            child:
                SingleChildScrollView(

              child: Column(

                children: [

                  Container(

                    width: 60,

                    height: 5,

                    decoration:
                        BoxDecoration(

                      color:
                          Colors.grey[
                              300],

                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Row(

                    children: [

                      Container(

                        padding:
                            const EdgeInsets
                                .all(
                          16,
                        ),

                        decoration:
                            BoxDecoration(

                          color:
                              primaryColor
                                  .withOpacity(
                            0.08,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),

                        child: const Icon(
                          Icons
                              .precision_manufacturing,
                          color:
                              primaryColor,
                          size: 30,
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(

                              t.equipment,

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                                fontSize:
                                    24,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(

                              t.tagNumber,

                              style:
                                  TextStyle(
                                color:
                                    Colors
                                            .grey[
                                        600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  detailItem(
                    "Nama Mekanik",
                    t.namaMekanik,
                    Icons.person,
                  ),

                  detailItem(
                    "Lokasi",
                    t.lokasi,
                    Icons.location_on,
                  ),

                  detailItem(
                    "Task List",
                    t.taskList,
                    Icons.task_alt,
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  Container(

                    width: double.infinity,

                    padding:
                        const EdgeInsets
                            .all(16),

                    decoration:
                        BoxDecoration(

                      color:
                          Colors.orange
                              .withOpacity(
                        0.08,
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        18,
                      ),
                    ),

                    child: Row(

                      children: [

                        const Icon(
                          Icons.info,
                          color:
                              Colors.orange,
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Text(

                          "Release Order",

                          style:
                              TextStyle(
                            color:
                                Colors.orange[
                                    800],
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // ======================================================
    // CARD
    // ======================================================

    Widget taskCard(
      TugasTetap t,
    ) {

      return GestureDetector(

        onTap: () {
          showDetail(t);
        },

        child: Container(

          margin:
              const EdgeInsets.only(
            bottom: 18,
          ),

          padding:
              const EdgeInsets.all(18),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              24,
            ),

            boxShadow: [

              BoxShadow(

                color:
                    Colors.black
                        .withOpacity(
                  0.03,
                ),

                blurRadius: 12,

                offset:
                    const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child: Column(

            children: [

              Row(

                children: [

                  Container(

                    padding:
                        const EdgeInsets
                            .all(14),

                    decoration:
                        BoxDecoration(

                      color:
                          primaryColor
                              .withOpacity(
                        0.08,
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        18,
                      ),
                    ),

                    child: const Icon(
                      Icons
                          .precision_manufacturing,
                      color:
                          primaryColor,
                    ),
                  ),

                  const SizedBox(
                    width: 14,
                  ),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(

                          t.equipment,

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontSize:
                                18,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Text(

                          t.namaMekanik,

                          style:
                              TextStyle(
                            color:
                                Colors
                                        .grey[
                                    600],
                            fontSize:
                                13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  statusBadge(
                    t.status,
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              Row(

                children: [

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(

                          "Tag Number",

                          style:
                              TextStyle(
                            color:
                                Colors
                                        .grey[
                                    500],
                            fontSize:
                                11,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Text(

                          t.tagNumber,

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontSize:
                                14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(

                          "Lokasi",

                          style:
                              TextStyle(
                            color:
                                Colors
                                        .grey[
                                    500],
                            fontSize:
                                11,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Text(

                          t.lokasi,

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontSize:
                                14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 22,
              ),

              Row(

                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  ElevatedButton.icon(

                    style:
                        ElevatedButton
                            .styleFrom(

                      elevation: 0,

                      backgroundColor:
                          Colors.blue,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                    ),

                    onPressed: () async {

  final result = await Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) => TugasTetapEditPage(
        tugas: t,
        token: widget.user.token,
        userName: widget.user.name,
      ),
    ),
  );

  if (result == true) {

    await loadData();

    showNotif("Tugas berhasil diupdate");
  }
},

                    icon:
                        const Icon(
                      Icons.edit,
                      color:
                          Colors.white,
                      size: 18,
                    ),

                    label:
                        const Text(
                      "Edit",
                      style: TextStyle(
                        color:
                            Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  ElevatedButton.icon(

                    style:
                        ElevatedButton
                            .styleFrom(

                      elevation: 0,

                      backgroundColor:
                          primaryColor,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                    ),

                    onPressed: () {
                      confirmDelete(
                        t.id,
                      );
                    },

                    icon:
                        const Icon(
                      Icons.delete,
                      color:
                          Colors.white,
                      size: 18,
                    ),

                    label:
                        const Text(
                      "Hapus",
                      style: TextStyle(
                        color:
                            Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
          0xFFF3F4F8,
        ),

        appBar: AppBar(

  elevation: 0,

  backgroundColor:
      primaryColor,

  centerTitle: true,

  title: const Text(

    "Tugas Tetap",

    style: TextStyle(
      fontWeight:
          FontWeight.bold,
      color: Colors.white,
    ),
  ),
),

// ==========================
// NAVBAR BAWAH
// ==========================

bottomNavigationBar: BottomAdminNavbar(
  currentIndex:
      widget.user.role.toLowerCase().trim() == 'maintenance-planning'
          ? 2
          : 3,
  user: widget.user,
),

// ==========================
// FLOAT BUTTON
// ==========================

floatingActionButton:
    FloatingActionButton.extended(

  backgroundColor:
      primaryColor,

  elevation: 8,

  icon: const Icon(
    Icons.add,
    color: Colors.white,
  ),

  label: const Text(
    "Tambah",
    style: TextStyle(
      color: Colors.white,
      fontWeight:
          FontWeight.bold,
    ),
  ),
onPressed: () async {

  final result = await Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) => TugasTetapCreatePage(

        token: widget.user.token,

        userName: widget.user.name,
      ),
    ),
  );

  if (result == true) {

    await loadData();

    showNotif(
      "Tugas berhasil ditambahkan",
    );
  }
},
),

        

        body: loading

            ? const Center(
                child:
                    CircularProgressIndicator(),
              )

            : Column(

                children: [

                  Padding(

                    padding:
                        const EdgeInsets
                            .all(16),

                    child: Container(

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                      ),

                      child: TextField(

                        controller:
                            search,

                        onChanged:
                            doSearch,

                        decoration:
                            InputDecoration(

                          hintText:
                              "Cari mekanik, equipment, lokasi...",

                          hintStyle:
                              TextStyle(
                            color:
                                Colors
                                    .grey[
                                        500],
                          ),

                          prefixIcon:
                              const Icon(
                            Icons.search,
                            color:
                                primaryColor,
                          ),

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),

                            borderSide:
                                BorderSide
                                    .none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(

                    child:
                        filtered
                                .isEmpty
                            ? Center(

                                child:
                                    Column(

                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,

                                  children: [

                                    Icon(
                                      Icons
                                          .assignment_late_outlined,
                                      size:
                                          90,
                                      color:
                                          Colors.grey[
                                              400],
                                    ),

                                    const SizedBox(
                                      height:
                                          18,
                                    ),

                                    Text(

                                      "Belum ada tugas",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.grey[
                                                600],
                                        fontSize:
                                            16,
                                      ),
                                    ),
                                  ],
                                ),
                              )

                            : RefreshIndicator(

                                onRefresh:
                                    loadData,

                                child:
                                    ListView.builder(

                                  padding:
                                      const EdgeInsets
                                          .fromLTRB(
                                    16,
                                    0,
                                    16,
                                    100,
                                  ),

                                  itemCount:
                                      filtered
                                          .length,

                                  itemBuilder:
                                      (
                                    context,
                                    i,
                                  ) {

                                    return taskCard(
                                      filtered[
                                          i],
                                    );
                                  },
                                ),
                              ),
                  ),
                ],
              ),
      );
    }
  }