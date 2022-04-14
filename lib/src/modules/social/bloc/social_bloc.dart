import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/model/action_count_list.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  SocialBloc() : super(SocialInitial());
  SocialState get initialState => SocialInitial();
  final DbServices _dbServices = DbServices();

  @override
  Stream<SocialState> mapEventToState(
    SocialEvent event,
  ) async* {
    if (event is SocialPageEvent) {
      try {
        // yield Loading(); Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName = "${Strings.socialObjectName}";
        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();

        if (_localData.isEmpty) {
          yield Loading();
        } else if (event.action!.contains("returnBack")) {
          yield SocialReload(obj: _localData);
        } else {
          yield SocialDataSucess(obj: _localData);
        }
        // Local database end.

        //getting both list response
        //social list
        List<Item> list = [];
        if (event.action!.contains("initial")) {
          list = await getEventDetails();
          if (_localData.isEmpty) {
            yield SocialInitialState(obj: list);
          }
        } else {
          list = _localData;
        }

        // Action count list

        List<ActionCountList> listActioncount = await fetchSocialActionCount();

        List<Item> newList = [];
        newList.clear();
        if (listActioncount.length == 0) {
          newList.addAll(list);
        } else {
          for (int i = 0; i < list.length; i++) {
            for (int j = 0; j < listActioncount.length; j++) {
              if (list[i].guid['\$t'] + Overrides.SCHOOL_ID ==
                      listActioncount[j].id

                  //Old method of mapping
                  // Globals.socialList[i].id.toString()+Globals.socialList[i].guid['\$t'] ==
                  //     list[j].notificationId
                  ) {
                newList.add(Item(
                    id: list[i].id,
                    title: list[i].title,
                    description: list[i].description,
                    link: list[i].link,
                    guid: list[i].guid,
                    creator: list[i].creator,
                    pubDate: list[i].pubDate,
                    content: list[i].content,
                    mediaContent: list[i].mediaContent,
                    enclosure: list[i].enclosure,
                    likeCount: listActioncount[j].likeCount,
                    thanksCount: listActioncount[j].thanksCount,
                    helpfulCount: listActioncount[j].helpfulCount,
                    shareCount: listActioncount[j].shareCount));
                break;
              }

              if (listActioncount.length - 1 == j) {
                newList.add(Item(
                    id: list[i].id,
                    title: list[i].title,
                    description: list[i].description,
                    link: list[i].link,
                    guid: list[i].guid,
                    creator: list[i].creator,
                    pubDate: list[i].pubDate,
                    content: list[i].content,
                    mediaContent: list[i].mediaContent,
                    enclosure: list[i].enclosure,
                    likeCount: 0,
                    thanksCount: 0,
                    helpfulCount: 0,
                    shareCount: 0));
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
        yield Loading();

        yield SocialDataSucess(
          obj: newList,
        );
      } catch (e) {
        print("inside catch");
        // Fetching from the local database instead.
        String? _objectName = "${Strings.socialObjectName}";
        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();
        yield SocialDataSucess(
          obj: _localData,
        );
        // yield SocialError(err: e);
      }
    }

    if (event is SocialAction) {
      try {
        yield Loading();

        var data = await addSocailAction({
          "Notification_Id__c": event.id! + Overrides.SCHOOL_ID,
          "Title__c": "${event.title}",
          "Like__c": "${event.like}",
          "Thanks__c": "${event.thanks}",
          "Helpful__c": "${event.helpful}",
          "Share__c": "${event.shared}",
          "Test_School__c": "${Globals.appSetting.isTestSchool}",
        });
        yield SocialActionSuccess(
          obj: data,
        );
      } catch (e) {
        yield SocialErrorReceived(err: e);
      }
    }
  }

  Future getEventDetails() async {
    try {
      final link = Uri.parse("${Globals.appSetting.socialapiurlc}");
      Xml2Json xml2json = new Xml2Json();
      http.Response response = await http.get(link);
      if (response.statusCode == 200) {
        xml2json.parse(response.body);
        final jsondata = xml2json.toGData();
        final data = json.decode(jsondata);
        final data1 = data["rss"]["channel"]["item"];
        final data2 = data1 as List;
        return data2.map((i) {
          return Item(
              title: i["title"] ?? '',
              description: i["description"] ?? '',
              link: i["link"] ?? '',
              guid: i['guid'] ?? '',
              creator: i['dc\$creator'] ?? '',
              pubDate: i['pubDate'] ?? '',
              content: i['content'] ?? '',
              enclosure: i['enclosure'] ?? '',
              mediaContent: i['media\$content'] ?? '',
              id: Utility.generateUniqueId(i['pubDate']['\$t']));
        }).toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<ActionCountList>> fetchSocialActionCount() async {
    try {
      final ResponseModel response = await _dbServices.getapi(Uri.parse(
          'getUserAction?schoolId=${Overrides.SCHOOL_ID}&objectName=Social'));
      if (response.statusCode == 200) {
        var data = response.data["body"];
        final _allNotificationsAction = data;
        //  listActioncount.clear();
        final data1 = _allNotificationsAction;
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

  Future addSocailAction(body) async {
    try {
      final ResponseModel response = await _dbServices.postapi(
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
