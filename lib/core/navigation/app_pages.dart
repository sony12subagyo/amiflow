import 'package:amiflow/features/gateway/presentation/gateway_page.dart';
import 'package:flutter/material.dart';
import 'package:amiflow/features/profile/presentation/profile_page.dart';

class AppPages {
  AppPages._();

  static final pages = <Widget>[
    GatewayPage(),
    ProfilePage(),
  ];
}