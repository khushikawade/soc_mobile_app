import 'dart:convert';

import 'package:Soc/src/globals.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as httpClient;
import '../overrides.dart';
import 'db_service_response.model.dart';

class DbServices {
  getapi(api, {headers}) async {
    try {
      print('${Overrides.API_BASE_URL}$api');
      final response = await httpClient.get(
          Uri.parse('${Overrides.API_BASE_URL}$api'),
          headers: headers != null
              ? headers
              : {
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
}
