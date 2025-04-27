import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'edit_profile_page.dart';
import '../attendance/recorde_attendance.dart';
import '../attendance/generate_Qrcode.dart';

class HomePage extends StatelessWidget {
  final String username;
  const HomePage({super.key, required this.username});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, $username!', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              ),
              child: const Text('Edit Profile'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                // MaterialPageRoute(builder: (_) => AttendanceScannerPage()),
                MaterialPageRoute(builder: (_) => AttendanceScannerPage()),
              ),
              child: const Text('Scan'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GenerateQRCodePage()),
              ),
              child: const Text('Get QR Code'),
            ),

          ],
        ),
      ),
    );
  }
}

