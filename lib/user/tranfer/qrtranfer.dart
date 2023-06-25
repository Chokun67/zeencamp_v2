import 'package:flutter/material.dart';

import '../../background.dart/background.dart';

class QrTranFer extends StatefulWidget {
   const QrTranFer({Key? key, required this.idstore})
      : super(key: key);
  final String idstore;

  @override
  State<QrTranFer> createState() => _QrTranFerState();
}

class _QrTranFerState extends State<QrTranFer> {
  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Mystlye()
            .buildBackground(widthsize, heightsize, context, "", true, 0.3),
        Padding(
          padding: EdgeInsets.all(widthsize * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightsize * 0.23),
              
            ],
          ),
        ),
      ])),
    );
  }
}