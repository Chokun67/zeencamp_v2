import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../background.dart/securestorage.dart';

class QrReceive extends StatefulWidget {
  const QrReceive({super.key});

  @override
  State<QrReceive> createState() => _QrReceiveState();
}

class _QrReceiveState extends State<QrReceive> {
  var token = "";
  var idAccount = "";
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR รับเงิน'),
        backgroundColor: const Color(0xFF4A4A4A),
        foregroundColor: const Color(0xFFFFD600),
      ),
      body: Center(
        child: QrImageView(
          data: idAccount,
          version: QrVersions.auto,
          backgroundColor: Colors.white,
          size: 200.0,
        ),
      ),
    );
  }
}
