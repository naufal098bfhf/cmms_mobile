import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class DetailValidasiPage extends StatefulWidget {
  final Map tugas;
  final String jenis;
  final String token;

  const DetailValidasiPage({
    super.key,
    required this.tugas,
    required this.jenis,
    required this.token,
  });

  @override
  State<DetailValidasiPage> createState() =>
      _DetailValidasiPageState();
}

class _DetailValidasiPageState
    extends State<DetailValidasiPage> {
  String formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) {
      return "-";
    }

    try {
      final dt = DateTime.parse(tanggal);
      return
          "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}";
    } catch (_) {
      return tanggal;
    }
  }

  String getImageUrl(String? path) {
  if (path == null || path.isEmpty) {
    return "";
  }

  String cleanPath =
      path.replaceAll('\\', '/');

  cleanPath =
      cleanPath.replaceAll(
    'api/storage/',
    '',
  );

  cleanPath =
      cleanPath.replaceAll(
    '/api/storage/',
    '',
  );

  cleanPath =
      cleanPath.replaceAll(
    'storage/',
    '',
  );

  cleanPath =
      cleanPath.replaceAll(
    '/storage/',
    '',
  );

  cleanPath =
      cleanPath.replaceAll(
    RegExp(r'^/+'),
    '',
  );

  final baseUrl =
      ApiService.baseUrl
          .replaceAll(
    '/api',
    '',
  );

  return "$baseUrl/storage/$cleanPath";
}

  bool loading = false;

  Future<void> validasi() async {

    try {

      setState(() {
        loading = true;
      });

      if (widget.jenis == "Tetap") {

        await ApiService.validasiTetap(
          widget.tugas['id'],
          widget.token,
        );

      } else {

        await ApiService.validasiDarurat(
          widget.tugas['id'],
          widget.token,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Tugas berhasil divalidasi",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Gagal validasi : $e",
          ),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  Widget infoTile(
    IconData icon,
    String title,
    String value,
  ) {

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.red,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: TextStyle(
                    color:
                        Colors.grey[600],
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final tugas = widget.tugas;

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FB),

      body: CustomScrollView(

        slivers: [

          SliverAppBar(

            expandedHeight: 280,

            pinned: true,

            backgroundColor:
                Colors.red.shade700,

            flexibleSpace:
                FlexibleSpaceBar(

              title: Text(
                tugas['equipment']
                        ?.toString() ??
                    '-',
              ),

              background: tugas['bukti_foto'] != null &&
        tugas['bukti_foto']
            .toString()
            .trim()
            .isNotEmpty

    ? Image.network(
        getImageUrl(
          tugas['bukti_foto'],
        ),
        fit: BoxFit.cover,

        errorBuilder:
            (context, error, stackTrace) {

          return Container(

            color: Colors.grey.shade200,

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Icon(
                  Icons.broken_image_outlined,
                  size: 80,
                  color: Colors.grey.shade500,
                ),

                const SizedBox(height: 12),

                Text(
                  "Foto tidak ditemukan",
                  style: TextStyle(
                    color:
                        Colors.grey.shade700,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      )
: Container(

    color: Colors.grey.shade200,

    child: Column(

      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [

        Icon(
          Icons.camera_alt_outlined,
          size: 80,
          color: Colors.grey.shade500,
        ),

        const SizedBox(height: 12),

        Text(
          "Mekanik belum mengunggah foto bukti",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  ),
),
),
          SliverToBoxAdapter(

            child: Padding(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),

                    decoration:
                        BoxDecoration(
                      color: widget
                                  .jenis ==
                              "Tetap"
                          ? Colors.blue
                              .withOpacity(
                              0.1,
                            )
                          : Colors.orange
                              .withOpacity(
                              0.1,
                            ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        30,
                      ),
                    ),

                    child: Text(
                      "Tugas ${widget.jenis}",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,

                        color: widget
                                    .jenis ==
                                "Tetap"
                            ? Colors.blue
                            : Colors.orange,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  infoTile(
                    Icons.person,
                    "Nama Mekanik",
                    tugas['nama_mekanik']
                            ?.toString() ??
                        "-",
                  ),

                  infoTile(
                    Icons.assignment_ind,
                    "Pemberi Tugas",
                    tugas['pemberi_tugas']
                            ?.toString() ??
                        "-",
                  ),

                  infoTile(
                    Icons.precision_manufacturing,
                    "Equipment",
                    tugas['equipment']
                            ?.toString() ??
                        "-",
                  ),

                  infoTile(
                    Icons.qr_code,
                    "Tag Number",
                    tugas['tag_number']
                            ?.toString() ??
                        "-",
                  ),

                  infoTile(
                    Icons.settings,
                    "EQ Class",
                    tugas['eq_class']
                            ?.toString() ??
                        "-",
                  ),

                  infoTile(
                    Icons.inventory,
                    "BOM",
                    tugas['bom']
                            ?.toString() ??
                        "-",
                  ),

                  infoTile(
                    Icons.list_alt,
                    "Task List",
                    tugas['task_list']
                            ?.toString() ??
                        "-",
                  ),

                  infoTile(
                    Icons.location_on,
                    "Lokasi",
                    tugas['lokasi']
                            ?.toString() ??
                        "-",
                  ),

                  if (widget.jenis ==
                      "Tetap") ...[

                    infoTile(
                      Icons.calendar_month,
                      "Jenis Tugas",
                      tugas['jenis_tugas']
                              ?.toString() ??
                          "-",
                    ),

                    infoTile(
                      Icons.today,
                      "Hari Mingguan",
                      tugas['hari_mingguan']
                              ?.toString() ??
                          "-",
                    ),

                    infoTile(
                      Icons.event,
                      "Tanggal Bulanan",
                      tugas['tanggal_bulanan']
                              ?.toString() ??
                          "-",
                    ),

                    infoTile(
                      Icons.date_range,
                      "Tanggal Tahunan",
                      tugas['tanggal_tahunan']
                              ?.toString() ??
                          "-",
                    ),
                  ],

                  if (widget.jenis ==
                      "Darurat") ...[

                    infoTile(
                      Icons.play_arrow,
                      "Tanggal Mulai",
                      formatTanggal(tugas['tgl_mulai']?.toString()),
                    ),

                    infoTile(
                      Icons.check,
                      "Tanggal Selesai",
                      formatTanggal(tugas['tgl_selesai']?.toString()),
                    ),
                  ],

                  const SizedBox(
                    height: 30,
                  ),

                  SizedBox(

                    width:
                        double.infinity,

                    height: 58,

                    child:
                        ElevatedButton.icon(

                      onPressed:
                          loading
                              ? null
                              : validasi,

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            Colors.green,

                        foregroundColor:
                            Colors.white,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                        ),
                      ),

                      icon: loading

                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                color:
                                    Colors
                                        .white,
                              ),
                            )

                          : const Icon(
                              Icons.verified,
                            ),

                      label: const Text(
                        "VALIDASI TUGAS",
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}