// lib/core/auth/current_user.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amiflow/features/auth/domain/entities/user.dart';

/// Sama seperti TokenStorage -- sebelumnya `CurrentUser.user` cuma
/// variabel statis di memori. Ditambah penyimpanan permanen supaya info
/// user (nama/email) tetap ada meski aplikasi baru dibuka lagi, tanpa
/// perlu login ulang ke server.
class CurrentUser {
  static const _keyName = 'user_name';
  static const _keyEmail = 'user_email';

  /// Tetap disediakan untuk akses cepat SELAMA aplikasi berjalan
  /// (diisi otomatis oleh save()/load()).
  static User? user;

  static Future<void> save(User u) async {
    user = u;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, u.name);
    await prefs.setString(_keyEmail, u.email);
  }

  /// Muat ulang dari penyimpanan permanen -- panggil ini SEKALI saat
  /// aplikasi baru dibuka (main.dart), sebelum memutuskan halaman awal.
  static Future<User?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);

    if (name == null || email == null) {
      user = null;
      return null;
    }

    user = User(name: name, email: email);
    return user;
  }

  static Future<void> clear() async {
    user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
  }
}
