import 'dart:async';
import 'dart:convert';
import 'package:app/src/overrides.dart';
import 'package:app/src/services/db_service.dart';
import 'package:app/src/services/db_service_response.model.dart';
import 'package:app/src/services/shared_preference.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:app/src/Globals.dart';
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
    if (event is InitLogin) {
      try {
        if ((Globals.linkUsername != null && Globals.linkUsername != '') &&
            (Globals.linkPassword != null && Globals.linkPassword != '')) {
          // WIll bypass the login screen if the credentials are found in the dynamic link
          bool result =
              await login(Globals.linkUsername, Globals.linkPassword, true);
          yield result ? OpenChangePassword() : ErrorReceived();
        } else {
          // yield Loading();
          bool result = await initiateAutoLogin();
          if (result) {
            yield LoginSuccess();
          } else {
            yield ErrorReceived();
          }
        }
      } catch (e) {
        print(e);
        yield ErrorReceived(err: e);
      }
    }

    if (event is PerfomLogin) {
      try {
        yield Loading();
        final cred = PerfomLogin(
          email: event.email,
          password: event.password,
        );
        print(cred);
        bool result = await login(cred.email, cred.password, false);
        if (result != null && result) {
          yield LoginSuccess();
        } else {
          yield InvalidCredentials();
        }
      } catch (e) {
        yield ErrorReceived(err: e);
      }
    }

    if (event is AutoLogin) {
      try {
        yield Loading();
        bool result = await initiateAutoLogin();
        if (result) {
          yield LoginSuccess();
        } else {
          yield ErrorReceived();
        }
      } catch (e) {
        yield ErrorReceived(err: e);
      }
    }

    if (event is PerfomChangePassword) {
      try {
        yield Loading();
        final cred = PerfomChangePassword(
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
        );
        print(cred);
        bool result = await (_changePassword(cred.oldPassword, cred.newPassword) as FutureOr<bool>);
        if (result != null && result) {
          yield LoginSuccess();
        }
      } catch (e) {
        yield ErrorReceived(err: e);
      }
    }

    if (event is LogOut) {
      yield Loading();
      // await resetDeviceId();
      bool flag = await (louout() as FutureOr<bool>);
      print(flag);
      yield flag ? LoggedOut() : ErrorReceived();
    }
  }

  Future<bool> login(email, password, isOpenedByLink) async {
    try {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$email:$password'));
      final ResponseModel response = await _dbServices
          .postapi('login', headers: {'authorization': basicAuth});
      final data = response.data;
      if (response.statusCode == 200) {
        if (isOpenedByLink == null || isOpenedByLink == false) {
          await _sharedPref.setString('email', email);
          await _sharedPref.setString('password', password);
          Globals.token = data['results'][0]['JWT'];
          Overrides.API_BASE_URL = data['results'][0]['url'];
          await checkRole(email);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<String> checkRole(email) async {
    try {
      const String _fieldList = "fistName, lastName, email, profile_pic_url_text";
      final ResponseModel response =
          await _dbServices.getapi('data/users/$email', headers: {
        'JWT': '${Globals.token}',
        'Content-Type': 'application/json',
      });
      final data = response.data;
      // Utility.printWrapped(json.encode(data['results'][0]));
      if (response.statusCode == 200) {
        return "";
      } else {
         return "";
      }
    } catch (e) {
      throw (e);
    }
  }

  initiateAutoLogin() async {
    try {
      final _email = await _sharedPref.getString('email');
      final _password = await _sharedPref.getString('password');
      print('Email : $_email');
      if (_email != null &&
          _email != '' &&
          _password != null &&
          _password != '') {
        bool result = await login(_email, _password, false);
        return result;
      } else {
        throw ('');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future _changePassword(oldPassword, newPassword) async {
    try {
      print('change password called');
      final _body =
          json.encode({'oldPassword': oldPassword, 'newPassword': newPassword});
      final ResponseModel _response =
          await _dbServices.postapi('', body: _body);
      print(_response.data);
      if (_response.statusCode == 200) {
        _sharedPref.setString('password', newPassword);
        return true;
      } else {
        if (_response.data['errors'] != null &&
            _response.data['errors']['msg'] != null) {
          print(_response.data['errors']['msg']);
          throw (_response.data['errors']['msg']);
        } else {
          throw ('ER IS IETS FOUT GEGAAN');
        }
      }
    } catch (e) {
      throw (e);
    }
  }

  Future louout() async {
    try {
      await _sharedPref.setString('email', '');
      await _sharedPref.setString('password', '');
      // final ResponseModel response = await _dbServices.getapi('/logout',
      //     headers: {'Authorization': 'bearer ${Globals.token}'});
      // final data = response.data;
      // print(data);
      // if (response.statusCode == 200) {
      //   // return true;
      // } else {
      //   //  return false;
      // }
      return true;
    } catch (e) {
      // throw (e);
      return true;
    }
  }
}
