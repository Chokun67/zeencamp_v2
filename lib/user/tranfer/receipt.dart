import 'package:flutter/material.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage(
      {Key? key,
      required this.idAccount,
      required this.idname,
      required this.payee,
      required this.idpayee,
      required this.date,
      required this.point,
      required this.balance})
      : super(key: key);
  final String idAccount;
   final String idname;
  final String payee;
  final String idpayee;
  final String date;
  final int point;
  final int balance;

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: heightsize,
            width: widthsize,
            color: kWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: heightsize * 0.07),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: kGrayD9,
),
                  height: heightsize * 0.63,
                  width: widthsize * 0.91,
                  child: Column(
                    children: [
                      SizedBox(height: heightsize * 0.02),
                      success(widthsize, heightsize),
                      SizedBox(height: heightsize * 0.02),
                      confirmBox(widthsize, heightsize),
                      SizedBox(height: heightsize * 0.04),
                      confirmMoney(widthsize, heightsize),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("ยอดคงเหลือ"),
                SizedBox(height: heightsize * 0.02),
                cancelPageButton(heightsize, widthsize, context),
                SizedBox(height: heightsize * 0.05)
              ],
            ),
          ))
        ],
      )),
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
              Text(idname,
                  style: mystyleText(heightsize, 0.025, kBlack, true)),
              Text("User ID $idAccount",
                  style: mystyleText(heightsize, 0.02, kGray4A, false)),
              Icon(
                Icons.arrow_downward_sharp,
                size: heightsize * 0.04,
              ),
              Text(payee,
                  style: mystyleText(heightsize, 0.025, kBlack, true)),
              Text("User ID $idpayee",
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
                  style: mystyleText(heightsize, 0.023, kGray4A, true)),
              Text("100 พอยท์",
                  style: mystyleText(heightsize, 0.023, kGray4A, true))
            ]),
      );

  Widget success(widthsize, heightsize) => Column(
        children: [
          Icon(Icons.check_circle_outline_outlined,
              size: widthsize * 0.2, color: kGreen),
          Text("โอนสำเร็จ", style: mystyleText(heightsize, 0.05, kGray4A, true))
        ],
      );

  Widget cancelPageButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.7,
        height: heightsize * 0.055,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
              backgroundColor: kYellow,
              shape: const StadiumBorder(),
              elevation: 5,
              shadowColor: Colors.grey),
          child: Text(
            "กลับสู่หน้าแรก",
            style: TextStyle(
                color: kGray4A,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.03),
          ),
        ),
      );
}
