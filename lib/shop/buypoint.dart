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
  bool test = false;
  bool isExpanded = false; // สถานะของ ExpansionTile
  List<ExpansionTileController> expanController = [];
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
        expanController =
            List.generate(value.length, (index) => ExpansionTileController());
      });
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
              widthsize, heightsize, context, "ซื้อพอยท์", true, 0.2),
          Container(
            width: widthsize,
            padding: EdgeInsets.all(widthsize * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: heightsize * 0.2),
                Text("MyPoints:",
                    style: mystyleText(heightsize, 0.03, kGray4A, true)),
                Text(
                  NumberFormat("#,##0").format(pointid),
                  style: mystyleText(heightsize, 0.05, kGray4A, true),
                ),
                listMenu(widthsize, heightsize)
              ],
            ),
          ),
          Positioned(bottom: 0, child: buttonBuyPoint(widthsize, heightsize))
        ]),
      )),
    );
  }



  Widget listMenu(widthsize, heightsize) {
    return Padding(
        padding: EdgeInsets.all(widthsize * 0.01),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            ListView.builder(
                physics: const ScrollPhysics(parent: null),
                shrinkWrap: true,
                itemCount: paymentlist.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: heightsize * 0.01),
                      child: ExpansionTile(
                          controller: expanController[index],
                          leading: Checkbox(
                            value: isCheckedList[index], // สถานะเช็คบล็อก
                            onChanged: (bool? value) {
                              setState(() {
                                for (int i = 0; i < isCheckedList.length; i++) {
                                  if (i == index) {
                                    // ถ้าเป็น Checkbox ที่กำลังเปลี่ยนสถานะ
                                    isCheckedList[i] = value ??
                                        false; // เปลี่ยนสถานะของ Checkbox
                                    if (isCheckedList[i]) {
                                      // ถ้าเลือก Checkbox นี้ใหม่
                                      expanController[i]
                                          .expand(); // เปิด ExpansionTile
                                    } else {
                                      expanController[i]
                                          .collapse(); // ปิด ExpansionTile
                                      textControllers[i].text = "";
                                    }
                                  } else {
                                    // ถ้าเป็น Checkbox ที่ไม่ได้กำลังเปลี่ยนสถานะ
                                    isCheckedList[i] =
                                        false; // ยกเลิกสถานะของ Checkbox ที่ไม่ได้เลือก
                                    expanController[i]
                                        .collapse(); // ปิด ExpansionTile
                                    textControllers[i].text = "";
                                  }
                                }
                              });
                            },
                          ),
                          trailing: Text(
                            "${NumberFormat("#,##0").format(paymentlist[index]!.price)} บาท",
                            style: TextStyle(
                              fontSize: heightsize * 0.025,
                            ),
                          ),
                          title: Text(
                            "${NumberFormat("#,##0").format(paymentlist[index]!.point)} พอยท์",
                            style: TextStyle(
                              fontSize: heightsize * 0.025,
                            ),
                          ),
                          children: isCheckedList[index]
                              ? [buildButtons(context, index, heightsize,widthsize)]
                              : []));
                }),
          ])
        ]));
  }

  Widget buildButtons(BuildContext context, index, heightsize,widthsize) => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "จำนวน : ",
                  style: mystyleText(heightsize, 0.025, kBlack, false),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.only(left: widthsize*0.02),
              height: heightsize * 0.04,
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // จำกัดให้เป็นตัวเลขเท่านั้น
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]?[0-9]$')),
                ],
                
                controller: textControllers[index],
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: widthsize * 0.02),
                  // fillColor: kGrayD9,
                  // filled: true,
                  hintText: "",
                ),
              ),
            ),
          )
        ],
      );
  double find() {
    double amount = 0;
    if (isCheckedList.every((element) => !element)) {
    } else {
      for (int i = 0; i < isCheckedList.length; i++) {
        if (isCheckedList[i]) {
          try {
            amount =
                double.parse(textControllers[i].text) * paymentlist[i]!.price;
          } catch (e) {
            return 0.0;
          }
        }
      }
    }
    return amount;
  }

  bool hasError = false;
  Widget buttonBuyPoint(widthsize, heightsize) => Container(
      padding: EdgeInsets.only(left: widthsize * 0.02, right: widthsize * 0.02),
      width: widthsize,
      height: heightsize * 0.08,
      color: kWhite,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        textControllers.isNotEmpty
            ? Text(
                "ราคารวม: ${find()}",
                style: mystyleText(heightsize, 0.025, kGray4A, false),
              )
            : const Text(''),
        SizedBox(
          width: widthsize*0.26,
          height: heightsize*0.06,
          child: ElevatedButton(
              onPressed: () {
                String idPayment = "";
                int amount = 0;
                if (isCheckedList.every((element) => !element)) {
                  showAlertBox(context, "แจ้งเตือน", "กรุณาเลือกรายการ");
                  hasError = true;
                } else {
                  for (int i = 0; i < isCheckedList.length; i++) {
                    if (isCheckedList[i]) {
                      try {
                        amount = int.parse(textControllers[i].text);
                        idPayment = paymentlist[i]!.id;
                        if (amount < 1) {
                          hasError = true;
                          break;
                        }
                      } catch (e) {
                        hasError = true;
                        showAlertBox(context, "test", "กรุณากรอกตัวเลข");
                        break;
                      }
                    }
                  }
                }
                if (!hasError) {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      String confirmationCode = '';
                      bool obscureText = true;
                      return AlertDialog(
                        title: const Text("ยืนยัน"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("กรุณากรอกรหัสเพื่อยืนยันการซื้อ"),
                            TextField(
                              onChanged: (value) {
                                confirmationCode = value;
                              },
                              obscureText: obscureText,
                              style: TextStyle(fontSize: heightsize * 0.02),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: heightsize * 0.008),
                                labelText: "รหัสผ่าน",
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            child: const Text('ยกเลิก'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('ตกลง'),
                            onPressed: () {
                              StoresService()
                                  .buyPaymentConfirm(
                                      token, idPayment, amount, confirmationCode)
                                  .then((value) => {
                                        if (value.code == 200 ||
                                            value.code == 500)
                                          {
                                            showAlertBox2(context, "แจ้งเตือน",
                                                "เรียบร้อย", heightsize),
                                          }
                                        else
                                          {Navigator.of(context).pop()}
                                      });
                            },
                          ),
                        ],
                      );
                    },
                  );
                  hasError = false;
                } else {
                  hasError = false;
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kYellow,
              ),
              child: Text(
                "ชำระเงิน",
                style: mystyleText(heightsize, 0.025, kGray4A, false),
              )),
        )
      ]));
}
