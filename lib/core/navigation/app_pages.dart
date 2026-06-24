// lib/core/navigation/app_pages.dart
import 'package:amiflow/beranda_page.dart';
import 'package:amiflow/pencarian_page.dart';
import 'package:amiflow/profile_page.dart';
import 'package:flutter/material.dart';

class AppPages {
  AppPages._();

  static const pages = <Widget>[
    BerandaPage(),   // 0 - Home
    PencarianPage(), // 1 - Pencarian
    ProfilePage(),   // 2 - Profil
  ];
}