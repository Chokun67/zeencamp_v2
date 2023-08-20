import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeencamp_v2/application/accountService/accountservice.dart';
import 'package:zeencamp_v2/background.dart/background.dart';

import '../../application/shopService/shopservice.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/securestorage.dart';

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({super.key});

  @override
  State<AddMenuItem> createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  final _ctrlname = TextEditingController();
  final _ctrlprice = TextEditingController();
  final _ctrlexchange = TextEditingController();
  final _ctrlreceive = TextEditingController();
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
    getData().then((_) {
      fetchpoint();
    });
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  void fetchpoint() =>
      AccountService().apigetpoint(token).then((value) => setState(() {
            pointid = value.point;
            iduser = value.id;
            idname = value.name;
          }));

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Mystlye().buildBackground(
                  widthsize, heightsize, context, "เพิ่มเมนู", true, 0.3),
              Column(
                children: [
                  deTail(widthsize, heightsize, context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget deTail(widthsize, heightsize, context) => Container(
        padding: EdgeInsets.only(top: heightsize * 0.18),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            imageHere(widthsize),
            SizedBox(height: heightsize * 0.04),
            iconPickPicture(widthsize),
            textfieldName(heightsize, widthsize),
            SizedBox(height: heightsize * 0.02),
            textfieldprice(heightsize, widthsize),
            SizedBox(height: heightsize * 0.02),
            textfieldexchange(heightsize, widthsize),
            SizedBox(height: heightsize * 0.02),
            textfieldreceive(heightsize, widthsize),
            SizedBox(height: heightsize * 0.02),
            radiobutton(heightsize, widthsize),
            SizedBox(height: heightsize * 0.02),
            btnAddMenuItem(heightsize, widthsize),
            SizedBox(height: heightsize * 0.02),
          ]),
        ),
      );

  Widget textfieldName(heightsize, widthsize) => SizedBox(
    width: widthsize*0.75,
    child: TextFormField(
      inputFormatters: [
    LengthLimitingTextInputFormatter(15), // กำหนดความยาวสูงสุดเป็น 5 ตัวอักษร
  ],
      style: TextStyle(fontSize: heightsize * 0.02),
      controller: _ctrlname,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกค่า';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "name : ",
        fillColor: kGrayD9,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
      ),
    ),
  );

  Widget textfieldprice(heightsize, widthsize) => SizedBox(
    width: widthsize*0.75,
    child: TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: heightsize * 0.02),
      controller: _ctrlprice,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกค่า';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "price : ",
        fillColor: kGrayD9,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
      ),
    ),
  );

  Widget textfieldexchange(heightsize, widthsize) => SizedBox(
    width: widthsize*0.75,
    child: TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyle(fontSize: heightsize * 0.02),
      controller: _ctrlexchange,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกค่า';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "exchange : ",
        fillColor: kGrayD9,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
      ),
    ),
  );

  Widget textfieldreceive(heightsize, widthsize) => SizedBox(
    width: widthsize*0.75,
    child: TextFormField(
      keyboardType: TextInputType.number,
       inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyle(fontSize: heightsize * 0.02),
      controller: _ctrlreceive,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกค่า';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "receive :",
        fillColor: kGrayD9,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
      ),
    ),
  );

  int selectedOption = 0; // ตัวแปรสำหรับเก็บค่าตัวเลือกที่ถูกเลือก

  Widget radiobutton(heightsize, widthsize) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Radio(
              value: 1,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
          ),
          Expanded(child: Text("เครื่องดื่ม", style: styletype(heightsize))),
          Expanded(
            child: Radio(
              value: 2,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
          ),
          Expanded(child: Text("ขนม", style: styletype(heightsize))),
          Expanded(
            child: Radio(
              value: 3,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
          ),
          Expanded(
              child: Text(
            "อาหาร",
            style: styletype(heightsize),
          ))
        ],
      );

  TextStyle styletype(heightsize) {
    return TextStyle(
      fontSize: heightsize * 0.022,
      color: kGray4A,
    );
  }

  Widget imageHere(widthsize) => SizedBox(
        height: widthsize * 0.35,
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

  Widget btnAddMenuItem(heightsize, widthsize) => SizedBox(
        width: widthsize * 0.4,
        height: heightsize * 0.07,
        child: ElevatedButton(
          onPressed: btnaddmenuitem,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A4A4A),
              side: const BorderSide(
                color: Color(0xFFAD6800),
                width: 2,
              ),
              shape: const StadiumBorder()),
          child: Text(
            "เพิ่มเมนูร้านค้า",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: heightsize * 0.025),
          ),
        ),
      );

  void btnaddmenuitem() {
    if (file != null) {
      if (selectedOption != 0) {
        if (_formKey.currentState!.validate()) {
          StoresService()
              .addMenuStore(
                  token,
                  bit,
                  _ctrlname.text,
                  int.parse(_ctrlprice.text),
                  int.parse(_ctrlexchange.text),
                  int.parse(_ctrlreceive.text),
                  selectedOption)
              .then((value) => {Navigator.pop(context)});
        }
      } else {
        showAlertBox(context, 'แจ้งเตือน', 'กรุณาเลือกประเภทสินค้า');
      }
    } else {
      showAlertBox(context, 'แจ้งเตือน', 'กรุณาใส่รูปภาพ');
    }
  }
}
