import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../models/login_models.dart';
import '../../../models/tugas_darurat_mekanik_model.dart';
import '../../../services/api_service.dart';
import '../../../widgets/bottom_mekanik_navbar.dart';

class TugasDaruratPage extends StatefulWidget {
  final String token;
  final User user;

  const TugasDaruratPage({
    super.key,
    required this.token,
    required this.user,
  });

  @override
  State<TugasDaruratPage> createState() => _TugasDaruratPageState();
}

class _TugasDaruratPageState extends State<TugasDaruratPage> {
  // =====================================================
  // BASE URL
  // =====================================================
  final String baseUrl = ApiService.baseUrl;

String _buildFotoUrl(String buktiFoto, String baseUrl) {
  final webUrl = baseUrl.replaceAll('/api', '');

  if (buktiFoto.contains('tugas-darurat/')) {
    return '$webUrl/storage/$buktiFoto';
  }

  return '$webUrl/storage/tugas-darurat/$buktiFoto';
}

  // =====================================================
  // DATA
  // =====================================================
  List<TugasDaruratMekanikModel> data = [];
  List<TugasDaruratMekanikModel> filteredData = [];

  bool loading = true;
  String errorMessage = "";

  int showEntries = 10;
  String selectedFilter = "semua";

  @override
  void initState() {
    super.initState();
    load();
  }

  // =====================================================
  // LOAD DATA
  // =====================================================
  Future<void> load() async {
    try {
      setState(() {
        loading = true;
        errorMessage = "";
      });

      final response = await http.get(
        Uri.parse("$baseUrl/mekanik/tugas-darurat"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        data = (json as List)
            .map((e) => TugasDaruratMekanikModel.fromJson(e))
            .toList();

        // Filter hanya tugas milik mekanik yang login
       final today = DateTime.now();

data = data.where((e) {
  final mulai = DateTime.parse(e.tglMulai);

  final tanggalMulai = DateTime(
    mulai.year,
    mulai.month,
    mulai.day,
  );

  final tanggalHariIni = DateTime(
    today.year,
    today.month,
    today.day,
  );

  return e.namaMekanik == widget.user.name &&
      !tanggalMulai.isAfter(tanggalHariIni);
}).toList();

        // DATA TERBARU PALING ATAS
        data.sort((a, b) => b.id.compareTo(a.id));

        applyFilter();

        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          errorMessage = "Error ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "Terjadi kesalahan koneksi";
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error : $e"),
        ),
      );
    }
  }

