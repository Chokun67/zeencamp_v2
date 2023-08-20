import 'package:flutter/material.dart';
import 'package:zeencamp_v2/user/aboutshop/searchshop.dart';
import 'package:zeencamp_v2/user/aboutshop/shopdetail.dart';

import '../../application/accountService/accountservice.dart';
import '../../application/shopService/shopservice.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';
import '../../domain/dmstore/allstore.dart';
import '../../shop/map/mapuser.dart';

class ShopType extends StatefulWidget {
  const ShopType({Key? key, required this.lat, required this.lon})
      : super(key: key);

  final double lat;
  final double lon;

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
              "ร้านค้า",
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
          Positioned(
              top: widthsize * 0.04,
              right: widthsize * 0.04,
              child: mapButton(heightsize, widthsize)),
        ]),
      )),
    );
  }

  double currentLat = 13.7563; // ละติจูดของตำแหน่งปัจจุบัน
  double currentLon = 100.5018;
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
                    stores.sort((a, b) {
                      double distanceToA = calculateDistance(
                          widget.lat,
                          widget.lon,
                          extractLoca(a.location, 0),
                          extractLoca(a.location, 1));
                      double distanceToB = calculateDistance(
                          widget.lat,
                          widget.lon,
                          extractLoca(b.location, 0),
                          extractLoca(b.location, 1));
                      return distanceToA.compareTo(distanceToB);
                    });
                    Allstore store = stores[index];
                    double distanceToStore = calculateDistance(
                        widget.lat,
                        widget.lon,
                        extractLoca(store.location, 0),
                        extractLoca(store.location, 1));
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
                                lat: widget.lat,
                                lon: widget.lon,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              height: heightsize * 0.14,
                              width: widthsize * 0.38,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: store.storePicture.isNotEmpty
                                    ? Image.network(
                                        'http://$ip:17003/api/v1/util/image/${store.storePicture}',
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                              ),
                            ),
                            Text(
                              " ${store.name}",
                              style: TextStyle(
                                color: const Color(0xFF4A4A4A),
                                fontSize: heightsize * 0.016,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " ${distanceToStore.toStringAsFixed(2)} ก.ม.",
                              style: TextStyle(
                                color: const Color(0xFF4A4A4A),
                                fontSize: heightsize * 0.016,
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
                                SearchShop(category: number,lat: widget.lat,lon: widget.lon,)));
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
                              lat: widget.lat,
                                lon: widget.lon,
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

  Widget mapButton(widthsize, heightsize) => IconButton(
        icon: Icon(Icons.map_sharp, size: widthsize * 0.055),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MapUser(geolocation: "${widget.lat},${widget.lon}")));
        },
      );
}
