import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/modules/social/modal/social_action_count_list.dart';
import 'package:Soc/src/overrides.dart';
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
  // final data;
  SocialBloc() : super(SocialInitial());

  SocialState get initialState => SocialInitial();

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
        } else {
          //Adding social list local data to global list
          Globals.socialList.clear();
          Globals.socialList.addAll(_localData);
          yield SocialDataSucess(obj: _localData);
        }
        // Local database end.

        List<Item> list = await getEventDetails();
        // Syncing to local database
        await _localDb.clear();
        list.forEach((Item e) {
          _localDb.addData(e);
        });
        // Syncing end.
        yield Loading(); // Mimic state change

        //Adding social list data to global list
        Globals.socialList.clear();
        Globals.socialList.addAll(list);

        yield SocialDataSucess(obj: list);
      } catch (e) {
        // Fetching from the local database instead.
        String? _objectName = "${Strings.socialObjectName}";
        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();
        yield SocialDataSucess(obj: _localData);
        // yield SocialError(err: e);
      }
    }
    if (event is FetchSocialActionCount) {
      try {
        yield Loading();
        String? _objectName = "social_action";
        // String? _objectName = "${Strings.newsObjectName}";
        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();
        // _localData.sort((a, b) => -a.completedAt.compareTo(b.completedAt));

        if (_localData.isEmpty) {
          yield Loading();
        } else {
          yield SocialActionCountSuccess(obj: _localData);
        }
        List<SocialActionCountList> list = await fetchSocialActionCount();

        List<Item> newList = [];
        newList.clear();
        if (list.length == 0) {
          newList.addAll(Globals.socialList);
        } else {
          for (int i = 0; i < Globals.socialList.length; i++) {
            for (int j = 0; j < list.length; j++) {
              if ("${Globals.socialList[i].id.toString() + Globals.socialList[i].guid['\$t']}" ==
                  list[j].socialId) {
                newList.add(Item(
                    id: Globals.socialList[i].id,
                    title: Globals.socialList[i].title,
                    description: Globals.socialList[i].description,
                    link: Globals.socialList[i].link,
                    guid: Globals.socialList[i].guid,
                    creator: Globals.socialList[i].creator,
                    pubDate: Globals.socialList[i].pubDate,
                    content: Globals.socialList[i].content,
                    mediaContent: Globals.socialList[i].mediaContent,
                    enclosure: Globals.socialList[i].enclosure,
                    likeCount: list[j].likeCount,
                    thanksCount: list[j].thanksCount,
                    helpfulCount: list[j].helpfulCount,
                    shareCount: list[j].shareCount));
                break;
              }

              if (list.length - 1 == j) {
                newList.add(Item(
                    id: Globals.socialList[i].id,
                    title: Globals.socialList[i].title,
                    description: Globals.socialList[i].description,
                    link: Globals.socialList[i].link,
                    guid: Globals.socialList[i].guid,
                    creator: Globals.socialList[i].creator,
                    pubDate: Globals.socialList[i].pubDate,
                    content: Globals.socialList[i].content,
                    mediaContent: Globals.socialList[i].mediaContent,
                    enclosure: Globals.socialList[i].enclosure,
                    likeCount: 0,
                    thanksCount: 0,
                    helpfulCount: 0,
                    shareCount: 0));
              }
            }
          }
        }
        await _localDb.clear();
        newList.forEach((Item e) {
          _localDb.addData(e);
        });

        yield SocialActionCountSuccess(obj: newList);
      } catch (e) {
        print(e);
        // yield SocialErrorReceived(err: e);
          String? _objectName = "social_action";
        // String? _objectName = "${Strings.newsObjectName}";
        LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
        List<Item> _localData = await _localDb.getData();
        // _localData.sort((a, b) => -a.completedAt.compareTo(b.completedAt));
        yield SocialActionCountSuccess(obj: _localData);
      }
    }

    if (event is SocialAction) {
      try {
        yield Loading();

        var data = await addSocailAction({
          "socialId": "${event.id}",
          // "School_App_ID__c": event.schoolId,
          "like": event.like,
          "thanks": event.thanks,
          "helpful": event.helpful,
          "share": event.shared,
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
      final link = Uri.parse("${Globals.homeObject["Social_API_URL__c"]}");
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

  Future<List<SocialActionCountList>> fetchSocialActionCount() async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://ny67869sad.execute-api.us-east-2.amazonaws.com/sandbox/getSocialAction?schoolId=${Overrides.SCHOOL_ID}'),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        //data["records"];

        return data["body"]["Items"]
            .map<SocialActionCountList>(
                (i) => SocialActionCountList.fromJson(i))
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
      final response = await http.post(
        Uri.parse(
            'https://ny67869sad.execute-api.us-east-2.amazonaws.com/sandbox/addSocialAction?schoolId=${Overrides.SCHOOL_ID}'),
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
}
