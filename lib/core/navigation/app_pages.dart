// lib/core/navigation/app_pages.dart
import 'package:amiflow/features/gateway/presentation/gateway_page.dart';
import 'package:amiflow/features/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';

class AppPages {
  AppPages._();

  static const pages = <Widget>[
    GatewayPage(), // 0
    ProfilePage(), // 1
  ];
}