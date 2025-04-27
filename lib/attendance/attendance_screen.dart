import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AttendanceScannerPage extends StatefulWidget {
  @override
  _AttendanceScannerPageState createState() => _AttendanceScannerPageState();
}

class _AttendanceScannerPageState extends State<AttendanceScannerPage> {
  bool _isScanned = false;
  String _qrCode= '';
  String _studentId= '';
  String _studentName= '';

  void _onDetect(Barcode barcode) {
    if (!_isScanned) {
      final String code = barcode.rawValue ?? '';
      final String studentId = 'Student001';
      final String studentName = 'Ne Zha';
      setState(() {
        _isScanned = true;
        _qrCode = code;
        _studentId = studentId;
        _studentName = studentName;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance recorded for: $_qrCode')),
      );

    }
  }

  void _resetScanner() {
    setState(() {
      _isScanned = false;
      _qrCode = '';
      _studentId='';
      _studentName='';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: MobileScannerController(),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  _onDetect(barcode);
                  break;
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: _isScanned
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scanned QR Code: $_qrCode',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _resetScanner,
                    child: Text('Scan Another'),
                  ),
                ],
              )
                  : Text('Scan a student QR code', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
