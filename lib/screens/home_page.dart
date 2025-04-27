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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Home'),
  //       actions: [
  //         IconButton(
  //           onPressed: () => logout(context),
  //           icon: const Icon(Icons.logout),
  //         ),
  //       ],
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text('Hello, $username!', style: const TextStyle(fontSize: 24)),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (_) => const EditProfilePage()),
  //             ),
  //             child: const Text('Edit Profile'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => Navigator.push(
  //               context,
  //               // MaterialPageRoute(builder: (_) => AttendanceScannerPage()),
  //               MaterialPageRoute(builder: (_) => AttendanceScannerPage()),
  //             ),
  //             child: const Text('Scan'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (_) => GenerateQRCodePage()),
  //             ),
  //             child: const Text('Get QR Code'),
  //           ),
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          '🏠 Home',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout,  color: Colors.white),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Greeting, $username!',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              _buildButton(
                context,
                title: 'Edit Profile',
                color: Colors.teal,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                ),
              ),
              const SizedBox(height: 15),

              _buildButton(
                context,
                title: 'Scan',
                color: Colors.orange,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AttendanceScannerPage()),
                ),
              ),
              const SizedBox(height: 15),

              _buildButton(
                context,
                title: 'Get QR Code',
                color: Colors.blue,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GenerateQRCodePage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String title, required Color color, required VoidCallback onPressed}) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

