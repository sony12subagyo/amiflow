// lib/features/notification/data/notification_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/core/auth/token_storage.dart';
import 'package:amiflow/features/notification/domain/entities/notification_item.dart';

class NotificationApi {
  Map<String, String> _headers() {
    final token = TokenStorage.get();
    return {
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<NotificationItem>> fetchNotifications() async {
    final url = Uri.parse('${AppConfig.baseUrl}/notifications');
    final response = await http.get(url, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat notifikasi (${response.statusCode})');
    }

    final body = jsonDecode(response.body);
    final List<dynamic> data = body['data'];
    return data.map((json) => NotificationItem.fromJson(json)).toList();
  }

  Future<int> fetchUnreadCount() async {
    final url = Uri.parse('${AppConfig.baseUrl}/notifications/unread-count');
    final response = await http.get(url, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat jumlah notifikasi (${response.statusCode})');
    }

    final body = jsonDecode(response.body);
    return body['count'] as int;
  }

  Future<void> markAsRead(int id) async {
    final url = Uri.parse('${AppConfig.baseUrl}/notifications/$id/read');
    await http.put(url, headers: _headers());
  }

  Future<void> delete(int id) async {
  final url = Uri.parse('${AppConfig.baseUrl}/notifications/$id');
  final response = await http.delete(url, headers: _headers());

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus notifikasi (${response.statusCode})');
  }
}
}