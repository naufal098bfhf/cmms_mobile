import 'package:flutter/material.dart';

import '../../models/dashboard_mekanik_model.dart';
import '../../models/login_models.dart';

import '../../services/api_service.dart';

import '../login_page.dart';
import 'notifikasi_mekanik_page.dart';
import '../riwayat_tugas_page.dart';
import '../../widgets/bottom_mekanik_navbar.dart';

import 'kelola_tugas/tugas_darurat_page.dart';

class MekanikDashboardPage extends StatefulWidget {
  final User user;

  const MekanikDashboardPage({
    super.key,
    required this.user,
  });

  @override
  State<MekanikDashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState extends State<MekanikDashboardPage> {
  final String baseUrl = "${ApiService.storageUrl}/storage/";
  late Future<DashboardMekanikModel>
      dashboardData;

  int notifCount = 0;

  bool showLogoutMenu = false;

  int selectedEntries = 10;

  final List<int> entryOptions = [
    10,
    15,
    20,
    50,
    100,
  ];

 @override
void initState() {
  super.initState();

  loadDashboard();

  loadNotif();

  Future.delayed(
    const Duration(seconds: 1),
    () {
      cekNotifBaru();
    },
  );
}

  // =====================================================
  // LOAD DASHBOARD
  // =====================================================

void loadDashboard() {
  dashboardData =
      ApiService.getDashboard(
    widget.user.token,
  );

  if (mounted) {
    setState(() {});
  }
}
Future<void> cekNotifBaru() async {
  final notif =
      await ApiService.getNotifikasi(
    widget.user.id,
  );

  final unread = notif
      .where((e) => e['read'] == false)
      .toList();

  if (unread.isEmpty) return;

  if (!mounted) return;

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text("Tugas Baru"),
          ],
        ),
        content: Text(
          unread.first['pesan'],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              goToNotif();
            },
            child: const Text("Lihat"),
          ),
        ],
      );
    },
  );
 
  }
// =====================================================
// LOAD NOTIF
// =====================================================

