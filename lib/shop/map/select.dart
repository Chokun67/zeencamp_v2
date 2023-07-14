// import 'package:example/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key,required this.geolocation}) : super(key: key);
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
  String b = "(13.93448,100.6450688)";

  Marker buildPin(LatLng point) => Marker(
        point: point,
        builder: (ctx) => const Icon(Icons.location_pin, size: 60),
        width: 60,
        height: 60,
      );

  // Future<Position> getgeoloca() async {
  //   bool serviceEnable = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnable) {
  //     Future.error("Location are disable");
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error(
  //           "Location persossons are permanently denied, we cannot request");
  //     }
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getgeoloca().then((value) => {
  //         print("${value.latitude},${value.longitude}"),
  //         b = "${value.latitude},${value.longitude}",
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Markers')),
      body: WillPopScope(
                onWillPop: () async{
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
                            center: LatLng(13.83448,100.6450688), //37.4219983,-122.084
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
                                buildPin(LatLng(
                                    extractLoca(b, 0), extractLoca(b, 1))),
                                // buildPin(LatLng(extractLoca(a, 0), extractLoca(a, 1))),
                                Marker(
                                  point: const LatLng(
                                      13.83448,100.650689),
                                  rotate: false,
                                  builder: (context) =>
                                      const Icon(Icons.location_pin, size: 60),
                                ),
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
              )
            
    );
  }

  double extractLoca(String a, int b) {
    List<String> parts = a.substring(1, a.length - 1).split(",");
    return double.parse(parts[b].trim()); // -0.12835376940892318
  }
}