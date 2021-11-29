import 'dart:convert';
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
        throw ('NO_CONNECTION');
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
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  Future login() async {
    try {
      final dio = Dio();
      FormData formData = FormData.fromMap({
        "grant_type": "password",
        "client_id":
            "3MVG9l2zHsylwlpTLc7YpeVR4xdkRtQUC2dlLre5eF36oxcfvNls5uurApC9_yNNM7whHlgTrTrrT1thrzYi4",
        "client_secret":
            "BF5C7D4FEA3092A9F11A6A572A9B23DECE61241EE3ADC88912EF628CBFF7BCD3",
        "username": "scott.walker@solvedconsulting.com",
        "password": "Windows2020?"
      });
      Response response = await dio.post(
        "https://login.salesforce.com/services/oauth2/token",
        // "https://test.salesforce.com/services/oauth2/token",
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
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  // get List Object using this method

}
