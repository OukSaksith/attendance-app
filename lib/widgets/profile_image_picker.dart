import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  final Function(File?) onImagePicked;
  final File? currentImage;
  const ProfileImagePicker({super.key, required this.onImagePicked, this.currentImage});
  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? imageFile;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      setState(() {
        imageFile = file;
      });
      widget.onImagePicked(file);
    }
  }

  @override
  void initState() {
    super.initState();
    imageFile = widget.currentImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
        child: imageFile == null ? const Icon(Icons.camera_alt, size: 40) : null,
      ),
    );
  }
}