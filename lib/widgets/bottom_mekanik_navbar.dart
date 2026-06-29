import 'package:flutter/material.dart';

import '../models/login_models.dart';

import '../pages/mekanik/dashboard_page.dart';

import '../pages/mekanik/kelola_tugas/tugas_darurat_page.dart';

import '../pages/mekanik/kelola_tugas/tugas_tetap_page.dart';

import '../pages/riwayat_tugas_page.dart';

class BottomMekanikNavbar extends StatelessWidget {

  final int currentIndex;

  final User user;

  const BottomMekanikNavbar({
    super.key,
    required this.currentIndex,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: BoxDecoration(

        color: Colors.white,

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.08),

            blurRadius: 10,
          ),
        ],
      ),

      child: BottomNavigationBar(

        backgroundColor: Colors.white,

        elevation: 0,

        currentIndex: currentIndex,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.red,

        unselectedItemColor: Colors.grey,

        showUnselectedLabels: true,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Tugas",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Riwayat",
          ),
        ],

        onTap: (index) {

          // =========================
          // DASHBOARD
          // =========================

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MekanikDashboardPage(
                  user: user,
                ),
              ),
            );
          }

          // =========================
          // TUGAS
          // =========================

          else if (index == 1) {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              builder: (context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 14),
                      const Text(
                        "Kelola Tugas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // =====================
                      // TUGAS TETAP
                      // =====================
                      ListTile(
                        leading: const Icon(Icons.assignment),
                        title: const Text("Tugas Tetap"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TugasTetapPage(
                                token: user.token,
                                user: user,
                              ),
                            ),
                          );
                        },
                      ),
                      // =====================
                      // TUGAS DARURAT
                      // =====================
                      ListTile(
                        leading: const Icon(Icons.warning),
                        title: const Text("Tugas Darurat"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TugasDaruratPage(
                                token: user.token,
                                user: user,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          }

          // =========================
          // RIWAYAT
          // =========================
          else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RiwayatTugasPage(
                  user: user,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

