import 'package:flutter/material.dart';

import 'pages/login_page.dart';

import 'pages/riwayat_tugas_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'CMMS Login',

      theme: ThemeData(

        fontFamily: 'Roboto',

        primaryColor: Colors.orange,
      ),

      // ==========================
      // HALAMAN PERTAMA
      // ==========================

      initialRoute: '/login',

      // ==========================
      // ROUTES
      // ==========================

      routes: {

        // ==========================
        // LOGIN
        // ==========================

        '/login': (context) =>
            const LoginPage(),

        // ==========================
        // RIWAYAT
        // ==========================

        '/admin/riwayat': (context) =>
            const SizedBox.shrink(),
      },
    );
  }
}