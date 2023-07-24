import 'package:flutter/material.dart';
import 'package:zeencamp_v2/setting/tostore.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../Authentication/login.dart';
import '../background.dart/securestorage.dart';
import 'detailaccount.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingState();
}

class _SettingState extends State<SettingPage> {
  var isstore = "";
  @override
  void initState() {
    super.initState();
    getData().then((value) => setState(() {

          }));
  }

  Future<void> getData() async {
    isstore = await SecureStorage().read("isstore") as String;
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
                  isstore=="false"?tranferToShop(widthsize, heightsize, context):Container(),
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

  Widget detailAccount(widthsize, heightsize, context) => InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DetailAccount()));
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
    SecureStorage().delete("token");
    SecureStorage().delete("idAccount");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
