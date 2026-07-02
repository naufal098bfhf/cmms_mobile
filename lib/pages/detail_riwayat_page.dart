  import 'package:flutter/material.dart';

  class DetailRiwayatPage extends StatelessWidget {
    final Map data;

    const DetailRiwayatPage({
      super.key,
      required this.data,
    });

  Color getStatusColor() {

    final status =
        (data['status'] ?? '')
            .toString()
            .toLowerCase();

    switch (status) {

      case 'pending':
        return Colors.orange;

      case 'dikerjakan':
        return Colors.blue;

      case 'validasi':
        return Colors.deepOrange;

      case 'selesai':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }
  String getStatusText() {
    final status =
        (data['status'] ?? '')
            .toString()
            .toLowerCase();

    switch (status) {

      case 'pending':
        return 'Release Order';

      case 'dikerjakan':
        return 'Dikerjakan';

      case 'validasi':
        return 'Menunggu Validasi MP';

      case 'selesai':
        return 'Selesai';

      default:
        return '-';
    }
  }
    String formatTanggal(dynamic tanggal) {
    if (tanggal == null) return '-';

    try {
      final date = DateTime.parse(
        tanggal.toString(),
      );

      return "${date.day.toString().padLeft(2, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.year}";
    } catch (e) {
      return tanggal.toString();
    }
  }

    int getProgressStep() {

    final status =
        (data['status'] ?? '')
            .toString()
            .toLowerCase();

    switch (status) {

      case 'pending':
        return 1;

      case 'dikerjakan':
        return 2;

      case 'validasi':
        return 3;

      case 'selesai':
        return 4;

      default:
        return 1;
    }
  }

    @override
  Widget build(BuildContext context) {

    final statusColor = getStatusColor();

    final fotoUrl =
        data['bukti_foto'] != null &&
        data['bukti_foto'].toString().isNotEmpty
            ? "http://192.168.1.175:8001/storage/${data['bukti_foto']}"
            : null;

    print("BUKTI FOTO = ${data['bukti_foto']}");
    print("URL FOTO = $fotoUrl");

    return Scaffold(
        backgroundColor: const Color(0xffF4F6F9),

        body: CustomScrollView(
          slivers: [

            // HEADER FOTO
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: Colors.red,

              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  "Detail Tugas",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              background: Stack(
    fit: StackFit.expand,
    children: [

    fotoUrl != null
      ? Image.network(
          fotoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Mekanik belum upload foto",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          },
        )
      : Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 70,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              "Mekanik belum upload foto",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black54,
              Colors.transparent,
            ],
          ),
        ),
      ),
    ],
  ),
              ),

            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // STATUS
                    Center(
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              statusColor.withOpacity(.15),
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                        child: Text(
                          getStatusText(),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // EQUIPMENT
                    Text(
                      data['equipment'] ?? '-',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      data['task_list'] ?? '-',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // GRID INFO
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.6,
                      children: [

                        infoCard(
                          Icons.qr_code,
                          "Tag Number",
                          data['tag_number']
                                  ?.toString() ??
                              '-',
                        ),

                        infoCard(
                          Icons.category,
                          "Jenis",
                          data['jenis']
                                  ?.toString() ??
                              '-',
                        ),

                        infoCard(
                          Icons.location_on,
                          "Lokasi",
                          data['lokasi']
                                  ?.toString() ??
                              '-',
                        ),

                        infoCard(
                        Icons.calendar_month,
                        "Tanggal",
                        formatTanggal(
                          data['tgl_mulai'],
                        ),
                      ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // TEKNISI
                    sectionTitle("Nama Mekanik"),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                          const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(.05),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [

                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                Colors.red.shade50,
                            child: const Icon(
                              Icons.person,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  data['nama_mekanik']
                                          ?.toString() ??
                                      '-',
                                  style:
                                      const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 5),

                                Text(
                                  "Mekanik Pelaksana",
                                  style: TextStyle(
                                    color: Colors
                                        .grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // TIMELINE
                sectionTitle("Progress Pekerjaan"),

  const SizedBox(height: 20),

  Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      children: [
        buildStepProgress(),
      ],
    ),
  ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget sectionTitle(String title) {
      return Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    Widget infoCard(
      IconData icon,
      String title,
      String value,
    ) {
      return Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(.05),
              blurRadius: 12,
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              color: Colors.red,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }
  Widget buildStepProgress() {
  final currentStep = getProgressStep();

  return Row(
    children: [

      buildStep(
        1,
        "Release\nOrder",
        currentStep,
      ),

      buildLine(currentStep >= 1),

      buildStep(
        2,
        "Dikerjakan",
        currentStep,
      ),

      buildLine(currentStep >= 2),

      buildStep(
        3,
        "Menuggu Validasi MP",
        currentStep,
      ),

      buildLine(currentStep >= 3),

      buildStep(
        4,
        "Selesai",
        currentStep,
      ),
    ],
  );
}
  Widget buildLine(bool active) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(
          bottom: 45,
        ),
        color: active
            ? Colors.green
            : Colors.red.shade200,
      ),
    );
  }
Widget buildStep(
  int step,
  String title,
  int currentStep,
) {
  final bool completed = currentStep > step;
  final bool active = currentStep == step;

  // Step dianggap aktif jika sudah dilewati ATAU sedang berada di step tersebut
  final bool isActive = completed || active;

  return Column(
    children: [

      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? Colors.green
              : Colors.red.shade50,
          border: Border.all(
            color: isActive
                ? Colors.green
                : Colors.red,
            width: 2,
          ),
        ),
        child: Center(
          child: completed
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                )
              : Text(
                  '$step',
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),

      const SizedBox(height: 8),

      SizedBox(
        width: 70,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active
                ? FontWeight.bold
                : FontWeight.w500,
            color: isActive
                ? Colors.green
                : Colors.black87,
          ),
        ),
      ),
    ],
  );
}
  Widget expandedLine(bool active) {
    return Expanded(
      child: Container(
        height: 4,
        margin: const EdgeInsets.only(bottom: 28),
        decoration: BoxDecoration(
          color: active
              ? Colors.green
              : Colors.grey.shade300,
          borderRadius:
              BorderRadius.circular(20),
        ),
      ),
    );
  }
  Widget stepCircle(
    String title,
    Color color,
  ) {
    return Column(
      children: [

        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,

            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
    Widget timelineItem(
      String title,
      bool active,
    ) {
      return Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Column(
            children: [

              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? Colors.green
                      : Colors.grey.shade300,
                ),
              ),

              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade300,
              ),
            ],
          ),

          const SizedBox(width: 15),

          Padding(
            padding:
                const EdgeInsets.only(top: 2),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: active
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: active
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ),
        ],
      );
    }
  }
  class HeartBeatPainter extends CustomPainter {
    Widget buildStep(
    int step,
    String title,
    int currentStep,
  ) {
    final bool completed =
        currentStep > step;

    final bool active =
        currentStep == step;

    return Column(
      children: [

        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: completed || active
                ? const Color(0xff4CAF50)
                : Colors.white,

            border: Border.all(
              color: completed || active
                  ? const Color(0xff4CAF50)
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),

          child: Center(
            child: completed
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : Text(
                    "$step",
                    style: TextStyle(
                      color: active
                          ? Colors.white
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: 70,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  active
                      ? FontWeight.bold
                      : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

    final int step;

    HeartBeatPainter({
      required this.step,
    });

    @override
    void paint(
      Canvas canvas,
      Size size,
    ) {

      final inactivePaint = Paint()
        ..color = Colors.grey.shade300
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;

      final activePaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(0, 30),
        Offset(size.width, 30),
        inactivePaint,
      );

      final path = Path();

      if (step >= 1) {
        path.moveTo(0, 30);
        path.lineTo(60, 30);
        path.lineTo(80, 10);
        path.lineTo(100, 50);
        path.lineTo(120, 30);
      }

      if (step >= 2) {
        path.lineTo(180, 30);
        path.lineTo(200, 5);
        path.lineTo(220, 55);
        path.lineTo(240, 30);
      }

      if (step >= 3) {
        path.lineTo(300, 30);
        path.lineTo(320, 15);
        path.lineTo(340, 45);
        path.lineTo(360, 30);
      }

      if (step >= 4) {
        path.lineTo(size.width, 30);
      }

      canvas.drawShadow(
        path,
        Colors.red,
        8,
        false,
      );

      canvas.drawPath(
        path,
        activePaint,
      );
    }

    @override
    bool shouldRepaint(
      CustomPainter oldDelegate,
    ) {
      return true;
    }
  }
