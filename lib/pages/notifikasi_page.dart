import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/login_models.dart';

// SESUAIKAN DENGAN FILE ANDA
import 'admin/kelola_tugas/tugas_darurat/tugas_darurat_page.dart';
import 'admin/kelola_tugas/tugas_tetap/tugas_tetap_page.dart';

class NotifikasiPage extends StatefulWidget {

  final User user;

  const NotifikasiPage({
    super.key,
    required this.user,
  });

  @override
  State<NotifikasiPage> createState() =>
      _NotifikasiPageState();
}

class _NotifikasiPageState
    extends State<NotifikasiPage> {
  List data = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      setState(() {
        loading = true;
      });

     final res =
    await ApiService.getNotifikasi(
  widget.user.id,
);

      if (!mounted) return;

      setState(() {
        data = res;
      });
    } catch (e) {
      debugPrint(
        "ERROR NOTIF: $e",
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  int get unreadCount =>
      data.where(
        (e) => e['read'] == false,
      ).length;

  IconData getIcon(String pesan) {
    final text =
        pesan.toLowerCase();

    if (text.contains("darurat")) {
      return Icons.warning_amber_rounded;
    }

    if (text.contains("tetap")) {
      return Icons.assignment_rounded;
    }

    if (text.contains("validasi")) {
      return Icons.verified_rounded;
    }

    return Icons.notifications_active;
  }

  Color getColor(String pesan) {
    final text =
        pesan.toLowerCase();

    if (text.contains("darurat")) {
      return Colors.red;
    }

    if (text.contains("tetap")) {
      return Colors.blue;
    }

    if (text.contains("validasi")) {
      return Colors.green;
    }

    return Colors.orange;
  }

  Future<void> bukaNotifikasi(
    dynamic notif,
  ) async {
    try {
      await ApiService.readNotifikasi(
        notif['id'],
      );

      if (!mounted) return;

      await load();

      final pesan =
          notif['pesan']
              .toString()
              .toLowerCase();

      if (pesan.contains(
        "darurat",
      )) {
       Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => TugasDaruratPage(
      user: widget.user,
    ),
  ),
);
        return;
      }

      if (pesan.contains(
        "tetap",
      )) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TugasTetapPage(
            user: widget.user,
          ),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            notif['pesan'],
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        "ERROR BUKA NOTIF: $e",
      );
    }
  }

  Future<void> hapusNotif(
    int id,
  ) async {
    try {
      await ApiService
          .hapusNotifikasi(id);

      await load();
    } catch (e) {
      debugPrint(
        "HAPUS ERROR: $e",
      );
    }
  }

  Widget buildNotifCard(
    dynamic n,
  ) {
    final color =
        getColor(n['pesan']);

    final icon =
        getIcon(n['pesan']);

    final unread =
        n['read'] == false;

    return Dismissible(
      key: Key(
        n['id'].toString(),
      ),

      background: Container(
        margin:
            const EdgeInsets.only(
          bottom: 14,
        ),

        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius:
              BorderRadius.circular(
            24,
          ),
        ),

        alignment:
            Alignment.centerRight,

        padding:
            const EdgeInsets.only(
          right: 24,
        ),

        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      direction:
          DismissDirection
              .endToStart,

      onDismissed: (_) {
        hapusNotif(
          n['id'],
        );
      },

      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          24,
        ),

        onTap: () {
          bukaNotifikasi(n);
        },

        child: Container(
          margin:
              const EdgeInsets.only(
            bottom: 14,
          ),

          padding:
              const EdgeInsets.all(
            18,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              24,
            ),

            border: Border.all(
              color: unread
                  ? color.withOpacity(
                      .20,
                    )
                  : Colors
                      .grey
                      .shade200,
            ),

            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                offset:
                    const Offset(
                  0,
                  5,
                ),
                color: Colors.black
                    .withOpacity(
                  .05,
                ),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,

                decoration:
                    BoxDecoration(
                  color: color
                      .withOpacity(
                    .12,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    18,
                  ),
                ),

                child: Icon(
                  icon,
                  color: color,
                  size: 30,
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
                      n['pesan'] ??
                          "-",

                      style:
                          const TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),

                      decoration:
                          BoxDecoration(
                        color: unread
                            ? Colors
                                .red
                                .shade50
                            : Colors
                                .green
                                .shade50,

                        borderRadius:
                            BorderRadius
                                .circular(
                          50,
                        ),
                      ),

                      child: Text(
                        unread
                            ? "BARU"
                            : "DIBACA",

                        style:
                            TextStyle(
                          fontSize: 11,
                          fontWeight:
                              FontWeight
                                  .bold,

                          color: unread
                              ? Colors.red
                              : Colors
                                  .green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (unread)
                Container(
                  width: 12,
                  height: 12,

                  decoration:
                      const BoxDecoration(
                    color: Colors.red,
                    shape:
                        BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Icon(
            Icons
                .notifications_off_rounded,
            size: 110,
            color:
                Colors.grey.shade300,
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(
            "Tidak Ada Notifikasi",
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            "Saat Admin atau Maintenance Planning\nmemberikan tugas kepada Anda,\nnotifikasi akan muncul di sini.",
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Notifikasi",
          style: TextStyle(
            color:
                Color(0xFF111827),
            fontWeight:
                FontWeight.bold,
          ),
        ),

        actions: [
          if (data.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color:
                    Color(0xFF111827),
              ),
              onPressed: load,
            ),
        ],
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : data.isEmpty
              ? buildEmptyState()
              : RefreshIndicator(
                  onRefresh: load,

                  child: ListView(
                    padding:
                        const EdgeInsets
                            .all(16),

                    children: [
                      Container(
                        padding:
                            const EdgeInsets
                                .all(24),

                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            30,
                          ),

                          gradient:
                              const LinearGradient(
                            begin:
                                Alignment
                                    .topLeft,
                            end:
                                Alignment
                                    .bottomRight,
                            colors: [
                              Color(
                                  0xFF1E293B),
                              Color(
                                  0xFF334155),
                            ],
                          ),
                        ),

                        child: Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets
                                      .all(
                                14,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .white
                                    .withOpacity(
                                  .10,
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  16,
                                ),
                              ),

                              child:
                                  const Icon(
                                Icons
                                    .notifications_active_rounded,
                                color:
                                    Colors
                                        .white,
                                size: 30,
                              ),
                            ),

                            const SizedBox(
                              width: 16,
                            ),

                            Expanded(
                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [
                                  const Text(
                                    "Notification Center",
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.white70,
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                        4,
                                  ),

                                  Text(
                                    "${data.length} Notifikasi",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                      fontSize:
                                          24,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    "$unreadCount Belum Dibaca",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      ...data.map(
                        (e) =>
                            buildNotifCard(
                          e,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}