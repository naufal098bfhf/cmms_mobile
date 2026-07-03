  import 'package:flutter/material.dart';

  import '../pages/admin/dashboard_page.dart';

  import '../pages/admin/kelola_equipment/equipment_list_page.dart';

  import '../pages/admin/kelola_tugas/tugas_darurat/tugas_darurat_page.dart';

  import '../pages/admin/kelola_tugas/tugas_tetap/tugas_tetap_page.dart';

  import '../pages/kelola_user/user_list_page.dart';
  
  import '../pages/riwayat_tugas_page.dart';

import '../models/login_models.dart';
// Pastikan tidak ada import dengan prefix package:cmms_mobile/models/... pada file ini,
// supaya tipe `User` tidak dianggap berbeda saat build.


  class BottomAdminNavbar extends StatelessWidget {

    final int currentIndex;

    final User user;

    const BottomAdminNavbar({

      super.key,

      required this.currentIndex,

      required this.user,
    });

    @override
  Widget build(BuildContext context) {

    debugPrint("ROLE LOGIN = ${user.role}");

final role = user.role.toLowerCase().trim();

final bool isMP =
    role == 'maintenance_planning' ||
    role == 'maintenance-planning';

  debugPrint("IS MP = $isMP");

      return Container(

       decoration: BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 10,
    ),
  ],
),

        child: BottomNavigationBar(

          backgroundColor: Colors.white,

          showUnselectedLabels: true,

          elevation: 0,

          currentIndex: currentIndex,

          type: BottomNavigationBarType.fixed,

          selectedItemColor: Colors.red,

          unselectedItemColor: Colors.grey,

        items: isMP

  ? const [

      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: "Dashboard",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.precision_manufacturing),
        label: "Equipment",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.assignment),
        label: "Tugas",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: "Riwayat",
      ),
    ]

  : const [

      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: "Dashboard",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: "User",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.precision_manufacturing),
        label: "Equipment",
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

    if (isMP) {
  switch (index) {
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboardPage(
            user: user,
          ),
        ),
      );
      break;

    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EquipmentListPage(
            token: user.token,
            user: user,
          ),
        ),
      );
      break;

    case 2:
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
                ListTile(
                  title: const Text("Tugas Tetap"),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TugasTetapPage(
                          user: user,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Tugas Darurat"),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TugasDaruratPage(
                          user: user,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
      break;

    case 3:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RiwayatTugasPage(
            user: user,
          ),
        ),
      );
      break;
  }

  return;
}
            // =========================
            // DASHBOARD
            // =========================

            if (index == 0) {

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      AdminDashboardPage(
                    user: user,
                  ),
                ),
              );
            }

            // =========================
            // USER
            // =========================

            else if (index == 1) {

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(

                  builder: (_) =>
    UserListPage(
  token: user.token,
  user: user,
),
                ),
              );
            }

            // =========================
            // EQUIPMENT
            // =========================

            else if (index == 2) {

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(
                  builder: (_) =>
                      EquipmentListPage(
                    token: user.token,
                    user: user,
                  ),
                ),
              );
            }

            // =========================
            // TUGAS
            // =========================

            else if (index == 3) {

              showModalBottomSheet(

                context: context,

                shape:
                    const RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),

                builder: (context) {

                  return SafeArea(

                    child: Column(

                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        const SizedBox(
                          height: 10,
                        ),

                        const Text(

                          "Kelola Tugas",

                          style: TextStyle(

                            fontSize: 18,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        ListTile(

                          leading: const Icon(
                            Icons.assignment,
                          ),

                          title: const Text(
                            "Tugas Tetap",
                          ),

                          onTap: () {

                            Navigator.pop(
                              context,
                            );

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) => TugasTetapPage(
                              user: user,
                            ),
                              ),
                            );
                          },
                        ),

                        ListTile(

                          leading: const Icon(
                            Icons.warning,
                          ),

                          title: const Text(
                            "Tugas Darurat",
                          ),

                          onTap: () {

                            Navigator.pop(
                              context,
                            );

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
TugasDaruratPage(

                                  user: user,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            // =========================
            // RIWAYAT
            // =========================

            else if (index == 4) {

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(

                    builder: (_) =>
                      RiwayatTugasPage(user: user),
                ),
              );
            }
          },
        ),
      );
    }
  }