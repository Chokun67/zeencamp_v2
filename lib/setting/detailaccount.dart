import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../background.dart/background.dart';
import '../application/accountService/accountservice.dart';
import '../background.dart/appstyle.dart';
import '../background.dart/securestorage.dart';

class DetailAccount extends StatefulWidget {
  const DetailAccount({super.key});

  @override
  State<DetailAccount> createState() => _SettingState();
}

class _SettingState extends State<DetailAccount> {
  final _ctrluser = TextEditingController();
  final _ctrlusername = TextEditingController();
  final _ctrldatetime = TextEditingController();
  final _ctrlgender = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  var token = "";
  var iduser = "";
  var idname = "";
  var birthday = "";
  var sex = "";
  var idAccount = "";
  var age = 0;
  var isedit = false;

  @override
  void initState() {
    super.initState();
    getData().then((_) {
      AccountService().apigetpersonal(token).then((value) => {
            if (value != null)
              {
                setState(() {
                  idname = value.name;
                  iduser = value.username;
                  birthday = value.birthday;
                  sex = value.sex;
                  age = value.age;
                })
              }
            else
              {idname = "dont have"}
          });
    });
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(children: [
          Mystlye().buildBackground(
              widthsize,
              heightsize - MediaQuery.of(context).padding.vertical,
              context,
              "การจัดการบัญชี",
              true,
              0.2),
          Padding(
            padding: EdgeInsets.all(widthsize * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heightsize * 0.1),
                Container(
                  padding: EdgeInsets.only(top: heightsize * 0.1),
                  height: heightsize * 0.6,
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      textfielduser(heightsize, widthsize),
                      SizedBox(height: heightsize * 0.02),
                      textfieldusername(heightsize, widthsize),
                      SizedBox(height: heightsize * 0.02),
                      textfieldbirthday(heightsize, widthsize),
                      SizedBox(height: heightsize * 0.02),
                      textfieldgender(heightsize, widthsize),
                    ]),
                  ),
                )
              ],
            ),
          ),
          !isedit
              ? Positioned(
                  bottom: heightsize * 0.2,
                  child: SizedBox(
                      width: widthsize,
                      child: Center(
                          child: editButton(heightsize, widthsize, context))))
              : Positioned(
                  bottom: heightsize * 0.2,
                  child: SizedBox(
                    width: widthsize,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        cancelButton(heightsize, widthsize, context),
                        confirmButton(heightsize, widthsize, context)
                      ],
                    ),
                  ))
        ]),
      )),
    );
  }

  Widget textfielduser(heightsize, widthsize) => TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _ctrluser,
        readOnly: !isedit ? true : false,
        style: TextStyle(fontSize: heightsize * 0.02),
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาป้อนอีเมล';
          } else if (value.length < 8) {
            return 'ต้องมีความยาวมากกว่าเท่ากับ 8 ตัวอักษร';
          } else if (!value.contains("@") ||
              RegExp(r'^[\u0E00-\u0E7F]+$').hasMatch(value)) {
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
          hintText: "อีเมลล์ : $iduser",
          prefixIcon: const Icon(Icons.email_outlined),
        ),
      );

  Widget textfieldusername(heightsize, widthsize) => TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(15)],
        controller: _ctrlusername,
        readOnly: !isedit ? true : false,
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
          hintText: "ชื่อผู้ใช้: $idname",
          prefixIcon: const Icon(Icons.person_2_outlined),
        ),
      );

  Widget textfieldbirthday(heightsize, widthsize) => TextFormField(
        controller: _ctrldatetime,
        readOnly: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกค่า';
          }
          return null;
        },
        style: TextStyle(fontSize: heightsize * 0.02),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
            fillColor: kGrayD9,
            filled: true,
            hintText: "วันเกิด: $birthday",
            prefixIcon: const Icon(Icons.cake_outlined),
            suffixIcon: InkWell(
                onTap: () async {
                  if (isedit) {
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
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                      });
                    }
                  }
                },
                child: Icon(Icons.arrow_drop_down, size: widthsize * 0.1))),
      );

  Widget textfieldgender(heightsize, widthsize) {
    void showGenderMenu() {
      if (isedit) {
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
    }

    return TextFormField(
        readOnly: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกค่า';
          }
          return null;
        },
        style: TextStyle(fontSize: heightsize * 0.02),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
            fillColor: kGrayD9,
            filled: true,
            hintText: "เพศ: $sex",
            prefixIcon: const Icon(Icons.male),
            suffixIcon: InkWell(
                onTap: showGenderMenu,
                child: Icon(Icons.arrow_drop_down, size: widthsize * 0.1))),
        controller: _ctrlgender);
  }

  Widget editButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.5,
        height: heightsize * 0.06,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              isedit = true;
              _ctrluser.text = iduser;
              _ctrlusername.text = idname;
              _ctrldatetime.text = birthday;
              _ctrlgender.text = sex;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kYellow,
            shape: const StadiumBorder(),
          ),
          child: Text(
            "แก้ไขข้อมูล",
            style: mystyleText(heightsize, 0.025, kGray4A, true),
          ),
        ),
      );

  Widget cancelButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.3,
        height: heightsize * 0.06,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              isedit = false;
              _ctrluser.text = "";
              _ctrlusername.text = "";
              _ctrldatetime.text = "";
              _ctrlgender.text = "";
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kYellow,
            shape: const StadiumBorder(),
          ),
          child: Text(
            "ยกเลิก",
            style: mystyleText(heightsize, 0.025, kGray4A, true),
          ),
        ),
      );

  Widget confirmButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.3,
        height: heightsize * 0.06,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              AccountService()
                  .editpersonal(
                      token,
                      _ctrlusername.text,
                      _ctrluser.text,
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      _ctrlgender.text)
                  .then((value) => {
                        if (value.code == 200)
                          {
                            setState(() {
                              isedit = false;
                              _ctrluser.text = "";
                              _ctrlusername.text = "";
                              _ctrldatetime.text = "";
                              _ctrlgender.text = "";
                            }),
                            showAlertBox(
                                context, "แจ้งเตือน", "แก้ไขข้อมูลสำเร็จ"),
                            AccountService()
                                .apigetpersonal(token)
                                .then((value) => {
                                      if (value != null)
                                        {
                                          setState(() {
                                            idname = value.name;
                                            iduser = value.username;
                                            birthday = value.birthday;
                                            sex = value.sex;
                                            age = value.age;
                                          })
                                        }
                                      else
                                        {idname = "dont have"}
                                    })
                          }
                        else
                          {
                            showAlertBox(
                                context, "แจ้งเตือน", "แก้ไขข้อมูลไม่สำเร็จ")
                          }
                      });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kYellow,
            shape: const StadiumBorder(),
          ),
          child: Text(
            "ยืนยัน",
            style: mystyleText(heightsize, 0.025, kGray4A, true),
          ),
        ),
      );
}
