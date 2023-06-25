import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../tranfer/qrtranfer.dart';

class QrScaner extends StatefulWidget {
  const QrScaner({super.key});

  @override
  State<QrScaner> createState() => _QrScanerState();
}

class _QrScanerState extends State<QrScaner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = "";
  int testint = 0;
  String teststring = "";
  late Map<String, dynamic> toTranfer = {};
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR จ่ายเงิน'),backgroundColor: const Color(0xFF4A4A4A),foregroundColor: 
        const Color(0xFFFFD600),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 20.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: Text(
                'Scan QR Code within the red rectangle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: Text(
                'Result: $qrText',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (!isScanned) {
        setState(() {
          qrText = scanData.code!;
          try {
            toTranfer = jsonDecode(qrText);
            if (toTranfer['point'] is! int || toTranfer['idstore'] is! String) {
              isScanned = true;
              _showErrorDialog('Invalid data types in QR Code');
              return;
            }            
          } catch (e) {
            isScanned = true;
            _showErrorDialog('Invalid data types in QR Code');
            return;
          }
          isScanned = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QrTranFer(
                idstore: toTranfer['idstore']!,
              ),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isScanned = false;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
