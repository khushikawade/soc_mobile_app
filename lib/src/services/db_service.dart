import 'dart:convert';
import 'package:Soc/src/globals.dart';
import 'package:http/http.dart' as httpClient;
import '../overrides.dart';
import 'db_service_response.model.dart';

class DbServices {
  getApi(api, {headers}) async {
    try {
      final response = await httpClient.get(
          // baseURLExist == true
          //     ? Uri.parse('$api')
          //     :
          Uri.parse('${Overrides.API_BASE_URL}$api'),
          headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      } else {
        if (response.body == 'Unauthorized') {
          ResponseModel _res = await getApi(api, headers: headers);
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

//User this for OCR/Google inetgration
  getApiNew(api, {headers, required bool? isCompleteUrl}) async {
    try {
      final response = await httpClient.get(
          isCompleteUrl == true
              ? Uri.parse('$api')
              : Uri.parse('${Overrides.API_BASE_URL}$api'),
          headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      } else {
        if (response.body == 'Unauthorized') {
          ResponseModel _res = await getApi(api, headers: headers);
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

  // googlegetApi(api, {headers}) async {
  //   try {
  //     final response = await httpClient.get(Uri.parse(api), headers: headers);

  //     if (response.statusCode == 200) {
  //       //print(response.body);
  //       final data = json.decode(response.body);
  //       return ResponseModel(statusCode: response.statusCode, data: data);
  //     } else {
  //       if (response.body == 'Unauthorized') {
  //         ResponseModel _res = await getApi(api, headers: headers);
  //         return _res;
  //       }
  //       return ResponseModel(statusCode: response.statusCode, data: null);
  //     }
  //   } catch (e) {
  //     if (e.toString().contains('Failed host lookup')) {
  //       throw ('NO_CONNECTION');
  //     } else {
  //       throw (e);
  //     }
  //   }
  // }

  postApi(api, {body, headers, bool? isGoogleApi}) async {
    try {
      final response = await httpClient.post(
          isGoogleApi == true
              ? Uri.parse('$api')
              : Uri.parse('${Overrides.API_BASE_URL}$api'),
          headers: isGoogleApi == true && headers == null
              ? {
                  'Content-Type': 'application/json',
                }
              : headers ??
                  {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'authorization': 'Bearer ${Globals.token}'
                  },
          body: json.encode(body));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      } else {
        if (response.body == 'Unauthorized') {
          ResponseModel _res = await postApi(api, body: body, headers: headers);
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

  // dioPostAPI(api, _headers, body) async {
  //   try {
  //     final dio = Dio();
  //     Response response = await dio.post(
  //       '${Overrides.API_BASE_URL}$api',
  //       data: body,
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept-Language': 'Accept-Language',
  //           'authorization': 'Bearer ${Globals.token}'
  //         },
  //       ),
  //     );
  //     final data = response.data;
  //     if (response.statusCode == 200) {
  //       return ResponseModel(statusCode: response.statusCode, data: data);
  //     } else {
  //       return ResponseModel(statusCode: response.statusCode, data: data);
  //     }
  //   } catch (e) {
  //     if (e.toString().contains("Failed host lookup")) {
  //       throw ("NO_CONNECTION");
  //     } else {
  //       throw (e);
  //     }
  //   }
  // }

  patchApi(api, {body, headers}) async {
    try {
      final response = await httpClient.patch(Uri.parse('$api'),
          headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      } else {
        if (response.body == 'Unauthorized') {
          ResponseModel _res =
              await patchApi(api, body: body, headers: headers);
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

//Use it for all the previous aws APIs, Do not use it for google APIs
//'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/'
  postAPIMain(api, {body, headers}) async {
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
          ResponseModel _res = await postApi(api, body: body, headers: headers);
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

  deleteApi(api) async {
    try {
      final response = await httpClient.delete(Uri.parse(api));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      } else {
        if (response.body == 'Unauthorized') {
          ResponseModel _res = await deleteApi(api);
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
}
