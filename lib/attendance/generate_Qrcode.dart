import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart'; // your own service file
import 'dart:convert'; // For decoding Base64
import 'dart:typed_data'; // For handling bytes
import 'package:qr_flutter/qr_flutter.dart';

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
          // qrImageUrl = data['qr_image_base'];
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Generate QR Code'),
        backgroundColor: Colors.grey[400],
        elevation: 1,
        centerTitle: true,
        foregroundColor: Colors.black87,
      ),

      body: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        color: Colors.grey[100],
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
            // Image.memory(
            //   base64Decode(qrImageUrl!),
            //   width: 250,
            //   height: 250,
            //   fit: BoxFit.cover,
            // ),
            // QrImageView(
            //   data: qrImageUrl!, // <-- Use the base64 text directly!
            //   version: QrVersions.auto,
            //   size: 200.0,
            // ),

            SizedBox(height: 40),
            ElevatedButton(
              onPressed: generateQRCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Generate New QR Code',
                style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),),

            ),
          ],
        )
            : ElevatedButton(
          onPressed: generateQRCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Generate New QR Code',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),),
        ),
        ),
      );
  }
}
