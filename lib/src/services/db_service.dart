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
      print('${Overrides.API_BASE_URL}$api');
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
        // print(response.body);
        if (response.body == 'Unauthorized') {
          // await refreshtoken(); here we should refresh the token // TODO implement refresh session
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
      // print('${Overrides.API_BASE_URL}$api?output=json');
      final response = await httpClient.post(
          Uri.parse('${Overrides.API_BASE_URL}$api?output=json'),
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
          print('The token has been expired....');
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
      var dio = Dio();

      Response response = await dio.post(
        '${Overrides.API_BASE_URL}$api',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
            // 'Authorization': 'Bearer ${Globals.token}'
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

  // Future<List> getSelectedDateData(tableName) async {
  //   try {
  //     var hiveBox = await Hive.openBox(tableName);
  //     var list = hiveBox.values.toList();
  //     List<LogsModel> listofSelectedDate;
  //     listofSelectedDate = new List();

  //     if (list != null && list.length > 0) {
  //       for (int i = 0; i < list.length; i++) {
  //         // print(logsList[i].dateTime);

  //         String logTemp1 = "${list[i].dateTime}".split(' ')[0];
  //         String logTemp2 = "${globals.getdatefromslider}".split(' ')[0];

  //         if (logTemp1 == logTemp2) {
  //           // DateTime dateTime = logsList[i].dateTime;
  //           // String position;
  //           // String temprature;
  //           // String symptoms;
  //           // var addMedinceLog;
  //           // String addNotehere;
  //           var item = LogsModel(
  //               list[i].dateTime,
  //               list[i].position,
  //               list[i].temprature,
  //               list[i].symptoms,
  //               list[i].addMedinceLog,
  //               list[i].addNotehere);

  //           listofSelectedDate.add(item);

  //           // var filteredUsers = logsList.values
  //           //     .where((LogsModel) => LogsModel.dateTime == "")
  //           //     .toList();
  //           // print(filteredUsers.length);
  //         }
  //       }
  //     }

  //     return listofSelectedDate;
  //   } catch (e) {
  //     if (e.toString().contains("Failed host lookup")) {
  //       throw ("NO_CONNECTION");
  //     } else {
  //       throw (e);
  //     }
  //   }
  // }

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
