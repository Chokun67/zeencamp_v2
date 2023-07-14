import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeencamp_v2/application/tranferService/tranferservice.dart';
import 'package:zeencamp_v2/domain/dmtranfer/qrhash.dart';

import '../../application/accountService/accountservice.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';

class GetPoint extends StatefulWidget {
  const GetPoint({
    Key? key,
    required this.hash,
    required this.menuList,
    required this.amount,
  }) : super(key: key);
  final String hash;
  final List<MenuList> menuList;
  final int amount;

  @override
  State<GetPoint> createState() => _GetPointState();
}

class _GetPointState extends State<GetPoint> {
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
    final heightsize = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Mystlye().buildBackground(
            widthsize, heightsize, context, "รับพอยท์", true, 0.22),
        Padding(
          padding: EdgeInsets.all(widthsize * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: heightsize * 0.13),
              boxPoint(widthsize, heightsize),
              getOrGive(widthsize, heightsize),
              detailTrandfer(widthsize, heightsize),
              beta(heightsize, widthsize, context)
            ],
          ),
        ),
      ])),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("การทำรายการ",
                  style: mystyleText(heightsize, 0.03, kGray4A, true)),
              Text("100", style: mystyleText(heightsize, 0.03, kGray4A, true))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("ยอดคงเหลือ",
                  style: mystyleText(heightsize, 0.03, kGray4A, true)),
              Text("3600", style: mystyleText(heightsize, 0.03, kGray4A, true))
            ])
          ],
        ),
      );

  Widget getOrGive(widthsize, heightsize) => Container(
        width: widthsize,
        padding: EdgeInsets.only(
            left: widthsize * 0.1,
            bottom: widthsize * 0.02,
            top: heightsize * 0.025),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("29 มค 2566",
                style: mystyleText(heightsize, 0.023, kBlack, false)),
            SizedBox(height: heightsize * 0.01),
            Text("รับพอยท์",
                style: mystyleText(heightsize, 0.035, kBlack, true)),
          ],
        ),
      );

  Widget detailTrandfer(widthsize, heightsize) => Container(
        height: heightsize * 0.45,
        width: widthsize * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kWhite,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.5,
              blurRadius: 4, // รัศมีการเบลอของเงา
              offset: Offset(0, 5), // ตำแหน่งเงาแนวนอนและแนวตั้ง
            )
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: widthsize * 0.4,
              child: Column(
                children: [
                  Text("รายการ",style: mystyleText(heightsize, 0.025, kBlack, false),),
                  ListView.builder(
                      itemCount: widget.menuList.length,
                      padding: EdgeInsets.all(widthsize * 0.04),
                      physics: const ScrollPhysics(parent: null),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext buildList, int index) {
                        MenuList menu = widget.menuList[index];
                        return Text(menu.nameMenu);
                      })
                ],
              ),
            ),
            SizedBox(
              width: widthsize * 0.2,
              child: Column(
                children: [
                  Text("จำนวน",style: mystyleText(heightsize, 0.025, kBlack, false)),
                  ListView.builder(
                      itemCount: widget.menuList.length,
                      padding: EdgeInsets.all(widthsize * 0.04),
                      physics: const ScrollPhysics(parent: null),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext buildList, int index) {
                        MenuList menu = widget.menuList[index];
                        return Text(NumberFormat("#,##0").format(menu.receive),);
                      })
                ],
              ),
            ),
            SizedBox(
              width: widthsize * 0.2,
              child: Column(
                children: [
                  Text("พอยท์",style: mystyleText(heightsize, 0.025, kBlack, false)),
                  ListView.builder(
                      itemCount: widget.menuList.length,
                      padding: EdgeInsets.all(widthsize * 0.04),
                      physics: const ScrollPhysics(parent: null),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext buildList, int index) {
                        return Text(widget.amount.toString());
                      })
                ],
              ),
            )
          ],
        ),
      );

  Widget beta(double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.7,
        height: heightsize * 0.055,
        child: ElevatedButton(
          onPressed: () {
            TranferService()
                .transferConfirmPoint(token, widget.hash)
                .then((value) => print("พังครับพี่ $value"));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: kYellow,
              shape: const StadiumBorder(),
              elevation: 5,
              shadowColor: Colors.grey),
          child: Text(
            "รับพ้อย",
            style: TextStyle(
                color: kBlack,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.035),
          ),
        ),
      );
}
