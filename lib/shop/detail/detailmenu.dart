import 'package:flutter/material.dart';
import 'package:zeencamp_v2/application/accountService/accountservice.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';

// ignore: must_be_immutable
class DetailMenu extends StatelessWidget {
  DetailMenu({Key? key, required this.image, required this.name})
      : super(key: key);
  String image;
  String name;
  final String ip = AccountService().ipAddress;

  var token = "";

  var iduser = "";

  var idAccount = "";

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
        Mystlye()
            .buildBackground(widthsize, heightsize, context, "", false, 0.3),
        SizedBox(
          width: widthsize,
          height: heightsize * 0.35,
          child: image.isNotEmpty
              ? Image.network(
                  'http://$ip:17003/api/v1/util/image/$image',
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
              SizedBox(height: heightsize * 0.05),
              Column(children: [
                // detailMenu2(widthsize, heightsize,
                //     customerData.menuStores)
              ])
            ],
          ),
        ),
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
      ])),
    ));
  }
}
