// import 'package:example/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';
import '../../domain/dmstore/allstore.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key, required this.geolocation}) : super(key: key);
  final String geolocation;
  @override
  MyMapState createState() {
    return MyMapState();
  }
}

class MyMapState extends State<MyMap> {
  AnchorAlign anchorAlign = AnchorAlign.top;
  bool counterRotate = false;
  final customMarkers = <Marker>[];
  String a = "";
  String b = "13.93448,100.6450688";
  String token = "";
  List<Allstore> stores = [];

  @override
  void initState() {
    super.initState();
    getData().then((_) {
      // AccountService().apigetpoint(token).then((value) => setState(() {
      //       pointid = value.point;
      //       idAccount = value.id;
      //       idname = value.name;
      //     }));
      fetchData();
    });
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    // idAccount = await SecureStorage().read("idAccount") as String;
  }

  void fetchData() async {
    // late List<Allstore> fetchedStores;
    // fetchedStores = await StoresService().getStores(token);
    // setState(() {
    //   stores = fetchedStores;
    // });
  }

  Marker buildPin(LatLng point) => Marker(
        point: point,
        builder: (ctx) => const Icon(Icons.location_pin, size: 60),
        width: 60,
        height: 60,
      );

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text('Markers')),
        body: WillPopScope(
          onWillPop: () async {
            a = "";
            Navigator.pop(context, a);
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Flexible(
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          // center: const LatLng(13.83448,100.6450688),
                          center: LatLng(extractLoca(widget.geolocation, 0),
                              extractLoca(widget.geolocation, 1)),
                          zoom: 15,
                          onTap: (_, p) => setState(() => {
                                debugPrint('debug: $p'),
                                a = "${p.latitude},${p.longitude}",
                                customMarkers.clear(),
                                customMarkers.add(buildPin(p)),
                              }),
                          interactiveFlags: ~InteractiveFlag.doubleTapZoom,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                          ),
                          MarkerLayer(
                            rotate: counterRotate,
                            anchorPos: AnchorPos.align(anchorAlign),
                            markers: [
                              buildPin(
                                  LatLng(extractLoca(b, 0), extractLoca(b, 1))),
                              // buildPin(LatLng(extractLoca(a, 0), extractLoca(a, 1))),
                              Marker(
                                point: const LatLng(13.83448, 100.650689),
                                rotate: false,
                                builder: (context) =>
                                    const Icon(Icons.location_pin, size: 60),
                              ),
                              // for (var stores in stores)
                              //   buildPin(
                              //     LatLng(extractLoca(stores.location, 0), extractLoca(stores.location, 1)))
                            ],
                          ),
                          MarkerLayer(
                            markers: customMarkers,
                            rotate: counterRotate,
                            anchorPos: AnchorPos.align(anchorAlign),
                          ),
                        ],
                      ),
                      Positioned(
                          bottom: 0,
                          child: SizedBox(
                            width: widthsize,
                            height: heightsize * 0.15,
                            child: Center(
                                child:
                                    goRegister(heightsize, widthsize, context)),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget goRegister(
          double heightsize, double widthsize, BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widthsize * 0.5,
            height: heightsize * 0.06,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, a);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kYellow,
                shape: const StadiumBorder(),
              ),
              child: Text(
                "ยืนยันพิกัดร้าน",
                style: mystyleText(heightsize, 0.025, kGray4A, true),
              ),
            ),
          )
        ],
      );
}
