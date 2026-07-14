// Penyimpan token — versi MEMORI (sementara).
// Nanti kita upgrade ke shared_preferences agar permanen.
class TokenStorage {
  static String? _token;

  static void save(String token) => _token = token;
  static String? get() => _token;
  static void clear() => _token = null;
}
