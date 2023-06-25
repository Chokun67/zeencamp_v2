import 'package:flutter/material.dart';

import 'package:zeencamp_v2/user/aboutshop/shopdetail.dart';

import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../application/accountService/accountservice.dart';
import '../application/shopService/shopservice.dart';
import '../background.dart/securestorage.dart';
import '../domain/dmstore/detailshopdm.dart';

class CreateBill extends StatefulWidget {
  const CreateBill({super.key});

  @override
  State<CreateBill> createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> {
  final String ip = AccountService().ipAddress;
  List<Store> storemenu = [];
  List<bool> isCheckedList = [];
  List<TextEditingController> textControllers = [];
  var token = "";
  var idAccount = "";

  @override
  void initState() {
    super.initState();
    // token = context.read<AppData>().token;
    getData().then((_) {
      fetchData().then((_) {
        textControllers = List.generate(
          storemenu.length,
          (index) => TextEditingController(),
        );
        isCheckedList = List.generate(storemenu.length, (index) => false);
      });
    });
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  Future<void> fetchData() async {
    List<Store> fetchedStores =
        await StoresService().fetchStoreData2(token, idAccount);
    setState(() {
      storemenu = fetchedStores;
    });
  }

  @override
  void dispose() {
    // คืนทรัพยากรของ Controllers เมื่อไม่ใช้งาน
    for (final controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Stack(children: [
        Mystlye().buildBackground(
            widthsize,
            heightsize - MediaQuery.of(context).padding.vertical,
            context,
            "สร้างบิล",
            true,
            0.2),
        listMenu(widthsize, heightsize),
        Positioned(
            bottom: 0,
            child: Container(
              width: widthsize,
              height: heightsize * 0.05,
              color: Colors.amberAccent,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                textControllers.isNotEmpty
                    ? Text(textControllers[1].text)
                    : const Text(''),
                ElevatedButton(onPressed: (){}, child: Text("สร้าง QR"))
              ]), // แก้ไขด้วยการตรวจสอบขนาดของ textControllers),
            ))
      ]))),
    );
  }

  Widget listMenu(widthsize, heightsize) {
    return Padding(
      padding: EdgeInsets.all(widthsize * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: heightsize * 0.1),
          Container(
            padding: EdgeInsets.only(top: heightsize * 0.1),
            height: heightsize * 0.8,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: widthsize * 0.02,
                      right: widthsize * 0.05,
                      bottom: heightsize * 0.01),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("เลือกรายการ"), Text("จำนวน")],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: storemenu.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: heightsize * 0.01),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isCheckedList[index], // สถานะเช็คบล็อก
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckedList[index] =
                                      value ?? false; // อัปเดตสถานะเช็คบล็อก
                                });
                              },
                            ),
                            Container(
                              width: widthsize * 0.2,
                              height: heightsize * 0.1,
                              color: isCheckedList[index]
                                  ? Colors.green
                                  : null, // สีของคอนเทนเนอร์
                              child: Center(
                                child: Image.network(
                                  'http://$ip:17003/api/v1/util/image/${storemenu[index].pictures}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: widthsize * 0.25,
                              height: heightsize * 0.1,
                              color: isCheckedList[index]
                                  ? Colors.green
                                  : null, // สีของคอนเทนเนอร์
                              child: Center(
                                child: Text(
                                  storemenu[index].nameMenu,
                                  style: const TextStyle(
                                    // สีของข้อความเมื่อเช็คบล็อกปิด
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // โค้ดที่จะทำเมื่อกดปุ่มเล็กที่เรียงลำดับ
                              },
                              icon: Icon(Icons.arrow_downward,
                                  size: heightsize * 0.03),
                            ),
                            SizedBox(
                              width: widthsize * 0.1,
                              height: heightsize * 0.03,
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: '',
                                ),
                                controller: index < textControllers.length
                                    ? textControllers[index]
                                    : null, // ตรวจสอบขนาดของ textControllers
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // โค้ดที่จะทำเมื่อกดปุ่มเล็กที่เรียงลำดับ
                              },
                              icon: Icon(Icons.arrow_upward,
                                  size: heightsize * 0.03),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget beta(double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.7,
        height: heightsize * 0.055,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ShopDetail()));
          },
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
                fontSize: heightsize * 0.035),
          ),
        ),
      );

  // Widget listMenu(widthsize, heightsize, List<Store>? menuStores) {
  //   return Padding(
  //     padding: EdgeInsets.all(widthsize * 0.03),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: heightsize * 0.1),
  //         Container(
  //           padding: EdgeInsets.only(top: heightsize * 0.1),
  //           height: heightsize * 0.8,
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     left: widthsize * 0.02, right: widthsize * 0.05),
  //                 child: const Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [Text("เลือกรายการ"), Text("จำนวน")],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: menuStores?.length,
  //                   itemBuilder: (context, index) {
  //                     final menuStore = menuStores?[index];
  //                     return Row(
  //                       children: [
  //                         Checkbox(
  //                           value: isCheckedList[index], // สถานะเช็คบล็อก
  //                           onChanged: (bool? value) {
  //                             setState(() {
  //                               isCheckedList[index] =
  //                                   value ?? false; // อัปเดตสถานะเช็คบล็อก
  //                             });
  //                           },
  //                         ),
  //                         Container(
  //                           width: widthsize * 0.3,
  //                           height: heightsize * 0.1,
  //                           color: isCheckedList[index]
  //                               ? Colors.green
  //                               : null, // สีของคอนเทนเนอร์
  //                           child: Center(
  //                             child: Text(
  //                               "${menuStore?.nameMenu}",
  //                               style: TextStyle(
  //                                 color: isCheckedList[index]
  //                                     ? Colors
  //                                         .white // สีของข้อความเมื่อเช็คบล็อกเปิด
  //                                     : Colors
  //                                         .black, // สีของข้อความเมื่อเช็คบล็อกปิด
  //                                 fontSize: 16,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         IconButton(
  //                           onPressed: () {
  //                             // โค้ดที่จะทำเมื่อกดปุ่มเล็กที่เรียงลำดับ
  //                           },
  //                           icon: Icon(Icons.arrow_upward,
  //                               size: heightsize * 0.03),
  //                         ),
  //                         SizedBox(
  //                           width: widthsize * 0.15,
  //                           height: heightsize * 0.03,
  //                           child: TextField(
  //                               decoration: const InputDecoration(
  //                                 hintText: '',
  //                               ),
  //                               controller: textControllers[index]),
  //                         ),
  //                         IconButton(
  //                           onPressed: () {
  //                             // โค้ดที่จะทำเมื่อกดปุ่มเล็กที่เรียงลำดับ
  //                           },
  //                           icon: Icon(Icons.arrow_downward,
  //                               size: heightsize * 0.03),
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
