import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final Map user;

  const UserDetailPage({
    super.key,
    required this.user,
  });

final String baseUrl =
    "http://192.168.1.175/storage/";

  Color roleColor(String role) {
    switch (role.toLowerCase()) {
      case "admin":
        return Colors.purple;
      case "mekanik":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  bool getStatus() {
    return user['is_active']
            .toString()
            .toLowerCase() ==
        "true";
  }

  @override
  Widget build(BuildContext context) {
    final role =
        user['role']?.toString() ?? "-";

    final isActive = getStatus();

final photoUrl =
    (user['photo'] != null &&
            user['photo']
                .toString()
                .isNotEmpty)
        ? "$baseUrl${user['photo']}"
        : null;
debugPrint(
    "USER DATA = $user");

debugPrint(
    "PHOTO FIELD = ${user['photo']}");

debugPrint(
    "PHOTO URL = $photoUrl");

    return Scaffold(
      backgroundColor:
          const Color(0xfff5f7fb),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text(
          "Detail User",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// HEADER CARD
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(24),
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
                        const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [

                  /// FOTOr
  ClipOval(
  child: photoUrl != null
      ? Image.network(
          photoUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,

          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            debugPrint(
              "ERROR FOTO => $error",
            );

            return Container(
              width: 110,
              height: 110,
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.person,
                size: 55,
                color: Colors.grey,
              ),
            );
          },
        )
      : Container(
          width: 110,
          height: 110,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.person,
            size: 55,
            color: Colors.grey,
          ),
        ),
),
                  const SizedBox(
                    height: 16,
                  ),

                  Text(
                    user['name']
                            ?.toString() ??
                        '-',
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    user['email']
                            ?.toString() ??
                        '-',
                    style: TextStyle(
                      color:
                          Colors.grey[600],
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [

                      /// ROLE
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration:
                            BoxDecoration(
                          color: roleColor(
                            role,
                          ).withOpacity(
                            0.15,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),
                        child: Text(
                          role
                              .toUpperCase(),
                          style:
                              TextStyle(
                            color:
                                roleColor(
                              role,
                            ),
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      /// STATUS
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration:
                            BoxDecoration(
                          color: isActive
                              ? Colors
                                  .green
                                  .withOpacity(
                                  0.15,
                                )
                              : Colors
                                  .red
                                  .withOpacity(
                                  0.15,
                                ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),
                        child: Text(
                          isActive
                              ? "AKTIF"
                              : "NONAKTIF",
                          style:
                              TextStyle(
                            color: isActive
                                ? Colors
                                    .green
                                : Colors
                                    .red,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            /// DETAIL CARD
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(20),
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
                        const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [

                  buildItem(
                    Icons.badge,
                    "ID",
                    user['id'],
                  ),

                  buildItem(
                    Icons.person,
                    "Nama",
                    user['name'],
                  ),

                  buildItem(
                    Icons.email,
                    "Email",
                    user['email'],
                  ),

                  buildItem(
                    Icons.apartment,
                    "Department",
                    user['department'],
                  ),

                  buildItem(
                    Icons.work,
                    "Role",
                    role,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 55,
              child:
                  ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
                label: const Text(
                  "Kembali",
                  style: TextStyle(
                  color: Colors.white,
                ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(
    IconData icon,
    String title,
    dynamic value,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            const Color(0xfff8f9fc),
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.red,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color:
                        Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  value?.toString() ??
                      "-",
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}