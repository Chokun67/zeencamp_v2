import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zeencamp_v2/application/tranferService/tranferservice.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';
import 'package:zeencamp_v2/domain/dmstore/detailshopdm.dart';
import '../../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';

class QrBill extends StatefulWidget {
  const QrBill(
      {Key? key,
      required this.hash,
      required this.amountmenu,
      required this.menusend,
      required this.isReceive,
      required this.sumpoint})
      : super(key: key);
  final String hash;
  final List<int> amountmenu;
  final List<Store> menusend;
  final bool isReceive;
  final double sumpoint;
  @override
  State<QrBill> createState() => _ShopTypeState();
}

class _ShopTypeState extends State<QrBill> {
  String token = "";
  String idAccount = "";
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
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
            widget.isReceive?"สแกนเพื่อรับพอยท์":"สแกนเพื่อใช้พอยท์",
            true,
            0.2),
        Padding(
          padding: EdgeInsets.all(widthsize * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightsize * 0.2),
              beta(heightsize, widthsize, context),
              menuqr(heightsize, widthsize)
            ],
          ),
        ),
      ])),
    );
  }

  Widget beta(double heightsize, double widthsize, BuildContext context) =>
      InkWell(
        onTap: () {
          TranferService()
              .transferExchangeInteraction(token, widget.hash)
              .then((value) => {
                    if (value == true)
                      {
                        showAlertBox(
                            context, "ตรวจสอบ", "qrยังถูกใช้งานเรียบร้อยแล้ว")
                      }
                    else
                      {showAlertBox(context, "ตรวจสอบ", "qrยังไม่ถูกใช้งาน")}
                  });
        },
        child: Center(
          child: QrImageView(
            data: widget.hash,
            version: QrVersions.auto,
            backgroundColor: Colors.white,
            size: widthsize * 0.5,
          ),
        ),
      );

  Widget menuqr(
    double heightsize,
    double widthsize,
  ) =>
      SizedBox(
        width: widthsize,
        child: Column(
          children: [
            Text(
                widget.isReceive
                    ? "พ้อยที่ได้รับ : ${widget.sumpoint}"
                    : "พ้อยที่ต้องชำระ : ${widget.sumpoint}",
                style: mystyleText(heightsize, 0.03, kGray4A, true)),
            Container(
                padding: EdgeInsets.all(heightsize * 0.02),
                width: widthsize * 0.8,
                height: heightsize * 0.3,
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      topic(heightsize, widthsize),
                      menu1(heightsize, widthsize)
                    ],
                  ),
                )),
            SizedBox(
              height: heightsize * 0.02,
            ),
            loginButton(heightsize, widthsize, context)
          ],
        ),
      );

  Widget topic(heightsize, widthsize) => SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: widthsize * 0.3,
                child: Text("รายการ",
                    style: mystyleText(heightsize, 0.02, kGray4A, true))),
            SizedBox(
                width: widthsize * 0.2,
                child: Center(
                  child: Text("จำนวน",
                      style: mystyleText(heightsize, 0.02, kGray4A, true)),
                )),
            SizedBox(
                width: widthsize * 0.2,
                child: Center(
                  child: Text("พอยท์",
                      style: mystyleText(heightsize, 0.02, kGray4A, true)),
                )),
          ],
        ),
      );

  Widget menu1(heightsize, widthsize) => SizedBox(
        child: Column(
          children: [
            ListView.builder(
                itemCount: widget.menusend.length,
                padding: EdgeInsets.only(top: widthsize * 0.04),
                physics: const ScrollPhysics(parent: null),
                shrinkWrap: true,
                itemBuilder: (BuildContext buildList, int index) {
                  Store menu = widget.menusend[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: widthsize * 0.3,
                          child: Text(
                            menu.nameMenu,
                            style:
                                mystyleText(heightsize, 0.02, kGray4A, false),
                          )),
                      SizedBox(
                        width: widthsize * 0.2,
                        child: Center(
                          child: Text(widget.amountmenu[index].toString(),
                              style: mystyleText(
                                  heightsize, 0.02, kGray4A, false)),
                        ),
                      ),
                      SizedBox(
                          width: widthsize * 0.2,
                          child: Center(
                            child: Text(
                                widget.isReceive
                                    ? "${menu.receive * widget.amountmenu[index]}"
                                    : "${menu.exchange * widget.amountmenu[index]}",
                                style: mystyleText(
                                    heightsize, 0.02, kGray4A, false)),
                          )),
                    ],
                  );
                })
          ],
        ),
      );

  Widget menu(heightsize, widthsize) => SizedBox(
        width: widthsize * 0.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("รายการ", style: mystyleText(heightsize, 0.02, kGray4A, true)),
            ListView.builder(
                itemCount: widget.menusend.length,
                padding: EdgeInsets.all(widthsize * 0.04),
                physics: const ScrollPhysics(parent: null),
                shrinkWrap: true,
                itemBuilder: (BuildContext buildList, int index) {
                  Store menu = widget.menusend[index];
                  return Text(menu.nameMenu);
                })
          ],
        ),
      );

  Widget amount(heightsize, widthsize) => SizedBox(
        width: widthsize * 0.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("จำนวน", style: mystyleText(heightsize, 0.02, kGray4A, true)),
            ListView.builder(
                itemCount: widget.menusend.length,
                padding: EdgeInsets.all(widthsize * 0.04),
                physics: const ScrollPhysics(parent: null),
                shrinkWrap: true,
                itemBuilder: (BuildContext buildList, int index) {
                  return Center(
                      child: Text(widget.amountmenu[index].toString()));
                })
          ],
        ),
      );

  Widget amountpoint(heightsize, widthsize) => SizedBox(
        width: widthsize * 0.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("พอยท์", style: mystyleText(heightsize, 0.02, kGray4A, true)),
            ListView.builder(
                itemCount: widget.amountmenu.length,
                padding: EdgeInsets.only(top: heightsize * 0.04),
                physics: const ScrollPhysics(parent: null),
                shrinkWrap: true,
                itemBuilder: (BuildContext buildList, int index) {
                  Store menu = widget.menusend[index];
                  return Center(
                      child: Text(widget.isReceive
                          ? "${menu.receive}"
                          : "${menu.exchange}"));
                })
          ],
        ),
      );

  Widget loginButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.5,
        height: heightsize * 0.06,
        child: ElevatedButton(
          onPressed: () {
            TranferService()
                .transferExchangeInteraction(token, widget.hash)
                .then((value) => {
                      if (value == true)
                        {
                          showAlertBox(
                              context, "ตรวจสอบ", "qrยังถูกใช้งานเรียบร้อยแล้ว")
                        }
                      else
                        {showAlertBox(context, "ตรวจสอบ", "qrยังไม่ถูกใช้งาน")}
                    });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kYellow,
            shape: const StadiumBorder(),
          ),
          child: Text(
            "ตรวจสอบQR",
            style: mystyleText(heightsize, 0.025, kGray4A, true),
          ),
        ),
      );
}
