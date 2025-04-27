import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';

class ProfileService {
  final String? profileUrl = ApiService.APIDoc['ProfileAPI'];
  Future<http.StreamedResponse> updateProfile(UserProfile profile, File? imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var request = http.MultipartRequest('PUT', Uri.parse(profileUrl!));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll(profile.toJson());
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_picture', imageFile.path));
    }
    return request.send();
  }

  Future<UserProfile?> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(profileUrl!),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);
    }
    return null;
  }
}