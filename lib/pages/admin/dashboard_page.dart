import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/dashboard_admin_model.dart';
import '../../models/login_models.dart';
// Samakan import model dengan path yang sama di seluruh project agar tipe tidak dianggap berbeda.

import '../../services/api_service.dart';

import '../kelola_user/user_list_page.dart';
import '../riwayat_tugas_page.dart';
import 'kelola_equipment/equipment_list_page.dart';
import 'kelola_tugas/tugas_darurat/tugas_darurat_page.dart';
import 'kelola_tugas/tugas_tetap/tugas_tetap_page.dart';
import 'validasi_tugas_page.dart';
import '../../widgets/bottom_admin_navbar.dart';

class AdminDashboardPage extends StatefulWidget {
  final User user;

  const AdminDashboardPage({
    super.key,
    required this.user,
  });

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int dashboardValidasiCount = 0;
  late Future<DashboardModel> dashboardData;
  final String baseUrl =
    "${ApiService.storageUrl}/storage/";

    bool get isOwner =>
      widget.user.role.toLowerCase().trim() ==
      'owner';
  bool get isMP =>
    widget.user.role.toLowerCase().trim() == 'maintenance_planning';

  @override
  void initState() {
    super.initState();
    debugPrint("PHOTO PATH = ${widget.user.photo}");
    dashboardData = ApiService.getDashboardAdmin(widget.user.token);
    loadValidasiCount();
  }

  Future<void> loadValidasiCount() async {
    if (!isMP) return;

    try {
      final result = await ApiService.getValidasiMp(widget.user.token);
      final tetap = result['tetap'] ?? [];
      final darurat = result['darurat'] ?? [];

      if (!mounted) return;
      setState(() {
        dashboardValidasiCount = tetap.length + darurat.length;
      });
    } catch (e) {
      debugPrint('ERROR VALIDASI COUNT: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void showLogoutDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                logout();
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showProfileMenu(Offset position) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, 20, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      items: [
        PopupMenuItem<String>(
          value: 'logout',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.logout,
                  color: Color(0xFFE53935),
                  size: 28,
                ),
                const SizedBox(width: 16),
                const Text(
                  'Logout',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    if (selected == 'logout') {
      showLogoutDialog();
    }
  }

  void goToTugas(String jenis) {
    if (jenis == 'tetap') {
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TugasDaruratPage(
          user: widget.user,
        ),
      ),
    );
  }

  void goToEquipment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EquipmentListPage(
          token: widget.user.token,
          user: widget.user,
        ),
      ),
    );
  }

  void goToRiwayat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RiwayatTugasPage(user: widget.user),
      ),
    );
  }

  Widget buildHeader() {
    final notifCount = isMP ? dashboardValidasiCount : 0;
    final userName = widget.user.name.isNotEmpty ? widget.user.name : 'User';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.engineering, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                   Text(
  isOwner
      ? 'Owner'
      : isMP
          ? 'Maintenance Planner'
          : 'Admin',
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    fontSize: isMP ? 20 : 28,
    fontWeight: FontWeight.bold,
    color: Colors.red.shade700,
  ),
),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isMP) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ValidasiTugasPage(token: widget.user.token),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tidak ada notifikasi')),
                        );
                      },
                      icon: const Icon(Icons.notifications_none, size: 28),
                    ),
                    if (notifCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            notifCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
               GestureDetector(
  onTapDown: (details) {
    showProfileMenu(details.globalPosition);
  },
  child: CircleAvatar(
    radius: 24,
    backgroundColor: Colors.grey.shade300,
    child: ClipOval(
      child: widget.user.photo != null &&
              widget.user.photo!.isNotEmpty
          ? Image.network(
  "$baseUrl${widget.user.photo}",
  width: 48,
  height: 48,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {

    debugPrint("PHOTO PATH = ${widget.user.photo}");
    debugPrint("PHOTO URL  = $baseUrl${widget.user.photo}");
    debugPrint("ERROR      = $error");

    return const Icon(
      Icons.person,
      size: 40,
      color: Colors.grey,
    );
  },
)
          : Center(
              child: Text(
                userName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
  Widget buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFC62828)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang 👋',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Semoga pekerjaan hari ini berjalan lancar dan produktif.',
                  style: TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.engineering, size: 50, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required String title,
    required int value,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 10),
              Text(title),
              const SizedBox(height: 6),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTaskItem(dynamic t) {
    final status = (t.status ?? '').toString();
    final statusLower = status.toLowerCase();

    final statusColor = (status == 'Selesai' || statusLower == 'selesai') ? Colors.green : Colors.orange;
    final iconData = (status == 'Selesai' || statusLower == 'selesai') ? Icons.check_circle : Icons.engineering;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        final jenis = (t.jenis ?? '').toString().toLowerCase();

        if (jenis == 'darurat') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TugasDaruratPage(
  user: widget.user,
)   
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TugasTetapPage(
  user: widget.user,
)
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: statusColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.equipment ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    t.lokasi ?? '-',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Status: $status',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                t.status ?? '-',
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: BottomAdminNavbar(
        currentIndex: 0,
        user: widget.user,
      ),
      body: FutureBuilder<DashboardModel>(
        future: dashboardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Data kosong'));
          }

          final data = snapshot.data!;

          return Column(
            children: [
              buildHeader(),
              Expanded(
                child: ListView(
                  children: [
                    buildWelcomeCard(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              buildCard(
                                title: 'Jumlah Equipment',
                                value: data.jumlahEquipment,
                                color: Colors.blue,
                                icon: Icons.precision_manufacturing,
                                onTap: goToEquipment,
                              ),
                              buildCard(
                                title: 'Tugas Tetap',
                                value: data.tugasTetap,
                                color: Colors.green,
                                icon: Icons.assignment,
                                onTap: () => goToTugas('tetap'),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              buildCard(
                                title: 'Tugas Darurat',
                                value: data.tugasDarurat,
                                color: Colors.orange,
                                icon: Icons.warning,
                                onTap: () => goToTugas('darurat'),
                              ),
                              buildCard(
                                title: 'Tugas Selesai',
                                value: data.tugasSelesai,
                                color: Colors.teal,
                                icon: Icons.check_circle,
                                onTap: goToRiwayat,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isMP)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            buildCard(
                              title: 'Menunggu Validasi',
                              value: dashboardValidasiCount,
                              color: Colors.purple,
                              icon: Icons.verified,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ValidasiTugasPage(token: widget.user.token),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '10 Tugas Terbaru',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ...data.tugas.take(10).map((t) => buildTaskItem(t)),
                    const SizedBox(height: 20),

                    // Pastikan role MP tidak bisa akses kelola user.
                    if (!isMP)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.people),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserListPage(
                                  token: widget.user.token,
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                          label: const Text('Kelola User'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

