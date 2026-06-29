  import 'package:flutter/material.dart';

  import '../../models/login_models.dart';
  import '../../services/api_service.dart';

  import 'kelola_tugas/tugas_tetap_page.dart';
  import 'kelola_tugas/tugas_darurat_page.dart';

  class NotifikasiMekanikPage extends StatefulWidget {
    final User user;

    const NotifikasiMekanikPage({
      super.key,
      required this.user,
    });

    @override
    State<NotifikasiMekanikPage> createState() =>
        _NotifikasiMekanikPageState();
  }

  class _NotifikasiMekanikPageState
      extends State<NotifikasiMekanikPage> {
    List data = [];

    bool loading = true;

    @override
    void initState() {
      super.initState();
      loadNotif();
    }

    Future<void> loadNotif() async {
      setState(() {
        loading = true;
      });

      try {
        final res =
            await ApiService.getNotifikasi(
          widget.user.id,
        );

        setState(() {
          data = res;
        });
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        setState(() {
          loading = false;
        });
      }
    }

    Future<void> bukaNotif(Map notif) async {
  try {
    await ApiService.readNotifikasi(notif['id']);

    if (!mounted) return;

    // Cek jenis notifikasi
   final link = notif['link']?.toString() ?? '';

if (link == '/tugas-darurat') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TugasDaruratPage(
        token: widget.user.token,
        user: widget.user,
      ),
    ),
  ).then((_) {
    loadNotif();
  });
} else if (link == '/tugas-tetap') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TugasTetapPage(
        token: widget.user.token,
        user: widget.user,
      ),
    ),
  ).then((_) {
    loadNotif();
  });
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
    
  Future<void> hapusNotif(Map notif) async {
    try {
      await ApiService.deleteNotifikasi(
        notif['id'],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Notifikasi berhasil dihapus",
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Gagal menghapus notifikasi",
          ),
        ),
      );
    }
  }
    Widget buildNotifCard(
      Map notif,
    ) {
      final read = notif['read'];

  final bool isRead =
      read == true ||
      read == 1 ||
      read == "1";

      return InkWell(
        borderRadius:
            BorderRadius.circular(20),
        onTap: () => bukaNotif(notif),
        child: Container(
          margin:
              const EdgeInsets.only(
            bottom: 14,
          ),
          padding:
              const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead
                ? Colors.white
                : Colors.red.shade50,
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color:
                      Colors.red.shade100,
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                child: const Icon(
                  Icons.notifications,
                  color: Colors.red,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      notif['pesan'] ??
                          "-",
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      isRead
                          ? "Sudah Dibaca"
                          : "Belum Dibaca",
                      style: TextStyle(
                        color: isRead
                            ? Colors.green
                            : Colors.red,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
              ),
            ],
          ),
        ),
      );
    }

    @override
    Widget build(
      BuildContext context,
    ) {
      final unread = data.where((e) {
    final read = e['read'];

    return read == false ||
        read == 0 ||
        read == "0";
  }).length;

      return Scaffold(
        backgroundColor:
            const Color(0xfff5f7fb),

        appBar: AppBar(
          centerTitle: true,
          backgroundColor:
              Colors.red,
          elevation: 0,
          title: const Text(
            "Notifikasi",
            style: TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),

        body: RefreshIndicator(
          onRefresh: loadNotif,
          child: loading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      width:
                          double.infinity,
                      margin:
                          const EdgeInsets.all(
                        16,
                      ),
                      padding:
                          const EdgeInsets.all(
                        20,
                      ),
                      decoration:
                          BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(
                                0xFFE53935),
                            Color(
                                0xFFB71C1C),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons
                                .notifications_active,
                            color:
                                Colors.white,
                            size: 50,
                          ),
                          const SizedBox(
                              height: 10),
                          Text(
                            "$unread",
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontSize:
                                  30,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Notifikasi Belum Dibaca",
                            style:
                                TextStyle(
                              color:
                                  Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: data.isEmpty
                          ? const Center(
                              child: Text(
                                "Belum ada notifikasi",
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    16,
                              ),
                              itemCount:
                                  data.length,
                              itemBuilder:
                                  (
                                context,
                                index,
                              ) {
                                final notif = data[index];

  return Dismissible(
    key: Key(
      notif['id'].toString(),
    ),

    direction: DismissDirection.horizontal,

    background: Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        left: 25,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
    ),

    secondaryBackground: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(
        right: 25,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
    ),
    onDismissed: (_) async {

    // Hapus dari list terlebih dahulu
    setState(() {
      data.removeAt(index);
    });

    // Baru hapus di database
    await hapusNotif(notif);
  },

    child: buildNotifCard(
      notif,
    ),
  );
                              },
                            ),
                    ),
                  ],
                ),
        ),
      );
    }
  }