// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Latar
  static const background = Color(0xFF111316); // latar utama (paling gelap)
  static const surface = Color(0xFF1E2023); // kartu, banner
  static const surfaceAlt = Color(0xFF1A1C1F); // kartu "add node"
  static const surfaceLight = Color(0xFF333538); // lingkaran ikon

  // Aksen
  static const accent = Color(0xFF00E5FF); // cyan utama
  static const accentSoft = Color(0xFFC3F5FF); // teks cyan muda

  // Status
  static const online = Colors.green;
  static const offline = Colors.red;
  static const danger = Colors.redAccent; // aksi destruktif (hapus)
}
