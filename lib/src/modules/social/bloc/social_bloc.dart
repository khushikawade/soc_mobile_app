// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/model/action_count_list.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  SocialBloc() : super(SocialInitial());
  SocialState get initialState => SocialInitial();
  final DbServices _dbServices = DbServices();
  int _totalRetry = 0;
  int? apiSocialDataListlimit = 10;

  @override
  Stream<SocialState> mapEventToState(
    SocialEvent event,
  ) async* {
    // print("event-------------------$event");
    if (event is SocialPageEvent) {
      try {
        // yield Loading(); Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName = "${Strings.socialObjectName}";

        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();

        //Clear social local data to manage loading issue
        /////Start
        SharedPreferences clearSocialCache =
            await SharedPreferences.getInstance();

        final clearCacheResult =
            await clearSocialCache.getBool('delete_rss_feed_cache');

        if (clearCacheResult != true) {
          _localData.clear();
          // await clearSocialCache.setBool('delete_rss_feed_cache', true);
        }
        //End

        if (_localData.isEmpty) {
          yield Loading(); //Circular loader for whole content loading (Social + Interactions)
        } else {
          //isLoading is used to manage the pagination on UI

          yield SocialDataSuccess(
              obj: _localData,
              isLoading: _localData.length == apiSocialDataListlimit);

          // yield SocialReload(obj: _localData, isLoading: true);
        }
        // Local database end.

        //getting both list response
        //social list
        List<Item> socialRSSFeedList = [];
        if (event.action!.contains("initial")) {
          //Fetching the records with offset and limit = 10
          socialRSSFeedList = await getEventDetails(0, apiSocialDataListlimit!);
          if (_localData.isEmpty) {
            yield SocialInitialState(
                obj: socialRSSFeedList,
                isLoading: socialRSSFeedList.length == apiSocialDataListlimit);
          }
        } else {
          socialRSSFeedList = _localData;
        }

        // User Interaction count list
        List<ActionCountList> listActionCount = await fetchSocialActionCount();

        List<Item> newList = [];
        newList.clear();
        if (listActionCount.length == 0) {
          //Add 0 interaction counts to all the post in case of no interaction found
          newList.addAll(socialRSSFeedList);
        } else {
          //Check with the length of social list
          for (int i = 0; i < socialRSSFeedList.length; i++) {
            for (int j = 0; j < listActionCount.length; j++) {
              // if (list[i].id + Overrides.SCHOOL_ID ==
              //         listActionCount[j].id
              if (socialRSSFeedList[i].id + Overrides.SCHOOL_ID ==
                      listActionCount[j].id

                  //Old method of mapping
                  // Globals.socialList[i].id.toString()+Globals.socialList[i].guid['\$t'] ==
                  //     list[j].notificationId
                  ) {
                newList.add(Item(
                    id: socialRSSFeedList[i].id,
                    title: socialRSSFeedList[i].title,
                    description: socialRSSFeedList[i].description,
                    link: socialRSSFeedList[i].link,
                    guid: socialRSSFeedList[i].guid,
                    creator: socialRSSFeedList[i].creator,
                    pubDate: socialRSSFeedList[i].pubDate,
                    content: socialRSSFeedList[i].content,
                    mediaContent: socialRSSFeedList[i].mediaContent,
                    enclosure: socialRSSFeedList[i].enclosure,
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
                    id: socialRSSFeedList[i].id,
                    title: socialRSSFeedList[i].title,
                    description: socialRSSFeedList[i].description,
                    link: socialRSSFeedList[i].link,
                    guid: socialRSSFeedList[i].guid,
                    creator: socialRSSFeedList[i].creator,
                    pubDate: socialRSSFeedList[i].pubDate,
                    content: socialRSSFeedList[i].content,
                    mediaContent: socialRSSFeedList[i].mediaContent,
                    enclosure: socialRSSFeedList[i].enclosure,
                    likeCount: 0,
                    thanksCount: 0,
                    helpfulCount: 0,
                    shareCount: 0,
                    supportCount: 0));
              }
            }
          }
        }

        // Syncing to local database

        await _localDb.clear();
        newList.forEach((Item e) {
          _localDb.addData(e);
        });

        // Syncing end.
        yield Loading(); //To mimic the state

        //Confirming later
        if (clearCacheResult != true) {
          print('Clear Local Social Feed');
          await clearSocialCache.setBool('delete_rss_feed_cache', true);
        }

        yield SocialDataSuccess(
            obj:
                // listActionCount.length == 0 ? _localData :
                newList,
            isLoading: newList.length == apiSocialDataListlimit);
      } catch (e) {
        print("inside catch: $e");
        // Fetching from the local database instead.
        String? _objectName = "${Strings.socialObjectName}";
        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();
        yield SocialDataSuccess(obj: _localData, isLoading: false);
        // yield SocialError(err: e);
      }
    }
    //Using the event in case of fetching more data for social database
    if (event is UpdateSocialList) {
      try {
        //Fetching the data from the list's current length in the bunch of 10 records each time
        List<Item> fetchMoreRecods_RSSFeed =
            await getEventDetails(event.list!.length, apiSocialDataListlimit!);
        List<Item> existingRecords_RSSFeed = event.list!;
        existingRecords_RSSFeed.addAll(fetchMoreRecods_RSSFeed);

        // Action count list
        // For fetching the action count of the updated list
        List<ActionCountList> listActionCount = await fetchSocialActionCount();

        List<Item> newList = [];
        // newList.clear();
        if (listActionCount.length == 0) {
          newList
              .addAll(existingRecords_RSSFeed); //Add 0 counts to all the post
        } else {
          //Check with the existing length of social list
          for (int i = 0; i < existingRecords_RSSFeed.length; i++) {
            //Check with the length of social existing interaction
            for (int j = 0; j < listActionCount.length; j++) {
              if (existingRecords_RSSFeed[i].id + Overrides.SCHOOL_ID ==
                  listActionCount[j].id) {
                newList.add(Item(
                    id: existingRecords_RSSFeed[i].id,
                    title: existingRecords_RSSFeed[i].title,
                    description: existingRecords_RSSFeed[i].description,
                    link: existingRecords_RSSFeed[i].link,
                    guid: existingRecords_RSSFeed[i].guid,
                    creator: existingRecords_RSSFeed[i].creator,
                    pubDate: existingRecords_RSSFeed[i].pubDate,
                    content: existingRecords_RSSFeed[i].content,
                    mediaContent: existingRecords_RSSFeed[i].mediaContent,
                    enclosure: existingRecords_RSSFeed[i].enclosure,
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
                    id: existingRecords_RSSFeed[i].id,
                    title: existingRecords_RSSFeed[i].title,
                    description: existingRecords_RSSFeed[i].description,
                    link: existingRecords_RSSFeed[i].link,
                    guid: existingRecords_RSSFeed[i].guid,
                    creator: existingRecords_RSSFeed[i].creator,
                    pubDate: existingRecords_RSSFeed[i].pubDate,
                    content: existingRecords_RSSFeed[i].content,
                    mediaContent: existingRecords_RSSFeed[i].mediaContent,
                    enclosure: existingRecords_RSSFeed[i].enclosure,
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

        if (fetchMoreRecods_RSSFeed.isEmpty) {
          isLoading = false;
        }
        //Commented due to double state found with same logic
        // yield SocialReload(isLoading: isLoading, obj: newList);

        //To mimic the state
        yield Loading();

        yield SocialDataSuccess(
          obj: newList,
          isLoading: isLoading,
        );
      } catch (e) {
        throw Exception(e);
      }
    }

    if (event is SocialAction) {
      try {
        String? _objectName = "${Strings.socialObjectName}";
        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();
        yield Loading();
        if (_localData.isNotEmpty) {
          for (int i = 0; i < _localData.length; i++) {
            if (_localData[i].id == event.id) {
              Item obj = _localData[i];
              // print(_localData[i].likeCount);
              _localDb.putAt(i, obj);
            }
          }
        }

        var data = await addSocialAction({
          "Notification_Id__c": event.id! + Overrides.SCHOOL_ID,
          "Title__c": "${event.title}",
          "Like__c": "${event.like}",
          "Thanks__c": "${event.thanks}",
          "Helpful__c": "${event.helpful}",
          "Share__c": "${event.shared}",
          "Support__c": "${event.support}",
          "Test_School__c": "${Globals.appSetting.isTestSchool}",
        });
        yield SocialActionSuccess(
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
        yield SocialErrorReceived(err: e);
      }
    }
  }

  Future getEventDetails(int offset, int limit) async {
    try {
      // final link = Uri.parse("${Globals.appSetting.socialapiurlc}");
      // Xml2Json xml2json = new Xml2Json();
      final ResponseModel response = await _dbServices.getApiNew(
          Uri.encodeFull(
            'https://anl2h22jc4.execute-api.us-east-2.amazonaws.com/production/getSocialRSSFeed/${Overrides.SCHOOL_ID}?offset=${offset}&limit=${limit}',
          ),
          isCompleteUrl: true);
      // final response = await http.get(Uri.parse(
      //         "https://anl2h22jc4.execute-api.us-east-2.amazonaws.com/production/getSocialRSSFeed/a1f4W000007DQaNQAW?offset=${offset}&limit=${limit}"),
      // headers: {
      //   'Authorization': 'Basic ${Overrides.REST_API_KEY}',
      // }
      //  );
      if (response.statusCode == 200) {
        // xml2json.parse(response.body);
        // final jsondata = xml2json.toGData();s
        // final data = json.decode(jsondata);
        // final data1 = data["rss"]["channel"]["item"];
        // final data = json.decode(response.data);
        // Globals.notiCount = data["total_count"];

        final _allSocial = response.data['body'];
        // Filtering the scheduled notifications. Only delivered notifications should display in the list.
        // final data1 =
        //     _allNotifications.where((e) => e['completed_at'] != null).toList();
        final data2 = _allSocial as List;
        return data2.map((i) {
          return Item(
              title: Utility.utf8convert(i["Title"] ?? ''),
              description: Utility.utf8convert(i["Description"] ?? ''),
              link: i["Link"] ?? '',
              creator: Utility.utf8convert(i['Creator'] ?? ''),
              pubDate: Utility.convertTimestampToDate(i['Date'] ?? ''),
              mediaContent: i['Media'] ?? '',
              id: i['Id']);
        }).toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  // For fecting the action count of the updated list
  Future<List<ActionCountList>> fetchSocialActionCount() async {
    try {
      // print(Overrides.SCHOOL_ID);
      final ResponseModel response = await _dbServices.getApi(Uri.parse(
          'getUserAction?schoolId=${Overrides.SCHOOL_ID}&objectName=Social'));
      if (response.statusCode == 200) {
        var data = response.data["body"];
        final _allNotificationsAction = data;
        //  listActionCount.clear();
        final data1 = _allNotificationsAction;
        return data1
            .map<ActionCountList>((i) => ActionCountList.fromJson(i))
            .toList();
        //return [];
      } else {
        if (_totalRetry < 3) {
          _totalRetry++;
          return await fetchSocialActionCount();
        } else {
          // Utility.currentScreenSnackBar(
          //     "Unable to fetch the user Interactions. Please try to refresh the content.");
          return [];
        }
      }
    } catch (e) {
      throw (e);
    }
  }

  Future addSocialAction(body) async {
    try {
      final ResponseModel response = await _dbServices.postApimain(
          "addUserAction?schoolId=${Overrides.SCHOOL_ID}&objectName=Social&withTimeStamp=false",
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
}
