import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:zeencamp_v2/domain/dmstore/detailshopdm.dart';
import '../../domain/dmstore/allstore.dart';
import '../../domain/dmstore/getpayment.dart';
import '../../domain/dmstore/storecheck.dart';
import '../accountService/accountservice.dart';

class StoresService {
  var ipAddress = AccountService().ipAddress;
  var port = AccountService().port;

  Future<List<Allstore>> getStores(token) async {
    final response = await http.get(
      Uri.parse('http://$ipAddress:$port/api/v1/stores/get-all-stores'),
      headers: {
        'content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var decodeutf8 = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = jsonDecode(decodeutf8);
      List<Allstore> stores =
          jsonList.map((json) => Allstore.fromJson(json)).toList();
      return stores;
    } else if (response.statusCode == 404) {
      List<Allstore> stores = [];
      return stores;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  Future<StoreData> fetchStoreData(token, idshop) async {
    final response = await http.get(
        Uri.parse(
            'http://$ipAddress:$port/api/v1/stores/get-detail-store?id=$idshop'),
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });

    if (response.statusCode == 200) {
      var decodeutf8 = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = jsonDecode(decodeutf8);

      final storeData = StoreData(
          storePicture: jsonData.containsKey('storePicture') &&
                  jsonData['storePicture'] !=
                      null //ตรวจสอบว่ามีkeyชื่อ storePictureละรูปภาพเป็น null
              ? jsonData['storePicture']
              : "",
          menuStores: jsonData.containsKey('menuStoreSubdomains')
              ? List<Store>.from(
                  jsonData['menuStoreSubdomains'].map((x) => Store.fromJson(x)))
              : []);
      return storeData;
    } else if (response.statusCode == 404) {
      var decodeutf8 = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = jsonDecode(decodeutf8);
      final storeData = StoreData(
          storePicture: jsonData.containsKey('storePicture') &&
                  jsonData['storePicture'] != null
              ? jsonData['storePicture']
              : "",
          menuStores: []);
      return storeData;
    } else {
      throw Exception(
          'เกิดข้อผิดพลาดในการร้องขอข้อมูล: ${response.statusCode}');
    }
  }

  Future<List<Store>> fetchStoreData2(token, idshop) async {
    final response = await http.get(
        Uri.parse(
            'http://$ipAddress:$port/api/v1/stores/get-detail-store?id=$idshop'),
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });

    if (response.statusCode == 200) {
      var decodeutf8 = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = jsonDecode(decodeutf8);

      List<Store> storeData2 = jsonData.containsKey('menuStoreSubdomains')
          ? List<Store>.from(
              jsonData['menuStoreSubdomains'].map((x) => Store.fromJson(x)))
          : [];
      return storeData2;
    } else if (response.statusCode == 404) {
      var decodeutf8 = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = jsonDecode(decodeutf8);
      List<Store> storeData2 = jsonData.containsKey('storePicture') &&
              jsonData['storePicture'] != null
          ? jsonData['storePicture']
          : "";
      return storeData2;
    } else {
      throw Exception(
          'เกิดข้อผิดพลาดในการร้องขอข้อมูล: ${response.statusCode}');
    }
  }

  Future<Check> apiSettostore(token, idshop) async {
    final response = await http.put(
        Uri.parse('http://$ipAddress:$port/api/v1/stores/set-to-store'),
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });

    if (response.statusCode == 200) {
      return Check.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'เกิดข้อผิดพลาดในการร้องขอข้อมูล: ${response.statusCode}');
    }
  }

  Future<Check> setStoreimage(String token, String picture) async {
    var uri = Uri.parse(
        'http://$ipAddress:$port/api/v1/stores/upload-picture-stores');

    var request = http.MultipartRequest('POST', uri);
    request.headers['content-type'] = 'multipart/form-data';
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', picture));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var decodedJson = jsonDecode(responseBody);
      return Check.fromJson(decodedJson);
    } else {
      throw Exception(
          'เกิดข้อผิดพลาดในการร้องขอข้อมูล: ${response.statusCode}');
    }
  }

  Future<void> addMenuStore(String token, String picture, String name,
      int price, int exchange, int receive, int category) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://$ipAddress:$port/api/v1/stores/upload-menu'));
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    // กำหนดข้อมูลที่ต้องการส่งเป็นตัวแปร int โดยตรง

    request.fields['name'] = name;
    request.fields['price'] = price.toString();
    request.fields['exchange'] = exchange.toString();
    request.fields['receive'] = receive.toString();
    request.fields['category'] = category.toString();

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      picture,
      filename: picture,
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      debugPrint('ส่งข้อมูลเรียบร้อย');
    } else {
      debugPrint('เกิดข้อผิดพลาดในการส่งข้อมูล: ${response.statusCode}');
    }
  }

  Future<Check> deleteMenu(String token, String idMenu) async {
    var response = await http.delete(
      Uri.parse('http://$ipAddress:$port/api/v1/secure/data/delete?id=$idMenu'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      return Check.fromJson(jsonDecode(response.body));
    } else {
      return Check(code: response.statusCode, message: "message");
    }
  }

  Future<List<Allstore>> getmenucategory(token, category) async {
    final response = await http.get(
      Uri.parse(
          'http://$ipAddress:$port/api/v1/stores/get-menu-category?category=$category'),
      headers: {
        'content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      var decodeutf8 = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = jsonDecode(decodeutf8);
      List<Allstore> stores =
          jsonList.map((json) => Allstore.fromJson(json)).toList();
      return stores;
    } else if (response.statusCode == 404) {
      List<Allstore> stores = [];
      return stores;
    } else {
      throw Exception('Failed to fetch stores');
    }
  }

  Future<List<PaymentList?>> getPaymentList(token) async {
    final response = await http.get(
      Uri.parse(
          'http://$ipAddress:$port/api/v1/secure/payment/get-payment-list'),
      headers: {
        'content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    debugPrint("ซื้อพ้อย ${jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<PaymentList> data =
          jsonData.map((json) => PaymentList.fromJson(json)).toList();

      return data;
    } else {
      return [];
    }
  }

  Future<Check> buyPaymentConfirm(
      String token, String idpayment, int amount, String pswd) async {
    var response = await http.post(
        Uri.parse(
            'http://$ipAddress:$port/api/v1/secure/payment/buy-payment-confirm'),
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'idPayment': idpayment,
          'amount': amount,
          'pass': pswd
        }));

    debugPrint("ซื้อพ้อยเซิฟเวอ" + response.statusCode.toString());
    if (response.statusCode == 200) {
      return Check.fromJson(jsonDecode(response.body));
    } else {
      return Check(code: response.statusCode, message: "message");
    }
  }

  Future<Check> updatelocation(String token, String location) async {
    var response = await http.post(
        Uri.parse('http://$ipAddress:$port/api/v1/stores/update-location'),
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, String>{'location': location}));
    debugPrint("data" + location);
    debugPrint("position " + response.statusCode.toString());
    if (response.statusCode == 200) {
      return Check.fromJson(jsonDecode(response.body));
    } else {
      print(jsonDecode(response.body).toString());
      return Check(code: response.statusCode, message: "");
    }
  }

  Future<void> dowloadreport(token) async {
    final response = await http.get(
      Uri.parse('http://$ipAddress:$port/api/v1/report/download?auth=$token'),
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
    const fileName = 'your_report.csv'; // กำหนดชื่อและนามสกุลไฟล์ที่ต้องการ
    final directory = await getExternalStorageDirectory();// ให้ไฟล์ถูกบันทึกใน temporary directory ของแอป
    final filePath = '${directory!.path}/$fileName';
    File file = File(filePath);
    await file.writeAsBytes(bytes); // เขียน bytes ลงในไฟล์
    print('Downloaded to: $filePath');
    } else {
    print('error');
    }
  }
}
