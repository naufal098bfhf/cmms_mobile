import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

import 'admin/dashboard_page.dart';
import 'mekanik/dashboard_page.dart';

import 'forgot_password_page.dart';

class LoginPageFixed extends StatefulWidget {
  const LoginPageFixed({super.key});

  @override
  State<LoginPageFixed> createState() => _LoginPageFixedState();
}

class _LoginPageFixedState extends State<LoginPageFixed> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  String? loginError;

  final List<Map<String, dynamic>> loginHistory = [];

  @override
  void initState() {
    super.initState();
    loadLoginHistory();
    
  }
  
  Future<void> loadLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('login_history') ?? <String>[];

    setState(() {
      loginHistory
        ..clear()
        ..addAll(data.map((e) => jsonDecode(e) as Map<String, dynamic>).toList());
    });
  }

  Future<void> saveLoginHistory(dynamic user) async {
    final prefs = await SharedPreferences.getInstance();

    loginHistory.removeWhere((e) => e['email'] == user.email);

    loginHistory.insert(0, {
      'name': user.name,
      'email': user.email,
    });

    if (loginHistory.length > 5) {
      loginHistory.removeRange(5, loginHistory.length);
    }

    await prefs.setStringList(
      'login_history',
      loginHistory.map((e) => jsonEncode(e)).toList(),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    loginError = null;

    try {
      print("========== DEBUG LOGIN ==========");
print("EMAIL   : ${_emailController.text}");
print("PASSWORD: ${_passwordController.text}");
      final user = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      await saveLoginHistory(user);
      _showSuccess('Login berhasil');

      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      final role = user.role
          .toString()
          .toLowerCase()
          .trim()
          .replaceAll('_', '-')
          .replaceAll(' ', '-');

      if (role == 'admin' || role == 'owner') {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => AdminDashboardPage(user: user),
    ),
  );
  return;
}

      if (role == 'mekanik') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MekanikDashboardPage(user: user),
          ),
        );
        return;
      }

      if (role == 'maintenance-planning') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminDashboardPage(user: user)),
        );
        return;
      }

      _showError('Role tidak dikenali');
    } 
   catch (e) {
  print(e);

  setState(() {
    loginError = e.toString();
  });

  _showError(e.toString());
} finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void showAccountPicker() {
    if (loginHistory.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Akun Tersimpan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ...loginHistory.map((item) {
                final email = (item['email'] ?? '').toString();
                final name = (item['name'] ?? '').toString();
                final initials =
                    name.isNotEmpty ? name[0].toUpperCase() : (email.isNotEmpty ? email[0].toUpperCase() : '?');
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE30613),
                    child: Text(
                      initials,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(name),
                  subtitle: Text(email),
                  onTap: () {
                    _emailController.text = email;
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget buildHistory() {
    if (loginHistory.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Riwayat Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loginHistory.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final item = loginHistory[i];
            final name = (item['name'] ?? '').toString();
            final email = (item['email'] ?? '').toString();
            final initials = name.isNotEmpty
                ? name[0].toUpperCase()
                : (email.isNotEmpty ? email[0].toUpperCase() : '?');

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                _emailController.text = email;
                _passwordController.clear();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black.withOpacity(0.04),
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFE30613),
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name.isNotEmpty ? name : 'Akun',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFE30613),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 80 : 28,
                          vertical: 40,
                        ),
                        color: const Color(0xFFF8FAFC),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Form(
                              key: _formKey,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 25,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // HEADER
                                    Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 18,
                                                color: Colors.black12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.asset(
                                              'assets/images/logo.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 18),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'POLITEKNIK INDUSTRI',
                                                style: TextStyle(
                                                  color: Color(0xFFE30613),
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'PETROKIMIA',
                                                style: TextStyle(
                                                  color: Color(0xFF111827),
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 55),

                                    RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 54,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Selamat ',
                                            style: TextStyle(
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Datang\nKembali',
                                            style: TextStyle(
                                              color: Color(0xFFE30613),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 18),

                                    Text(
                                      'Silakan login untuk melanjutkan ke sistem CMMS',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 17,
                                        height: 1.6,
                                      ),
                                    ),

                                    const SizedBox(height: 40),

                                    if (loginHistory.isNotEmpty) buildHistory(),

                                    const Text(
                                      'Email',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _emailController,
                                      onTap: showAccountPicker,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email wajib diisi';
                                        }

                                        if (!RegExp(
                                          r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$',
                                        ).hasMatch(value)) {
                                          return 'Format email tidak valid';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Masukkan email',
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 20,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE30613),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 25),

                                    const Text(
                                      'Password',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscure,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password wajib diisi';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Masukkan password',
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscure = !_obscure;
                                            });
                                          },
                                          icon: Icon(
                                            _obscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 20,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE30613),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
        ),
      );
    },
    child: const Text(
      "Lupa Password?",
      style: TextStyle(
        color: Color(0xFFE30613),
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

const SizedBox(height: 15),

                                    const SizedBox(height: 35),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 64,
                                      child: ElevatedButton(
                                        onPressed: _loading ? null : _login,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFE30613),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                          ),
                                        ),
                                        child: _loading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : const Text(
                                                'LOGIN',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                      ),
                                    ),

                                    if (loginError != null) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        loginError!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (isDesktop)
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFE30613),
                                Color(0xFFB0000C),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -100,
                                right: -100,
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF000000),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -120,
                                left: -120,
                                child: Container(
                                  width: 340,
                                  height: 340,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.06),
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(40),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(20),
                                        child: Image.asset(
                                          'assets/images/logo.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    const Text(
                                      'CMMS SYSTEM',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 46,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 70),
                                      child: Text(
                                        'Computerized Maintenance Management System untuk manajemen maintenance industri modern.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18,
                                          height: 1.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          if (_loading)
            Container(
              color: Colors.black38,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 15),
                    Text(
                      "Memverifikasi akun...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

