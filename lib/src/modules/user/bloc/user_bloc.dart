import 'dart:convert';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/globals.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as httpClient;
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial());

  final DbServices _dbServices = DbServices();
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    // if (event is InitLogin) {
    //   try {
    //     if ((Globals.linkUsername != null && Globals.linkUsername != '') &&
    //         (Globals.linkPassword != null && Globals.linkPassword != '')) {
    //       // WIll bypass the login screen if the credentials are found in the dynamic link
    //       bool result =
    //           await login(Globals.linkUsername, Globals.linkPassword, true);
    //       yield result ? OpenChangePassword() : ErrorReceived();
    //     } else {
    //       // yield Loading();
    //       bool result = await initiateAutoLogin();
    //       if (result) {
    //         yield LoginSuccess();
    //       } else {
    //         yield ErrorReceived();
    //       }
    //     }
    //   } catch (e) {
    //     print(e);
    //     yield ErrorReceived(err: e);
    //   }
    // }

    if (event is PerfomLogin) {
      try {
        yield Loading();
        await login();
        yield LoginSuccess();
      } catch (e) {
        yield ErrorReceived(err: e);
      }
    }

    // if (event is AutoLogin) {
    //   try {
    //     yield Loading();
    //     bool result = await initiateAutoLogin();
    //     if (result) {
    //       yield LoginSuccess();
    //     } else {
    //       yield ErrorReceived();
    //     }
    //   } catch (e) {
    //     yield ErrorReceived(err: e);
    //   }
    // }

    // if (event is PerfomChangePassword) {
    //   try {
    //     yield Loading();
    //     final cred = PerfomChangePassword(
    //       oldPassword: event.oldPassword,
    //       newPassword: event.newPassword,
    //     );
    //     print(cred);
    //     bool result = await (_changePassword(cred.oldPassword, cred.newPassword)
    //         as FutureOr<bool>);
    //     if (result != null && result) {
    //       yield LoginSuccess();
    //     }
    //   } catch (e) {
    //     yield ErrorReceived(err: e);
    //   }
    // }

    // if (event is LogOut) {
    //   yield Loading();
    //   // await resetDeviceId();
    //   bool flag = await (louout() as FutureOr<bool>);
    //   print(flag);
    //   yield flag ? LoggedOut() : ErrorReceived();
    // }
  }

  Future login() async {
    try {
      var dio = Dio();
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

      final data = response.data;

      if (response.statusCode == 200) {
        final data = response.data;
        Globals.token = data["access_token"];
        return data;
      } else {
        throw ("Something went wrong.");
      }
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("Please check your Internet Connection.");
      } else {
        throw ("Invalid credentials.");
      }
    }
  }
  // Future<bool> login(email, password, isOpenedByLink) async {
  //   try {
  //     String basicAuth =
  //         'Basic ' + base64Encode(utf8.encode('$email:$password'));
  //     final ResponseModel response = await _dbServices
  //         .postapi('login', headers: {'authorization': basicAuth});
  //     final data = response.data;
  //     if (response.statusCode == 200) {
  //       if (isOpenedByLink == null || isOpenedByLink == false) {
  //         await _sharedPref.setString('email', email);
  //         await _sharedPref.setString('password', password);
  //         Globals.token = data['results'][0]['JWT'];
  //         Overrides.API_BASE_URL = data['results'][0]['url'];
  //         await checkRole(email);
  //       }
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  // Future<String> checkRole(email) async {
  //   try {
  //     const String _fieldList =
  //         "fistName, lastName, email, profile_pic_url_text";
  //     final ResponseModel response =
  //         await _dbServices.getapi('data/users/$email', headers: {
  //       'JWT': '${Globals.token}',
  //       'Content-Type': 'application/json',
  //     });
  //     final data = response.data;
  //     // Utility.printWrapped(json.encode(data['results'][0]));
  //     if (response.statusCode == 200) {
  //       return "";
  //     } else {
  //       return "";
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  // initiateAutoLogin() async {
  //   try {
  //     final _email = await _sharedPref.getString('email');
  //     final _password = await _sharedPref.getString('password');
  //     // print('Email : $_email');
  //     if (_email != null &&
  //         _email != '' &&
  //         _password != null &&
  //         _password != '') {
  //       bool result = await login(_email, _password, false);
  //       return result;
  //     } else {
  //       throw ('');
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  // Future _changePassword(oldPassword, newPassword) async {
  //   try {
  //     // print('change password called');
  //     final _body =
  //         json.encode({'oldPassword': oldPassword, 'newPassword': newPassword});
  //     final ResponseModel _response =
  //         await _dbServices.postapi('', body: _body);
  //     // print(_response.data);
  //     if (_response.statusCode == 200) {
  //       _sharedPref.setString('password', newPassword);
  //       return true;
  //     } else {
  //       if (_response.data['errors'] != null &&
  //           _response.data['errors']['msg'] != null) {
  //         // print(_response.data['errors']['msg']);
  //         throw (_response.data['errors']['msg']);
  //       } else {
  //         throw ('ER IS IETS FOUT GEGAAN');
  //       }
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  // Future louout() async {
  //   try {
  //     await _sharedPref.setString('email', '');
  //     await _sharedPref.setString('password', '');
  //     // final ResponseModel response = await _dbServices.getapi('/logout',
  //     //     headers: {'Authorization': 'bearer ${Globals.token}'});
  //     // final data = response.data;
  //     // print(data);
  //     // if (response.statusCode == 200) {
  //     //   // return true;
  //     // } else {
  //     //   //  return false;
  //     // }
  //     return true;
  //   } catch (e) {
  //     // throw (e);
  //     return true;
  //   }
  // }
}
