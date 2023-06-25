import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeencamp_v2/shop/menushop.dart';
import 'package:zeencamp_v2/user/menu_user.dart';
import 'package:zeencamp_v2/Authentication/register.dart';
import 'package:zeencamp_v2/background.dart/background.dart';
import '../application/accountService/accountservice.dart';
import '../background.dart/appstyle.dart';
import '../background.dart/securestorage.dart';
import '../domain/pvd_data.dart';
import 'forgotpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;
  final _ctrlLogin = TextEditingController();
  final _ctrlPswd = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isvalid = true;
  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(widthsize * 0.08),
              height: heightsize - MediaQuery.of(context).padding.vertical,
              width: widthsize,
              color: kWhite,
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
                    textFieldUser(heightsize),
                    textFieldPassword(heightsize),
                    pwRemember(heightsize,widthsize),
                    SizedBox(height: heightsize * 0.08),
                    Center(child: loginButton(heightsize, widthsize, context))
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
                goRegister(heightsize, widthsize, context),
                SizedBox(
                  height: heightsize * 0.05,
                ),
              ],
            ),
          ))
        ],
      )),
    );
  }

  Widget textDescribe(heightsize, widthsize) => Padding(
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
              "Login to \nBee Point",
              style: TextStyle(
                  color: kBlack,
                  fontSize: heightsize * 0.035,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget textFieldUser(heightsize) => SizedBox(
        height: heightsize * 0.1,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกค่า';
            } else if (!isvalid) {
              return 'กรุณาตรวจสอบความถูกต้อง';
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
            fillColor: kGrayD9,
            filled: true,
            hintText: "Email",
            prefixIcon: const Icon(Icons.email_outlined),
          ),
        ),
      );

  Widget textFieldPassword(heightsize) => TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกค่า';
          } else if (!isvalid) {
            isvalid = true;
            return 'กรุณาตรวจสอบความถูกต้อง';
          }
          return null;
        },
        controller: _ctrlPswd,
        obscureText: obscureText,
        style: TextStyle(fontSize: heightsize * 0.02),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.symmetric(vertical: heightsize * 0.008),
            fillColor: kGrayD9,
            filled: true,
            hintText: "Password",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off))),
      );

  Widget pwRemember(heightsize,widthsize) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: widthsize*0.03),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPassword()));
            },
            child:  Text("ลืมรหัสผ่าน ?",
                style: TextStyle(
                  color: kDarkYellow,
                  fontSize: heightsize*0.021,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline, // เพิ่มเส้นใต้
                  decorationColor:
                      kDarkYellow, // สีของเส้นใต้ (สามารถเปลี่ยนเป็นสีอื่นได้)
                  decorationThickness: 1.0,
                )),
          ),
        ],
      );

  Widget loginButton(
          double heightsize, double widthsize, BuildContext context) =>
      SizedBox(
        width: widthsize * 0.5,
        height: heightsize * 0.06,
        child: ElevatedButton(
          onPressed: btnlogin,
          style: ElevatedButton.styleFrom(
              backgroundColor: kYellow,
              shape: const StadiumBorder(),
              elevation: 5,
              shadowColor: Colors.grey),
          child: Text(
            "เข้าสู่ระบบ",
            style: mystyleText(heightsize, 0.025, kGray4A, true),
          ),
        ),
      );

  void btnlogin() {
    if (_formKey.currentState!.validate()) {
      AccountService()
          .apiLogin(_ctrlLogin.text, _ctrlPswd.text)
          .then((value) => {
                if (value != null)
                  {
                    if (value.isstore == false)
                      {
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MenuUser()),
                          ),
                          SecureStorage().write('token', value.accessToken),
                          SecureStorage().write('idAccount', value.accountid),
                          context.read<AppData>().token = value.accessToken,
                          context.read<AppData>().idAccount = value.accountid,
                        }
                      }
                    else
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MenuShop()),
                        ),
                        SecureStorage().write('token', value.accessToken),
                        SecureStorage().write('idAccount', value.accountid),
                        context.read<AppData>().token = value.accessToken,
                        context.read<AppData>().idAccount = value.accountid,
                      }
                  }
                else
                  {
                    showAlertBox(
                        context, 'แจ้งเตือน', 'ชื่อผู้ใช้หรือรหัสผ่านพิดพลาด'),
                    isvalid = false,
                    if (_formKey.currentState!.validate()) {}
                  }
              });
    }
  }

  Widget goRegister(
          double heightsize, double widthsize, BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("ยังไม่มีบัญชี ?",
              style: TextStyle(
                color: kBlack,
                fontSize: heightsize * 0.02,
              )),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: Text(
                "ลงทะเบียน",
                style: TextStyle(
                    color: kDarkYellow,
                    fontSize: heightsize * 0.02,
                    fontWeight: FontWeight.bold),
              )),
        ],
      );
}
