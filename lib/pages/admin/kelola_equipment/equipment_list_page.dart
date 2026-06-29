import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/api_service.dart';

import 'equipment_create_page.dart';
import 'equipment_edit_page.dart';

import '../../../widgets/bottom_admin_navbar.dart';

import '../../../models/login_models.dart';

class EquipmentListPage extends StatefulWidget {
  final String token;
  final User user;

  const EquipmentListPage({
    super.key,
    required this.token,
    required this.user,
  });

  @override
  State<EquipmentListPage> createState() =>
      _EquipmentListPageState();
}

class _EquipmentListPageState
    extends State<EquipmentListPage> {
  List data = [];

  List filtered = [];

  bool loading = true;

  final searchC =
      TextEditingController();

  // ======================================================
  // INIT
  // ======================================================

  @override
  void initState() {
    super.initState();

    fetch();
  }

  // ======================================================
  // FETCH DATA
  // ======================================================

  Future fetch() async {
    setState(() {
      loading = true;
    });

    try {
      final res =
          await ApiService
              .getEquipment(
        widget.token,
      );

      setState(() {
        data = res;

        filtered = res;

        loading = false;
      });
    } catch (e) {
        debugPrint(
      "EQUIPMENT DATA => $e");

  return Container(
      );

      setState(() {
        loading = false;
      });
    }
  }

  // ======================================================
  // LOGOUT
  // ======================================================

  Future<void> logout() async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  // ======================================================
  // SEARCH
  // ======================================================

  void search(String value) {
    final result =
        data.where((e) {
      final name =
          (e['name'] ?? '')
              .toString()
              .toLowerCase();

      return name.contains(
        value.toLowerCase(),
      );
    }).toList();

    setState(() {
      filtered = result;
    });
  }

  // (buildStatCard masih ada tapi tidak dipakai di UI saat ini)
  Widget buildStatCard({
    required String title,
    required dynamic value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ======================================================
  // STATUS BADGE
  // ======================================================

  Widget statusBadge(dynamic kondisi) {
    final kondisiText = kondisi.toString();
    final bool baik = kondisiText.toLowerCase() == "baik";


  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 8,
    ),

    decoration: BoxDecoration(
      color: baik
          ? Colors.green.shade50
          : Colors.red.shade50,

      borderRadius:
          BorderRadius.circular(30),
    ),

    child: Row(
      mainAxisSize: MainAxisSize.min,

      children: [

        Icon(
          baik
              ? Icons.check_circle
              : Icons.warning,

          size: 14,

          color:
              baik
                  ? Colors.green
                  : Colors.red,
        ),

        const SizedBox(width: 5),
Text(
  kondisiText.toUpperCase(),


          style: TextStyle(
            color:
                baik
                    ? Colors.green
                    : Colors.red,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

  // ======================================================
  // ITEM TEXT
  // ======================================================

  Widget item(
    String title,
    dynamic value,
  ) {
    return SizedBox(
      width: 140,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 12,

              color: Colors.grey,
            ),
          ),

          Text(
            value?.toString() ??
                '-',

            style: const TextStyle(
  color: Color(0xFF1F2937),
  fontWeight: FontWeight.w600,
  fontSize: 14,
),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // CARD ITEM
  // ======================================================

  Widget buildItem(e) {
    return Container(
     margin: const EdgeInsets.only(
  bottom: 20,
),

padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
    BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),

            blurRadius: 20,

offset:
    const Offset(0, 10),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ==========================
          // TITLE + STATUS
          // ==========================

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [
              Expanded(
  child: Row(
    children: [

      Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius:
              BorderRadius.circular(14),
        ),

        child: const Icon(
  Icons.computer,
  color: Color(0xFFE53935),
),
      ),

      const SizedBox(width: 12),

      Expanded(
        child: Text(
  (e['name'] ?? '-')
      .toString(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
),

              statusBadge(
                e['kondisi'] ??
                    '-',
              ),
            ],
          ),

          const SizedBox(
              height: 10),

          // ==========================
          // INFO
          // ==========================

          Column(
  children: [

    Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          const Icon(
            Icons.qr_code,
            color: Colors.grey,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
  (e['tag_number'] ?? '-')
      .toString(),
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),

    const SizedBox(height: 10),

    Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          const Icon(
            Icons.calendar_today_outlined,
            color: Colors.grey,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
  (e['tanggal_masuk_aset'] ?? '-')
      .toString(),
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  ],
),

          const SizedBox(
              height: 12),
// ==========================
// BUTTON
// ==========================

Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [

    // ======================
    // EDIT
    // ======================

    Container(
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),

      child: IconButton(
        icon: const Icon(
          Icons.edit_outlined,
          color: Color(0xFFE53935),
        ),

        tooltip: "Edit Equipment",

        onPressed: () async {
          HapticFeedback.lightImpact();

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EquipmentEditPage(
                token: widget.token,
                data: e,
              ),
            ),
          );

          fetch();
        },
      ),
    ),

    const SizedBox(width: 8),

    // ======================
    // DELETE
    // ======================

    Container(
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),

      child: IconButton(
        icon: const Icon(
          Icons.delete_outline,
          color: Color(0xFFE53935),
        ),

        tooltip: "Hapus Equipment",

        onPressed: () async {
          HapticFeedback.lightImpact();

          final confirm =
              await showDialog<bool>(
            context: context,

            builder: (_) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                title: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                    ),

                    SizedBox(width: 8),

                    Text("Hapus Data"),
                  ],
                ),

                content: const Text(
                  "Yakin ingin menghapus equipment ini?",
                ),

                actions: [

                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        false,
                      );
                    },

                    child: const Text(
                      "Batal",
                    ),
                  ),

                  ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFFE53935,
                      ),

                      foregroundColor:
                          Colors.white,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                12),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pop(
                        context,
                        true,
                      );
                    },

                    icon: const Icon(
                      Icons.delete_outline,
                    ),

                    label: const Text(
                      "Hapus",
                    ),
                  ),
                ],
              );
            },
          );

          if (confirm == true) {
            await ApiService.deleteEquipment(
              e['id'],
              widget.token,
            );

            fetch();

            if (!mounted) return;

            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                backgroundColor:
                    Color(0xFFE53935),
                content: Text(
                  "Equipment berhasil dihapus",
                ),
              ),
            );
          }
        },
      ),
    ),
  ],
)
        ],
      ),
    );
  }

  // ======================================================
  // ======================================================
  // HEADER ITEM
  // ======================================================

  Widget _buildHeaderItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    final totalBaik = data
    .where(
      (e) =>
          (e['kondisi'] ?? '-')
      .toString()
              .toLowerCase() ==
          'baik',
    )
    .length;

