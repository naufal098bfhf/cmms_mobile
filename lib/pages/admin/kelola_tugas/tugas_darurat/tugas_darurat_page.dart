import 'package:flutter/material.dart';

import '../../../../models/tugas_darurat_admin_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/bottom_admin_navbar.dart';
import '../../../../models/login_models.dart';

import 'tugas_darurat_create.dart';
import 'tugas_darurat_edit.dart';

class TugasDaruratPage extends StatefulWidget {
  final User user;

  const TugasDaruratPage({
    super.key,
    required this.user,
  });

  @override
  State<TugasDaruratPage> createState() =>
      _TugasDaruratPageState();
}

class _TugasDaruratPageState
    extends State<TugasDaruratPage> {

  // ======================================================
  // PRIMARY COLOR
  // ======================================================

  static const primaryColor =
      Color(0xFFC81414);

  // ======================================================
  // DATA
  // ======================================================

  List<TugasDaruratAdminModel> data = [];

  List<TugasDaruratAdminModel> filtered = [];

  bool loading = true;

  final search =
      TextEditingController();

  // ======================================================
  // INIT
  // ======================================================

  @override
  void initState() {
    super.initState();
    load();
  }

  // ======================================================
  // LOAD
  // ======================================================

  Future<void> load() async {

    try {

      setState(() {
        loading = true;
      });

      final res =
          await ApiService
              .getTugasDaruratAdmin(
        widget.user.token,
      );

      final newData =
          res.map<TugasDaruratAdminModel>(
        (e) {

          return TugasDaruratAdminModel
              .fromJson(e);
        },
      ).toList();

      if (!mounted) return;

      setState(() {

        data = newData;

        filtered = List.from(
          newData,
        );

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

  void doSearch(
    String value,
  ) {

    final q =
        value.toLowerCase();

    setState(() {

      filtered =
          data.where((item) {

        final mekanik =
            item.namaMekanik
                .toLowerCase();

        final equipment =
            item.equipment
                .toLowerCase();

        final lokasi =
            item.lokasi
                .toLowerCase();

        return mekanik
                .contains(q) ||
            equipment
                .contains(q) ||
            lokasi.contains(q);

      }).toList();
    });
  }

  // ======================================================
  // STATUS COLOR
  // ======================================================

  Color statusColor(
    String status,
  ) {

    switch (status) {

      case "selesai":
        return Colors.green;

      case "dikerjakan":
        return Colors.blue;

      default:
        return Colors.orange;
    }
  }

  // ======================================================
  // STATUS TEXT
  // ======================================================

  String statusText(
    String status,
  ) {

    switch (status) {

      case "pending":
        return "Release Order";

      case "dikerjakan":
        return "Dikerjakan";

      case "selesai":
        return "Selesai";

      default:
        return status;
    }
  }

  // ======================================================
  // DETAIL
  // ======================================================

  void showDetail(
    TugasDaruratAdminModel item,
  ) {

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      backgroundColor:
          Colors.transparent,

      builder: (_) {

        return Container(

          padding:
              const EdgeInsets.all(24),

          decoration:
              const BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),

          child:
              SingleChildScrollView(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Center(
                  child: Container(
                    width: 70,
                    height: 6,
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
                ),

                const SizedBox(
                  height: 28,
                ),

                Row(

                  children: [

                    Container(

                      padding:
                          const EdgeInsets
                              .all(18),

                      decoration:
                          BoxDecoration(

                        color:
                            primaryColor
                                .withOpacity(
                          0.1,
                        ),

                        borderRadius:
                            BorderRadius
                                .circular(
                          22,
                        ),
                      ),

                      child: const Icon(
                        Icons
                            .precision_manufacturing,
                        color:
                            primaryColor,
                        size: 34,
                      ),
                    ),

                    const SizedBox(
                      width: 18,
                    ),

                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(
                            item.equipment,
                            style:
                                const TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            item.tagNumber,
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

                detailTile(
                  Icons.person,
                  "Nama Mekanik",
                  item.namaMekanik,
                ),

                detailTile(
                  Icons.location_on,
                  "Lokasi",
                  item.lokasi,
                ),

                detailTile(
                  Icons.task,
                  "Task List",
                  item.taskList,
                ),

                detailTile(
                  Icons.calendar_month,
                  "Tanggal Mulai",
                  item.tglMulai,
                ),

                detailTile(
                  Icons.calendar_today,
                  "Tanggal Selesai",
                  item.tglSelesai,
                ),

                const SizedBox(
                  height: 18,
                ),

                Container(

                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),

                  decoration:
                      BoxDecoration(

                    color:
                        statusColor(
                      item.status,
                    ).withOpacity(
                      0.1,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                  ),

                  child: Row(

                    children: [

                      Icon(
                        Icons.info,
                        color:
                            statusColor(
                          item.status,
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Text(
                        statusText(
                          item.status,
                        ),
                        style:
                            TextStyle(
                          color:
                              statusColor(
                            item.status,
                          ),
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ======================================================
  // DETAIL TILE
  // ======================================================

  Widget detailTile(
    IconData icon,
    String title,
    String value,
  ) {

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),

      decoration:
          BoxDecoration(

        color:
            const Color(
          0xfff8fafc,
        ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Row(

        children: [

          Container(

            padding:
                const EdgeInsets
                    .all(12),

            decoration:
                BoxDecoration(

              color:
                  primaryColor
                      .withOpacity(
                0.1,
              ),

              borderRadius:
                  BorderRadius
                      .circular(
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
            width: 16,
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
                        Colors
                            .grey[600],
                    fontSize:
                        12,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight
                            .bold,
                    fontSize:
                        15,
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
  // MINI INFO
  // ======================================================

  Widget miniInfo(
    String title,
    String value,
  ) {

    return Column(

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
                    500],
            fontSize:
                12,
          ),
        ),

        const SizedBox(
          height: 5,
        ),

        Text(
          value,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ======================================================
  // DELETE
  // ======================================================

  void deleteDialog(
    TugasDaruratAdminModel item,
  ) {

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              24,
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

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    14,
                  ),
                ),
              ),

              onPressed:
                  () async {

                try {

                  await ApiService
                      .deleteTugasDarurat(
                    item.id,
                  );

                  Navigator.pop(
                    context,
                  );

                  await load();

                  if (!mounted) {
                    return;
                  }

                  ScaffoldMessenger
                          .of(
                    context,
                  )
                      .showSnackBar(

                    const SnackBar(

                      content: Text(
                        "Tugas berhasil dihapus",
                      ),

                      backgroundColor:
                          Colors.green,
                    ),
                  );

                } catch (e) {

                  ScaffoldMessenger
                          .of(
                    context,
                  )
                      .showSnackBar(

                    SnackBar(

                      content: Text(
                        "Error : $e",
                      ),

                      backgroundColor:
                          Colors.red,
                    ),
                  );
                }
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
  // TASK CARD
  // ======================================================

  Widget taskCard(
    TugasDaruratAdminModel item,
  ) {

    return GestureDetector(

      onTap: () =>
          showDetail(item),

      child: Container(

        margin:
            const EdgeInsets.only(
          bottom: 18,
        ),

        padding:
            const EdgeInsets.all(20),

        decoration:
            BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            24,
          ),

          border: Border.all(
            color:
                Colors.grey
                    .shade100,
          ),

          boxShadow: [

            BoxShadow(
              color:
                  Colors.black
                      .withOpacity(
                0.03,
              ),
              blurRadius: 18,
              offset:
                  const Offset(
                0,
                8,
              ),
            ),
          ],
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

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
                      0.1,
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
                  width: 16,
                ),

                Expanded(

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(
                        item.equipment,
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        item.namaMekanik,
                        style:
                            TextStyle(
                          color:
                              Colors
                                      .grey[
                                  700],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(

                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration:
                      BoxDecoration(

                    color:
                        statusColor(
                      item.status,
                    ).withOpacity(
                      0.1,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      30,
                    ),
                  ),

                  child: Text(
                    statusText(
                      item.status,
                    ),
                    style:
                        TextStyle(
                      color:
                          statusColor(
                        item.status,
                      ),
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 22,
            ),

            Row(

              children: [

                Expanded(
                  child: miniInfo(
                    "Tag Number",
                    item.tagNumber,
                  ),
                ),

                Expanded(
                  child: miniInfo(
                    "Lokasi",
                    item.lokasi,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 24,
            ),

            Row(

              mainAxisAlignment:
                  MainAxisAlignment
                      .end,

              children: [

                ElevatedButton.icon(

                  style:
                      ElevatedButton
                          .styleFrom(

                    backgroundColor:
                        Colors.blue,

                    elevation: 0,

                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),
                    ),
                  ),

                  onPressed:
                      () async {

                    final result =
                        await Navigator
                            .push(

                      context,

                      MaterialPageRoute(

builder: (_) =>
                            TugasDaruratEditPage(


                          tugas:
                              item,

                          token:
                              widget.user.token,

                          userName:
                              widget.user.name,
                        ),
                      ),
                    );

                    if (result ==
                        true) {

                      await load();

                      if (!mounted) {
                        return;
                      }

                      ScaffoldMessenger
                              .of(
                        context,
                      )
                          .showSnackBar(

                        const SnackBar(

                          content: Text(
                            "Tugas berhasil diupdate",
                          ),

                          backgroundColor:
                              Colors.green,
                        ),
                      );
                    }
                  },

                  icon:
                      const Icon(
                    Icons.edit,
                    size: 18,
                    color:
                        Colors.white,
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

                    backgroundColor:
                        primaryColor,

                    elevation: 0,

                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),
                    ),
                  ),

                  onPressed:
                      () {
                    deleteDialog(
                      item,
                    );
                  },

                  icon:
                      const Icon(
                    Icons.delete,
                    size: 18,
                    color:
                        Colors.white,
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
        0xfff1f5f9,
      ),

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        backgroundColor:
            primaryColor,

        title:
            const Text(

          "Tugas Darurat",

          style: TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.3,
            color: Colors.white,
          ),
        ),
      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(

              children: [

                // ======================================================
                // SEARCH
                // ======================================================

                Padding(

                  padding:
                      const EdgeInsets
                          .all(18),

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

                      boxShadow: [

                        BoxShadow(
                          color:
                              Colors
                                  .black
                                  .withOpacity(
                            0.03,
                          ),
                          blurRadius:
                              10,
                          offset:
                              const Offset(
                            0,
                            4,
                          ),
                        ),
                      ],
                    ),

                    child:
                        TextField(

                      controller:
                          search,

                      onChanged:
                          doSearch,

                      style:
                          const TextStyle(
                        fontSize:
                            15,
                      ),

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
                            Icon(
                          Icons
                              .search_rounded,
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

                        contentPadding:
                            const EdgeInsets
                                .symmetric(
                          vertical:
                              18,
                        ),
                      ),
                    ),
                  ),
                ),

                // ======================================================
                // LIST
                // ======================================================

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
                                        100,
                                    color:
                                        Colors.grey[
                                            400],
                                  ),

                                  const SizedBox(
                                    height:
                                        20,
                                  ),

                                  Text(

                                    "Belum ada tugas",

                                    style:
                                        TextStyle(
                                      color:
                                          Colors.grey[
                                              600],
                                      fontSize:
                                          18,
                                    ),
                                  ),
                                ],
                              ),
                            )

                          : RefreshIndicator(

                              onRefresh:
                                  load,

                              child:
                                  ListView.builder(

                               padding:
                                const EdgeInsets
                                    .fromLTRB(
                              18,
                              0,
                              18,
                              180,
                            ),
                                itemCount:
                                    filtered
                                        .length,

                                itemBuilder:
                                    (
                                  _,
                                  index,
                                ) {

                                  return taskCard(
                                    filtered[
                                        index],
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),

      // ======================================================
      // FAB
      // ======================================================
// ======================================================
// NAVBAR BAWAH
// ======================================================
bottomNavigationBar: SafeArea(
  child: BottomAdminNavbar(
    currentIndex:
        widget.user.role.toLowerCase().trim() == 'maintenance-planning'
            ? 2
            : 3,
    user: widget.user,
  ),
),
// ======================================================
// FLOAT BUTTON
// ======================================================

floatingActionButtonLocation:
    FloatingActionButtonLocation.endFloat,

floatingActionButton:
    FloatingActionButton.extended(

  elevation: 8,

  backgroundColor: primaryColor,

  shape: RoundedRectangleBorder(

    borderRadius:
        BorderRadius.circular(18),
  ),

  icon: const Icon(
    Icons.add,
    color: Colors.white,
  ),

  label: const Text(

    "Tambah",

    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),

  onPressed: () async {

    final res =
        await Navigator.push(

      context,

      MaterialPageRoute(

builder: (_) =>
                            TugasDaruratCreatePage(


          token: widget.user.token,

          userName: widget.user.name,
        ),
      ),
    );

    if (res == true) {

      await load();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Tugas berhasil ditambahkan",
          ),

          backgroundColor:
              Colors.green,
        ),
      );
    }
  },
),
    );
  }
}