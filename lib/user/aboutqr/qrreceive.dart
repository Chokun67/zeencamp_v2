import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';

import '../../background.dart/securestorage.dart';

class QrReceive extends StatefulWidget {
    const QrReceive({Key? key, required this.idshop}) : super(key: key);
  final String idshop;

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
    // final heightsize = MediaQuery.of(context).size.height- MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR รับเงิน'),
        backgroundColor: kYellow,
        foregroundColor: kGray4A,
      ),
      body: Center(
        child: QrImageView(
          data: widget.idshop,
          version: QrVersions.auto,
          backgroundColor: Colors.white,
          size: widthsize*0.5,
        ),
      ),
    );
  }
}
