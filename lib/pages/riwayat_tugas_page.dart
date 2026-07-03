import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/login_models.dart';
import '../services/api_service.dart';
import '../widgets/bottom_admin_navbar.dart';
import '../widgets/bottom_mekanik_navbar.dart';
import 'detail_riwayat_page.dart';

class RiwayatTugasPage extends StatefulWidget {
  final User user;

  const RiwayatTugasPage({
    super.key,
    required this.user,
  });

  @override
  State<RiwayatTugasPage> createState() => _RiwayatTugasPageState();
}

class _RiwayatTugasPageState extends State<RiwayatTugasPage> {
  List data = [];
  bool loading = true;

  DateTime? startDate;
  DateTime? endDate;

  final searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }
Widget modernStatusBadge(item) {
  final status =
      (item['status'] ?? '')
          .toString()
          .toLowerCase();

  Color bgColor;
  Color textColor;
  String text;

 switch (status) {

  case 'pending':
    bgColor = Colors.orange.shade50;
    textColor = Colors.orange;
    text = "Release Order";
    break;

  case 'dikerjakan':
    bgColor = Colors.blue.shade50;
    textColor = Colors.blue;
    text = "Dikerjakan";
    break;

  case 'validasi':
    bgColor = Colors.deepOrange.shade50;
    textColor = Colors.deepOrange;
    text = "Menunggu Validasi MP";
    break;

  case 'selesai':
    bgColor = Colors.green.shade50;
    textColor = Colors.green;
    text = "Selesai";
    break;

  default:
    bgColor = Colors.grey.shade100;
    textColor = Colors.grey;
    text = "Unknown";
}
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),

    decoration: BoxDecoration(
      color: bgColor,
      borderRadius:
          BorderRadius.circular(30),
    ),

    child: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}
  // ======================================================
  // URL FOTO
  // ======================================================

String getImageUrl(
  String? path,
  String? jenisTugas,
) {
  if (path == null || path.isEmpty) {
    return "";
  }

  final webUrl =
      ApiService.baseUrl.replaceAll('/api', '');

  final fileName =
      path.split('/').last;

  // TUGAS DARURAT
  if ((jenisTugas ?? '')
      .toLowerCase()
      .contains('darurat')) {
    return '$webUrl/storage/tugas-darurat/$fileName';
  }

  // TUGAS TETAP
  return '$webUrl/storage/tugas-tetap/$fileName';
}
  // ======================================================
  // LOAD DATA
  // ======================================================

  void load() async {
    setState(() {
      loading = true;
    });

    try {
      final res = await ApiService.getRiwayatTugas(
        startDate: startDate?.toString().split(' ')[0],
        endDate: endDate?.toString().split(' ')[0],
        search: searchC.text,
      );

      setState(() {
  data = List.from(res);

  data.sort((a, b) {
    final aDate = DateTime.tryParse(
          a['updated_at'] ?? a['created_at'] ?? '',
        ) ??
        DateTime(2000);

    final bDate = DateTime.tryParse(
          b['updated_at'] ?? b['created_at'] ?? '',
        ) ??
        DateTime(2000);

    return bDate.compareTo(aDate);
  });
});
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Gagal load riwayat",
          ),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // ======================================================
  // PICK DATE
  // ======================================================

  Future<void> pickDate(bool isStart) async {
    DateTime? picked =
        await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  // ======================================================
  // ITEM
  // ======================================================

  Widget item(String title, dynamic value) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value?.toString() ?? "-",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // FOTO
  // ======================================================

 Widget buildImage(
  String? path,
  String? jenisTugas,
) {
  final url = getImageUrl(
    path,
    jenisTugas,
  );
    if (url.isEmpty) {
      return Container(
        height: 220,
        color: Colors.grey.shade200,
        child: const Center(
          child: Text("Tidak ada foto"),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: InteractiveViewer(
                      child: Image.network(
                        url,
                        fit: BoxFit.contain,
                        loadingBuilder: (
                          context,
                          child,
                          loadingProgress,
                        ) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return Container(
                            height: 400,
                            color: Colors.black,
                            child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    CircularProgressIndicator(),
    SizedBox(height: 12),
    Text(
      "Memuat foto...",
      style: TextStyle(
        color: Colors.grey,
      ),
    ),
  ],
),
                          );
                        },
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          debugPrint("ERROR IMAGE => $url");
                          debugPrint(error.toString());

                          return Container(
                            height: 400,
                            color: Colors.black,
                            child: const Center(
                              child: Text(
                                "Gagal load gambar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Image.network(
          url,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
          loadingBuilder: (
            context,
            child,
            loadingProgress,
          ) {
            if (loadingProgress == null) return child;

            return Container(
              height: 220,
              color: Colors.grey.shade100,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
  debugPrint("URL FOTO = $url");
  debugPrint("ERROR = $error");

  return Container(
              height: 220,
              color: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gagal load gambar',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.red,
        title: const Text(
          "Riwayat Tugas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
  child: widget.user.role.toLowerCase() == 'mekanik'
      ? BottomMekanikNavbar(
          currentIndex: 2,
          user: widget.user,
        )
      : BottomAdminNavbar(
          currentIndex: (
                  widget.user.role.toLowerCase().trim() ==
                      'maintenance_planning' ||
                  widget.user.role.toLowerCase().trim() ==
                      'maintenance-planning')
              ? 3
              : 4,
          user: widget.user,
        ),
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          children: [
            // ======================================================
            // FILTER
            // ======================================================
            Container(
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pickDate(true),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              startDate == null
                                  ? "Tanggal Awal"
                                  : DateFormat('dd/MM/yyyy').format(
                                      startDate!,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pickDate(false),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              endDate == null
                                  ? "Tanggal Akhir"
                                  : DateFormat('dd/MM/yyyy').format(
                                      endDate!,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: searchC,
                    decoration: InputDecoration(
                      hintText: "Cari mekanik, equipment, tag...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: load,
                      child: const Text(
                        "Filter Data",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ======================================================
            // LIST
            // ======================================================
            loading
                ? const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : data.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(
                          child: Text("Tidak ada data"),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          final t = data[i];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailRiwayatPage(
                                    data: t,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.assignment,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
  child: Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [

          Expanded(
            child: Text(
              t['equipment'] ?? '-',

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          modernStatusBadge(t),
        ],
      ),

      const SizedBox(height: 8),

      Text(
        t['task_list'] ?? '-',

        maxLines: 2,

        overflow:
            TextOverflow.ellipsis,

        style: TextStyle(
          color:
              Colors.grey.shade700,
        ),
      ),

      const SizedBox(height: 8),

      Row(
        children: [

          Icon(
            Icons.calendar_today,
            size: 14,
            color:
                Colors.grey.shade500,
          ),

          const SizedBox(width: 6),

          Text(
            t['tgl_mulai'] ?? '-',

            style: TextStyle(
              fontSize: 12,
              color: Colors.grey
                  .shade500,
            ),
          ),
        ],
      ),
    ],
  ),
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
    );
  }
}

