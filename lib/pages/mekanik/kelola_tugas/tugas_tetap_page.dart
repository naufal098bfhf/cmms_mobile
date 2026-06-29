import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../models/login_models.dart';
import '../../../models/tugas_tetap_mekanik_model.dart';
import '../../../services/api_service.dart';
import '../../../widgets/bottom_mekanik_navbar.dart';

class TugasTetapPage extends StatefulWidget {
  final String token;
  final User user;

  const TugasTetapPage({
    super.key,
    required this.token,
    required this.user,
  });

  @override
  State<TugasTetapPage> createState() => _TugasTetapPageState();
}

class _TugasTetapPageState extends State<TugasTetapPage> {
  final String baseUrl = ApiService.baseUrl;

  String _buildFotoUrl(String buktiFoto) {
    final webUrl = baseUrl.replaceAll('/api', '');

    if (buktiFoto.contains('tugas-tetap/')) {
      return '$webUrl/storage/$buktiFoto';
    }

    return '$webUrl/storage/tugas-tetap/$buktiFoto';
  }

  final List<TugasTetapMekanikModel> data = [];
  final List<TugasTetapMekanikModel> filteredData = [];

  bool loading = true;
  String errorMessage = "";

  String selectedFilter = "semua";
  int showEntries = 10;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      errorMessage = "";
    });

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/mekanik/tugas-tetap"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Accept": "application/json",
        },
      );

      if (response.statusCode != 200) {
        if (mounted) {
          setState(() {
            errorMessage = "";
            loading = false;
            filteredData.clear();
          });
        }
        return;
      }

      final jsonList = jsonDecode(response.body) as List;
      data
        ..clear()
        ..addAll(
          jsonList
              .map((e) => TugasTetapMekanikModel.fromJson(e))
              .toList(),
        );

      data.sort((a, b) => b.id.compareTo(a.id));
      applyFilter();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void applyFilter() {
    List<TugasTetapMekanikModel> temp = List.from(data);

    if (selectedFilter == "release_order") {
      temp = temp.where((e) => e.status == "pending").toList();
    } else if (selectedFilter == "dikerjakan") {
      temp = temp.where((e) => e.status == "dikerjakan").toList();
    } else if (selectedFilter == "validasi_mp") {
      temp = temp
          .where((e) => e.status == "selesai" && e.validasiMp == false)
          .toList();
    } else if (selectedFilter == "selesai") {
      temp = temp
          .where((e) => e.status == "selesai" && e.validasiMp == true)
          .toList();
    }

    temp.sort((a, b) => b.id.compareTo(a.id));

    filteredData
      ..clear()
      ..addAll(temp.take(showEntries).toList());

    setState(() {});
  }
  
Widget detailCard(
  IconData icon,
  String title,
  String value,
) {
  return Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.red,
          size: 22,
        ),
        const SizedBox(height: 8),
        Text(
  title,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
  value.isEmpty ? "-" : value,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 13,
  ),
)
      ],
    ),
  );
}

