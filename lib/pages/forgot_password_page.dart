import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool loading = false;
  bool usernameVerified = false;

  bool obscure1 = true;
  bool obscure2 = true;

  Future<void> checkUsername() async {
    if (usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username wajib diisi"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await ApiService.checkUsername(
        usernameController.text.trim(),
      );

      setState(() {
        usernameVerified = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Username ditemukan"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {
      await ApiService.forgotPassword(
        usernameController.text.trim(),
        passwordController.text.trim(),
        confirmPasswordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Password berhasil diubah"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lupa Password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 25),

              const Icon(
                Icons.lock_reset,
                size: 90,
                color: Colors.red,
              ),

              const SizedBox(height: 20),

              const Text(
                "Lupa Password",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                usernameVerified
                    ? "Masukkan password baru Anda."
                    : "Masukkan username Anda.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 35),

              TextFormField(
                controller: usernameController,
                enabled: !usernameVerified,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username wajib diisi";
                  }
                  return null;
                },
              ),

              if (usernameVerified) ...[
                const SizedBox(height: 20),

                TextFormField(
                  controller: passwordController,
                  obscureText: obscure1,
                  decoration: InputDecoration(
                    labelText: "Password Baru",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure1 = !obscure1;
                        });
                      },
                      icon: Icon(
                        obscure1
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (!usernameVerified) return null;

                    if (value == null || value.isEmpty) {
                      return "Password wajib diisi";
                    }

                    if (value.length < 6) {
                      return "Minimal 6 karakter";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscure2,
                  decoration: InputDecoration(
                    labelText: "Konfirmasi Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure2 = !obscure2;
                        });
                      },
                      icon: Icon(
                        obscure2
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (!usernameVerified) return null;

                    if (value != passwordController.text) {
                      return "Konfirmasi password tidak sama";
                    }

                    return null;
                  },
                ),
              ],

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : usernameVerified
                          ? resetPassword
                          : checkUsername,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          usernameVerified
                              ? "UBAH PASSWORD"
                              : "LANJUT",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
}