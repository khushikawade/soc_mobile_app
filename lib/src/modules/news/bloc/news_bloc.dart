import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/model/action_count_list.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
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
        // yield NewsLoading();// Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName = "${Strings.newsObjectName}";
        LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);
        List<NotificationList> _localData = await _localDb.getData();
        _localData.forEach((element) {
          if (element.completedAtTimestamp != null) {
            _localData.sort((a, b) =>
                b.completedAtTimestamp.compareTo(a.completedAtTimestamp));
          }
        });

        if (_localData.isEmpty) {
          yield NewsLoading();
        } else {
          //Adding push notification local data to global list
          Globals.notificationList.clear();
          Globals.notificationList.addAll(_localData);
          yield NewsLoaded(obj: _localData);
        }
        // Local database end.
        List<NotificationList> _list = await fetchNotificationList();
        // Syncing to local database
        await _localDb.clear();
        _list.forEach((NotificationList e) {
          _localDb.addData(e);
        });
        _list.sort(
            (a, b) => b.completedAtTimestamp.compareTo(a.completedAtTimestamp));
        // Syncing end.

        yield NewsLoading(); // Mimic state change

        //Adding push notification list data to global list
        Globals.notificationList.clear();
        Globals.notificationList.addAll(_list);

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
          "Notification_Id__c": "${event.notificationId}${Overrides.SCHOOL_ID}",
          "Like__c": "${event.like}",
          "Thanks__c": "${event.thanks}",
          "Helpful__c": "${event.helpful}",
          "Share__c": "${event.shared}",
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
        String? _objectName = "news_action";
        LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);
        List<NotificationList> _localData = await _localDb.getData();
        if (event.isDetailPage == false) {
          if (_localData.isEmpty) {
            yield NewsLoading();
          } else {
            yield ActionCountSuccess(obj: _localData);
          }
        }
        List<ActionCountList> list = await fetchNewsActionCount();

        List<NotificationList> newList = [];
        newList.clear();
        if (list.length == 0) {
          //If no action added yet for school, Adding onsignal list as it is with no action counts
          newList.addAll(Globals.notificationList);
        } else {
          for (int i = 0; i < Globals.notificationList.length; i++) {
            for (int j = 0; j < list.length; j++) {
              //Comparing Id and mapping data to the list if exist in action API
              if ("${Globals.notificationList[i].id}${Overrides.SCHOOL_ID}" ==
                  list[j].notificationId) {
                newList.add(NotificationList(
                    id: Globals.notificationList[i].id,
                    contents:
                        Globals.notificationList[i].contents, //obj.contents,
                    headings:
                        Globals.notificationList[i].headings, //obj.headings,
                    image: Globals.notificationList[i].image, //obj.image,
                    url: Globals.notificationList[i].url, //obj.url,
                    likeCount: list[j].likeCount,
                    thanksCount: list[j].thanksCount,
                    helpfulCount: list[j].helpfulCount,
                    shareCount: list[j].shareCount));
                break;
              }

              //Mapping action counts 0 if the record doesn't exist in action API
              if (list.length - 1 == j) {
                newList.add(NotificationList(
                    id: Globals.notificationList[i].id,
                    contents:
                        Globals.notificationList[i].contents, //obj.contents,
                    headings:
                        Globals.notificationList[i].headings, //obj.headings,
                    image: Globals.notificationList[i].image, //obj.image,
                    url: Globals.notificationList[i].url, //obj.url,
                    likeCount: 0,
                    thanksCount: 0,
                    helpfulCount: 0,
                    shareCount: 0));
              }
            }
          }
        }
        await _localDb.clear();
        newList.forEach((NotificationList e) {
          _localDb.addData(e);
        });
        //  newsMainList.sort((a, b) => -a.completedAt.compareTo(b.completedAt));
        yield ActionCountSuccess(obj: newList);
      } catch (e) {
        print(e);
        // yield NewsErrorReceived(err: e);
        String? _objectName = "news_action";
        // String? _objectName = "${Strings.newsObjectName}";
        LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);
        List<NotificationList> _localData = await _localDb.getData();
        // _localData.sort((a, b) => -a.completedAt.compareTo(b.completedAt));
        yield ActionCountSuccess(obj: _localData);
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
              completedAt: Utility.convertTimestampToDate(i["completed_at"]),
              completedAtTimestamp: i["completed_at"]);
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

      print(body);

      final ResponseModel response = await _dbServices.postapi(
          "addUserAction?schoolId=${Overrides.SCHOOL_ID}&objectName=News",
          body: body);

      if (response.statusCode == 200) {
        var res = response.data;
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
      final ResponseModel response = await _dbServices.getapi(Uri.parse(
          'getUserAction?schoolId=${Overrides.SCHOOL_ID}&objectName=News'));

      if (response.statusCode == 200) {
        var data = response.data["body"];
        final _allNotificationsAction = data;
        final data1 = _allNotificationsAction;
        // .where((e) => e['completed_at'] != null)
        // .toList();
        return data1
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