  // =====================================================
  // FILTER DATA
  // =====================================================
  void applyFilter() {
    List<TugasDaruratMekanikModel> temp = List.from(data);

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

    filteredData = temp.take(showEntries).toList();

    setState(() {});
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
    updateStatus(id, status);
  }
}
  // =====================================================
  // UPDATE STATUS
  // =====================================================
  Future<void> updateStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/mekanik/tugas-darurat/$id/status"),
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
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error : $e"),
        ),
      );
    }
  }

  // =====================================================
  // UPLOAD FOTO
  // =====================================================
  Future<void> uploadFoto(int id, XFile file) async {
    try {
      await ApiService.uploadFoto(id, file, widget.token);
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

  // =====================================================
  // AMBIL FOTO
  // =====================================================
  Future<void> ambilFoto(int id) async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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

  // =====================================================
  // FILTER CHIP
  // =====================================================
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
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

  // =====================================================
  // HEADER CARD
  // =====================================================
  Widget buildTopCard() {
    final selesai = data
        .where((e) => e.namaMekanik == widget.user.name)
        .where((e) => e.status == "selesai")
        .where((e) => e.validasiMp == true)
        .length;

    final pending = data.where((e) => e.status == "pending").length;

    final proses = data
        .where((e) => e.namaMekanik == widget.user.name)
        .where((e) => e.status == "dikerjakan")
        .length;

    final validasiMp = data
        .where((e) => e.namaMekanik == widget.user.name)
        .where((e) => e.status == "selesai")
        .where((e) => e.validasiMp == false)
        .length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE53935),
            Color(0xFFB71C1C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 35,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monitoring Tugas Darurat",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Manajemen Tugas Mekanik",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStatItem("Release Order", pending.toString()),
              buildStatItem("Proses", proses.toString()),
              buildStatItem("Validasi", validasiMp.toString()),
              buildStatItem("Selesai", selesai.toString()),
            ],
          ),
        ],
      ),
    );
  }
  Widget detailCard(
  IconData icon,
  String title,
  String value,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 15,
          offset: const Offset(0, 5),
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

        const SizedBox(height: 12),

        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          value.isEmpty ? "-" : value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
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

  // =====================================================
  // STATUS
  // =====================================================
  Widget buildStatus(TugasDaruratMekanikModel t) {
    late final Color bgColor;
    late final String label;

    if (t.status == "pending") {
      bgColor = Colors.orange;
      label = "RELEASE ORDER";
    } else if (t.status == "dikerjakan") {
      bgColor = Colors.blue;
      label = "DIKERJAKAN";
    } else if (t.status == "selesai" && t.validasiMp == false) {
      bgColor = Colors.purple;
      label = "MENUNGGU VALIDASI MP";
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

  // =====================================================
  // DETAIL
  // =====================================================
  void showDetailTugas(TugasDaruratMekanikModel t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        String tglMulai = t.tglMulai;
        if (tglMulai.contains(" ")) tglMulai = tglMulai.split(" ")[0];
        if (tglMulai.contains('T')) tglMulai = tglMulai.split('T')[0];

        String tglSelesai = t.tglSelesai;
        if (tglSelesai.contains(" ")) tglSelesai = tglSelesai.split(" ")[0];
        if (tglSelesai.contains('T')) tglSelesai = tglSelesai.split('T')[0];

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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

                if (t.status == "selesai" && t.validasiMp == false)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Menunggu validasi Maintenance Planning",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.hourglass_top),
                      label: const Text("MENUNGGU VALIDASI MP"),
                    ),
                  ),

                const SizedBox(height: 20),

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
  childAspectRatio: 1.45,
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
      Icons.calendar_today,
      "Tanggal Mulai",
      tglMulai,
    ),

    detailCard(
      Icons.event_available,
      "Tanggal Selesai",
      tglSelesai,
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
                    child: Builder(
  builder: (context) {
    final fotoUrl = _buildFotoUrl(t.buktiFoto!, baseUrl);

    print("FOTO URL = $fotoUrl");

    return Image.network(
      fotoUrl,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return const SizedBox(
          height: 220,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print("ERROR FOTO = $error");

        return Container(
          height: 220,
          width: double.infinity,
          color: Colors.red.shade50,
          child: Center(
            child: Text(
              "Gagal memuat foto\n\n$fotoUrl",
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
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

  Widget buildDetailItem(String title, String value) {
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

  // =====================================================
  // BUILD
  // =====================================================
  @override
  Widget build(BuildContext context) {
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
          "Tugas Darurat",
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
              buildTopCard(),
              const SizedBox(height: 18),

              // FILTER
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildFilterChip('Semua', 'semua'),
                    buildFilterChip('Release', 'release_order'),
                    buildFilterChip('Dikerjakan', 'dikerjakan'),
                    buildFilterChip('Validasi MP', 'validasi_mp'),
                    buildFilterChip('Selesai', 'selesai'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // CONTENT
              if (loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else
                ListView.builder(
                  itemCount: filteredData.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    final t = filteredData[i];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          showDetailTugas(t);
                        },
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
                                child: const Text(
                                  "Work Order",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ),
                                  buildStatus(t),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Equipment: ${t.equipment.isNotEmpty ? t.equipment : '-'}",
                                style: const TextStyle(color: Color(0xFF6B7280)),
                              ),
                              Text(
                                "Lokasi: ${t.lokasi.isNotEmpty ? t.lokasi : '-'}",
                                style: const TextStyle(color: Color(0xFF6B7280)),
                              ),
                              const SizedBox(height: 12),

                              // BADGE FOTO
                              if (t.buktiFoto != null && t.buktiFoto!.isNotEmpty)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
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
                                    onPressed: () {
                                      ambilFoto(t.id);
                                    },
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('Upload Bukti'),
                                  ),

                                  // RELEASE ORDER
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

                                  // DIKERJAKAN
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

                                  // MENUNGGU VALIDASI MP
                                  if (t.status == "selesai" && !t.validasiMp)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      child: const Text(
                                        "Menunggu Validasi MP",
                                        style: TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
      ),
    );
  }
}

