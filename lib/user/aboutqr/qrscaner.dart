import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';

import '../../application/tranferService/tranferservice.dart';
import '../../background.dart/securestorage.dart';
import '../aboutshop/getpoint.dart';
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
  bool isScanned = false;
  String token = "";
  String idAccount = "";

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
        title: const Text('QR จ่ายเงิน'),
        backgroundColor: kYellow,
        foregroundColor: kGray4A,
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
          isScanned = true;
          TranferService().apiValidateTranfer(qrText, token).then((value) => {
                if (value != null)
                  {
                    print("wtf 1"),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QrTranFer(idstore: qrText)))
                            ,isScanned = false
                  }
                else
                  {
                    TranferService()
                        .validateMenuForMenu(token, qrText)
                        .then((value) => {
                              if (value != null)
                                {
                                  _showErrorDialog("QR ใช้งานได้"),
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GetPoint(
                                              hash: qrText,
                                              menuList: value.menuStores,
                                              amount: value.amount)))
                                  
                                }
                              else
                                {_showErrorDialog("รูปแบบ QR ไม่ถูกต้อง")}
                            })
                  },
              });
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
