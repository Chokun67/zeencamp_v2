// import 'package:example/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:zeencamp_v2/user/aboutshop/shopdetail.dart';

import '../../application/shopService/shopservice.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';
import '../../domain/dmstore/allstore.dart';

class MapUser extends StatefulWidget {
  const MapUser({Key? key, required this.geolocation}) : super(key: key);
  final String geolocation;
  @override
  MapUserState createState() {
    return MapUserState();
  }
}

class MapUserState extends State<MapUser> {
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
    late List<Allstore> fetchedStores;
    fetchedStores = await StoresService().getStores(token);
    setState(() {
      stores = fetchedStores;
    });
  }

  Marker buildPin(LatLng point) => Marker(
        point: point,
        builder: (ctx) => const Icon(Icons.location_pin, size: 60),
        width: 60,
        height: 60,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Markers')),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, a);
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Flexible(
                  child: FlutterMap(
                    options: MapOptions(
                      // center: LatLng(13.83448,100.6450688),
                      center: LatLng(extractLoca(widget.geolocation, 0),
                          extractLoca(widget.geolocation, 1)),
                      zoom: 15,
                      // onTap: (_, p) => setState(() => {
                      //       debugPrint('debug: $p'),
                      //       a = "${p.latitude},${p.longitude}",
                      //       customMarkers.clear(),
                      //       customMarkers.add(buildPin(p)),
                      //     }),
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
                          // buildPin(
                          //     LatLng(extractLoca(b, 0), extractLoca(b, 1))),
                          // Marker(
                          //   point: const LatLng(13.83448, 100.650689),
                          //   rotate: false,
                          //   builder: (context) => const Icon(Icons.location_pin, size: 60)),
                          for (var stores in stores)
                            Marker(
                              width: 120,
                              height: 100,
                              point: LatLng(extractLoca(stores.location, 0),
                                  extractLoca(stores.location, 1)),
                              rotate: false,
                              builder: (context) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShopDetail(
                                                  idshop: stores.id,
                                                  nameshop: stores.name,
                                                  lat: extractLoca(
                                                      stores.location, 0),
                                                  lon: extractLoca(
                                                      stores.location, 1),
                                                )));
                                  },
                                  child: Column(
                                    children: [
                                      const Icon(Icons.location_pin, size: 60),
                                      Text(stores.name)
                                    ],
                                  )),
                            )
                        ],
                      ),
                      MarkerLayer(
                        markers: customMarkers,
                        rotate: counterRotate,
                        anchorPos: AnchorPos.align(anchorAlign),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
