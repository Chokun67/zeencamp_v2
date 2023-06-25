import 'package:flutter/material.dart';

import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';

class ShopDetail extends StatefulWidget {
  const ShopDetail({super.key});

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> yourData = [
      {
        'line1': 'ข้อความบรรทัดที่ 1',
        'line2': 'ข้อความบรรทัดที่ 2',
      },
      {
        'line1': 'ข้อความบรรทัดที่ 1',
        'line2': 'ข้อความบรรทัดที่ 2',
      },
      {
        'line1': 'ข้อความบรรทัดที่ 1',
        'line2': 'ข้อความบรรทัดที่ 2',
      },
      {
        'line1': 'ข้อความบรรทัดที่ 1',
        'line2': 'ข้อความบรรทัดที่ 2',
      },
      {
        'line1': 'ข้อความบรรทัดที่ 1',
        'line2': 'ข้อความบรรทัดที่ 2',
      },
      {
        'line1': 'ข้อความบรรทัดที่ 1',
        'line2': 'ข้อความบรรทัดที่ 2',
      },
      {
        'line1': 'ข้อความบรรทัดที่ 1',
        'line2': 'ข้อความบรรทัดที่ 2',
      }
    ];

    final heightsize = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(children: [
                  Mystlye()
              .buildBackground(widthsize, heightsize, context, "", true, 0.3),
                  SizedBox(
            width: widthsize,
            height: heightsize * 0.3,
            child: //customerData.storePicture.isNotEmpty
                // ? Image.network(
                //     'http://$ip:17003/api/v1/image/${customerData.storePicture}',
                //     fit: BoxFit.cover,
                //   )
                // :
                Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ไม่มีรูปภาพ",
                    style: TextStyle(
                        fontSize: heightsize * 0.05,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: heightsize * 0.1)
              ],
            ),
                  ),
                  Padding(
            padding: EdgeInsets.all(widthsize * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heightsize * 0.23),
                Center(child: boxPoint(widthsize, heightsize)),
                SizedBox(height: heightsize * 0.05),
                Column(children: [detailMenu(widthsize, heightsize, yourData)])
              ],
            ),
                  ),
                ]),
          )),
    );
  }

  Widget boxPoint(widthsize, heightsize) => Container(
        padding: EdgeInsets.all(widthsize * 0.05),
        width: widthsize * 0.88,
        height: heightsize * 0.17,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: kWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.5,
              blurRadius: 4, // รัศมีการเบลอของเงา
              offset: Offset(0, 5), // ตำแหน่งเงาแนวนอนและแนวตั้ง
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ปอนด์แอบแซ่บ - ชลบุรี",
              style: TextStyle(
                  color: kGray4A,
                  fontSize: heightsize * 0.026,
                  fontWeight: FontWeight.bold),
            ),
            Container(
                width: widthsize * 0.7,
                height: heightsize * 0.01,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: kGray75,
                  width: 2.0,
                ))))
          ],
        ),
      );

  Widget detailMenu(widthsize, heightsize, yourData) => SingleChildScrollView(
        child: Column(children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            physics: const ScrollPhysics(parent: null),
            shrinkWrap: true,
            itemCount: yourData.length, // จำนวนรายการข้อมูลใน GridView
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(8.0), // ระยะห่างรอบด้านของแต่ละรายการ
                child: Column(
                  children: [
                    Container(
                        height: heightsize * 0.14,
                        width: widthsize * 0.44,
                        color: Colors.green), // รูปภาพ
                    Text(
                      yourData[index]['line1'], // ข้อความบรรทัดที่ 1
                    ),
                    Text(
                      yourData[index]['line2'], // ข้อความบรรทัดที่ 2
                    ),
                  ],
                ),
              );
            },
          ),
        ]),
      );
}
