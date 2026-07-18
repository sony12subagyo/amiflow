import 'package:amiflow/features/auth/domain/entities/user.dart';

class LoginResult {
  final String token;
  final User user;

  const LoginResult({
    required this.token,
    required this.user,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      token: json['token'] as String,
      user: User.fromJson(json['user']),
    );
  }
}