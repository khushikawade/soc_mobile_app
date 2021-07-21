import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../overrides.dart';
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  var data;
  NewsBloc() : super(NewsInitial());
  final DbServices _dbServices = DbServices();

  NewsState get initialState => NewsInitial();

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

        // List<NotificationList> _notifications = data["notifications"]
        //     .map<NotificationList>((i) => NotificationList.fromJson(i))
        //     .toList();
        final data1 = data["notifications"];
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
        throw (e);
      }
    }
  }

  Future<void> initPushState(context) async {
    bool _requireConsent = false;
    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    final settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent notification) {
      print(
          "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(
          "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      // _performPushOperation(result, context);
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {});

    OneSignal.shared.setAppId(Overrides.PUSH_APP_ID);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    // await OneSignal.shared.sendTags({"dbKey": "coimbee"});

    if (Platform.isIOS) {
      await OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true);
    }
    if (Platform.isAndroid) {
      await OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true);
    }

    updateDeviceId();
  }

  Future<void> updateDeviceId() async {
    // print("Updating the Onesignal Player id");
    try {
      final status = await OneSignal.shared.getDeviceState();
      final deviceId = status?.userId;
      // print("deviceId...");
      print(deviceId);
      if (deviceId == null) {
        // print("Calling again");
        await Future.delayed(Duration(milliseconds: 2000));
        updateDeviceId();
        return;
      } else {}
    } catch (e) {
      throw ("something went wrong");
    }
  }
}