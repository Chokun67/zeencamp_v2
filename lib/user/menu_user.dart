import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeencamp_v2/setting/setting.dart';
import 'package:zeencamp_v2/user/tranfer/history.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';
import '../application/accountService/accountservice.dart';
import '../background.dart/background.dart';
import '../background.dart/securestorage.dart';
import 'aboutqr/qrmenu.dart';
import 'tranfer/tranfer.dart';
import 'aboutshop/typeshop.dart';

class MenuUser extends StatefulWidget {
  const MenuUser({super.key});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  // late Future<Map<String, dynamic>> datapoint;
  var pointid = 0;
  var token = "";
  var iduser = "";
  var idname = "";
  var idAccount = "";

  @override
  void initState() {
    super.initState();
    getData().then((_) {
      AccountService().apigetpoint(token).then((value) => setState(() {
            pointid = value.point;
            idAccount = value.id;
            idname = value.name;
          }));
    });
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  @override
  Widget build(BuildContext context) {
    List widgetOptions = [
      const MenuUser(),
      const TranferPage(),
      const ShopType(),
      QrMenu(idAccount: idAccount)
    ];
    final heightsize = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        showAlertDecide(context,
            title: 'แจ้งเตือน',
            content: 'ยืนยันการออกจากระบบ',
            okAction: logOut);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Stack(
            children: [
              Mystlye().buildBackground(
                  widthsize, heightsize, context, "", false, 0.3),
              Padding(
                padding: EdgeInsets.all(widthsize * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heightsize * 0.23),
                    Center(child: boxPoint(widthsize, heightsize)),
                    SizedBox(height: heightsize * 0.02),
                    Padding(
                      padding: EdgeInsets.only(left: widthsize * 0.07),
                      child: Text(
                        "โปรโมชั่น!",
                        style: TextStyle(
                            fontSize: heightsize * 0.025,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    promotionShop(widthsize, heightsize),
                    Padding(
                      padding: EdgeInsets.only(left: widthsize * 0.07),
                      child: Text("ร้านค้าแนะนำ",
                          style: TextStyle(
                              fontSize: heightsize * 0.025,
                              fontWeight: FontWeight.bold)),
                    ),
                    adviseShop(widthsize, heightsize)
                  ],
                ),
              ),
              Positioned(
                  top: widthsize * 0.02,
                  right: widthsize * 0.04,
                  child: settingButton(heightsize, widthsize)),
              Positioned(
                  top: widthsize * 0.04,
                  left: widthsize * 0.04,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("สวัสดีครับ\nคุณ $idname",
                          style: mystyleText(heightsize, 0.04, kBlack, true)),
                      SizedBox(height: heightsize * 0.01),
                      Text("id: $idAccount ",
                          style: mystyleText(heightsize, 0.02, kGray4A, true))
                    ],
                  ))
            ],
          ),
        )),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: heightsize * 0.018,
          selectedFontSize: heightsize * 0.018,
          iconSize: heightsize * 0.04,
          backgroundColor: kWhite,
          unselectedItemColor: kGray55,
          selectedItemColor: kGray55,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'เมนู'),
            BottomNavigationBarItem(
                icon: Icon(Icons.import_export), label: 'โอนพ้อย'),
            BottomNavigationBarItem(
                icon: Icon(Icons.store), label: 'ร้านค้าต่างๆ'),
            BottomNavigationBarItem(
                icon: Icon(Icons.qr_code), label: 'แสกน QR'),
          ],
          currentIndex: 0,
          onTap: (index) async {
            if (index != 0) {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => widgetOptions[index]));
              setState(() {
                AccountService()
                    .apigetpoint(token)
                    .then((value) => setState(() {
                          pointid = value.point;
                        }));
              });
            }
          },
        ),
      ),
    );
  }

  Widget boxPoint(widthsize, heightsize) => InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const History())),
        child: Container(
          padding: EdgeInsets.all(widthsize * 0.05),
          width: widthsize * 0.8,
          height: heightsize * 0.185,
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("ยอดคงเหลือ",
                    style:
                        TextStyle(color: kBlack, fontSize: heightsize * 0.02)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(NumberFormat("#,##0").format(pointid),
                        style: TextStyle(
                            color: kGray4A,
                            fontSize: heightsize * 0.05,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: widthsize * 0.02),
                    Text("พอยท์",
                        style: TextStyle(
                            color: kGray4A,
                            fontSize: heightsize * 0.02,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ]),
              Container(
                  width: widthsize * 0.7,
                  height: heightsize * 0.035,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: kGray75,
                    width: 2.0,
                  )))),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('รายละเอียดเพิ่มเติม',
                        style: TextStyle(
                            fontSize: heightsize * 0.02,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget promotionShop(widthsize, heightsize) => Container(
        padding: EdgeInsets.only(left: widthsize * 0.03),
        height: heightsize * 0.18,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: heightsize * 0.15,
                width: widthsize * 0.7,
                decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
              SizedBox(width: widthsize * 0.05),
              Container(
                  height: heightsize * 0.15,
                  width: widthsize * 0.6,
                  decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15))))
            ],
          ),
        ),
      );

  Widget adviseShop(widthsize, heightsize) => Container(
        padding: EdgeInsets.only(left: widthsize * 0.03),
        height: heightsize * 0.15,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                  height: heightsize * 0.14,
                  width: widthsize * 0.38,
                  decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              SizedBox(width: widthsize * 0.05),
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: heightsize * 0.14,
                  width: widthsize * 0.38),
              SizedBox(width: widthsize * 0.05),
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: heightsize * 0.14,
                  width: widthsize * 0.38)
            ],
          ),
        ),
      );

  void logOut() {
    SecureStorage().deleteAll();
    Navigator.pop(context);
  }

  Widget settingButton(widthsize, heightsize) => IconButton(
        icon: Icon(Icons.settings, size: widthsize * 0.055),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingPage()));
        },
      );
}
