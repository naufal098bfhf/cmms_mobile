import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import 'detail_validasi_page.dart';

class ValidasiTugasPage extends StatefulWidget {
  final String token;

  const ValidasiTugasPage({
    super.key,
    required this.token,
  });

  @override
  State<ValidasiTugasPage> createState() =>
      _ValidasiTugasPageState();
}

class _ValidasiTugasPageState extends State<ValidasiTugasPage> {
  bool loading = true;

  List tugasTetap = [];
  List tugasDarurat = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final result = await ApiService.getValidasiMp(widget.token);

      setState(() {
        tugasTetap = result['tetap'] ?? [];
        tugasDarurat = result['darurat'] ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      debugPrint('ERROR VALIDASI MP: $e');
    }
  }

  Widget buildCard(Map tugas, String jenis) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailValidasiPage(
              tugas: tugas,
              jenis: jenis,
              token: widget.token,
            ),
          ),
        );

        if (result == true) {
          loadData();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: jenis == 'Tetap'
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Tugas $jenis',
                      style: TextStyle(
                        color: jenis == 'Tetap'
                            ? Colors.blue
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                tugas['equipment']?.toString() ?? '-',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      tugas['nama_mekanik']?.toString() ?? '-',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Status : Menunggu Validasi MP'),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Klik untuk melihat detail',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Validasi Tugas'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE53935),
                          Color(0xFFB71C1C),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.25),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Maintenance Planning',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${tugasTetap.length + tugasDarurat.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Tugas Menunggu Validasi',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Text(
                      '${tugasTetap.length + tugasDarurat.length} Menunggu Validasi',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (tugasTetap.isNotEmpty) ...[
                    const Text(
                      'Tugas Tetap',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...tugasTetap.map(
                      (tugas) => buildCard(tugas, 'Tetap'),
                    ),
                  ],

                  if (tugasDarurat.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Tugas Darurat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...tugasDarurat.map(
                      (tugas) => buildCard(tugas, 'Darurat'),
                    ),
                  ],

                  if (tugasTetap.isEmpty && tugasDarurat.isEmpty)
                    const Center(
                      child: Text(
                        'Tidak ada tugas yang menunggu validasi MP.',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

