// lib/shared/widgets/background_wrapper.dart
import 'package:amiflow/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.bgWhite),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}