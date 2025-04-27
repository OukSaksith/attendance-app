import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart'; // your own service file

class GenerateQRCodePage extends StatefulWidget {
  @override
  _GenerateQRCodePageState createState() => _GenerateQRCodePageState();
}

class _GenerateQRCodePageState extends State<GenerateQRCodePage> {
  String? qrImageUrl;
  bool isLoading = false;

  Future<void> generateQRCode() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(ApiService.APIDoc['mainAPI'].toString() + '/generate-qr/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          qrImageUrl = data['qr_image_url'];
          isLoading = false;
        });
      } else {
        print('Failed to generate QR Code');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : qrImageUrl != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              qrImageUrl!,
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateQRCode,
              child: Text('Generate New QR Code'),
            ),
          ],
        )
            : ElevatedButton(
          onPressed: generateQRCode,
          child: Text('Generate QR Code'),
        ),
      ),
    );
  }
}
