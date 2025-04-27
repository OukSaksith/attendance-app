import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart';

class AttendanceScannerPage extends StatefulWidget {
  @override
  _AttendanceScannerPageState createState() => _AttendanceScannerPageState();
}

class _AttendanceScannerPageState extends State<AttendanceScannerPage> {
  bool _isScanned = false;
  String? _resultMessage;

  Future<void> saveAttendance(String studentId, String studentName, String qrCode) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.APIDoc['mainAPI'].toString()+'/attendance/save/'), // Update this!
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'student_id': studentId,
          'student_name': studentName,
          'qr_data': qrCode
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _resultMessage = '✅ Attendance Saved!';
        });
      } else {
        setState(() {
          _resultMessage = '❌ Failed to Save Attendance';
        });
      }
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Error: $e';
      });
    }
  }

  void _onDetect(Barcode barcode) {
    if (!_isScanned) {
      final String? code = barcode.rawValue;
      // Decode the base64 string
      String decodedString = utf8.decode(base64.decode(barcode.rawValue.toString()));
      Map<String, dynamic> jsonObject = jsonDecode(decodedString);

      if (code != null) {
        setState(() {
          _isScanned = true;
        });
        saveAttendance(jsonObject['student_id'],jsonObject['student_name'],code);  // Save attendance to Django
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan for Attendance'),
      ),
      body: Center(
        child: _isScanned
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _resultMessage ?? '',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isScanned = false;
                  _resultMessage = null;
                });
              },
              child: Text('Scan Another'),
            ),
          ],
        )
            : MobileScanner(
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              _onDetect(barcode);
              break;  // only take the first scan
            }
          },
        ),
      ),
    );
  }
}
