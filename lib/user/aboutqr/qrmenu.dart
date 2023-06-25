import 'package:flutter/material.dart';
import 'qrreceive.dart';
import 'qrscaner.dart';

class QrMenu extends StatefulWidget {
  const QrMenu({super.key});

  @override
  State<QrMenu> createState() => _QrMenuState();
}

class _QrMenuState extends State<QrMenu> {
  var pages = <Widget>[const QrScaner(), const QrReceive()];
    int _navItemIndex = 0;
  @override
  Widget build(BuildContext context) {
     var heightsize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: pages[_navItemIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: heightsize * 0.025,
        selectedFontSize: heightsize * 0.025,
        iconSize: heightsize * 0.04,
        backgroundColor: const Color(0xFF4A4A4A),
        unselectedItemColor: const Color(0xFFFFD600),
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