// lib/core/navigation/app_pages.dart

import 'package:amiflow/features/dashboard/presentation/dashboard_page.dart';
import 'package:amiflow/features/gateway/domain/entities/gateway.dart';
import 'package:amiflow/features/manage/presentation/manage_page.dart';
import 'package:amiflow/features/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';

class AppPages {
  AppPages._();

  static List<Widget> pages(
    Gateway selectedGateway,
    VoidCallback onChangeGateway,
  ) {
    return [
      DashboardPage(
        gateway: selectedGateway,
        onChangeGateway: onChangeGateway,
      ),

      const ManagePage(),

      const ProfilePage(),
    ];
  }
}