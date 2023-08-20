import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeencamp_v2/setting/setting.dart';
import 'package:zeencamp_v2/shop/report.dart';
import 'package:zeencamp_v2/shop/tranferbill/billchoice.dart';
import 'package:zeencamp_v2/shop/detail/detailstore.dart';
import '../Authentication/login.dart';
import '../application/accountService/accountservice.dart';
import '../background.dart/appstyle.dart';
import '../background.dart/background.dart';
import '../background.dart/securestorage.dart';
import '../user/tranfer/history.dart';
import '../user/tranfer/tranfer.dart';
import 'buypoint.dart';

class MenuShop extends StatefulWidget {
  const MenuShop({super.key});

  @override
  State<MenuShop> createState() => _MenuShopState();
}

class _MenuShopState extends State<MenuShop> {
  late var pointid = 0;
  late var token = "";
  late var idname = "";
  late var idAccount = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  Future<void> getpoint() async {
    await AccountService().apigetpoint(token).then((value) =>
        {pointid = value.point, idAccount = value.id, idname = value.name});
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getData().then((value) => getpoint()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Mystlye().waitfuture();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
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
                          SizedBox(height: heightsize * 0.22),
                          Center(child: boxPoint(widthsize, heightsize)),
                          SizedBox(height: heightsize * 0.018),
                          checkData(widthsize, heightsize),
                          SizedBox(height: heightsize * 0.018),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("สวัสดีครับ\nคุณ $idname",
                                style: mystyleText(
                                    heightsize, 0.045, kBlack, true)),
                            SizedBox(height: heightsize * 0.01),
                            Text("id: $idAccount ",
                                style: mystyleText(
                                    heightsize, 0.025, kGray4A, true))
                          ],
                        ))
                  ],
                )),
              ),
            );
          }
        });
  }

  Widget boxPoint(widthsize, heightsize) => InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const History())),
        child: Container(
          padding: EdgeInsets.all(widthsize * 0.05),
          width: widthsize * 0.8,
          height: heightsize * 0.2,
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
              Text("ยอดคงเหลือ",
                  style:
                      TextStyle(color: kBlack, fontSize: heightsize * 0.022)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(NumberFormat("#,##0").format(pointid),
                      style: TextStyle(
                          color: kGray4A,
                          fontSize: heightsize * 0.04,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: widthsize * 0.02),
                  Text("พอยท์",
                      style: TextStyle(
                          color: kGray4A,
                          fontSize: heightsize * 0.022,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Container(
                  width: widthsize * 0.7,
                  height: heightsize * 0.02,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: kGray75, width: 2.0)))),
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

  Widget checkData(widthsize, heightsize) => InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Report()),
        ),
        child: Container(
          width: widthsize * 0.8,
          height: heightsize * 0.14,
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
              size: heightsize * 0.075,
            ),
            Text(
              "ข้อมูล",
              style: mystyleText(heightsize, 0.028, kGray4A, true),
            )
          ]),
        ),
      );

  Widget fourmenustore(widthsize, heightsize) => SizedBox(
        width: widthsize * 0.8,
        height: heightsize * 0.355,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BuyPoint()));
                      setState(() {});
                    },
                    child: menustore(widthsize, heightsize,
                        Icons.attach_money_outlined, "ซื้อพอยท์"),
                  ),
                  InkWell(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailStore(
                                    idshop: idAccount, nameshop: idname)));
                        setState(() {});
                      },
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
                        Icons.import_export_rounded, "โอนพอยท์"),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BillChoice())),
                    child: menustore(
                        widthsize, heightsize, Icons.credit_card, "สร้างบิล"),
                  ),
                ])
          ],
        ),
      );

  Widget menustore(widthsize, heightsize, menuicon, title) => Container(
        width: widthsize * 0.38,
        height: heightsize * 0.17,
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
          Icon(menuicon, size: heightsize * 0.075, color: kGray4A),
          Text(
            title,
            style: mystyleText(heightsize, 0.028, kGray4A, true),
          )
        ]),
      );

  void logOut() {
    SecureStorage().delete("token");
    SecureStorage().delete("idAccount");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Widget settingButton(widthsize, heightsize) => IconButton(
        icon: Icon(Icons.settings, size: widthsize * 0.055),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingPage()));
        },
      );
}
