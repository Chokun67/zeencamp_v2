import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';

class DetailTranfer extends StatelessWidget {
  const DetailTranfer(
      {Key? key,
      required this.idAccount,
      required this.idname,
      required this.state,
      required this.payee,
      required this.payeename,
      required this.date,
      required this.point,
      required this.balance})
      : super(key: key);
  final String idAccount;
  final String idname;
  final String state;
  final String payee;
  final String payeename;
  final String date;
  final int point;
  final int balance;

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Mystlye().buildBackground(
            widthsize, heightsize, context, "ใบเสร็จ", true, 0.22),
        Padding(
          padding: EdgeInsets.all(widthsize * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: heightsize * 0.13),
              boxPoint(widthsize, heightsize),
              getOrGive(widthsize, heightsize),
              detailTrandfer(widthsize, heightsize)
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
              Text(NumberFormat("#,##0").format(point),
                  style: mystyleText(heightsize, 0.03, kGray4A, true))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("ยอดคงเหลือ",
                  style: mystyleText(heightsize, 0.03, kGray4A, true)),
              Text(NumberFormat("#,##0").format(balance),
                  style: mystyleText(heightsize, 0.03, kGray4A, true))
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
            Text(date.toString(),
                style: mystyleText(heightsize, 0.023, kBlack, false)),
            SizedBox(height: heightsize * 0.01),
            Text(isDeposit(state) ? "รับพอยท์" : "โอนพอยท์",
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(widthsize * 0.04),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("จากบัญชี",
                        style: mystyleText(heightsize, 0.025, kBlack, false)),
                    SizedBox(
                      width: widthsize * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(idname,
                              style:
                                  mystyleText(heightsize, 0.025, kBlack, true)),
                          Text("USER ID $idAccount",
                              style:
                                  mystyleText(heightsize, 0.02, kBlack, false)),
                        ],
                      ),
                    )
                  ]),
            ),
            Container(
              padding: EdgeInsets.all(widthsize * 0.04),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ไปยัง",
                      style: mystyleText(heightsize, 0.025, kBlack, false),
                    ),
                    SizedBox(
                      width: widthsize * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(payeename,
                              style:
                                  mystyleText(heightsize, 0.025, kBlack, true)),
                          Text("USER ID $payee",
                              style:
                                  mystyleText(heightsize, 0.02, kBlack, false)),
                        ],
                      ),
                    )
                  ]),
            ),
            Container(
              width: widthsize * 0.78,
              margin: EdgeInsets.only(
                  top: widthsize * 0.04, bottom: widthsize * 0.04),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(widthsize * 0.04),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("จำนวนPoint",
                        style: mystyleText(heightsize, 0.03, kBlack, false)),
                    Text(
                      "${NumberFormat("#,##0").format(point.abs())} พอยท์",
                      style: mystyleText(heightsize, 0.03, kBlack, false),
                    )
                  ]),
            )
          ],
        ),
      );

  bool isDeposit(String state) {
    return state == "deposit";
  }
}
