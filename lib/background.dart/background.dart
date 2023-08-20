import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../background.dart/appstyle.dart';
import 'dart:math';

import '../shop/menushop.dart';
import '../user/menu_user.dart';

class Mystlye {
  SafeArea buildBackground(double widthsize, double heightsize, context,
      String title, bool back, double hight) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            width: widthsize,
            height: heightsize,
            color: kWhiteF32,
          ),
          Container(
            width: widthsize,
            height: heightsize * 0.4,
            color: kYellow,
          ),
          Column(
            children: [
              SizedBox(
                width: widthsize,
                height: heightsize * hight,
              ),
              Container(
                width: widthsize,
                height: heightsize * 0.3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: kWhiteF32,
                ),
              )
            ],
          ),
          back
              ? Positioned(
                  top: widthsize * 0.055,
                  left: widthsize * 0.055,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    iconSize: heightsize * 0.04,
                  ))
              : const SizedBox.shrink(),
          Positioned(
              top: widthsize * 0.13,
              child: SizedBox(
                width: widthsize,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: kGray4A,
                        fontSize: heightsize * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  SafeArea waitfuture() {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
          body: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}

void showAlertBox(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showAlertBox2(BuildContext context, String title, String content,double heightsize) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_outlined,
              size: heightsize * 0.2, color: kGreen),
            Text(content,style: mystyleText(heightsize, 0.05, kGray4A, true)),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showAlertDecide(BuildContext context,
    {String title = '', String content = '', Function? okAction}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            child: const Text('ยกเลิก'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('ตกลง'),
            onPressed: () {
              Navigator.of(context).pop();
              if (okAction != null) {
                okAction();
              }
            },
          ),
        ],
      );
    },
  );
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // รัศมีของโลกในหน่วยกิโลเมตร
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);

  double a = pow(sin(dLat / 2), 2) +
      cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = earthRadius * c;
  return distance;
}

double _toRadians(double degree) {
  return degree * pi / 180;
}

double extractLoca(String a, int b) {
  RegExp regex = RegExp(r',');
  List<String> array = a.split(regex);
  return double.parse(array[b].trim());
  // List<String> parts = a.substring(0, a.length - 1).split(",");
}

Future<Position> getgeoloca() async {
  bool serviceEnable = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnable) {
    Future.error("Location are disable");
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error(
          "Location persossons are permanently denied, we cannot request");
    }
  }
  return await Geolocator.getCurrentPosition();
}

void gomenu(context,isstore){
  if (isstore == "true") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MenuShop()),
              (route) => false,
            );
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MenuUser()),
              (route) => false,
            );
        }
}