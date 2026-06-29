import 'package:flutter/material.dart';
import 'package:cmms_mobile/pages/kelola_user/user_detail_page.dart';
import 'package:cmms_mobile/pages/kelola_user/user_edit_page.dart';
import 'package:cmms_mobile/pages/kelola_user/user_create_page.dart';
import '../../widgets/bottom_admin_navbar.dart';
import '../../models/login_models.dart';
import '../../services/api_service.dart';

class UserListPage extends StatefulWidget {
  final String token;
  final User user;

  const UserListPage({
    super.key,
    required this.token,
    required this.user,
  });

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final data = await ApiService.getUsers(widget.token);

      if (!mounted) return;

      setState(() {
        users = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color roleColor(String role) {
    switch (role) {
      case "admin":
        return Colors.purple;
      case "mekanik":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus User"),
        content: const Text(
          "Yakin ingin menghapus user ini?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
           onPressed: () async {

  Navigator.pop(context);

  await ApiService.deleteUser(
    id,
    widget.token,
  );

  await fetchUsers();

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(

    const SnackBar(

      content: Text(
        "User berhasil dihapus",
      ),

      backgroundColor: Colors.green,

      behavior: SnackBarBehavior.floating,

      margin: EdgeInsets.all(16),
    ),
  );
},
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.red,
        title: const Text(
          "Kelola User",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchUsers,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  12,
                  12,
                  100,
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
               final isActive =
    user['is_active'].toString() == '1' ||
    user['is_active'].toString().toLowerCase() == 'true';

                  return InkWell(
                    borderRadius:
                        BorderRadius.circular(18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              UserDetailPage(
                            user: user,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      padding:
                          const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 10,
                            offset:
                                const Offset(0, 4),
                          ),
                        ],
                      ),
                     child: Row(
  children: [
    CircleAvatar(
      radius: 26,
      backgroundColor:
          roleColor(user['role']).withOpacity(0.15),
      child: Icon(
        Icons.person,
        color: roleColor(user['role']),
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            user['name'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            user['email'] ?? '',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: roleColor(
                    user['role'],
                  ).withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  user['role']
                      .toString()
                      .toUpperCase(),
                  style: TextStyle(
                    color: roleColor(
                      user['role'],
                    ),
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green
                          .withOpacity(0.15)
                      : Colors.red
                          .withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
                child: Text(
                  isActive
                      ? "AKTIF"
                      : "NONAKTIF",
                  style: TextStyle(
                    color: isActive
                        ? Colors.green
                        : Colors.red,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),

    Column(
      children: [
        IconButton(
          icon: const Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          onPressed: () async {
            final res =
                await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    UserEditPage(
                  user: user,
                  token:
                      widget.token,
                ),
              ),
            );

            if (res == true) {
              fetchUsers();
            }
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () =>
              confirmDelete(
            user['id'],
          ),
        ),
      ],
    ),
  ],
),
                    ),
                  );
                },
              ),
            ),

      bottomNavigationBar: SafeArea(
        child: BottomAdminNavbar(
          currentIndex: 1,
          user: widget.user,
        ),
      ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserCreatePage(
                token: widget.token,
              ),
            ),
          );

          if (res == true) {
            fetchUsers();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}