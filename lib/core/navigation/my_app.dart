// // lib/core/navigation/my_app.dart
// import 'package:flutter/material.dart';
// import 'package:amiflow/features/auth/presentation/login_page.dart';
// import 'package:amiflow/core/navigation/main_screen.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/login',
//       routes: {
//         '/login': (_) => const LoginPage(),
//         '/main': (_) => const MainScreen(),
//       },
//     );
//   }
// }


// lib/core/navigation/my_app.dart
import 'package:amiflow/features/gateway/presentation/gateway_page.dart';
import 'package:flutter/material.dart';
import 'package:amiflow/features/auth/presentation/login_page.dart';
import 'package:amiflow/core/navigation/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Gunakan GatewayPage sebagai halaman pertama (home)
      home: const GatewayPage(), 
      
      // Tetap daftarkan rute lain agar bisa dinavigasikan nanti
      routes: {
        '/login': (_) => const LoginPage(),
        '/main': (_) => const MainScreen(),
      },
    );
  }
}
