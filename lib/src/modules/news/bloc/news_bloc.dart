import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:http/http.dart' as http;
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../overrides.dart';
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial());
  NewsState get initialState => NewsInitial();

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is FetchNotificationCount) {
      try {
        yield NewsLoading();
        List<NotificationList> _list = await fetchNotificationList();
        yield NewsLoaded(
          obj: _list,
        );
      } catch (e) {
        yield NewsErrorReceived(err: e);
      }
    }
    if (event is FetchNotificationList) {
      try {
        // yield NewsLoading();// Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName = "${Strings.newsObjectName}";
        LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);
        List<NotificationList> _localData = await _localDb.getData();

        if (_localData.isEmpty) {
          yield NewsLoading();
        } else {
          yield NewsLoaded(obj: _localData);
        }

        // Local database end.

        List<NotificationList> _list = await fetchNotificationList();
        // Syncing to local database
        await _localDb.clear();
        _list.forEach((NotificationList e) {
          _localDb.addData(e);
        });
        // Syncing end.

        yield NewsLoading(); // Mimic state change
        yield NewsLoaded(
          obj: _list,
        );
      } catch (e) {
        String? _objectName = "${Strings.newsObjectName}";
        LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);
        List<NotificationList> _localData = await _localDb.getData();

        yield NewsLoaded(obj: _localData);
        // yield NewsErrorReceived(err: e);
      }
    }
  }

  Future<List<NotificationList>> fetchNotificationList() async {
    try {
     
      final response = await http.get(
          Uri.parse(
              "https://onesignal.com/api/v1/notifications?app_id=${Overrides.PUSH_APP_ID}"),
          headers: {
            'Authorization': 'Basic ${Overrides.REST_API_KEY}',
          });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Globals.notiCount = data["total_count"];
        final _allNotifications = data["notifications"];
        // Filtering the scheduled notifications. Only delivered notifications should display in the list.
        final data1 =
            _allNotifications.where((e) => e['completed_at'] != null).toList();
        final data2 = data1 as List;
        return data2.map((i) {
          return NotificationList(
              id: i["id"],
              contents: i["contents"],
              headings: i["headings"],
              url: i["url"],
              image: i["global_image"]);
        }).toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("No Internet Connection.");
      } else {
        print(e);
        throw (e);
      }
    }
  }

  Future<void> initPushState(context) async {
    bool _requireConsent = false;
    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);
    SharedPreferences pref = await SharedPreferences.getInstance();
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent notification) async {
      notification.complete(notification.notification);
      Globals.indicator.value = true;
      // print(
      //     "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      pref.setInt(Strings.bottomNavigation, 1);
    });

    OneSignal.shared.setAppId(Overrides.PUSH_APP_ID);

    // if (Platform.isIOS) {
    //   await OneSignal.shared
    //       .promptUserForPushNotificationPermission(fallbackToSettings: true);
    // }
    // if (Platform.isAndroid) {
    //   await OneSignal.shared
    //       .promptUserForPushNotificationPermission(fallbackToSettings: true);
    // }
    updateDeviceId();
  }

  Future<void> updateDeviceId() async {
    try {
      final status = await OneSignal.shared.getDeviceState();
      final deviceId = status?.userId;

      print(deviceId);
      if (deviceId == null) {
        await Future.delayed(Duration(milliseconds: 2000));
        updateDeviceId();
        return;
      } else {
        Globals.deviceID = deviceId;
      }
    } catch (e) {
      throw ("something went wrong");
    }
  }
}
