import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../../domain/dmtranfer/historydm.dart';
import '../../domain/dmtranfer/qrhash.dart';
import '../../domain/dmtranfer/tranferdm.dart';
import '../../domain/dmtranfer/vldtranfer.dart';
import '../accountService/accountservice.dart';

class TranferService {
  var ipAddress = AccountService().ipAddress;
  var port = AccountService().port;

  Future<Tranfer?> apiTranfer(String idTo, int pointTo, String token) async {
    var response = await http.put(
        Uri.parse(
            'http://$ipAddress:$port/api/v1/secure/transfer/transfer-point'),
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{'payee': idTo, 'point': pointTo}));
    if (response.statusCode == 200) {
      return Tranfer.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<List<DepositModel>> getTranfer(token) async {
    final response = await http.get(
      Uri.parse('http://$ipAddress:$port/api/v1/member/get-history-transfer'),
      headers: {
        'content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      List<DepositModel> stores =
          jsonList.map((json) => DepositModel.fromJson(json)).toList();
      return stores;
    } else if (response.statusCode == 404) {
      List<DepositModel> stores = [];
      return stores;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  Future<ValidateTranfer?> apiValidateTranfer(
      String idpayee, String token) async {
    var response = await http.get(
      Uri.parse(
          'http://$ipAddress:$port/api/v1/secure/transfer/validate-transfer-point?idPayee=$idpayee'),
      headers: {
        'content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var decodeutf8 = utf8.decode(response.bodyBytes);
      return ValidateTranfer.fromJson(jsonDecode(decodeutf8));
    }
    return null;
  }

  Future<String?> buildqrcodeformenu(
      String token, Map<String, int> data, bool isreceive) async {
    print(isreceive.toString());
    var requestData = {
      'state': isreceive ? "RECEIVE" : "EXCHANGE",
      'menu': data,
    };
    var response = await http.post(
        Uri.parse(
            'http://$ipAddress:$port/api/v1/secure/transfer/build-qrcode-for-menu'),
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(requestData));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json['hash'] as String;
    } else {
      return response.statusCode.toString();
    }
  }

  Future<Qrhash?> validateMenuForMenu(String token, String hash) async {
    var response = await http.get(
      Uri.parse(
          'http://$ipAddress:$port/api/v1/secure/transfer/validate-menu-for-menu?hash=$hash'),
      headers: {
        'content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var decodeutf8 = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = jsonDecode(decodeutf8);

      final storeData = Qrhash(
          amount: jsonData.containsKey('amount') &&
                  jsonData['amount'] !=
                      null //ตรวจสอบว่ามีkeyชื่อ storePictureละรูปภาพเป็น null
              ? jsonData['amount']
              : 0,
          menuStores: jsonData.containsKey('idMenu')
              ? List<MenuList>.from(
                  jsonData['idMenu'].map((x) => MenuList.fromJson(x)))
              : []);
      return storeData;
    } else if (response.statusCode == 404) {
      final storeData = Qrhash(amount: 0, menuStores: []);
      return storeData;
    } else {
      return null;
    }
  }

  Future<String> transferConfirmPoint(String token, String hash) async {
    var response = await http.put(
        Uri.parse(
            'http://$ipAddress:$port/api/v1/secure/transfer/transfer-confirm-point'),
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{'hash': hash}));
    if (response.statusCode == 200) {
      return response.statusCode.toString();
    }
    return response.statusCode.toString();
  }

  Future<bool> transferExchangeInteraction(String token, String hash) async {
    var response = await http.get(
        Uri.parse(
            'http://$ipAddress:$port/api/v1/secure/transfer/transfer-exchange-interaction?hash=$hash'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final boolValue = jsonData['state'] as bool;
      return boolValue;
    } else {
      throw Exception('${response.statusCode}');
    }
  }
}
