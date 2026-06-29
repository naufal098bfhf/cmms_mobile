import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class UserCreatePage extends StatefulWidget {
  final String token;

  const UserCreatePage({
    super.key,
    required this.token,
  });

  @override
  State<UserCreatePage> createState() => _UserCreatePageState();
}

class _UserCreatePageState extends State<UserCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final departmentController = TextEditingController();

  String role = "owner";
  String status = "1";

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await ApiService.createUserWithPhoto(
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
  SnackBar(
    content: const Text(
      "User berhasil ditambahkan",
    ),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    duration: const Duration(seconds: 2),
  ),
);

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => isLoading = false);
  }

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color:  Colors.red,
          width: 2,
        ),
      ),
    );
  }
XFile? imageFile;
final picker = ImagePicker();
Future<void> pickImage() async {
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (picked != null) {
    setState(() {
      imageFile = picked;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:  Colors.red,
        centerTitle: true,
        title: const Text(
          "Tambah User",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:  Colors.red,
                        child: Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tambah User Baru",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Kelola pengguna CMMS dengan mudah",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: nameController,
                    decoration: inputDecoration(
                      label: "Nama Lengkap",
                      icon: Icons.person,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama wajib diisi";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: emailController,
                    decoration: inputDecoration(
                      label: "Email",
                      icon: Icons.email,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email wajib diisi";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: inputDecoration(
                      label: "Password",
                      icon: Icons.lock,
                      suffix: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password wajib diisi";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: inputDecoration(
                      label: "Role",
                      icon: Icons.badge,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "owner",
                        child: Text("Owner"),
                      ),
                      DropdownMenuItem(
                        value: "admin",
                        child: Text("Admin"),
                      ),
                      DropdownMenuItem(
                        value: "mekanik",
                        child: Text("Mekanik"),
                      ),
                      DropdownMenuItem(
                        value: "maintenance-planning",
                        child:
                            Text("Maintenance Planning"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        role = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

const Text(
  "Foto Profil",
  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
),

const SizedBox(height: 10),

Row(
  children: [
    ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageFile != null
          ? Image.network(
              imageFile!.path,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            )
          : Container(
              width: 90,
              height: 90,
              color: Colors.grey.shade300,
              child: const Icon(
                Icons.person,
                size: 40,
              ),
            ),
    ),

    const SizedBox(width: 15),

    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: pickImage,
          icon: const Icon(Icons.image),
          label: const Text("Pilih Foto"),
        ),

        const SizedBox(height: 8),

        TextButton(
          onPressed: () {
            setState(() {
              imageFile = null;
            });
          },
          child: const Text(
            "Hapus Foto",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    ),
  ],
),

const SizedBox(height: 30),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: departmentController,
                    decoration: inputDecoration(
                      label: "Department",
                      icon: Icons.apartment,
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: inputDecoration(
                      label: "Status",
                      icon: Icons.verified_user,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "1",
                        child: Text("Aktif"),
                      ),
                      DropdownMenuItem(
                        value: "0",
                        child: Text("Nonaktif"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        status = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 30),
                        Row(
  children: [

    Expanded(
      child: OutlinedButton.icon(
        icon: const Icon(Icons.close),
        label: const Text("Batal"),
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            55,
          ),
        ),
      ),
    ),  

    const SizedBox(width: 12),

    Expanded(
      child: ElevatedButton.icon(
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save),
        label: Text(
          isLoading
              ? "Menyimpan..."
              : "Simpan",
        ),
        onPressed:
            isLoading ? null : submit,
        style:
            ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          minimumSize:
              const Size(
            double.infinity,
            55,
          ),
        ),
      ),
    ),
  ],
),    
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

