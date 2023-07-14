import 'package:flutter/material.dart';
import 'package:zeencamp_v2/user/aboutshop/searchshop.dart';
import 'package:zeencamp_v2/user/aboutshop/shopdetail.dart';

import '../../application/accountService/accountservice.dart';
import '../../application/shopService/shopservice.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';
import '../../domain/dmstore/allstore.dart';

class ShopType extends StatefulWidget {
  const ShopType({super.key});

  @override
  State<ShopType> createState() => _ShopTypeState();
}

class _ShopTypeState extends State<ShopType> {
  final String ip = AccountService().ipAddress;
  List<Allstore> stores = [];
  List<Allstore> stores0 = [];
  List<Allstore> stores1 = [];
  List<Allstore> stores2 = [];
  List<Allstore> stores3 = [];
  var token = "";
  @override
  initState() {
    super.initState();
    fetchData();
    // token = context.read<AppData>().token;
    // List<Allstore> stores = await getStores(token);
  }

  void fetchData() async {
    token = await SecureStorage().read("token") as String;
    List<Allstore> fetchedStores1 =
        await StoresService().getmenucategory(token, 1);
    List<Allstore> fetchedStores2 =
        await StoresService().getmenucategory(token, 2);
    List<Allstore> fetchedStores3 =
        await StoresService().getmenucategory(token, 3);
    late List<Allstore> fetchedStores;
    fetchedStores = await StoresService().getStores(token);
    setState(() {
      stores0 = fetchedStores;
      stores1 = fetchedStores1;
      stores2 = fetchedStores2;
      stores3 = fetchedStores3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kWhiteF32,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(children: [
          Mystlye().buildBackground(
              widthsize,
              heightsize - MediaQuery.of(context).padding.vertical,
              context,
              "ร้านนค้า",
              true,
              0.2),
          Padding(
            padding: EdgeInsets.all(widthsize * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heightsize * 0.2),
                stores3.isNotEmpty
                    ? aTypeShop3(heightsize, widthsize, context, 3, "อาหารคาว")
                    : Container(),
                adviseShop(widthsize, heightsize, 3),
                stores2.isNotEmpty
                    ? aTypeShop3(
                        heightsize, widthsize, context, 1, "เครื่องดื่ม")
                    : Container(),
                adviseShop(widthsize, heightsize, 1),
                stores1.isNotEmpty
                    ? aTypeShop3(heightsize, widthsize, context, 2, "ของหวาน")
                    : Container(),
                adviseShop(widthsize, heightsize, 2),
                stores0.isNotEmpty
                    ? aTypeShop3(
                        heightsize, widthsize, context, 0, "ร้านค้าทั้งหมด")
                    : Container(),
                adviseShop(widthsize, heightsize, 0),
              ],
            ),
          ),
        ]),
      )),
    );
  }

  Widget adviseShop(widthsize, heightsize, int type) {
    List<Allstore> stores;
    if (type == 1) {
      stores = stores1.isNotEmpty ? stores1 : [];
    } else if (type == 2) {
      stores = stores2.isNotEmpty ? stores2 : [];
    } else if (type == 3) {
      stores = stores3.isNotEmpty ? stores3 : [];
    } else if (type == 0) {
      stores = stores0.isNotEmpty ? stores0 : [];
    } else {
      stores = [];
    }
    return stores.isNotEmpty
        ? Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: widthsize * 0.03),
                height: heightsize * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stores.length,
                  physics: const ScrollPhysics(parent: null),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Allstore store = stores[
                        index]; // Access the item in stores using the index
                    return Padding(
                      padding: EdgeInsets.only(right: widthsize * 0.05),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopDetail(
                                idshop: store.id,
                                nameshop: store.name,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              height: heightsize * 0.14,
                              width: widthsize * 0.38,
                              child: store.storePicture.isNotEmpty
                                  ? Image.network(
                                      'http://$ip:17003/api/v1/util/image/${store.storePicture}',
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                            ),
                            Text(
                              "ร้าน ${store.name}",
                              style: TextStyle(
                                color: const Color(0xFFEB3F3F),
                                fontSize: heightsize * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "id ${store.id}",
                              style: TextStyle(
                                color: const Color(0xFFEB3F3F),
                                fontSize: heightsize * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Container();
  }

  Widget aTypeShop3(widthsize, heightsize, context, number, title) {
    return Container(
      padding: EdgeInsets.only(left: widthsize * 0.03),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: mystyleText(heightsize, 0.05, kBlack, true)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchShop(category: number)));
                  },
                  icon: const Icon(Icons.arrow_circle_right),
                  iconSize: heightsize * 0.07)
            ],
          )
        ],
      ),
    );
  }

  Widget adviseShop2(widthsize, heightsize, type) {
    return Container(
      padding: EdgeInsets.only(left: widthsize * 0.03),
      height: heightsize * 0.19,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stores2.length, // จำนวนรายการที่ต้องการให้แสดง
        physics: const ScrollPhysics(parent: null),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: widthsize * 0.05),
            child: InkWell(
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShopDetail(
                              idshop: stores2[index].id,
                              nameshop: stores2[index].name,
                            )))
              },
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    height: heightsize * 0.14,
                    width: widthsize * 0.38,
                  ),
                  Text(
                    "ร้าน ${stores2[index].name}",
                    style: TextStyle(
                        color: const Color(0xFFEB3F3F),
                        fontSize: heightsize * 0.015,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "id ${stores2[index].id}",
                    style: TextStyle(
                        color: const Color(0xFFEB3F3F),
                        fontSize: heightsize * 0.015,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
