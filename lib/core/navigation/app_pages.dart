import 'package:flutter/material.dart';
import 'package:amiflow/features/dashboard/presentation/dashboard_page.dart';
import 'package:amiflow/features/profile/presentation/profile_page.dart';

class AppPages {
  AppPages._();

  static final pages = <Widget>[
    DashboardPage(),
    ProfilePage(),
  ];
}