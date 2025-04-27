import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'services/api_service.dart';

class UserProfilePage extends StatefulWidget {
  final String token;
  const UserProfilePage({super.key, required this.token});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final idCardController = TextEditingController();
  String gender = 'M';
  File? imageFile;
  bool isLoading = true;

  final String? apiUrl = ApiService.APIDoc["ProfileAPI"];

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final response = await http.get(
      Uri.parse(apiUrl!),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
        dobController.text = data['dob'] ?? '';
        idCardController.text = data['id_card'] ?? '';
        gender = data['gender'] ?? 'M';
        isLoading = false;
      });
    } else {
      print('Failed to load profile: ${response.statusCode}');
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> updateProfile() async {
    final request = http.MultipartRequest('PUT', Uri.parse(apiUrl!));
    request.headers['Authorization'] = 'Bearer ${widget.token}';

    request.fields['name'] = nameController.text;
    request.fields['email'] = emailController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['dob'] = dobController.text;
    request.fields['id_card'] = idCardController.text;
    request.fields['gender'] = gender;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_picture', imageFile!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Profile updated');
      fetchProfile(); // Refresh UI
    } else {
      print('Update failed: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null ? const Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: dobController, decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)')),
            TextField(controller: idCardController, decoration: const InputDecoration(labelText: 'ID Card')),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: gender,
              items: const [
                DropdownMenuItem(value: 'M', child: Text('Male')),
                DropdownMenuItem(value: 'F', child: Text('Female')),
                DropdownMenuItem(value: 'O', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updateProfile, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
