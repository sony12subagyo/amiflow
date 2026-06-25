// lib/core/navigation/app_pages.dart
import 'package:amiflow/features/dashboard/presentation/dashboard_page.dart';
import 'package:amiflow/features/manage/presentation/manage_page.dart';
import 'package:amiflow/features/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';

class AppPages {
  AppPages._();

  static const pages = <Widget>[
    DashboardPage(),   // 0 - Home
    ManagePage(), // 1 - Pencarian
    ProfilePage(),   // 2 - Profil
  ];
}