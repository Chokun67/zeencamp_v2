import 'package:flutter/material.dart';
import 'package:zeencamp_v2/user/aboutshop/shopdetail.dart';

import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';

class ShopType extends StatefulWidget {
  const ShopType({super.key});

  @override
  State<ShopType> createState() => _ShopTypeState();
}

class _ShopTypeState extends State<ShopType> {
  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Mystlye()
            .buildBackground(widthsize, heightsize, context, "", true, 0.3),
        Padding(
          padding: EdgeInsets.all(widthsize * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightsize * 0.23),
              beta(heightsize, widthsize, context),
              adviseShop(widthsize, heightsize),
              adviseShop(widthsize, heightsize),
              adviseShop(widthsize, heightsize),
            ],
          ),
        ),
      ])),
    );
  }

  Widget beta(
          double heightsize, double widthsize, BuildContext context) =>
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

  Widget adviseShop(widthsize, heightsize) => Container(
        padding: EdgeInsets.only(left: widthsize*0.03),
        height: heightsize * 0.15,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: heightsize * 0.14,
                width: widthsize * 0.38,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(15))
                )
              ),
              SizedBox(width: widthsize * 0.05),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                height: heightsize * 0.14,
                width: widthsize * 0.38
              ),
              SizedBox(width: widthsize * 0.05),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                height: heightsize * 0.14,
                width: widthsize * 0.38
              )
            ],
          ),
        ),
      );
}
