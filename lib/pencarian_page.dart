// lib/features/pencarian/presentation/pages/pencarian_page.dart
import 'package:amiflow/core/constants/app_padding.dart';
import 'package:flutter/material.dart';

class PencarianPage extends StatelessWidget {
  const PencarianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: kPagePadding,
          child: Center(child: Text('Pencarian')),
        ),
      ),
    );
  }
}