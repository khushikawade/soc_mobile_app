import 'dart:async';
import 'dart:convert';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/model/action_count_list.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
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
// 2218b20a-5e74-4e4e-8e90-286eb7051c58
    if (event is NewsAction) {
      try {
        yield NewsLoading();
        var data = await addNewsAction({
          "Notification_ID__c": event.notificationId,
          "School_App_ID__c": event.schoolId,
          "Like__c": event.like,
          "Thanks__c": event.thanks,
          "Helpful__c": event.helpful,
          "Shared__c": event.shared,
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
        yield NewsErrorReceived(err: e);
      }
    }
  }

  Future<List<NotificationList>> fetchNotificationList() async {
    try {
      print(
          "https://onesignal.com/api/v1/notifications?app_id=${Overrides.PUSH_APP_ID}");
      print('Basic ${Overrides.REST_API_KEY}');
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

  Future addNewsAction(body) async {
    try {
      final ResponseModel response = await _dbServices
          .postapi("sobjects/News_Interactions__c", body: body);
      if (response.statusCode == 201) {
        var data = response.data["records"];
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
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Name,School_App__c, Total_helpful__c, Total_Likes__c, Total_Thanks__c, Total__c FROM Total_News_Interaction__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
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
