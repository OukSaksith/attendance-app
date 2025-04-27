import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final String? loginUrl = ApiService.APIDoc['loginAPI'];
  final String? refreshUrl = ApiService.APIDoc['refreshAPI'];

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl!),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);
      await prefs.setString('token', data['access']);
      await prefs.setString('refresh', data['refresh']);
      await prefs.setString('username', username);
      return true;
    }
    return false;
  }

  Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh');
    if (refresh == null) return false;

    final response = await http.post(
      Uri.parse(refreshUrl!),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refresh}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('token', data['access']);
      return true;
    }
    return false;
  }
}