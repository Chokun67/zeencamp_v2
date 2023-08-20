import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';

import '../../application/accountService/accountservice.dart';
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
  var idname = "";
  @override
  void initState() {
    super.initState();
    getData().then((value) =>
        AccountService().apigetpoint(token).then((value) => setState(() {
              idAccount = value.id;
              idname = value.name;
            })));
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height- MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR รับเงิน'),
        backgroundColor: kYellow,
        foregroundColor: kGray4A,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: widget.idshop,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
              size: widthsize * 0.5,
            ),
            SizedBox(height: heightsize*0.01),
            Text("ชื่อ $idname",style: mystyleText(heightsize, 0.03, kGray4A, true)),
            SizedBox(height: heightsize*0.01),
            Text("id $idAccount",style: mystyleText(heightsize, 0.03, kGray4A, true)),
          ],
        ),
      ),
    );
  }
}
