import 'package:flutter/material.dart';
import 'package:zeencamp_v2/setting/tostore.dart';
import 'package:zeencamp_v2/user/aboutshop/shopdetail.dart';

import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../Authentication/login.dart';
import '../background.dart/securestorage.dart';

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
                  detailAccount(widthsize, heightsize, context),
                  tranferToShop(widthsize, heightsize, context),
                  detailPolicy(widthsize, heightsize, context),
                  detailLogout(widthsize, heightsize, context)
                ]),
              )
            ],
          ),
        ),
      ])),
    );
  }

  Widget beta(double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.7,
        height: heightsize * 0.055,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ShopDetail()));
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: kYellow,
              shape: const StadiumBorder(),
              elevation: 5,
              shadowColor: Colors.grey),
          child: Text(
            "ยืนยัน",
            style: TextStyle(
                color: kBlack,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.035),
          ),
        ),
      );

  Widget detailAccount(widthsize, heightsize, context) => InkWell(
        onTap: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const DetailAccount()));
        },
        child: Container(
          padding: EdgeInsets.only(left: widthsize * 0.1),
          alignment: Alignment.centerLeft,
          width: widthsize,
          height: heightsize * 0.1,
          decoration: const BoxDecoration(
            border: Border(
              // top: BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.black),
            ),
          ),
          child: Text(
            "การจัดการบัญชี",
            style: mystyleText(heightsize, 0.03, kGray4A, true),
          ),
        ),
      );

  Widget detailPolicy(widthsize, heightsize, context) => InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.only(left: widthsize * 0.1),
          alignment: Alignment.centerLeft,
          width: widthsize,
          height: heightsize * 0.1,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black),
            ),
          ),
          child: Text(
            "ข้อกำหนดและนโยบาย",
            style: mystyleText(heightsize, 0.03, kGray4A, true),
          ),
        ),
      );

  Widget tranferToShop(widthsize, heightsize, context) => InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ToStore()));
        },
        child: Container(
          padding: EdgeInsets.only(left: widthsize * 0.1),
          alignment: Alignment.centerLeft,
          width: widthsize,
          height: heightsize * 0.1,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black),
            ),
          ),
          child: Text(
            "เปลี่ยนเป็นไอดีร้านค้า",
            style: mystyleText(heightsize, 0.03, kGray4A, true),
          ),
        ),
      );

  Widget detailLogout(widthsize, heightsize, context) => InkWell(
      onTap: () {
        showAlertDecide(context,
            title: 'แจ้งเตือน', content: 'ยืนยันการออกจากระบบ', okAction: () {
          logOut(context);
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: widthsize * 0.1),
        alignment: Alignment.centerLeft,
        width: widthsize,
        height: heightsize * 0.1,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: kBlack))),
        child: Text(
          "ออกจากระบบ",
          style: mystyleText(heightsize, 0.03, kGray4A, true),
        ),
      ));

  void logOut(context) {
    SecureStorage().deleteAll();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
