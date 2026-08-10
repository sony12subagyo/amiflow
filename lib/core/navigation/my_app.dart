import 'package:flutter/material.dart';
import 'package:amiflow/features/auth/presentation/login_page.dart';
import 'package:amiflow/core/navigation/main_screen.dart';
import 'package:amiflow/core/auth/token_storage.dart';
import 'package:amiflow/core/auth/current_user.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _cekSesi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final sudahLogin = snapshot.data ?? false;
          return sudahLogin ? const MainScreen() : const LoginPage();
        },
      ),
      routes: {
        '/login': (_) => const LoginPage(),
        '/main': (_) => const MainScreen(),
      },
    );
  }

  Future<bool> _cekSesi() async {
    final token = await TokenStorage.load(); // WAJIB dipanggil di sini
    await CurrentUser.load();
    return token != null && token.isNotEmpty;
  }
}