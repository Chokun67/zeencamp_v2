import 'package:flutter/material.dart';
import 'package:zeencamp_v2/setting/setting.dart';
import 'package:zeencamp_v2/shop/createbill.dart';
import 'package:zeencamp_v2/shop/detailstore.dart';
import '../application/accountService/accountservice.dart';
import '../background.dart/appstyle.dart';
import '../background.dart/background.dart';
import '../background.dart/securestorage.dart';
import '../user/tranfer/history.dart';
import '../user/tranfer/tranfer.dart';

class MenuShop extends StatefulWidget {
  const MenuShop({super.key});

  @override
  State<MenuShop> createState() => _MenuShopState();
}

class _MenuShopState extends State<MenuShop> {
  var pointid = 0;
  var token = "";
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
    final heightsize = MediaQuery.of(context).size.height;
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
            child: Stack(
          children: [
            Mystlye().buildBackground(
                widthsize, heightsize, context, "", false, 0.3),
            Padding(
              padding: EdgeInsets.all(widthsize * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: heightsize * 0.23),
                  Center(child: boxPoint(widthsize, heightsize)),
                  SizedBox(height: heightsize * 0.015),
                  checkData(widthsize, heightsize),
                  SizedBox(height: heightsize * 0.015),
                  fourmenustore(widthsize, heightsize)
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
                  children: [Text("สวัสดีครับคุณ $idname\nid: $idAccount ")],
                ))
          ],
        )),
      ),
    );
  }

  Widget boxPoint(widthsize, heightsize) => Container(
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
                  style: TextStyle(color: kBlack, fontSize: heightsize * 0.02)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("900",
                      style: TextStyle(
                          color: kGray4A,
                          fontSize: heightsize * 0.05,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: widthsize * 0.02),
                  Text("พ้อยท์",
                      style: TextStyle(
                          color: kGray4A,
                          fontSize: heightsize * 0.02,
                          fontWeight: FontWeight.bold))
                ],
              )
            ]),
            Container(
                width: widthsize * 0.7,
                height: heightsize * 0.04,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: kGray75, width: 2.0)))),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const History())),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('รายละเอียดเพิ่มเติม',
                        style: TextStyle(
                            fontSize: heightsize * 0.02,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget checkData(widthsize, heightsize) => Container(
        width: widthsize * 0.8,
        height: heightsize * 0.125,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: kWhite,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0.5,
                  blurRadius: 4, // รัศมีการเบลอของเงา
                  offset: Offset(0, 5) // ตำแหน่งเงาแนวนอนและแนวตั้ง
                  )
            ]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.auto_graph_sharp,
            size: heightsize * 0.07,
          ),
          Text(
            "ข้อมูล",
            style: mystyleText(heightsize, 0.025, kGray4A, true),
          )
        ]),
      );

  Widget fourmenustore(widthsize, heightsize) => SizedBox(
        width: widthsize * 0.8,
        height: heightsize * 0.35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  menustore(widthsize, heightsize, Icons.attach_money_outlined,
                      "ซ์้อพ้อย"),
                  InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailStore(idshop: idAccount, nameshop: idname))),
                      child: menustore(
                          widthsize, heightsize, Icons.store, "ร้านค้า"))
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TranferPage())),
                    child: menustore(widthsize, heightsize,
                        Icons.import_export_rounded, "โอนพ้อย"),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateBill())),
                    child: menustore(
                        widthsize, heightsize, Icons.credit_card, "สร้างบิล"),
                  ),
                ])
          ],
        ),
      );

  Widget menustore(widthsize, heightsize, menuicon, title) => Container(
    width: widthsize * 0.38,
    height: heightsize * 0.168,
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: kWhite,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.5,
              blurRadius: 4, // รัศมีการเบลอของเงา
              offset: Offset(0, 5) // ตำแหน่งเงาแนวนอนและแนวตั้ง
              )
        ]),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(menuicon, size: heightsize * 0.07, color: kGray4A),
      Text(
        title,
        style: mystyleText(heightsize, 0.025, kGray4A, true),
      )
    ]),
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
