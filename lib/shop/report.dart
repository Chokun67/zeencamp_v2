import 'package:flutter/material.dart';
import 'package:zeencamp_v2/application/shopService/shopservice.dart';

import '../background.dart/appstyle.dart';
import '../background.dart/background.dart';
import '../background.dart/securestorage.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String token = "";
  @override
  void initState() {
    super.initState();
      getData();
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
  }

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
            "รายงาน",
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
                child: Column(
                    children: [reportButton(heightsize, widthsize, context)]),
              )
            ],
          ),
        ),
      ])),
    );
  }

  Widget reportButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.5,
        height: heightsize * 0.06,
        child: ElevatedButton(
          onPressed: () {
            StoresService().dowloadreport(token);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kYellow,
            shape: const StadiumBorder(),
          ),
          child: Text(
            "ดาวโหลดรายงาน",
            style: mystyleText(heightsize, 0.025, kGray4A, true),
          ),
        ),
      );
}
