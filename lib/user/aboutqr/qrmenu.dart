import 'package:flutter/material.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';
import 'qrreceive.dart';
import 'qrscaner.dart';

class QrMenu extends StatefulWidget {
  const QrMenu({Key? key, required this.idAccount}) : super(key: key);
  final String idAccount;

  @override
  State<QrMenu> createState() => _QrMenuState();
}

class _QrMenuState extends State<QrMenu> {
      int _navItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    var pages = <Widget>[const QrScaner(), QrReceive(idshop: widget.idAccount)];
    var heightsize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: pages[_navItemIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: heightsize * 0.025,
        selectedFontSize: heightsize * 0.025,
        iconSize: heightsize * 0.04,
        backgroundColor: kWhite,
        unselectedItemColor: kGray4A,
        selectedItemColor: const Color(0xFFFF9900),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner_sharp), label: 'สแกน QR'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code), label: 'QR รับเงิน'),
        ],
        currentIndex: _navItemIndex,
        onTap: (index)=> setState(() {
          _navItemIndex = index;
        }),
      ),
    );
  }
}