Widget buildStatItem(String title, String value) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    ],
  );
}
  Widget buildStatus(TugasTetapMekanikModel t) {
    late final Color bgColor;
    late final String label;

    if (t.status == "pending") {
      bgColor = Colors.orange;
      label = "RELEASE ORDER";
    } else if (t.status == "dikerjakan") {
      bgColor = Colors.blue;
      label = "DIKERJAKAN";
    } else if (t.status == "selesai" && !t.validasiMp) {
      bgColor = Colors.purple;
      label = "MENUNGGU VALIDASI";
    } else {
      bgColor = Colors.green;
      label = "SELESAI";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildFilterChip(String title, String value) {
    final active = selectedFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          selectedFilter = value;
          applyFilter();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE53935) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: Text(
            title,
            style: TextStyle(
              color: active ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void showDetailTugas(TugasTetapMekanikModel t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Detail Tugas",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
               Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.red.shade50,
    borderRadius: BorderRadius.circular(24),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        t.equipment,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        t.taskList,
        style: TextStyle(
          color: Colors.grey.shade700,
          height: 1.5,
        ),
      ),
    ],
  ),
),

const SizedBox(height: 20),

GridView.count(
  crossAxisCount: 2,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 1.2,
  children: [
    detailCard(
      Icons.person,
      "Pemberi Tugas",
      t.pemberiTugas,
    ),
    detailCard(
      Icons.engineering,
      "Nama Mekanik",
      t.namaMekanik,
    ),
    detailCard(
      Icons.repeat,
      "Jenis Tugas",
      t.jenisTugas,
    ),
    detailCard(
      Icons.qr_code,
      "Tag Number",
      t.tagNumber,
    ),
    detailCard(
      Icons.location_on,
      "Lokasi",
      t.lokasi,
    ),
    detailCard(
      Icons.settings,
      "Eq. Class",
      t.eqClass,
    ),
    detailCard(
      Icons.inventory,
      "BoM",
      t.bom,
    ),
    detailCard(
      Icons.flag,
      "Status",
      t.status,
    ),
  ],
), 
                const SizedBox(height: 10),
                const Text(
                  "Bukti Foto",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                if (t.buktiFoto != null && t.buktiFoto!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                   child: Image.network(
  _buildFotoUrl(t.buktiFoto!),
  height: 220,
  width: double.infinity,
  fit: BoxFit.cover,

  loadingBuilder: (
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) {
      return child;
    }

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  },

  errorBuilder: (context, error, stackTrace) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          "Gagal memuat foto",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  },
)
                  )
                else
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text("Belum ada bukti foto"),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> konfirmasiUpdateStatus(
  int id,
  String status,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
            ),
            SizedBox(width: 8),
            Text("Konfirmasi"),
          ],
        ),
        content: const Text(
          "Apakah Anda yakin ingin merubah status tugas ini?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Ya"),
          ),
        ],
      );
    },
  );

  if (result == true) {
    await updateStatus(id, status);
  }
}
  Future<void> updateStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/mekanik/tugas-tetap/$id/status"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": status}),
      );

      if (response.statusCode == 200) {
        await load();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Status berhasil diupdate"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  Future<void> uploadFoto(int id, XFile file) async {
    try {
      await ApiService.uploadFotoTugasTetap(
        id,
        file,
        widget.token,
      );
      await load();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Foto berhasil diupload"),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error upload foto : $e"),
        ),
      );
    }
  }

  Future<void> ambilFoto(int id) async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Upload Bukti Foto",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.red),
                  title: const Text("Buka Kamera"),
                  tileColor: Colors.red.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final file = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 70,
                    );
                    if (file != null) {
                      uploadFoto(id, file);
                    }
                  },
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: const Icon(Icons.photo, color: Colors.blue),
                  title: const Text("Pilih dari Galeri"),
                  tileColor: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final file = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                    );
                    if (file != null) {
                      uploadFoto(id, file);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final releaseCount = data.where((e) => e.status == "pending").length;
    final prosesCount = data.where((e) => e.status == "dikerjakan").length;
    final validasiCount = data
        .where((e) => e.status == "selesai" && e.validasiMp == false)
        .length;
    final selesaiCount = data
        .where((e) => e.status == "selesai" && e.validasiMp == true)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      bottomNavigationBar: BottomMekanikNavbar(
        currentIndex: 1,
        user: widget.user,
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Tugas Tetap",
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE53935),
                      Color(0xFFB71C1C),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      color: Colors.red.withValues(alpha: 0.25),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tugas Tetap Mekanik",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildStatItem("Release", releaseCount.toString()),
                        buildStatItem("Proses", prosesCount.toString()),
                        buildStatItem(
                            "Validasi", validasiCount.toString()),
                        buildStatItem("Selesai", selesaiCount.toString()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Manajemen tugas preventif mekanik",
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
                        children: [
                          buildFilterChip("Semua", "semua"),
                          buildFilterChip("Release Order", "release_order"),
                          buildFilterChip("Dikerjakan", "dikerjakan"),
                          buildFilterChip("Validasi MP", "validasi_mp"),
                          buildFilterChip("Selesai", "selesai"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (filteredData.isEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Icon(
                            Icons.assignment_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Belum ada tugas tetap",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredData.length,
                        itemBuilder: (context, i) {
                          final t = filteredData[i];

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => showDetailTugas(t),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                      color: Colors.black.withValues(alpha: 0.05),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Tugas Ke-${t.id}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        buildStatus(t),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text("Equipment : ${t.equipment}"),
                                    Text("Lokasi : ${t.lokasi}"),
                                    Text("Jenis : ${t.jenisTugas}"),
                                    const SizedBox(height: 12),

                                    if (t.buktiFoto != null &&
                                        t.buktiFoto!.isNotEmpty)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Uploaded",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => ambilFoto(t.id),
                                          icon: const Icon(Icons.camera_alt),
                                          label: const Text("Upload Bukti"),
                                        ),

                                        if (t.status == "pending")
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                          ),
                                          onPressed: () {
                                            konfirmasiUpdateStatus(
                                              t.id,
                                              "dikerjakan",
                                            );
                                          },
                                          icon: const Icon(Icons.play_arrow),
                                          label: const Text("Kerjakan"),
                                        ),

                                        if (t.status == "dikerjakan")
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () {
                                          konfirmasiUpdateStatus(
                                            t.id,
                                            "selesai",
                                          );
                                        },
                                        icon: const Icon(Icons.check),
                                        label: const Text("Selesai"),
                                      ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

