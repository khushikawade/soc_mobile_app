import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
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
    if (event is PerfomLogin) {
      try {
        yield Loading();
        await login();
        yield LoginSuccess();
      } catch (e) {
        yield ErrorReceived(err: e);
      }
    }
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
}
