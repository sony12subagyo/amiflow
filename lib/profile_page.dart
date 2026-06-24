// lib/features/home/presentation/pages/beranda_page.dart
import 'package:amiflow/core/constants/app_padding.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kPagePadding,
          child: Center(child: Text('Profil')),
        ),
      ),
    );
  }
}