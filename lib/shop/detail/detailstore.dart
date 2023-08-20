import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeencamp_v2/shop/detail/addmenu.dart';
import 'package:zeencamp_v2/shop/detail/detailmenu.dart';
import 'package:zeencamp_v2/shop/map/select.dart';

import '../../../background.dart/appstyle.dart';
import '../../../background.dart/background.dart';
import '../../application/accountService/accountservice.dart';
import '../../application/shopService/shopservice.dart';
import '../../background.dart/securestorage.dart';
import '../../domain/dmstore/detailshopdm.dart';
import 'editimage.dart';

class DetailStore extends StatefulWidget {
  const DetailStore({Key? key, required this.idshop, required this.nameshop})
      : super(key: key);
  final String idshop;
  final String nameshop;

  @override
  State<DetailStore> createState() => _DetailStoreState();
}

class _DetailStoreState extends State<DetailStore> {
  bool isSwitched = false;
  final String ip = AccountService().ipAddress;
  var token = "";
  var idAccount = "";
  var idname = "";
  @override
  void initState() {
    super.initState();
    getData().then((_) {
      AccountService().apigetpoint(token).then((value) => setState(() {
            idAccount = value.id;
            idname = value.name;
          }));
    });
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: FutureBuilder(
                  future: getData().then((value) =>
                      StoresService().fetchStoreData(token, widget.idshop)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final customerData = snapshot.data!;
                      return Stack(children: [
                        Mystlye().buildBackground(
                            widthsize, heightsize, context, "", false, 0.3),
                        SizedBox(
                          width: widthsize,
                          height: heightsize * 0.35,
                          child: customerData.storePicture.isNotEmpty
                              ? Image.network(
                                  'http://$ip:17003/api/v1/util/image/${customerData.storePicture}',
                                  fit: BoxFit.cover,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ไม่มีรูปภาพ",
                                        style: TextStyle(
                                            fontSize: heightsize * 0.05,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: heightsize * 0.1)
                                  ],
                                ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: widthsize,
                              height: heightsize * 0.3,
                            ),
                            Container(
                              width: widthsize,
                              height: heightsize * 0.2,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                                color: kWhiteF32,
                              ),
                            )
                          ],
                        ), //มาจากทำขอบขาว
                        Padding(
                          padding: EdgeInsets.all(widthsize * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: heightsize * 0.23),
                              Center(child: boxPoint(widthsize, heightsize)),
                              SizedBox(height: heightsize * 0.05),
                              Column(children: [
                                detailMenu2(widthsize, heightsize,
                                    customerData.menuStores)
                              ])
                            ],
                          ),
                        ),
                        Positioned(
                            top: widthsize * 0.05,
                            right: widthsize * 0.03,
                            child: Column(children: [
                              SizedBox(
                                width: widthsize * 0.25,
                                height: heightsize * 0.04,
                                child: Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                    });
                                  },
                                ),
                              ),
                              isSwitched
                                  ? btnedit(heightsize, widthsize, context)
                                  : Container(),
                              SizedBox(height: heightsize * 0.01),
                              isSwitched
                                  ? btnaddmenu(heightsize, widthsize, context)
                                  : Container(),
                              SizedBox(height: heightsize * 0.01),
                              isSwitched
                                  ? btnlocation(heightsize, widthsize, context)
                                  : Container(),
                            ])),
                        Positioned(
                            top: widthsize * 0.065,
                            left: widthsize * 0.065,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios),
                              iconSize: heightsize * 0.04,
                              color: kDarkYellow,
                            ))
                      ]);
                    }
                  }))),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " $idname",
              style: TextStyle(
                  color: kGray4A,
                  fontSize: heightsize * 0.026,
                  fontWeight: FontWeight.bold),
            ),
            Container(
                width: widthsize * 0.7,
                height: heightsize * 0.01,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: kGray75,
                  width: 2.0,
                )))),
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.location_pin),
                    iconSize: heightsize * 0.05,
                    onPressed: () {
                      openGoogleMapNavigation(1, 100.5018);
                    },
                  ),
                  Text(
                    "เปิดใช้งาน Google Map ",
                    style: mystyleText(heightsize, 0.02, kGray4A, false),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  // Widget detailMenu(widthsize, heightsize, yourData) => SingleChildScrollView(
  //       child: Column(children: [
  //         GridView.builder(
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             childAspectRatio: 1,
  //           ),
  //           physics: const ScrollPhysics(parent: null),
  //           shrinkWrap: true,
  //           itemCount: yourData.length, // จำนวนรายการข้อมูลใน GridView
  //           itemBuilder: (BuildContext context, int index) {
  //             return Container(
  //               margin:
  //                   const EdgeInsets.all(8.0), // ระยะห่างรอบด้านของแต่ละรายการ
  //               child: Column(
  //                 children: [
  //                   Container(
  //                       height: heightsize * 0.14,
  //                       width: widthsize * 0.44,
  //                       color: Colors.green), // รูปภาพ
  //                   Text(
  //                     yourData[index]['line1'], // ข้อความบรรทัดที่ 1
  //                   ),
  //                   Text(
  //                     yourData[index]['line2'], // ข้อความบรรทัดที่ 2
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ]),
  //     );

  Widget detailMenu2(widthsize, heightsize, List<Store>? menuStores) =>
      SingleChildScrollView(
        child: Column(children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            physics: const ScrollPhysics(parent: null),
            shrinkWrap: true,
            itemCount: menuStores?.length ?? 0, // จำนวนรายการข้อมูลใน GridView
            itemBuilder: (BuildContext context, int index) {
              final menuStore = menuStores?[index];
              return Container(
                margin:
                    const EdgeInsets.all(8.0), // ระยะห่างรอบด้านของแต่ละรายการ
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailMenu(
                                      image: menuStore!.pictures,
                                      name: menuStore.nameMenu,
                                      exchange: menuStore.exchange.toString(),
                                      price: menuStore.price.toString(),
                                      receive: menuStore.receive.toString())),
                            );
                          },
                          child: Container(
                              height: heightsize * 0.14,
                              width: widthsize * 0.44,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.green,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  'http://$ip:17003/api/v1/util/image/${menuStore?.pictures}',
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Positioned(
                            right: 0,
                            child: isSwitched
                                ? btndelete(
                                    heightsize, widthsize, menuStore!.id)
                                : Container())
                      ],
                    ), // รูปภาพ
                    Text(
                      menuStore!.nameMenu, // ข้อความบรรทัดที่ 1
                    ),
                    Text(
                      "${menuStore.price} บาท", // ข้อความบรรทัดที่ 2
                    ),
                  ],
                ),
              );
            },
          ),
        ]),
      );

  // Widget detailPicture(double widthsize, double heightsize, String pictures,
  //     String idMenu, int price) {
  //   return InkWell(
  //     onTap: () {},
  //     child: Container(
  //       width: widthsize * 0.3,
  //       decoration: BoxDecoration(
  //         borderRadius: const BorderRadius.all(Radius.circular(15)),
  //         border: Border.all(color: const Color(0xFF000000), width: 4),
  //       ),
  //       child: Image.network(
  //         'http://$ip:17003/api/v1/image/$pictures',
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }

  // Widget detailPrice(widthsize, heightsize, name, price, receive, exchange) =>
  //     Container(
  //       padding: EdgeInsets.all(widthsize * 0.02),
  //       height: heightsize * 0.2,
  //       width: widthsize * 0.34,
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFFFF09F),
  //         borderRadius: const BorderRadius.all(Radius.circular(15)),
  //         border: Border.all(color: const Color(0xFF000000), width: 2),
  //       ),
  //       child: Text(
  //         "$name\nราคา $price บาท\nซื้อแล้วได้รับ $receive P\nใช้ $exchange เพื่อรับฟรี",
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: heightsize * 0.02,
  //         ),
  //       ),
  //     );

  Widget btnedit(heightsize, widthsize, context) => SizedBox(
        width: widthsize * 0.25,
        height: heightsize * 0.04,
        child: ElevatedButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditImage()));
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A4A4A),
              side: const BorderSide(
                color: Color(0xFFAD6800),
                width: 1,
              ),
              shape: const StadiumBorder()),
          child: Text(
            "แก้ไขรูป",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.02),
          ),
        ),
      );

  Widget btnlocation(heightsize, widthsize, context) => SizedBox(
        width: widthsize * 0.25,
        height: heightsize * 0.04,
        child: ElevatedButton(
          onPressed: () async {
            await getgeoloca().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyMap(
                            geolocation:
                                "${value.latitude},${value.longitude}")))
                .then((value) => {
                      if (value != "")
                        {
                          StoresService().updatelocation(token, "1.1,1.1"),
                          print(value)
                        }
                    }));
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A4A4A),
              side: const BorderSide(
                color: Color(0xFFAD6800),
                width: 1,
              ),
              shape: const StadiumBorder()),
          child: Text(
            "แก้ไขที่อยู่",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.02),
          ),
        ),
      );

  Widget btnaddmenu(heightsize, widthsize, context) => SizedBox(
        width: widthsize * 0.25,
        height: heightsize * 0.04,
        child: ElevatedButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddMenuItem()));
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A4A4A),
              side: const BorderSide(
                color: Color(0xFFAD6800),
                width: 1,
              ),
              shape: const StadiumBorder()),
          child: Text(
            "เพิ่มเมนู",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.02),
          ),
        ),
      );

  Widget btndelete(heightsize, widthsize, idMenu) => InkWell(
      onTap: () async {
        await StoresService().deleteMenu(token, idMenu);
        setState(() {});
      },
      child: Icon(Icons.delete, size: widthsize * 0.08, color: Colors.red));

  void openGoogleMapNavigation(double lat, double lon) async {
    String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not launch $googleMapUrl';
    }
  }
}
