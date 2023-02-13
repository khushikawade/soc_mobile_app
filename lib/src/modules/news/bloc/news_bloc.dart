import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/model/action_count_list.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/hive_db_services.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/Strings.dart';
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
  int? apiNewsDataListlimit = 10;
  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    // print("news_event-------------------$event");
    if (event is FetchNotificationList) {
      try {
        // Fetch local data for News feed to show data
        String? _objectName = "${Strings.newsObjectName}";
        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();

        //Clear news notification local data to manage loading issue
        // SharedPreferences clearNewsCache =
        //     await SharedPreferences.getInstance();
        // final clearCacheResult =
        //     clearNewsCache.getBool('delete_local_news_notification_cache');

        // if (clearCacheResult != true) {
        //   _localData.clear();
        //   await clearNewsCache.setBool(
        //       'delete_local_news_notification_cache', true);
        // }

        _localData.forEach((element) {
          if (element.completedAt != null) {
            _localData.sort((a, b) => b.completedAt.compareTo(a.completedAt));
          }
        });

        if (_localData.isEmpty) {
          yield NewsLoading();
        } else {
          //isLoading is used to manage the pagination on UI
          yield NewsDataSuccess(
            obj: _localData,
            isLoading: _localData.length == apiNewsDataListlimit,
          );
        }

        List<Item> NewsFeedList = [];
        if (event.action!.contains("initial")) {
          //Fetching the records with offset and limit = 10
          NewsFeedList = await fetchNotificationList(0, apiNewsDataListlimit!);
          if (_localData.isEmpty) {
            yield NewsInitialState(obj: NewsFeedList);
          }
        } else {
          NewsFeedList = _localData;
        }
        // Local database end.
        // List<Item> _list = await fetchNotificationList(0, 50);
        // Syncing to local database
        // User Interaction count list
        List<ActionCountList> list = await fetchNewsActionCount();
        List<Item> newList = [];

        newList.clear();
        if (list.length == 0) {
          //If no action added yet for school, Adding onsignal list as it is with no action counts
          newList.addAll(NewsFeedList);
        } else {
          for (int i = 0; i < NewsFeedList.length; i++) {
            for (int j = 0; j < list.length; j++) {
              //Comparing Id and mapping data to the list if exist in action API
              if ("${NewsFeedList[i].id}${Overrides.SCHOOL_ID}" ==
                  list[j].notificationId) {
                newList.add(Item(
                    id: NewsFeedList[i].id,
                    completedAt: NewsFeedList[i].completedAt,
                    description: NewsFeedList[i].description,
                    completedAtTimestamp: NewsFeedList[i].completedAtTimestamp,
                    title: NewsFeedList[i].title,
                    image: NewsFeedList[i].image,
                    link: NewsFeedList[i].link,
                    likeCount: list[j].likeCount,
                    thanksCount: list[j].thanksCount,
                    helpfulCount: list[j].helpfulCount,
                    shareCount: list[j].shareCount,
                    supportCount: list[j].supportCount));
                break;
              }

              //Mapping action counts 0 if the record doesn't exist in action API
              if (list.length - 1 == j) {
                newList.add(Item(
                    id: NewsFeedList[i].id,
                    completedAt: NewsFeedList[i].completedAt,
                    completedAtTimestamp: NewsFeedList[i].completedAtTimestamp,
                    description: NewsFeedList[i].description,
                    title: NewsFeedList[i].title,
                    image: NewsFeedList[i].image,
                    link: NewsFeedList[i].link,
                    likeCount: 0,
                    thanksCount: 0,
                    helpfulCount: 0,
                    shareCount: 0,
                    supportCount: 0));
              }
            }
          }
        }
        await _localDb.clear();
        newList.forEach((Item e) {
          _localDb.addData(e);
        });

        newList.forEach((element) {
          if (element.completedAt != null) {
            newList.sort((a, b) => b.completedAt.compareTo(a.completedAt));
          }
        });

        // _list.sort(
        //     (a, b) => b.completedAtTimestamp.compareTo(a.completedAtTimestamp));
        // Syncing end.
        //Adding push notification list data to global list
        // Globals.notificationList.clear();
        // Globals.notificationList.addAll(_list);

        yield NewsLoading(); // Mimic state change

        //Store latest news id to manage red dot in case of new notification arrives
        HiveDbServices _hiveDb = HiveDbServices();
        _hiveDb.addSingleData('${Strings.latestNewsId}',
            '${Strings.latestNewsId}', newList[0].id);

        yield NewsDataSuccess(
          obj: newList,
          isLoading: newList.length == apiNewsDataListlimit,
          // isFromUpdatedNewsList: false,
        );
      } catch (e) {
        String? _objectName = "${Strings.newsObjectName}";
        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();

        yield NewsDataSuccess(
          obj: _localData,
          isLoading: _localData.length == apiNewsDataListlimit,
          //  isFromUpdatedNewsList: false,
        );
        // yield NewsErrorReceived(err: e);
      }
    }

    if (event is NewsAction) {
      try {
        yield NewsLoading();
        var data = await addNewsAction({
          "Notification_Id__c": "${event.notificationId}${Overrides.SCHOOL_ID}",
          "Title__c": "${event.notificationTitle}",
          "Like__c": "${event.like}",
          "Thanks__c": "${event.thanks}",
          "Helpful__c": "${event.helpful}",
          "Share__c": "${event.shared}",
          "Test_School__c": "${Globals.appSetting.isTestSchool}",
          "Support__c": "${event.support}"
        });
        yield NewsActionSuccess(
          obj: data,
        );
      } catch (e) {
        if (e.toString().contains('NO_CONNECTION')) {
          Utility.showSnackBar(
              event.scaffoldKey,
              'Make sure you have a proper Internet connection',
              event.context,
              null);
        } else {
          Utility.showSnackBar(
              event.scaffoldKey, 'Something went wrong', event.context, null);
        }
        yield NewsErrorReceived(err: e);
      }
    }

    if (event is NewsCountLength) {
      try {
        List<Item> _list =
            await fetchNotificationList(0, apiNewsDataListlimit!);

        // print("list length $event================> ${_list.length}");
        Globals.notiCount = _list.length;

        HiveDbServices _hiveDb = HiveDbServices();
        String? newsLatestId = await _hiveDb.getSingleData(
            '${Strings.latestNewsId}', '${Strings.latestNewsId}');

        _list.forEach((element) {
          if (element.completedAt != null) {
            _list.sort((a, b) => b.completedAt.compareTo(a.completedAt));
          }
        });
        // ((newsLatestId == null || newsLatestId == '')&& _list.isNotEmpty) ||

        //Compare latest news id to manage red dot in case of new notification arrives
        if (_list.isNotEmpty && _list[0].id != newsLatestId) {
          Globals.indicator.value = true;
        }
        // LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);
        // List<NotificationList> _localData = await _localDb.getData();
        //check the new Notification to show indicator on app startup
        // if (_localData.isNotEmpty &&
        //     _list.isNotEmpty &&
        //     _localData[0].id != _list[0].id) {
        //   Globals.indicator.value = true;
        // }

        yield NewsCountLengthSuccess(obj: _list);
      } catch (e) {
        yield NewsErrorReceived(err: e);
      }
    }

    // if (event is FetchActionCountList) {
    //   try {
    //     yield NewsLoading();
    //     String? _objectName = "news_action";
    //     LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);

    //     List<NotificationList> _localData = await _localDb.getData();

    //     if (event.isDetailPage == false) {
    //       if (_localData.isEmpty) {
    //         yield NewsLoading();
    //       } else {
    //         yield ActionCountSuccess(obj: _localData);
    //       }
    //     }
    //     List<ActionCountList> list = await fetchNewsActionCount();
    //     List<NotificationList> newList = [];

    //     newList.clear();
    //     if (list.length == 0) {
    //       //If no action added yet for school, Adding onsignal list as it is with no action counts
    //       newList.addAll(Globals.notificationList);
    //     } else {
    //       for (int i = 0; i < Globals.notificationList.length; i++) {
    //         for (int j = 0; j < list.length; j++) {
    //           //Comparing Id and mapping data to the list if exist in action API
    //           if ("${Globals.notificationList[i].id}${Overrides.SCHOOL_ID}" ==
    //               list[j].notificationId) {
    //             newList.add(NotificationList(
    //                 id: Globals.notificationList[i].id,
    //                 completedAt: Globals.notificationList[i].completedAt,
    //                 contents: Globals.notificationList[i].contents,
    //                 headings: Globals.notificationList[i].headings,
    //                 image: Globals.notificationList[i].image,
    //                 url: Globals.notificationList[i].url,
    //                 likeCount: list[j].likeCount,
    //                 thanksCount: list[j].thanksCount,
    //                 helpfulCount: list[j].helpfulCount,
    //                 shareCount: list[j].shareCount,
    //                 supportCount: list[j].supportCount));
    //             break;
    //           }

    //           //Mapping action counts 0 if the record doesn't exist in action API
    //           if (list.length - 1 == j) {
    //             newList.add(NotificationList(
    //                 id: Globals.notificationList[i].id,
    //                 completedAt: Globals.notificationList[i].completedAt,
    //                 contents: Globals.notificationList[i].contents,
    //                 headings: Globals.notificationList[i].headings,
    //                 image: Globals.notificationList[i].image,
    //                 url: Globals.notificationList[i].url,
    //                 likeCount: 0,
    //                 thanksCount: 0,
    //                 helpfulCount: 0,
    //                 shareCount: 0,
    //                 supportCount: 0));
    //           }
    //         }
    //       }
    //     }
    //     await _localDb.clear();
    //     newList.forEach((NotificationList e) {
    //       _localDb.addData(e);
    //     });
    //     //  newsMainList.sort((a, b) => -a.completedAt.compareTo(b.completedAt));
    //     yield ActionCountSuccess(obj: newList);
    //   } catch (e) {
    //     print(e);
    //     // yield NewsErrorReceived(err: e);
    //     String? _objectName = "news_action";
    //     // String? _objectName = "${Strings.newsObjectName}";
    //     LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);
    //     List<NotificationList> _localData = await _localDb.getData();
    //     // _localData.sort((a, b) => -a.completedAt.compareTo(b.completedAt));
    //     if (event.isDetailPage == false) {
    //       yield ActionCountSuccess(obj: _localData);
    //     }
    //   }
    // }

    if (event is UpdateNotificationList) {
      try {
        List<Item> _list =
            await fetchNotificationList(event.list!.length, 10); //offset,limit
        List<Item> existingNotificationList = event.list!;

        //Adding newly fetched notification to the existing list
        existingNotificationList.addAll(_list);

        // Action count list
        // For fetching the action count of the updated list
        List<ActionCountList> listActionCount = await fetchNewsActionCount();

        List<Item> newList = [];
        // newList.clear();
        if (listActionCount.length == 0) {
          newList
              .addAll(existingNotificationList); //Add 0 counts to all the post
        } else {
          //Check with the existing length of social list
          for (int i = 0; i < existingNotificationList.length; i++) {
            //Check with the length of social existing interaction
            for (int j = 0; j < listActionCount.length; j++) {
              if ("${existingNotificationList[i].id}${Overrides.SCHOOL_ID}" ==
                  listActionCount[j].notificationId) {
                newList.add(Item(
                    id: existingNotificationList[i].id,
                    completedAt: existingNotificationList[i].completedAt,
                    description: existingNotificationList[i].description,
                    title: existingNotificationList[i].title,
                    image: existingNotificationList[i].image,
                    link: existingNotificationList[i].link,
                    completedAtTimestamp:
                        existingNotificationList[i].completedAtTimestamp,
                    likeCount: listActionCount[j].likeCount,
                    thanksCount: listActionCount[j].thanksCount,
                    helpfulCount: listActionCount[j].helpfulCount,
                    shareCount: listActionCount[j].shareCount,
                    supportCount: listActionCount[j].supportCount));
                break;
              }

              // If Interaction count list length ends, Add all the remaining RSS feed interaction count = 0
              if (listActionCount.length - 1 == j) {
                newList.add(Item(
                    id: existingNotificationList[i].id,
                    completedAt: existingNotificationList[i].completedAt,
                    description: existingNotificationList[i].description,
                    title: existingNotificationList[i].title,
                    image: existingNotificationList[i].image,
                    link: existingNotificationList[i].link,
                    completedAtTimestamp:
                        existingNotificationList[i].completedAtTimestamp,
                    likeCount: 0,
                    thanksCount: 0,
                    helpfulCount: 0,
                    shareCount: 0,
                    supportCount: 0));
              }
            }
          }
        }

        //isLoading is used to manage the pagination loading on UI
        bool isLoading = true;

        if (_list.isEmpty) {
          isLoading = false;
        }
        //Commented due to double state found with same logic
        // yield SocialReload(isLoading: isLoading, obj: newList);

        //To mimic the state

        // //Sorting the notification by date
        // existingNotificationList.forEach((element) {
        //   if (element.completedAt != null) {
        //     existingNotificationList
        //         .sort((a, b) => b.completedAt.compareTo(a.completedAt));
        //   }
        // });

        //To mimic the state
        yield NewsLoading2();

        yield NewsDataSuccess(
          obj: newList,
          isLoading: isLoading,
          //isFromUpdatedNewsList: true,
        );
      } catch (e) {
        print(e);
        throw Exception(e);
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

  Future<List<Item>> fetchNotificationList(int offset, int limit) async {
    try {
      final response = await http.get(
          Uri.parse(
              "https://anl2h22jc4.execute-api.us-east-2.amazonaws.com/production/getNotifications?appId=${Overrides.PUSH_APP_ID}&offset=${offset}&limit=${limit}"),
          headers: {
            'Authorization': 'Basic ${Overrides.REST_API_KEY}',
          });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Globals.notiCount = data["total_count"];

        final _allNotifications = data['body'] ?? [];
        // Filtering the scheduled notifications. Only delivered notifications should display in the list.
        final data1 =
            _allNotifications.where((e) => e['completed_at'] != null).toList();
        final data2 = data1 as List;

        return data2.map((i) {
          return Item(
              id: i["id"],
              description: i["contents"]["en"],
              title: i["headings"]["en"],
              link: i["url"],
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
      final ResponseModel response = await _dbServices.postApimain(
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
      final ResponseModel response = await _dbServices.getApi(Uri.parse(
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
    HiveDbServices _hiveDbServices = HiveDbServices();

    bool _requireConsent = false;
    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);
    SharedPreferences pref = await SharedPreferences.getInstance();
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent notification) async {
      notification.complete(notification.notification);
      Globals.indicator.value = true;
    });
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      //    Globals.newsIndex =
      // await _hiveDbServices.getSingleData('newsIndex', 'newsIndex');
      // pref.setInt(Strings.bottomNavigation, 1);
      Globals.isNewTap = true;
      Globals.controller!.index = Globals.newsIndex ?? 0;
      Globals.newsIndex =
          await _hiveDbServices.getSingleData('newsIndex', 'newsIndex');
      // Globals.indicator.value = false;
      Globals.isNewTap = true;
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
