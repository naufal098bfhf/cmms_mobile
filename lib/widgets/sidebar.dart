import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {

  const DashboardPage({
    super.key,
  });

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends State<DashboardPage> {

  int selectedIndex = 0;

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xFFF5F7FA,
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: SafeArea(

        child: SingleChildScrollView(

          child: Column(

            children: [

              // =====================================================
              // HEADER
              // =====================================================

              Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 40,
                ),

                decoration:
                    const BoxDecoration(

                  color:
                      Color(
                    0xFF1DA1F2,
                  ),

                  borderRadius:
                      BorderRadius.only(

                    bottomLeft:
                        Radius.circular(
                      35,
                    ),

                    bottomRight:
                        Radius.circular(
                      35,
                    ),
                  ),
                ),

                child: Column(

                  children: [

                    // =====================================================
                    // TOP BAR
                    // =====================================================

                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: const [

                            Text(

                              "Selamat Datang",

                              style: TextStyle(

                                color:
                                    Colors.white70,

                                fontSize: 15,
                              ),
                            ),

                            SizedBox(
                              height: 4,
                            ),

                            Text(

                              "Aplikasi Sekolah",

                              style: TextStyle(

                                color:
                                    Colors.white,

                                fontSize: 24,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Container(

                          width: 52,
                          height: 52,

                          decoration:
                              BoxDecoration(

                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                          ),

                          child: const Icon(

                            Icons.notifications_none_rounded,

                            color:
                                Colors.black87,

                            size: 28,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // =====================================================
                    // IMAGE SECTION
                    // =====================================================

                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,

                      children: [

                        Image.asset(

                          "assets/images/siswa1.png",

                          width: 130,
                        ),

                        Image.asset(

                          "assets/images/siswa2.png",

                          width: 130,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // =====================================================
              // CONTENT
              // =====================================================

              Padding(

                padding:
                    const EdgeInsets.all(
                  20,
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    // =====================================================
                    // TITLE
                    // =====================================================

                    const Text(

                      "Menu Utama",

                      style: TextStyle(

                        fontSize: 22,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // =====================================================
                    // MENU GRID
                    // =====================================================

                    GridView.count(

                      crossAxisCount: 3,

                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      mainAxisSpacing: 20,

                      crossAxisSpacing: 16,

                      children: [

                        topMenu(
                          Icons.menu_book_rounded,
                          "Sambutan",
                        ),

                        topMenu(
                          Icons.lightbulb_rounded,
                          "Visi & Misi",
                        ),

                        topMenu(
                          Icons.assignment_rounded,
                          "PPDB",
                        ),

                        topMenu(
                          Icons.computer_rounded,
                          "Hasil PPDB",
                        ),

                        topMenu(
                          Icons.school_rounded,
                          "Ekskul",
                        ),

                        topMenu(
                          Icons.photo_library_rounded,
                          "Galeri",
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // =====================================================
                    // CARD INFO
                    // =====================================================

                    Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors.black
                                    .withOpacity(
                              0.05,
                            ),

                            blurRadius: 10,
                          ),
                        ],
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: const [

                          Text(

                            "Informasi",

                            style: TextStyle(

                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(
                            height: 12,
                          ),

                          Text(

                            "Selamat datang di aplikasi sekolah modern berbasis mobile. Aplikasi ini dirancang agar lebih profesional, modern, dan mudah digunakan oleh siswa maupun wali murid.",

                            style: TextStyle(

                              fontSize: 14,

                              color:
                                  Colors.black54,

                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================

      bottomNavigationBar: Container(

        margin:
            const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            30,
          ),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.black
                      .withOpacity(
                0.08,
              ),

              blurRadius: 20,

              offset:
                  const Offset(
                0,
                8,
              ),
            ),
          ],
        ),

        child: Row(

          mainAxisAlignment:
              MainAxisAlignment
                  .spaceAround,

          children: [

            navItem(
              icon:
                  Icons.home_rounded,
              title:
                  "Home",
              index: 0,
            ),

            navItem(
              icon:
                  Icons.article_rounded,
              title:
                  "Berita",
              index: 1,
            ),

            navItem(
              icon:
                  Icons.grid_view_rounded,
              title:
                  "Menu",
              index: 2,
            ),

            navItem(
              icon:
                  Icons.contact_page_rounded,
              title:
                  "Kontak",
              index: 3,
            ),

            navItem(
              icon:
                  Icons.login_rounded,
              title:
                  "Login",
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // TOP MENU
  // =====================================================

  Widget topMenu(
    IconData icon,
    String title,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(
        14,
      ),

      decoration:
          BoxDecoration(

        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        boxShadow: [

          BoxShadow(

            color:
                Colors.black
                    .withOpacity(
              0.05,
            ),

            blurRadius: 10,
          ),
        ],
      ),

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Container(

            width: 60,
            height: 60,

            decoration:
                BoxDecoration(

              color:
                  const Color(
                0xFFEAF6FF,
              ),

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child: Center(

              child: Icon(

                icon,

                size: 32,

                color:
                    const Color(
                  0xFF1DA1F2,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Text(

            title,

            textAlign:
                TextAlign.center,

            style:
                const TextStyle(

              fontSize: 12,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // NAV ITEM
  // =====================================================

  Widget navItem({

    required IconData icon,

    required String title,

    required int index,
  }) {

    final active =
        selectedIndex == index;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedIndex =
              index;
        });
      },

      child: AnimatedContainer(

        duration:
            const Duration(
          milliseconds: 250,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),

        decoration:
            BoxDecoration(

          color: active
              ? const Color(
                  0xFF1DA1F2,
                )
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        child: Column(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            Icon(

              icon,

              color: active
                  ? Colors.white
                  : Colors.black54,

              size: 26,
            ),

            const SizedBox(
              height: 4,
            ),

            Text(

              title,

              style: TextStyle(

                color: active
                    ? Colors.white
                    : Colors.black54,

                fontSize: 11,

                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}