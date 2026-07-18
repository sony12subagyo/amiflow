import 'package:amiflow/features/auth/domain/entities/user.dart';

class CurrentUser {
  static User? user;

  static bool get isLoggedIn => user != null;

  static void clear() {
    user = null;
  }
}