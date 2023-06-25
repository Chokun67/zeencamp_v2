import 'package:flutter/material.dart';
import '../../background.dart/background.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingState();
}

class _SettingState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Mystlye().buildBackground(
            widthsize,
            heightsize - MediaQuery.of(context).padding.vertical,
            context,
            "การตั้งค่า",
            true,
            0.2),
        Padding(
          padding: EdgeInsets.all(widthsize * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightsize * 0.1),
              Container(
                padding: EdgeInsets.only(top: heightsize * 0.1),
                height: heightsize * 0.5,
                child: Column(children: [
                  
                ]),
              )
            ],
          ),
        ),
      ])),
    );
  }
}
