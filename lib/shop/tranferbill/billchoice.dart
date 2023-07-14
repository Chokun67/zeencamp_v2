import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeencamp_v2/shop/tranferbill/createbill.dart';
import 'package:zeencamp_v2/user/tranfer/confirm.dart';

import '../../../application/accountService/accountservice.dart';
import '../../../application/tranferService/tranferservice.dart';
import '../../../background.dart/appstyle.dart';
import '../../../background.dart/background.dart';
import '../../../background.dart/securestorage.dart';

class BillChoice extends StatefulWidget {
  const BillChoice({super.key});

  @override
  State<BillChoice> createState() => _BillChoiceState();
}

class _BillChoiceState extends State<BillChoice> {
  final _ctrlID = TextEditingController();
  final _ctrlPoint = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
    final heightsize = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(children: [
          Mystlye().buildBackground(
              widthsize, heightsize, context, "สร้างบิล", true, 0.22),
          Container(
            height: heightsize,
            padding: EdgeInsets.all(widthsize * 0.03),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: heightsize * 0.15),
                  Center(child: showPoint(widthsize, heightsize)),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          goReceive(widthsize, heightsize),
                          SizedBox(height: heightsize * 0.04),
                          goExchange(widthsize, heightsize),
                          SizedBox(height: heightsize * 0.1),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ]),
      )),
    );
  }

  Widget showPoint(widthsize, heightsize) => Container(
        padding: EdgeInsets.all(widthsize * 0.04),
        width: widthsize * 0.8,
        height: heightsize * 0.127,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: kWhite,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(idname,
                    style: mystyleText(heightsize, 0.022, kBlack, true)),
                Text("User ID $idAccount",
                    style: mystyleText(heightsize, 0.02, kGray4A, false))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(NumberFormat("#,##0").format(pointid),
                    style: mystyleText(heightsize, 0.035, kBlack, true)),
                Text("พอยท์",
                    style: mystyleText(heightsize, 0.02, kBlack, true)),
              ],
            )
          ],
        ),
      );

  Widget goReceive(widthsize, heightsize) => InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateBill(
                      isReceive: true,
                    ))),
        child: Container(
          padding: EdgeInsets.all(widthsize * 0.04),
          width: widthsize * 0.8,
          height: heightsize * 0.127,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: kWhite,
          ),
          child: Center(
              child: Text(
            "ให้พอยท์ลูกค้า",
            style: mystyleText(heightsize, 0.04, kGray4A, true),
          )),
        ),
      );

  Widget goExchange(widthsize, heightsize) => InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateBill(isReceive: false))),
        child: Container(
          padding: EdgeInsets.all(widthsize * 0.04),
          width: widthsize * 0.8,
          height: heightsize * 0.127,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: kWhite,
          ),
          child: Center(
              child: Text("รับพอยท์ลูกค้า",
                  style: mystyleText(heightsize, 0.04, kGray4A, true))),
        ),
      );

  void btnBillChoice() {
    if (_formKey.currentState!.validate()) {
      if (int.parse(_ctrlPoint.text) < pointid) {
        TranferService()
            .apiValidateTranfer(_ctrlID.text, token)
            .then((value) => {
                  if (value != null)
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmTranfer(
                                    payee: value.payee,
                                    idpayee: _ctrlID.text,
                                    amount: int.parse(_ctrlPoint.text),
                                  )))
                    }
                  else
                    {showAlertBox(context, 'แจ้งเตือน', 'ไม่มีไอดีนี้ในระบบ')},
                });
      } else {
        showAlertBox(context, 'แจ้งเตือน', 'จำนวนเงินไม่เพียงพอ');
      }
    }
  }
}
