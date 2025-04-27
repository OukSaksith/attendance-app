// ==========================
// screens/edit_profile_page.dart
// ==========================
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../widgets/profile_image_picker.dart';
import '../services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final idCardController = TextEditingController();
  String gender = 'M';
  File? imageFile;
  String? imageUrl;
  String message = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await ProfileService().fetchProfile();
      print('Fetched profile: ${profile?.toJson()}');
      if (profile != null) {
        setState(() {
          nameController.text = profile.name;
          emailController.text = profile.email;
          phoneController.text = profile.phone;
          dobController.text = profile.dob;
          idCardController.text = profile.idCard;
          gender = profile.gender;
          imageUrl = profile.profilePicture;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> saveProfile() async {
    final profile = UserProfile(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      dob: dobController.text,
      idCard: idCardController.text,
      gender: gender,
    );

    final response = await ProfileService().updateProfile(profile, imageFile);
    final respStr = await response.stream.bytesToString();

    setState(() {
      message = response.statusCode == 200
          ? "✅ Profile updated successfully!"
          : "❌ Failed to update profile: $respStr";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileImagePicker(
              currentImage: imageFile,
              onImagePicked: (file) => setState(() => imageFile = file),
            ),
            if (imageFile == null && imageUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(ApiService.APIDoc["baseurl"].toString()+imageUrl!),
              ),
            const SizedBox(height: 20),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: dobController, readOnly: true, decoration: const InputDecoration(labelText: 'Date of Birth'), onTap: pickDOB),
            TextField(controller: idCardController, decoration: const InputDecoration(labelText: 'ID Card')),
            DropdownButton<String>(
              value: gender,
              items: const [
                DropdownMenuItem(value: 'M', child: Text('Male')),
                DropdownMenuItem(value: 'F', child: Text('Female')),
                DropdownMenuItem(value: 'O', child: Text('Other')),
              ],
              onChanged: (value) => setState(() => gender = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveProfile, child: const Text('Save Profile')),
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  message,
                  style: TextStyle(color: message.contains('✅') ? Colors.green : Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
