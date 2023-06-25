import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Authentication/login.dart';
import '../application/shopService/shopservice.dart';
import '../background.dart/background.dart';
import '../background.dart/securestorage.dart';

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

  var pointid = 0;
  var token = "";
  var iduser = "";
  var idname = "";
  var idAccount = "";
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
        child: Stack(
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
        ),
      ),
    );
  }

  Widget deTail(widthsize, heightsize, context) => Center(
    child: Container(
          padding: EdgeInsets.only(top: heightsize * 0.1),
          height: heightsize * 0.7,
          width: widthsize,
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              imageHere(widthsize),
              iconPickPicture(widthsize),
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
      StoresService().apiSettostore(token, idAccount).then((value) => {
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
      showAlertBox(context, "แจ้งเตือน", "กรุณาใส่รูปภาพ");
    }
  }
}
