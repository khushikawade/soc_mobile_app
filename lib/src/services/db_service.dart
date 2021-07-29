import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:Soc/src/globals.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as httpClient;
import '../overrides.dart';
import 'db_service_response.model.dart';

class DbServices {
  getapi(api, {headers}) async {
    try {
      final response =
          await httpClient.get(Uri.parse('${Overrides.API_BASE_URL}$api'),
              headers: headers != null
                  ? headers
                  : {
                      'Content-Type': 'application/json',
                      'Accept-Language': 'Accept-Language',
                      'authorization': 'Bearer ${Globals.token}'
                    });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      } else {
        if (response.body == 'Unauthorized') {
          ResponseModel _res = await getapi(api, headers: headers);
          return _res;
        }
        return ResponseModel(statusCode: response.statusCode, data: null);
      }
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        throw ('NO_CONNECTION');
      } else {
        throw (e);
      }
    }
  }

  postapi(api, {body, headers}) async {
    try {
      final response = await httpClient.post(
          Uri.parse('${Overrides.API_BASE_URL}$api'),
          headers: headers ??
              {
                'Content-Type': 'application/json',
                'authorization': 'Bearer ${Globals.token}'
              },
          body: json.encode(body));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      } else {
        if (response.body == 'Unauthorized') {
          ResponseModel _res = await postapi(api, body: body, headers: headers);
          return _res;
        }
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      }
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        throw ('No Internet connection');
      } else {
        throw (e);
      }
    }
  }

  diopostapi(api, _headers, body) async {
    try {
      final dio = Dio();
      Response response = await dio.post(
        '${Overrides.API_BASE_URL}$api',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept-Language': 'Accept-Language',
            'authorization': 'Bearer ${Globals.token}'
          },
        ),
      );
      final data = response.data;
      if (response.statusCode == 200) {
        return ResponseModel(statusCode: response.statusCode, data: data);
      } else {
        return ResponseModel(statusCode: response.statusCode, data: data);
      }
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("No Internet Connection.");
      } else {
        throw (e);
      }
    }
  }

  // Local DB operations.

  // add Data in data base using this method
  Future<bool> addData(model, tableName) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      hiveBox.add(model);

      return true;
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  Future login() async {
     final dio = Dio();
     FormData formData = FormData.fromMap({
        "grant_type": "password",
        "client_id":
            "3MVG9eMnfmfDO5NC3QXoYv8SGxm3vUnduHs0xb5BwEiLHNXr46uKkiRFMIydXPVwcQG.T2uQ_4.uHRHnDL_tg",
        "client_secret":
            "9881213BBC5BA4A71BD3A5A1048815EE6775BC872A86203DA818A51AC7CCA624",
        "username": "mahendra.patidar@zehntech.com.flutter",
        "password": "YIB7tewn9joct*voghdVBvxNULlHjFmoQVqseNq1Iz"
      });
      Response response = await dio.post(
        "https://test.salesforce.com/services/oauth2/token",
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        Globals.token = data["access_token"];
        return data;
      } else {
        throw ("Something went wrong.");
      }
  }

  // get List Object using this method
  Future<List> getListData(tableName) async {
    try {
      var hiveBox = await Hive.openBox(tableName);
      var list = hiveBox.values.toList();
      return list;
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  Future<int> getListLength(tableName) async {
    try {
      var hiveBox = await Hive.openBox(tableName);
      var listCount = hiveBox.values.toList();
      return listCount.length;
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  Future<bool> updateListData(tableName, index, value) async {
    try {
      final hiveBox = await Hive.openBox(tableName);

      hiveBox.putAt(index, value);

      return true;
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  Future<bool> deleteData(tableName, index) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      hiveBox.deleteAt(index);

      return true;
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }
}
