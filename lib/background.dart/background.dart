import 'package:flutter/material.dart';
import '../background.dart/appstyle.dart';

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
            top: widthsize * 0.077,
            left: widthsize * 0.077,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: heightsize*0.04,
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
