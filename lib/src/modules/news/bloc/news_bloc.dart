import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/model/action_count_list.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/services/utility.dart';
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
  final DbServices _dbServices = DbServices();
  var dataArray;
  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is FetchNotificationList) {
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
        _localData.sort((a, b) => -a.completedAt.compareTo(b.completedAt));

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
        _list.sort((a, b) => -a.completedAt.compareTo(b.completedAt));
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

    if (event is NewsAction) {
      try {
        yield NewsLoading();
        var data = await addNewsAction({
          "notificationId": "${event.notificationId}${event.schoolId}",
          // "School_App_ID__c": event.schoolId,
          "like": event.like,
          "thanks": event.thanks,
          "helpful": event.helpful,
          "share": event.shared,
        });
        yield NewsActionSuccess(
          obj: data,
        );
      } catch (e) {
        yield NewsErrorReceived(err: e);
      }
    }

    if (event is FetchActionCountList) {
      try {
        yield NewsLoading();
        List<ActionCountList> list = await fetchNewsActionCount();
        yield ActionCountSuccess(obj: list);
      } catch (e) {
        print(e);
        yield NewsErrorReceived(err: e);
      }
    }
  }

  String? getImageUrl(dynamic obj) {
    try {
      String _image;
      if (Platform.isIOS) {
        _image = obj["ios_attachments"]["id1"];
      } else {
        _image = obj["big_picture"];
      }
      return _image;
    } catch (e) {
      return null;
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
              image: i["global_image"] ?? getImageUrl(i),
              completedAt: Utility.convertTimestampToDate(i["completed_at"]));
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

  Future addNewsAction(body) async {
    try {
      // final ResponseModel response = await _dbServices
      //     .postapi("sobjects/News_Interactions__c", body: body);

      final response = await http.post(
        Uri.parse(
            'https://ny67869sad.execute-api.us-east-2.amazonaws.com/sandbox/addNewsAction?schoolId=${Overrides.SCHOOL_ID}'),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': 'Accept-Language',
        },
      );

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        var data = res["statusCode"];
        return data;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<ActionCountList>> fetchNewsActionCount() async {
    try {
      // final ResponseModel response = await _dbServices.getapi(
      //     "query/?q=${Uri.encodeComponent("SELECT Name,School_App__c, Total_helpful__c, Total_Likes__c, Total_Thanks__c, Total__c FROM Total_News_Interaction__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");

      var response = await http.get(
        Uri.parse(
            'https://ny67869sad.execute-api.us-east-2.amazonaws.com/sandbox/getNewsAction?schoolId=${Overrides.SCHOOL_ID}'),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        //data["records"];

        return data["body"]["Items"]
            .map<ActionCountList>((i) => ActionCountList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
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
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      pref.setInt(Strings.bottomNavigation, 1);
    });

    OneSignal.shared.setAppId(Overrides.PUSH_APP_ID);
    updateDeviceId();
  }

  Future<void> updateDeviceId() async {
    try {
      final status = await OneSignal.shared.getDeviceState();
      final deviceId = status?.userId;
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
