import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeencamp_v2/user/tranfer/confirm.dart';

import '../../application/accountService/accountservice.dart';
import '../../application/tranferService/tranferservice.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';
import '../aboutqr/qrscaner.dart';

class TranferPage extends StatefulWidget {
  const TranferPage({super.key});

  @override
  State<TranferPage> createState() => _TranferPageState();
}

class _TranferPageState extends State<TranferPage> {
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
              widthsize, heightsize, context, "โอนพอยท์", true, 0.22),
          Padding(
            padding: EdgeInsets.all(widthsize * 0.03),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: heightsize * 0.15),
                  Center(child: showPoint(widthsize, heightsize)),
                  SizedBox(height: heightsize * 0.04),
                  textFieldID(heightsize),
                  textFieldPoint(heightsize),
                  SizedBox(height: heightsize * 0.22),
                  tranferPageButton(heightsize, widthsize, context)
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

  Widget textFieldID(heightsize) => SizedBox(
        height: heightsize * 0.1,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกค่า';
            } else if (value.length != 9 ||
                !RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'รูปแบบข้อความไม่ถูกต้อง';
            } else if (value == idAccount) {
              return 'ไม่สามารถส่งพ้อยไปยังไอดีต้นทางได้';
            }
            return null;
          },
          controller: _ctrlID,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: heightsize * 0.02),
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              contentPadding:
                  EdgeInsets.symmetric(vertical: heightsize * 0.008),
              fillColor: kWhite,
              filled: true,
              hintText: "ไอดีผู้ใช้",
              prefixIcon: const Icon(Icons.person_2_outlined),
              suffixIcon: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QrScaner()));
                  },
                  child: const Icon(Icons.qr_code_scanner))),
        ),
      );

  Widget textFieldPoint(heightsize) => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกค่า';
          } else if (int.tryParse(value) == null || int.parse(value) <= 0) {
            return 'รูปแบบข้อมูลไม่ถูกต้อง';
          } else if (int.parse(value) > pointid) {
            return 'จำนวนPointไม่เพียงพอ';
          }
          return null;
        },
        controller: _ctrlPoint,
        style: TextStyle(fontSize: heightsize * 0.02),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
          fillColor: kWhite,
          filled: true,
          hintText: "จำนวน",
          prefixIcon: const Icon(Icons.money),
        ),
      );

  Widget tranferPageButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.7,
        height: heightsize * 0.055,
        child: ElevatedButton(
          onPressed: btntranferPage,
          style: ElevatedButton.styleFrom(
              backgroundColor: kYellow, shape: const StadiumBorder()),
          child: Text(
            "ถัดไป",
            style: TextStyle(
                color: kBlack,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.035),
          ),
        ),
      );

  void btntranferPage() {
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
