// lib/core/auth/token_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

/// Gabungan dua hal:
///  - Cache di MEMORI (`_token`) -- supaya kode lain (mis. profile_api.dart)
///    tetap bisa panggil TokenStorage.get() secara SINKRON seperti biasa,
///    tanpa perlu diubah jadi async.
///  - Penyimpanan PERMANEN lewat SharedPreferences -- supaya token tidak
///    hilang saat aplikasi ditutup (beda dari sebelumnya yang cuma di memori).
///
/// PENTING: panggil `TokenStorage.load()` SEKALI di main.dart, SEBELUM
/// halaman manapun dibuka -- supaya cache memori terisi dari penyimpanan
/// permanen begitu aplikasi baru dibuka lagi. Tanpa ini, get() akan
/// mengembalikan null meski sebenarnya user sudah pernah login.
class TokenStorage {
  static const _key = 'auth_token';
  static String? _token;

  /// Simpan token -- ke memori (untuk akses cepat sinkron) DAN ke
  /// penyimpanan permanen (supaya bertahan meski app ditutup).
  static Future<void> save(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  /// Ambil token secara SINKRON dari cache memori -- dipakai kode yang
  /// sudah ada (mis. profile_api.dart) tanpa perlu diubah jadi await.
  static String? get() => _token;

  /// Muat token dari penyimpanan permanen ke cache memori. WAJIB
  /// dipanggil sekali di main.dart saat aplikasi baru dibuka.
  static Future<String?> load() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_key);
    return _token;
  }

  static Future<bool> hasToken() async {
    final token = await load();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clear() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
