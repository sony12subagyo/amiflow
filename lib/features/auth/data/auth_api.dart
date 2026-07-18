import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/features/auth/domain/login_result.dart';

class AuthApi {
  Future<LoginResult> login(String email, String password) async {
    final url = Uri.parse('${AppConfig.baseUrl}/login');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResult.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Email atau password salah');
    } else {
      throw Exception('Gagal login (${response.statusCode})');
    }
  }
}
