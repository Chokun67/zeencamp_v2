import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../application/accountService/accountservice.dart';
import '../background.dart/appstyle.dart';
import '../background.dart/background.dart';
import '../shop/menushop.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool obscureText1 = true;
  final _ctrlLogin = TextEditingController();
  final _ctrlnewPswd = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(widthsize * 0.08),
                height: heightsize- MediaQuery.of(context).padding.vertical,
                width: widthsize,
                color: kGrayD9,
                child: SingleChildScrollView(
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
                        textfieldUser(heightsize),
                        SizedBox(height: heightsize * 0.02),
                        textfieldbirthday(heightsize, widthsize),
                        SizedBox(height: heightsize * 0.02),
                        textfieldpswd(heightsize, widthsize),
                        SizedBox(height: heightsize * 0.08),
                        Center(child: forgotButton(heightsize, widthsize, context)),
                        SizedBox(height: heightsize * 0.12)
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              goLogin(heightsize, widthsize, context),
              SizedBox(height: heightsize*0.05,),
            ],
          ),
        ))],
          )),
    );
  }

  Widget textDescribe(heightsize, widthsize) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
            padding: EdgeInsets.only(left: widthsize * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: widthsize * 0.02),
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
                SizedBox(height: heightsize * 0.03),
                Text(
                  "Forgot Your \nBee Point",
                  style: TextStyle(
                      color: kBlack,
                      fontSize: heightsize * 0.035,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
    ],
  );

  Widget textfieldUser(heightsize) => TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return 'กรุณากรอกค่า';
      } 
      return null;
    },
    controller: _ctrlLogin,
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(fontSize: heightsize * 0.02),
    decoration: InputDecoration(
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
      fillColor: kWhite,
      filled: true,
      hintText: "Email",
      prefixIcon: const Icon(Icons.email_outlined),
    ),
  );

  bool havedatetime = true;
  Widget textfieldbirthday(heightsize, widthsize) => TextFormField(
    validator: (value) {
    if (havedatetime = true) {
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
        fillColor: kWhite,
        filled: true,
        hintText: havedatetime
            ? "Birthday"
            : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
        prefixIcon: const Icon(Icons.cake_outlined),
        suffixIcon: InkWell(
            onTap: () async {
              final DateTime? dateTime = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1940),
                  lastDate: DateTime.now());
              if (dateTime != null) {
                setState(() {
                  selectedDate = dateTime;
                  havedatetime = false;
                });
              }
            },
            child: Icon(Icons.arrow_drop_down, size: widthsize * 0.1))),
  );

  Widget textfieldpswd(heightsize, widthsize) => TextFormField(
        obscureText: obscureText1,
        style: TextStyle(fontSize: heightsize * 0.02),
        controller: _ctrlnewPswd,
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
            fillColor: kWhite,
            filled: true,
            hintText: "New Password",
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

  Widget forgotButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.5,
        height: heightsize * 0.06,
        child: ElevatedButton(
          onPressed: btnpassword,
          style: ElevatedButton.styleFrom(
              backgroundColor: kYellow,
              shape: const StadiumBorder(),
              elevation: 5,
              shadowColor: Colors.grey),
          child: const Text(
            "Change Password",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );

    void btnpassword() {
    // if (_formKey.currentState!.validate()) {
    //   AccountService()
    //       .forgotpassword(_ctrlLogin.text,
    //           DateFormat('yyyy-MM-dd').format(selectedDate), _ctrlnewPswd.text)
    //       .then((value) => {
    //             if (value.code == 200)
    //               {
    //                 Navigator.pop(context),
    //                 showAlertBox(context, "แจ้งเตือน", "เปลี่ยนรหัสผ่านสำเร็จ"),
    //               }
    //             else
    //               {showAlertBox(context, "แจ้งเตือน", "ตรวจสอบความถูกต้อง")}
    //           });
    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MenuShop()),
                        );
    
  }

  Widget goLogin(double heightsize, double widthsize, BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Already have an account?",
              style: TextStyle(
                color: kBlack,
                fontSize: heightsize * 0.02,
              )),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Login",
                style: TextStyle(
                    color: kDarkYellow,
                    fontSize: heightsize * 0.02,
                    fontWeight: FontWeight.bold),
              )),
        ],
      );
}