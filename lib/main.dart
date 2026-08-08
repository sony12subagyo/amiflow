import 'package:amiflow/core/navigation/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Android -> ikon putih
      statusBarBrightness: Brightness.dark,      // iOS
    ),
  );

  runApp(const MyApp());
}