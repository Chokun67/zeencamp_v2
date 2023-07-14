import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zeencamp_v2/application/shopService/shopservice.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';
import 'package:zeencamp_v2/domain/dmstore/getpayment.dart';
import '../../background.dart/background.dart';
import '../application/accountService/accountservice.dart';
import '../background.dart/securestorage.dart';

class BuyPoint extends StatefulWidget {
  const BuyPoint({super.key});
  @override
  State<BuyPoint> createState() => _BuyPointState();
}

class _BuyPointState extends State<BuyPoint> {
  var pointid = 0;
  var token = "";
  var idname = "";
  var idAccount = "";
  List<bool> isCheckedList = [];
  List<TextEditingController> textControllers = [];
  List<PaymentList?> paymentlist = [];

  @override
  void initState() {
    super.initState();
    getData().then((_) {
      AccountService().apigetpoint(token).then((value) => setState(() {
            pointid = value.point;
            idAccount = value.id;
            idname = value.name;
          }));
      StoresService().getPaymentList(token).then((value) {
        setState(() {
          setState(() {
            paymentlist = value;
          });
        });
        textControllers = List.generate(
          value.length,
          (index) => TextEditingController(),
        );
        isCheckedList = List.generate(value.length, (index) => false);
      });
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
            widthsize,
            heightsize - MediaQuery.of(context).padding.vertical,
            context,
            "ซื้อพอยท์",
            true,
            0.2),
        Container(
          width: widthsize,
          padding: EdgeInsets.all(widthsize * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: heightsize * 0.2),
              Text("MyPoints:",
                  style: mystyleText(heightsize, 0.03, kGray4A, true)),
              Text(NumberFormat("#,##0").format(pointid)),
              listMenu(widthsize, heightsize)
            ],
          ),
        ),
      ])),
    );
  }

  Widget listMenu(widthsize, heightsize) {
    return Padding(
        padding: EdgeInsets.all(widthsize * 0.03),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              padding: EdgeInsets.only(top: heightsize * 0.1),
              height: heightsize * 0.6,
              child: Column(children: [
                ListView.builder(
                    physics: const ScrollPhysics(parent: null),
                    shrinkWrap: true,
                    itemCount: paymentlist.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding:
                              EdgeInsets.only(bottom: heightsize * 0.01),
                          child: Row(children: [
                            Checkbox(
                              value: isCheckedList[index], // สถานะเช็คบล็อก
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckedList[index] = value ??
                                      false; // อัปเดตสถานะเช็คบล็อก
                                  textControllers[index].text = "";
                                });
                              },
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: widthsize * 0.02),
                              width: widthsize * 0.25,
                              height: heightsize * 0.1,
                              color: isCheckedList[index]
                                  ? Colors.green
                                  : null, // สีของคอนเทนเนอร์
                              child: Center(
                                child: Text(
                                  paymentlist[index]!.point,
                                  style: TextStyle(
                                    fontSize: heightsize * 0.02,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: widthsize * 0.02),
                              width: widthsize * 0.25,
                              height: heightsize * 0.1,
                              child: Center(
                                child: Text(
                                  paymentlist[index]!.price,
                                  style: TextStyle(
                                    fontSize: heightsize * 0.02,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: widthsize * 0.1,
                              height: heightsize * 0.03,
                              child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // จำกัดให้เป็นตัวเลขเท่านั้น
                                  ],
                                  readOnly: !isCheckedList[index],
                                  decoration: const InputDecoration(
                                    hintText: '',
                                  ),
                                  controller: textControllers[
                                      index] // ตรวจสอบขนาดของ textControllers
                                  ),
                            )
                          ]));
                    }),
              ]))
        ]));
  }
}
