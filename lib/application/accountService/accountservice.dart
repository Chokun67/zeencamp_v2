import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../domain/dmaccount/customer.dart';
import '../../domain/dmaccount/personal.dart';
import '../../domain/dmaccount/register.dart';
import '../../domain/dmaccount/userdm.dart';
import '../../domain/dmstore/storecheck.dart';

class AccountService {
  var ipAddress = "13.212.167.80";
  var port = "17003";

  Future<Customer?> apiLogin(String login, String pswd) async {
    var response = await http.post(
        Uri.parse('http://$ipAddress:$port/api/v1/member/login'),
        headers: <String, String>{'content-type': 'application/json'},
        body:
            jsonEncode(<String, String>{'username': login, 'password': pswd}));
    if (response.statusCode == 200) {
      return Customer.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<Register?> apiRegister(String login, String username, String pswd,
      String date, String gender,String identifier) async {
    var url = Uri.parse('http://$ipAddress:$port/api/v1/member/register');
    var headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({
      "name": username,
      "username": login,
      "password": pswd,
      "birthday": date,
      "sex": gender,
      "imei":identifier
    });

    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return Register.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 409) {
      return null;
    } else {
      return null;
    }
  }

  Future<Personal?> apigetpersonal(String token) async {
    var response = await http.get(
      Uri.parse('http://$ipAddress:$port/api/v1/member/get-personal-data'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    var decodeutf8 = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      return Personal.fromJson(jsonDecode(decodeutf8));
    } else {
      return null;
    }
  }

  Future<Check> editpersonal(
      String token,String username, String email, String birthday, String gender) async {
    var response = await http.put(
        Uri.parse('http://$ipAddress:$port/api/v1/member/edit-personal-data'),
        headers: {'content-type': 'application/json',HttpHeaders.authorizationHeader: 'Bearer $token',},
        body: jsonEncode(<String, dynamic>{
          "name": username,
          "username": email,
          "birthday": birthday,
          "sex": gender
        }));
    if (response.statusCode == 200) {
      return Check.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 400) {
      return Check(code: response.statusCode, message: "unsuccessful");
    } else {
      throw Exception(
          'เกิดข้อผิดพลาดในการร้องขอข้อมูล: ${response.statusCode}');
    }
  }

  Future<Check> deleteAccount(String token) async {
    var response = await http.delete(
      Uri.parse('http://$ipAddress:$port/api/v1/member/delete-account'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Check.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 404) {
      return Check(code: 404, message: "สำเร็จมั้ง");
    } else {
      throw Exception(
          'เกิดข้อผิดพลาดในการร้องขอข้อมูล: ${response.statusCode}');
    }
  }

  Future<Check> forgotpassword(
      String username, String birthday, String newpassword) async {
    var response = await http.put(
        Uri.parse('http://$ipAddress:$port/api/v1/member/forgot-password'),
        headers: <String, String>{'content-type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'birthday': birthday,
          'newPassword': newpassword
        }));
    
    if (response.statusCode == 200) {
      return Check.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 400) {
      return Check(code: response.statusCode, message: "unsuccessful");
    } else {
      throw Exception(
          'เกิดข้อผิดพลาดในการร้องขอข้อมูล: ${response.statusCode}');
    }
  }

  Future<UserModel> apigetpoint(String token) async {
    var response = await http.get(
      Uri.parse('http://$ipAddress:$port/api/v1/member/get-point'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var decodeutf8 = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(decodeutf8);
      return UserModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
}