final totalRusak =
    data.length - totalBaik;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
  children: [

    Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 55,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFE53935),
      ),
      child: const Center(
        child: Text(
          "Kelola Equipment",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),

    const SizedBox(height: 16),

    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildHeaderItem(
                    "Total",
                    data.length.toString(),
                    Icons.inventory_2_outlined,
                    Colors.red,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
                  _buildHeaderItem(
                    "Baik",
                    totalBaik.toString(),
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
                  _buildHeaderItem(
                    "Rusak",
                    totalRusak.toString(),
                    Icons.warning_amber_rounded,
                    Colors.red,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ==========================
          // SEARCH
          // ==========================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: searchC,
                onChanged: search,
                decoration: const InputDecoration(
                  hintText: "Cari equipment...",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFE53935),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
          ),

          // ==========================
          // LIST
          // ==========================
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text("Tidak ada data"))
                    : ListView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          return buildItem(filtered[i]);
                        },
                      ),
          ),
        ],
      ),
      // ==================================================
      // BOTTOM NAVBAR
      // ==================================================
      bottomNavigationBar: SafeArea(
        child: BottomAdminNavbar(
          currentIndex:
              widget.user.role == 'maintenance-planning' ? 1 : 2,
          user: widget.user,
        ),
      ),
      // ==================================================
      // FAB
      // ==================================================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE53935),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onPressed: () async {
          HapticFeedback.lightImpact();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EquipmentCreatePage(
                token: widget.token,
              ),
            ),
          );
          fetch();
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}