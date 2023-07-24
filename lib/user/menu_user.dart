import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeencamp_v2/setting/setting.dart';
import 'package:zeencamp_v2/shop/map/mapuser.dart';
import 'package:zeencamp_v2/user/tranfer/history.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';
import '../Authentication/login.dart';
import '../application/accountService/accountservice.dart';
import '../application/shopService/shopservice.dart';
import '../background.dart/background.dart';
import '../background.dart/securestorage.dart';
import '../domain/dmstore/allstore.dart';
import 'aboutqr/qrmenu.dart';
import 'aboutshop/shopdetail.dart';
import 'tranfer/tranfer.dart';
import 'aboutshop/typeshop.dart';

class MenuUser extends StatefulWidget {
  const MenuUser({super.key});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  final String ip = AccountService().ipAddress;
  // late Future<Map<String, dynamic>> datapoint;
  var pointid = 0;
  var token = "";
  var iduser = "";
  var idname = "";
  var idAccount = "";
  double geolatitude = 0.0;
  double geolongitude = 0.0;
  List<Allstore> stores = [];

  @override
  void initState() {
    super.initState();
    getData().then((_) {
      AccountService().apigetpoint(token).then((value) => setState(() {
            pointid = value.point;
            idAccount = value.id;
            idname = value.name;
          }));
      fetchData();
    });
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  void fetchData() async {
    late List<Allstore> fetchedStores;
    fetchedStores = await StoresService().getStores(token);
    setState(() {
      stores = fetchedStores;
    });
  }

  @override
  Widget build(BuildContext context) {
    List widgetOptions = [
      const MenuUser(),
      const TranferPage(),
      const ShopType(),
      QrMenu(idAccount: idAccount)
    ];
    final heightsize = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getgeoloca().then((value) =>
            {geolatitude = value.latitude, geolongitude = value.longitude}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Mystlye().waitfuture();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return WillPopScope(
              onWillPop: () async {
                showAlertDecide(context,
                    title: 'แจ้งเตือน',
                    content: 'ยืนยันการออกจากระบบ',
                    okAction: logOut);
                return false;
              },
              child: Scaffold(
                body: SafeArea(
                    child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Mystlye().buildBackground(
                          widthsize, heightsize, context, "", false, 0.3),
                      Padding(
                        padding: EdgeInsets.all(widthsize * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: heightsize * 0.23),
                            Center(child: boxPoint(widthsize, heightsize)),
                            SizedBox(height: heightsize * 0.02),
                            Padding(
                              padding: EdgeInsets.only(left: widthsize * 0.07),
                              child: Text(
                                "โปรโมชั่น!",
                                style: TextStyle(
                                    fontSize: heightsize * 0.025,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            promotionShop(widthsize, heightsize),
                            Padding(
                              padding: EdgeInsets.only(left: widthsize * 0.07),
                              child: Text("ร้านค้าแนะนำ",
                                  style: TextStyle(
                                      fontSize: heightsize * 0.025,
                                      fontWeight: FontWeight.bold)),
                            ),
                            adviseShop(widthsize, heightsize)
                          ],
                        ),
                      ),
                      Positioned(
                          top: widthsize * 0.02,
                          right: widthsize * 0.04,
                          child: settingButton(heightsize, widthsize)),
                      Positioned(
                          top: widthsize * 0.12,
                          right: widthsize * 0.04,
                          child: mapButton(heightsize, widthsize)),
                      Positioned(
                          top: widthsize * 0.04,
                          left: widthsize * 0.04,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("สวัสดีครับ\nคุณ $idname",
                                  style: mystyleText(
                                      heightsize, 0.04, kBlack, true)),
                              SizedBox(height: heightsize * 0.01),
                              Text("id: $idAccount ",
                                  style: mystyleText(
                                      heightsize, 0.02, kGray4A, true))
                            ],
                          ))
                    ],
                  ),
                )),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  unselectedFontSize: heightsize * 0.018,
                  selectedFontSize: heightsize * 0.018,
                  iconSize: heightsize * 0.04,
                  backgroundColor: kWhite,
                  unselectedItemColor: kGray55,
                  selectedItemColor: kGray55,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'เมนู'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.import_export), label: 'โอนพ้อย'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.store), label: 'ร้านค้าต่างๆ'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.qr_code), label: 'แสกน QR'),
                  ],
                  currentIndex: 0,
                  onTap: (index) async {
                    if (index != 0) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widgetOptions[index]));
                      setState(() {
                        AccountService()
                            .apigetpoint(token)
                            .then((value) => setState(() {
                                  pointid = value.point;
                                }));
                      });
                    }
                  },
                ),
              ),
            );
          }
        });
  }

  Widget boxPoint(widthsize, heightsize) => InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const History())),
        child: Container(
          padding: EdgeInsets.all(widthsize * 0.05),
          width: widthsize * 0.8,
          height: heightsize * 0.185,
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("ยอดคงเหลือ",
                    style:
                        TextStyle(color: kBlack, fontSize: heightsize * 0.02)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(NumberFormat("#,##0").format(pointid),
                        style: TextStyle(
                            color: kGray4A,
                            fontSize: heightsize * 0.05,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: widthsize * 0.02),
                    Text("พอยท์",
                        style: TextStyle(
                            color: kGray4A,
                            fontSize: heightsize * 0.02,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ]),
              Container(
                  width: widthsize * 0.7,
                  height: heightsize * 0.035,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: kGray75,
                    width: 2.0,
                  )))),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('รายละเอียดเพิ่มเติม',
                        style: TextStyle(
                            fontSize: heightsize * 0.02,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget promotionShop(widthsize, heightsize) => Container(
        padding: EdgeInsets.only(left: widthsize * 0.03),
        height: heightsize * 0.18,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: heightsize * 0.16,
                width: widthsize * 0.6,
                decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Image.asset(
                    'images/promo1.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: widthsize * 0.05),
              Container(
                  height: heightsize * 0.16,
                  width: widthsize * 0.6,
                  decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      'images/promo2.jpg',
                      fit: BoxFit.fill,
                    ),
                  ))
            ],
          ),
        ),
      );
  double currentLat = 13.7563; // ละติจูดของตำแหน่งปัจจุบัน
  double currentLon = 100.5018;
  Widget adviseShop(widthsize, heightsize) {
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
                          geolatitude,
                          geolongitude,
                          extractLoca(a.location, 0),
                          extractLoca(a.location, 1));
                      double distanceToB = calculateDistance(
                          geolatitude,
                          geolongitude,
                          extractLoca(b.location, 0),
                          extractLoca(b.location, 1));
                      return distanceToA.compareTo(distanceToB);
                    });
                    Allstore store = stores[index];
                    double distanceToStore = calculateDistance(
                        geolatitude,
                        geolongitude,
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
                              ),
                            ),
                          );
                        },
                        child: Column(
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
                              "ร้าน ${store.name}",
                              style: TextStyle(
                                color: const Color(0xFF4A4A4A),
                                fontSize: heightsize * 0.016,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${distanceToStore.toStringAsFixed(2)} ก.ม.",
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

  void logOut() {
    SecureStorage().delete("token");
    SecureStorage().delete("idAccount");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Widget settingButton(widthsize, heightsize) => IconButton(
        icon: Icon(Icons.settings, size: widthsize * 0.055),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingPage()));
        },
      );

  Widget mapButton(widthsize, heightsize) => IconButton(
        icon: Icon(Icons.map_sharp, size: widthsize * 0.055),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MapUser(geolocation: "$geolatitude,$geolongitude")));
        },
      );
}
