import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:amiflow/core/auth/token_storage.dart';
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/features/auth/domain/entities/user.dart';

class ProfileApi {
  Future<User> updateProfile({required String name, String? password}) async {
    final token = TokenStorage.get();

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final body = {'name': name};

    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await http.put(
      Uri.parse('${AppConfig.baseUrl}/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return User.fromJson(data['user']);
    }

    throw Exception('Gagal memperbarui profile');
  }
}
