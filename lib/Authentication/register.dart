import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zeencamp_v2/user/menu_user.dart';
import '../application/accountService/accountservice.dart';
import '../background.dart/appstyle.dart';
import '../background.dart/background.dart';
import '../background.dart/securestorage.dart';
import '../domain/pvd_data.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText1 = true;
  bool obscureText2 = true;
  final _ctrluser = TextEditingController();
  final _ctrlusername = TextEditingController();
  final _ctrlpswd = TextEditingController();
  final _ctrlconfirm = TextEditingController();
  final _ctrldatetime = TextEditingController();
  final _ctrlgender = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String identifier = "";
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    identifier = await SecureStorage().read("imei") as String;
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: heightsize,
        width: widthsize,
        color: kWhite,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(widthsize * 0.08),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: heightsize * 0.122,
                      width: widthsize * 0.62,
                      child: Image.asset(
                        'images/beeicon.png',
                        fit: BoxFit.cover,
                      )),
                  SizedBox(height: heightsize * 0.01),
                  textDescribe(heightsize, widthsize),
                  SizedBox(height: heightsize * 0.02),
                  textfielduser(heightsize, widthsize),
                  SizedBox(height: heightsize * 0.015),
                  textfieldusername(heightsize, widthsize),
                  SizedBox(height: heightsize * 0.015),
                  textfieldpswd(heightsize, widthsize),
                  SizedBox(height: heightsize * 0.015),
                  textfieldconfirm(heightsize, widthsize),
                  SizedBox(height: heightsize * 0.015),
                  textfieldbirthday(heightsize, widthsize),
                  SizedBox(height: heightsize * 0.015),
                  textfieldgender(heightsize, widthsize),
                  SizedBox(height: heightsize * 0.015),
                  Center(child: registerButton(heightsize, widthsize, context)),
                  SizedBox(height: heightsize * 0.01),
                  goLogin(heightsize, widthsize, context)
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget textDescribe(heightsize, widthsize) => Padding(
        padding: EdgeInsets.only(left: widthsize * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: heightsize * 0.03,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: kBlack, // สีของเส้นใต้
                    width: 4, // ความกว้างของเส้นใต้
                  ),
                ),
              ),
              child: Text(
                "Bee Point be your point",
                style: TextStyle(
                  color: kBlack,
                  fontSize: heightsize * 0.015,
                ),
              ),
            ),
            SizedBox(height: heightsize * 0.02),
            Text(
              "Create a new\naccount",
              style: TextStyle(
                  color: kBlack,
                  fontSize: heightsize * 0.035,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget textfielduser(heightsize, widthsize) => TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _ctrluser,
        style: TextStyle(fontSize: heightsize * 0.02),
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาป้อนอีเมล';
          } else if (!value.contains("@") ||
              RegExp(r'[ก-๙เแไใๆ]').hasMatch(value)) {
            return 'รูปแบบอีเมลไม่ถูกต้อง';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
          fillColor: kGrayD9,
          filled: true,
          hintText: "อีเมล",
          prefixIcon: const Icon(Icons.email_outlined),
        ),
      );

  Widget textfieldusername(heightsize, widthsize) => TextFormField(
        controller: _ctrlusername,
        style: TextStyle(fontSize: heightsize * 0.02),
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกค่า';
          } else if (value.length < 8) {
            return 'ต้องมีความยาวมากกว่าเท่ากับ 8 ตัวอักษร';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
          fillColor: kGrayD9,
          filled: true,
          hintText: "ชื่อผู้ใช้",
          prefixIcon: const Icon(Icons.person_2_outlined),
        ),
      );

  Widget textfieldpswd(heightsize, widthsize) => TextFormField(
        obscureText: obscureText1,
        style: TextStyle(fontSize: heightsize * 0.02),
        controller: _ctrlpswd,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกค่า';
          } else if (value.length < 8) {
            return 'ต้องมีความยาวมากกว่าเท่ากับ 8 ตัวอักษร';
          } else if (RegExp(r'^[\u0E00-\u0E7F]+$').hasMatch(value)) {
            return 'รูปแบบไม่ถูกต้อง';
          }
          return null;
        },
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
            fillColor: kGrayD9,
            filled: true,
            hintText: "รหัสผ่าน",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscureText1 = !obscureText1;
                  });
                },
                child: Icon(
                    obscureText1 ? Icons.visibility : Icons.visibility_off))),
      );

  Widget textfieldconfirm(heightsize, widthsize) => TextFormField(
        obscureText: obscureText2,
        style: TextStyle(fontSize: heightsize * 0.02),
        controller: _ctrlconfirm,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกค่า';
          } else if (value.length < 8) {
            return 'ต้องมีความยาวมากกว่าเท่ากับ 8 ตัวอักษร';
          } else if (RegExp(r'^[\u0E00-\u0E7F]+$').hasMatch(value)) {
            return 'รูปแบบไม่ถูกต้อง';
          }
          return null;
        },
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
            fillColor: kGrayD9,
            filled: true,
            hintText: "ยืนยันรหัสผ่าน",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscureText2 = !obscureText2;
                  });
                },
                child: Icon(
                    obscureText2 ? Icons.visibility : Icons.visibility_off))),
      );

  Widget textfieldbirthday(heightsize, widthsize) => TextFormField(
        controller: _ctrldatetime,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกค่า';
          }
          return null;
        },
        readOnly: true,
        style: TextStyle(fontSize: heightsize * 0.02),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
            fillColor: kGrayD9,
            filled: true,
            hintText: "วันเกิด",
            prefixIcon: const Icon(Icons.cake_outlined),
            suffixIcon: InkWell(
                onTap: () async {
                  final DateTime? dateTime = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light().copyWith(
                            primary: kDarkYellow, // กำหนดสีหัวข้อที่ต้องการ
                          ),
                        ),
                        child: child ?? const SizedBox(),
                      );
                    },
                  );

                  if (dateTime != null) {
                    setState(() {
                      selectedDate = dateTime;
                      _ctrldatetime.text =
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                    });
                  }
                },
                child: Icon(Icons.arrow_drop_down, size: widthsize * 0.1))),
      );

  Widget textfieldgender(heightsize, widthsize) {
    void showGenderMenu() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              title: const Text('ชาย'),
              onTap: () {
                setState(() {
                  _ctrlgender.text = 'ชาย';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
                title: const Text('หญิง'),
                onTap: () {
                  setState(() {
                    _ctrlgender.text = 'หญิง';
                  });
                  Navigator.pop(context);
                }),
            ListTile(
                title: const Text('อื่นๆ'),
                onTap: () {
                  setState(() {
                    _ctrlgender.text = 'อื่นๆ';
                  });
                  Navigator.pop(context);
                })
          ]);
        },
      );
    }

    return TextFormField(
      readOnly: true,
      style: TextStyle(fontSize: heightsize * 0.02),
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
          fillColor: kGrayD9,
          filled: true,
          hintText: "เพศ",
          prefixIcon: const Icon(Icons.cake_outlined),
          suffixIcon: InkWell(
              onTap: showGenderMenu,
              child: Icon(Icons.arrow_drop_down, size: widthsize * 0.1))),
      controller: _ctrlgender,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกค่า';
        }
        return null;
      },
    );
  }

  Widget registerButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.6,
        height: heightsize * 0.06,
        child: ElevatedButton(
          onPressed: btnregister,
          style: ElevatedButton.styleFrom(
              backgroundColor: kYellow, shape: const StadiumBorder()),
          child: Text(
            "ลงทะเบียน",
            style: mystyleText(heightsize, 0.025, kGray4A, true),
          ),
        ),
      );

  void btnregister() {
    if (_formKey.currentState!.validate()) {
      if (_ctrlpswd.text == _ctrlconfirm.text) {
        AccountService()
            .apiRegister(
                _ctrluser.text,
                _ctrlusername.text,
                _ctrlpswd.text,
                DateFormat('yyyy-MM-dd').format(selectedDate),
                _ctrlgender.text,
                identifier)
            .then((value) => {
                  if (value != null)
                    {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MenuUser()),
                        (route) => false,
                      ),
                      SecureStorage().write('token', value.accessToken),
                      SecureStorage().write('idAccount', value.accountid),
                      SecureStorage()
                          .write('isstore', value.isstore.toString()),
                      context.read<AppData>().token = value.accessToken,
                      context.read<AppData>().idAccount = value.accountid,
                    }
                  else
                    {
                      showAlertBox(context, 'แจ้งเตือน',
                          'email หรือ username มีผู้ใช้ไปแล้ว')
                    }
                });
      } else {
        showAlertBox(context, 'แจ้งเตือน',
            'โปรดตรวจสอบรหัสผ่านและการยืนยันรหัสผ่านให้ถูกต้อง');
      }
    }
  }

  Widget goLogin(double heightsize, double widthsize, BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("มีบัญชีอยู่แล้ว?",
              style: TextStyle(
                color: kBlack,
                fontSize: heightsize * 0.02,
              )),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "เข้าสู่ระบบ",
                style: TextStyle(
                    color: kDarkYellow,
                    fontSize: heightsize * 0.02,
                    fontWeight: FontWeight.bold),
              )),
        ],
      );
}
