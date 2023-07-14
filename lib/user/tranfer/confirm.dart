import 'package:flutter/material.dart';
import 'package:zeencamp_v2/application/accountService/accountservice.dart';
import 'package:zeencamp_v2/user/tranfer/receipt.dart';

import '../../application/tranferService/tranferservice.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';

class ConfirmTranfer extends StatefulWidget {
  const ConfirmTranfer(
      {Key? key,
      required this.payee,
      required this.idpayee,
      required this.amount})
      : super(key: key);
  final String payee;
  final String idpayee;
  final int amount;

  @override
  State<ConfirmTranfer> createState() => _ConfirmTranferState();
}

class _ConfirmTranferState extends State<ConfirmTranfer> {
  var pointid = 0;
  var token = "";
  var idAccount = "";
  var idname = "";

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
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Mystlye().buildBackground(
            widthsize, heightsize, context, "ตรวจสอบ", true, 0.22),
        Padding(
          padding: EdgeInsets.all(widthsize * 0.03),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: heightsize * 0.15),
                confirmBox(widthsize, heightsize),
                SizedBox(height: heightsize * 0.04),
                confirmMoney(widthsize, heightsize),
              ],
            ),
          ),
        ),
        Positioned(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              confirmPageButton(heightsize, widthsize, context),
              SizedBox(height: heightsize * 0.02),
              cancelPageButton(heightsize, widthsize, context),
              SizedBox(height: heightsize * 0.05)
            ],
          ),
        ))
      ])),
    );
  }

  Widget confirmBox(widthsize, heightsize) => Container(
        padding: EdgeInsets.all(widthsize * 0.06),
        width: widthsize * 0.8,
        height: heightsize * 0.22,
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(idname, style: mystyleText(heightsize, 0.025, kBlack, true)),
              Text("User ID $idAccount",
                  style: mystyleText(heightsize, 0.02, kGray4A, false)),
              Icon(
                Icons.arrow_downward_sharp,
                size: heightsize * 0.04,
              ),
              Text(widget.payee,
                  style: mystyleText(heightsize, 0.025, kBlack, true)),
              Text("User ID ${widget.idpayee}",
                  style: mystyleText(heightsize, 0.02, kGray4A, false))
            ]),
      );

  Widget confirmMoney(widthsize, heightsize) => Container(
        padding:
            EdgeInsets.only(left: widthsize * 0.05, right: widthsize * 0.05),
        width: widthsize * 0.8,
        height: heightsize * 0.07,
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
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("จำนวนพอยท์",
                  style: mystyleText(heightsize, 0.025, kGray4A, true)),
              Text("${widget.amount} พอยท์",
                  style: mystyleText(heightsize, 0.025, kGray4A, true))
            ]),
      );

  Widget confirmPageButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.7,
        height: heightsize * 0.055,
        child: ElevatedButton(
          onPressed: btnconfirmPage,
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
                fontSize: heightsize * 0.03),
          ),
        ),
      );

  Widget cancelPageButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.7,
        height: heightsize * 0.055,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
              backgroundColor: kGray4A,
              shape: const StadiumBorder(),
              elevation: 5,
              shadowColor: Colors.grey),
          child: Text(
            "ยกเลิก",
            style: TextStyle(
                color: kYellow,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.03),
          ),
        ),
      );

  void btnconfirmPage() {
    TranferService()
        .apiTranfer(widget.idpayee, widget.amount, token)
        .then((value) => {
              if (value != null)
                {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReceiptPage(
                              idAccount: idAccount,
                              idname: idname,
                              payee: widget.payee,
                              idpayee: widget.idpayee,
                              date: value.date,
                              point: value.point,
                              balance: value.balance,
                            )),
                  )
                }
              else
                {showAlertBox(context, 'แจ้งเตือน', 'เกิดข้อผิดพลาดในการโอน')}
            });

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => const ReceiptPage(idAccount: "", message: "", state: "", payee: "", date: "", point: 300, balance: 300)));
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => const ReceiptPage()));
  }
}
