import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class UserEditPage extends StatefulWidget {
  final Map user;
  final String token;

  const UserEditPage({super.key, required this.user, required this.token});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController departmentController;
  TextEditingController passwordController = TextEditingController();

  String role = "user";
  String status = "1";

XFile? imageFile;
final picker = ImagePicker();

/// BASE URL STORAGE
final String baseUrl = "${ApiService.storageUrl}/storage/";

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user['name']);
    emailController = TextEditingController(text: widget.user['email']);
    departmentController =
        TextEditingController(text: widget.user['department']);

    role = widget.user['role'] ?? "user";

    /// 🔥 HANDLE BOOL / INT
    status = (widget.user['is_active'] == true ||
            widget.user['is_active'] == 1)
        ? "1"
        : "0";
  }

  /// 🔥 PICK IMAGE
Future<void> pickImage() async {
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 70,
  );

  if (picked == null) return;

  final bytes = await picked.readAsBytes();

  final sizeInMB = bytes.length / 1024 / 1024;

  if (sizeInMB > 2) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Foto terlalu besar. Maksimal ukuran foto 2 MB.",
        ),
      ),
    );

    return;
  }

  setState(() {
    imageFile = picked;
  });
}

  /// 🔥 UPDATE USER
Future<void> update() async {
  try {

    await ApiService.updateUserWithPhoto(
      widget.user['id'],
      {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "role": role,
        "department": departmentController.text,
        "is_active": status,
      },
      imageFile,
      widget.token,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Data user berhasil diperbarui",
        ),
      ),
    );

    Navigator.pop(context, true);

  } catch (e) {

    String message = e.toString();

    if (message.contains("greater than 2048")) {
      message =
          "Foto terlalu besar. Maksimal ukuran foto adalah 2 MB.";
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }
}

  InputDecoration style(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = (widget.user['photo'] != null &&
            widget.user['photo'].toString().isNotEmpty)
        ? baseUrl + widget.user['photo']
        : null;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Edit Data User"),
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                /// ===== NAMA =====
                TextFormField(
                  controller: nameController,
                  decoration: style("Nama Lengkap"),
                ),

                const SizedBox(height: 10),

                /// ===== EMAIL =====
                TextFormField(
                  controller: emailController,
                  decoration: style("Email"),
                ),

                const SizedBox(height: 10),

                /// ===== PASSWORD =====
                TextFormField(
                  controller: passwordController,
                  decoration: style("Password Baru (opsional)"),
                ),

                const SizedBox(height: 10),

                /// ===== ROLE =====
                DropdownButtonFormField<String>(
                  value: ["admin", "mekanik", "maintenance_planning"]
                          .contains(role)
                      ? role
                      : "user",
                  decoration: style("Role"),
                  items: ["admin","owner", "mekanik", "user", "maintenance_planning"]
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => role = val!),
                ),

                const SizedBox(height: 10),

                /// ===== DEPARTMENT =====
                TextFormField(
                  controller: departmentController,
                  decoration: style("Department"),
                ),

                const SizedBox(height: 10),

                /// ===== STATUS =====
                DropdownButtonFormField<String>(
                  value: (status == "1" || status == "0") ? status : "1",
                  decoration: style("Status"),
                  items: const [
                    DropdownMenuItem(value: "1", child: Text("Aktif")),
                    DropdownMenuItem(value: "0", child: Text("Nonaktif")),
                  ],
                  onChanged: (val) => setState(() => status = val!),
                ),

                const SizedBox(height: 20),

                /// ===== FOTO PROFIL =====
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Foto Profil",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    /// PREVIEW FOTO
                 ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: imageFile != null
      ? Image.file(
          File(imageFile!.path),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        )
      : (photoUrl != null
          ? Image.network(
              photoUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person),
                );
              },
            )
          : Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: const Icon(Icons.person),
            )),
),

                    const SizedBox(width: 12),

                    /// BUTTON
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: pickImage,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300]),
                          child: const Text("Choose File",
                              style: TextStyle(color: Colors.black)),
                        ),

                        const SizedBox(height: 5),

                        TextButton(
                          onPressed: () =>
                              setState(() => imageFile = null),
                          child: const Text("Reset Foto",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                  ],
                ),

                const Spacer(),

                /// ===== BUTTON =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: update,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      child: const Text("Update"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}