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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[400],
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Picker
            Center(
              child: ProfileImagePicker(
                currentImage: imageFile,
                onImagePicked: (file) => setState(() => imageFile = file),
              ),
            ),
            if (imageFile == null && imageUrl != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    ApiService.APIDoc["baseurl"].toString() + imageUrl!,
                  ),
                ),
              ),
            const SizedBox(height: 30),

            _buildTextField(
              controller: nameController,
              label: 'Name',
              icon: Icons.person,
            ),
            _buildTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(
              controller: phoneController,
              label: 'Phone',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              controller: dobController,
              label: 'Date of Birth',
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: pickDOB,
            ),
            _buildTextField(
              controller: idCardController,
              label: 'ID Card',
              icon: Icons.credit_card,
            ),

            const SizedBox(height: 10),

            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildDropdownField(),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: message.contains('✅') ? Colors.green : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    GestureTapCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          prefixIcon: Icon(icon, color: Colors.black87),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: gender,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        dropdownColor: Colors.white,
        items: const [
          DropdownMenuItem(value: 'M', child: Text('Male')),
          DropdownMenuItem(value: 'F', child: Text('Female')),
          DropdownMenuItem(value: 'O', child: Text('Other')),
        ],
        onChanged: (value) => setState(() => gender = value!),
      ),
    );
  }


}
