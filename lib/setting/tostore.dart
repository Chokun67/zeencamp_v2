import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';
import '../Authentication/login.dart';
import '../application/shopService/shopservice.dart';
import '../background.dart/background.dart';
import '../background.dart/securestorage.dart';
import '../shop/map/select.dart';

class ToStore extends StatefulWidget {
  const ToStore({super.key});

  @override
  State<ToStore> createState() => _ToStoreState();
}

class _ToStoreState extends State<ToStore> {
  final _formKey = GlobalKey<FormState>();
  late String bit;
  File? file;
  ImagePicker image = ImagePicker();
  getImage() async {
    // ignore: deprecated_member_use
    var img = await image.getImage(source: ImageSource.gallery);
    if (img?.path != null) {
      setState(() {
        file = File(img!.path);
        bit = img.path;
      });
      // bit = base64.encode(await file!.readAsBytes());
    }
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

  var pointid = 0;
  var token = "";
  var iduser = "";
  var idname = "";
  var idAccount = "";
  var storeLocation = "";
  var currentlocation = "";
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: getgeoloca().then((value) => {
                  currentlocation = "${value.latitude},${value.longitude}",
                }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Stack(
                  children: [
                    Mystlye().buildBackground(
                        widthsize,
                        heightsize - MediaQuery.of(context).padding.vertical,
                        context,
                        "การตั้งค่า",
                        true,
                        0.2),
                    deTail(widthsize, heightsize, context)
                  ],
                );
              }
            }),
      ),
    );
  }

  Widget deTail(widthsize, heightsize, context) => Center(
        child: Container(
          padding: EdgeInsets.only(top: heightsize * 0.1),
          height: heightsize * 0.8,
          width: widthsize,
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imageHere(widthsize),
                  iconPickPicture(widthsize),
                  Text("เลือกพิกัดร้านค้า:\n$storeLocation",
                      style: mystyleText(heightsize, 0.02, kGray4A, true)),
                  Text("ตำแหน่งปัจจุบัน$currentlocation",
                      style: mystyleText(heightsize, 0.02, kGray4A, true)),
                  picklatlng(heightsize, widthsize),
                  btnToStore(heightsize, widthsize),
                ]),
          ),
        ),
      );

  Widget imageHere(widthsize) => SizedBox(
        height: widthsize * 0.5,
        width: widthsize * 0.5,
        child: file == null
            ? Icon(
                Icons.image,
                size: widthsize * 0.5,
              )
            : Image.file(
                file!,
                fit: BoxFit.fill,
              ),
      );

  Widget iconPickPicture(widthsize) => IconButton(
      onPressed: () {
        getImage();
      },
      icon: Icon(
        Icons.photo_album_outlined,
        size: 0.05 * widthsize,
      ));

  Widget picklatlng(heightsize, widthsize) => IconButton(
      onPressed: () {
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyMap(geolocation: currentlocation)),
          ).then((value) {
            if (value != null) {
              print('Returned value from SecondPage: $value');
              setState(() {
                storeLocation = value;
              });
            }
          });
        }
      },
      icon: Icon(
        Icons.location_city,
        size: 0.05 * widthsize,
      ));

  Widget btnToStore(heightsize, widthsize) => SizedBox(
        width: widthsize * 0.6,
        height: heightsize * 0.07,
        child: ElevatedButton(
          onPressed: btnchange,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A4A4A),
              side: const BorderSide(
                color: Color(0xFFAD6800),
                width: 2,
              ),
              shape: const StadiumBorder()),
          child: Text(
            "เปลี่ยนเป็นไอดีร้านค้า",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.025),
          ),
        ),
      );
  void btnchange() {
    if (file != null) {
      if (storeLocation != "") {
        StoresService().apiSettostore(token, idAccount).then((value) => {
          StoresService().updatelocation(token, storeLocation),
              StoresService()
                  .setStoreimage(token, bit)
                  .then((value) => // SecureStorage().deleteAll(),
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      ))
            });
      } else {
        showAlertBox(context, "แจ้งเตือน", "กรุณาเลือกตำแหน่งร้านค้า");
      }
    } else {
      showAlertBox(context, "แจ้งเตือน", "กรุณาใส่รูปภาพ");
    }
  }
}