Future<void> loadNotif() async {
  try {
    final res =
        await ApiService.getNotifikasi(
      widget.user.id,
    );

    if (!mounted) return;

    setState(() {
      notifCount = res.where(
        (e) => e['read'] == false,
      ).length;
    });
  } catch (e) {
    debugPrint(
      "ERROR NOTIF: $e",
    );
  }
}
  // =====================================================
  // LOGOUT
  // =====================================================

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginPage(),
      ),
      (route) => false,
    );
  }

  // =====================================================
  // TOGGLE LOGOUT
  // =====================================================

  void toggleLogoutMenu() {
    setState(() {
      showLogoutMenu =
          !showLogoutMenu;
    });
  }

  // =====================================================
  // NAVIGASI
  // =====================================================

  void goToNotif() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
    NotifikasiMekanikPage(
  user: widget.user,
),
    ),
  ).then((_) {
    loadNotif();
    loadDashboard();
  });
}

  void goToRiwayat() {
    Navigator.push(
      context,
      MaterialPageRoute(
      builder: (_) =>
            RiwayatTugasPage(user: widget.user),
      ),
    );
  }

  void goToTugas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TugasDaruratPage(
          token: widget.user.token,
          user: widget.user,
        )
      ),
    );
  }

  // =====================================================
  // AVATAR
  // =====================================================

  Widget buildAvatar() {
  final photo = widget.user.photo;

  return CircleAvatar(
    radius: 24,
    backgroundColor: Colors.grey.shade300,
    child: ClipOval(
      child: photo != null && photo.isNotEmpty
          ? Image.network(
              "$baseUrl$photo",
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Center(
                  child: Text(
                    widget.user.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                widget.user.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    ),
  );
}
  // =====================================================
  // HEADER
  // =====================================================

  Widget buildHeader() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration:
                        BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(0xFFE53935),
                          Color(0xFFB71C1C),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: const Icon(
                      Icons.engineering,
                      color:
                          Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(
                    width: 14,
                  ),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          "Dashboard",
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Colors.grey,
                            fontWeight:
                                FontWeight
                                    .w500,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Mekanik",
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight:
                                FontWeight
                                    .bold,
                            color: Color(
                              0xFF111827,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =========================================
            // NOTIFIKASI
            // =========================================

            Stack(
              clipBehavior:
                  Clip.none,
              children: [
                Container(
                  decoration:
                      BoxDecoration(
                    color: Colors
                        .grey.shade100,
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: IconButton(
                    onPressed:
                        goToNotif,
                    icon: const Icon(
                      Icons
                          .notifications_none_rounded,
                      size: 28,
                    ),
                  ),
                ),

                if (notifCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding:
                          const EdgeInsets
                              .all(5),
                      decoration:
                          const BoxDecoration(
                        color:
                            Colors.red,
                        shape:
                            BoxShape.circle,
                      ),
                      child: Text(
                        notifCount
                            .toString(),
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              10,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(
              width: 12,
            ),

            // =========================================
            // USER
            // =========================================

            GestureDetector(
              onTap:
                  toggleLogoutMenu,
              child: buildAvatar(),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // WELCOME
  // =====================================================

  Widget buildWelcomeSection() {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(
          30,
        ),
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(0xFFE53935),
            Color(0xFFB71C1C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset:
                const Offset(0, 8),
            color: Colors.red
                .withValues(
              alpha: 0.25,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                const Text(
                  "Selamat Datang 👋",
                  style: TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.user.name,
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize: 34,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Semoga pekerjaan hari ini berjalan lancar dan produktif.",
                  style: TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 88,
            height: 88,
            decoration:
                BoxDecoration(
              color: Colors.white
                  .withValues(
                alpha: 0.14,
              ),
              borderRadius:
                  BorderRadius.circular(
                24,
              ),
            ),
            child: const Icon(
              Icons
                  .engineering_rounded,
              size: 44,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // CARD
  // =====================================================
Widget buildCard({
  required String title,
  required int value,
  required Color color,
  required IconData icon,
}) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.all(6),

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // =========================
          // ICON
          // =========================

          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.12,
              ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(height: 16),

          // =========================
          // TITLE
          // =========================

          Text(
            title,

            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          // =========================
          // VALUE
          // =========================

          Text(
            value.toString(),

            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              height: 1,
            ),
          ),
        ],
      ),
    ),
  );
}
  // =====================================================
  // TASK ITEM
  // =====================================================

  Widget buildTaskItem(t) {
    Color statusColor;
    String statusLabel;

    switch (t.status) {
      case 'pending':
        statusColor =
            Colors.blue;
        statusLabel =
            'Release Order';
        break;

      case 'dikerjakan':
        statusColor =
            Colors.orange;
        statusLabel =
            'Dikerjakan';
        break;

      case 'selesai':
        statusColor =
            Colors.green;
        statusLabel =
            'Selesai';
        break;

      default:
        statusColor =
            Colors.grey;
        statusLabel =
            t.status;
    }

    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
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
            blurRadius: 12,
            offset:
                const Offset(0, 2),
            color:
                Colors.black12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration:
                BoxDecoration(
              color: statusColor
                  .withValues(
                alpha: 0.14,
              ),
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: Icon(
              Icons.build,
              color: statusColor,
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
                  t.equipment,
                  maxLines: 1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  t.lokasi,
                  style: TextStyle(
                    color: Colors
                        .grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration:
                BoxDecoration(
              color: statusColor,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: Text(
              statusLabel,
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontWeight:
                    FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // LOGOUT MENU
  // =====================================================

  Widget buildLogoutMenu() {
    if (!showLogoutMenu) {
      return const SizedBox();
    }

    return Positioned(
      top: 90,
      right: 16,
      child: Material(
        elevation: 20,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        color:
            const Color(0xFFF8FAFC),
        child: Container(
          width: 180,
          padding:
              const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: InkWell(
            borderRadius:
                BorderRadius.circular(
              22,
            ),
            onTap: logout,
            child: const Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight
                              .w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
   return Scaffold(
  bottomNavigationBar: BottomMekanikNavbar(
    currentIndex: 0,
    user: widget.user,
  ),

      body: Stack(
        children: [
          FutureBuilder<
              DashboardMekanikModel>(
            future: dashboardData,

            builder:
                (context, snapshot) {
              if (snapshot
                      .connectionState ==
                  ConnectionState
                      .waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error
                        .toString(),
                  ),
                );
              }

              final data =
                  snapshot.data!;

              final tugas =
                  data.tugas
                      .take(
                        selectedEntries,
                      )
                      .toList();

              return RefreshIndicator(
                onRefresh: () async {
                  loadDashboard();
                  await loadNotif();
                },

                child:
                    SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),

                  child: Column(
                    children: [
                      buildHeader(),

                      buildWelcomeSection(),

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),

                        child: Column(
                          children: [
                            Row(
                              children: [
                                buildCard(
                                  title:
                                      "Jumlah Equipment",
                                  value: data
                                      .jumlahEquipment,
                                  color:
                                      Colors.blue,
                                  icon: Icons
                                      .inventory_2_outlined,
                                ),

                                buildCard(
                                  title:
                                      "Tugas Hari Ini",
                                  value: data
                                      .tugasHariIni,
                                  color:
                                      Colors.green,
                                  icon: Icons
                                      .calendar_today_outlined,
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                buildCard(
                                  title:
                                      "Tugas Menunggu",
                                  value: data
                                      .tugasPending,
                                  color:
                                      Colors.orange,
                                  icon: Icons
                                      .access_time,
                                ),

                                buildCard(
                                  title:
                                      "Tugas Selesai",
                                  value: data
                                      .tugasSelesai,
                                  color:
                                      Colors.green,
                                  icon: Icons
                                      .check,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      // ====================================
                      // SHOW ENTRIES
                      // ====================================

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),

                        child: Row(
                          children: [
                            const Text(
                              "Show Entries",
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                                fontSize:
                                    15,
                              ),
                            ),

                            const SizedBox(
                              width: 14,
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    12,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                              ),
                              child:
                                  DropdownButton<
                                      int>(
                                value:
                                    selectedEntries,

                                underline:
                                    const SizedBox(),

                                items:
                                    entryOptions.map(
                                  (e) {

                                    return DropdownMenuItem(
                                      value:
                                          e,
                                      child:
                                          Text(
                                        e.toString(),
                                      ),
                                    );

                                  },
                                ).toList(),

                                onChanged:
                                    (value) {

                                  if (value ==
                                      null) {
                                    return;
                                  }

                                  setState(
                                      () {

                                    selectedEntries =
                                        value;

                                  });

                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // ====================================
                      // TASK LIST
                      // ====================================

                      ListView.builder(
                        itemCount:
                            tugas.length,
                        shrinkWrap:
                            true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemBuilder:
                            (context, i) {
                          return buildTaskItem(
                            tugas[i],
                          );
                        },
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          buildLogoutMenu(),
        ],
      ),
    );
  }
}