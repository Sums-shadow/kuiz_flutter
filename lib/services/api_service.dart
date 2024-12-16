import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5000/api'; // Use this for Android emulator
  // final String baseUrl = 'http://localhost:5000/api'; // Use this for iOS simulator
  final storage = const FlutterSecureStorage();

  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await storage.write(key: 'token', value: data['token']);
      return data['token'];
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<dynamic>> getQuestions() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/questions'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token ?? '',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load questions');
    }
  }
}