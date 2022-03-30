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
          print("social list length=>${list.length}");
          if (_localData.isEmpty) {
            print("local database empty sending SocialInitalState");
            yield SocialInitialState(obj: list);
          }
        } else {
          print(event.action);
          list = _localData;
        }

        // Action count list
        print("now calling count list");
        List<ActionCountList> listActioncount = await fetchSocialActionCount();
        print("count data response done");
        List<Item> newList = [];
        newList.clear();
        if (listActioncount.length == 0) {
          newList.addAll(list);
        } else {
          for (int i = 0; i < list.length; i++) {
            for (int j = 0; j < listActioncount.length; j++) {
              if (list[i].guid['\$t'] + Overrides.SCHOOL_ID ==
                      list[j].id

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
        print("calling local database");
        await _localDb.clear();
        newList.forEach((Item e) {
          _localDb.addData(e);
        });
        print("calling local database done");
        print("new list length =>${newList.length}");
        // Syncing end.
        // Globals.socialList.clear();
        // Globals.socialList.addAll(list);
        yield Loading();
        print("sending SocialDataSucess");
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
          "Test_School__c": Globals.appSetting.isTestSchool
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
      print(Globals.appSetting.socialapiurlc);
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
        print("200");
        var data = response.data["body"];
        final _allNotificationsAction = data;
        //  listActioncount.clear();
        final data1 = _allNotificationsAction;
        return data1
            .map<ActionCountList>((i) => ActionCountList.fromJson(i))
            .toList();
      } else {
        print("xxxxxxxxxxxxxxxxxx");
        throw ('something_went_wrong');
      }
    } catch (e) {
      print("000000000000");
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

















// class SocialBloc extends Bloc<SocialEvent, SocialState> {
//   // final data;

//   SocialBloc() : super(SocialInitial());

//   SocialState get initialState => SocialInitial();
//   final DbServices _dbServices = DbServices();
//   @override
//   Stream<SocialState> mapEventToState(
//     SocialEvent event,
//   ) async* {
//     if (event is SocialPageEvent) {
//       try {
//         //social list
//         // yield Loading();
//         // // yield Loading(); Should not show loading, instead fetch the data from the Local database and return the list instantly.
//         // String? _objectName = "${Strings.socialObjectName}";
//         // LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
//         // List<Item>? _localData = await _localDb.getData();

//         // if (_localData.isEmpty) {
//         //   yield Loading();
//         // } else {
//         //   //Adding social list local data to global list
//         //   Globals.socialList.clear();
//         //   Globals.socialList.addAll(_localData);
//         //   yield SocialDataSucess(obj: _localData);
//         // }
//         // Local database end.

//         // yield Loading(); Should not show loading, instead fetch the data from the Local database and return the list instantly.
//         String? _objectName = "${Strings.socialObjectName}";
//         LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
//         List<Item> _localData = await _localDb.getData();

//         if (_localData.isEmpty) {
//           yield Loading();
//         } else if (event.reLoad == true) {
//           yield Reload(obj: _localData);
//         } else {
//           yield SocialDataSucess(obj: _localData);
//         }
//         // Local database end.

//         //getting both list response
//         //social list
//         List<Item> list = await getEventDetails();

//         // Action count list
//         List<ActionCountList> listActioncount = await fetchSocialActionCount();
//         List<Item> newList = [];
//         newList.clear();
//         if (listActioncount.length == 0) {
//           newList.addAll(list);
//         } else {
//           for (int i = 0; i < list.length; i++) {
//             for (int j = 0; j < listActioncount.length; j++) {
//               if ("${list[i].id.toString() + list[i].guid['\$t'] + Overrides.SCHOOL_ID}" ==
//                   listActioncount[j].notificationId) {
//                 newList.add(Item(
//                     id: list[i].id,
//                     title: list[i].title,
//                     description: list[i].description,
//                     link: list[i].link,
//                     guid: list[i].guid,
//                     creator: list[i].creator,
//                     pubDate: list[i].pubDate,
//                     content: list[i].content,
//                     mediaContent: list[i].mediaContent,
//                     enclosure: list[i].enclosure,
//                     likeCount: listActioncount[j].likeCount,
//                     thanksCount: listActioncount[j].thanksCount,
//                     helpfulCount: listActioncount[j].helpfulCount,
//                     shareCount: listActioncount[j].shareCount));
//                 break;
//               }

//               if (listActioncount.length - 1 == j) {
//                 newList.add(Item(
//                     id: list[i].id,
//                     title: list[i].title,
//                     description: list[i].description,
//                     link: list[i].link,
//                     guid: list[i].guid,
//                     creator: list[i].creator,
//                     pubDate: list[i].pubDate,
//                     content: list[i].content,
//                     mediaContent: list[i].mediaContent,
//                     enclosure: list[i].enclosure,
//                     likeCount: 0,
//                     thanksCount: 0,
//                     helpfulCount: 0,
//                     shareCount: 0));
//               }
//             }
//           }
//         }

//         // Syncing to local database
//         await _localDb.clear();
//         newList.forEach((Item e) {
//           _localDb.addData(e);
//         });
//         // Syncing end.
//         Globals.socialList.clear();
//         Globals.socialList.addAll(list);
//         yield Loading();
//         yield SocialDataSucess(obj: newList, );
//       } catch (e) {
//         // Fetching from the local database instead.
//         String? _objectName = "${Strings.socialObjectName}";
//         LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
//         List<Item> _localData = await _localDb.getData();
//         yield SocialDataSucess(obj: _localData,);
//         // yield SocialError(err: e);

//       }

//       // try {
//       //   // yield Loading(); Should not show loading, instead fetch the data from the Local database and return the list instantly.
//       //   String? _objectName = "${Strings.socialObjectName}";
//       //   LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
//       //   List<Item> _localData = await _localDb.getData();

//       //   if (_localData.isEmpty) {
//       //     yield Loading();
//       //   } else {
//       //     //Adding social list local data to global list
//       //     Globals.socialList.clear();
//       //     Globals.socialList.addAll(_localData);
//       //     yield SocialDataSucess(obj: _localData);
//       //   }
//       //   // Local database end.

//       //   List<Item> list = await getEventDetails();
//       //   // Syncing to local database
//       //   await _localDb.clear();
//       //   list.forEach((Item e) {
//       //     _localDb.addData(e);
//       //   });
//       //   // Syncing end.
//       //   yield Loading(); // Mimic state change

//       //   //Adding social list data to global list
//       //   Globals.socialList.clear();
//       //   Globals.socialList.addAll(list);

//       //   yield SocialDataSucess(obj: list);
//       // } catch (e) {
//       //   // Fetching from the local database instead.
//       //   String? _objectName = "${Strings.socialObjectName}";
//       //   LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
//       //   List<Item> _localData = await _localDb.getData();
//       //   yield SocialDataSucess(obj: _localData);
//       //   // yield SocialError(err: e);
//       // }
//     }

//     // if (event is FetchSocialActionCount) {
//     //   try {
//     //     yield Loading();
//     //     String? _objectName = "social_action";
//     //     // String? _objectName = "${Strings.newsObjectName}";
//     //     LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
//     //     List<Item> _localData = await _localDb.getData();

//     //     //To fetch the latest count if returning back from detail page
//     //     if (event.isDetailPage == false) {
//     //       if (_localData.isEmpty) {
//     //         yield Loading();
//     //       } else {
//     //         yield SocialActionCountSuccess(obj: _localData);
//     //       }
//     //     }
//     //     List<ActionCountList> list = await fetchSocialActionCount();

//     //     List<Item> newList = [];
//     //     newList.clear();
//     //     if (list.length == 0) {
//     //       newList.addAll(Globals.socialList);
//     //     } else {
//     //       for (int i = 0; i < Globals.socialList.length; i++) {
//     //         for (int j = 0; j < list.length; j++) {
//     //           if ("${Globals.socialList[i].id.toString() + Globals.socialList[i].guid['\$t']}" ==
//     //               list[j].notificationId) {
//     //             newList.add(Item(
//     //                 id: Globals.socialList[i].id,
//     //                 title: Globals.socialList[i].title,
//     //                 description: Globals.socialList[i].description,
//     //                 link: Globals.socialList[i].link,
//     //                 guid: Globals.socialList[i].guid,
//     //                 creator: Globals.socialList[i].creator,
//     //                 pubDate: Globals.socialList[i].pubDate,
//     //                 content: Globals.socialList[i].content,
//     //                 mediaContent: Globals.socialList[i].mediaContent,
//     //                 enclosure: Globals.socialList[i].enclosure,
//     //                 likeCount: list[j].likeCount,
//     //                 thanksCount: list[j].thanksCount,
//     //                 helpfulCount: list[j].helpfulCount,
//     //                 shareCount: list[j].shareCount));
//     //             break;
//     //           }

//     //           if (list.length - 1 == j) {
//     //             newList.add(Item(
//     //                 id: Globals.socialList[i].id,
//     //                 title: Globals.socialList[i].title,
//     //                 description: Globals.socialList[i].description,
//     //                 link: Globals.socialList[i].link,
//     //                 guid: Globals.socialList[i].guid,
//     //                 creator: Globals.socialList[i].creator,
//     //                 pubDate: Globals.socialList[i].pubDate,
//     //                 content: Globals.socialList[i].content,
//     //                 mediaContent: Globals.socialList[i].mediaContent,
//     //                 enclosure: Globals.socialList[i].enclosure,
//     //                 likeCount: 0,
//     //                 thanksCount: 0,
//     //                 helpfulCount: 0,
//     //                 shareCount: 0));
//     //           }
//     //         }
//     //       }
//     //     }
//     //     await _localDb.clear();
//     //     newList.forEach((Item e) {
//     //       _localDb.addData(e);
//     //     });

//     //     yield SocialActionCountSuccess(obj: newList);
//     //   } catch (e) {
//     //     print(e);
//     //     // yield SocialErrorReceived(err: e);
//     //     String? _objectName = "social_action";
//     //     // String? _objectName = "${Strings.newsObjectName}";
//     //     LocalDatabase<Item> _localDb = LocalDatabase(_objectName);
//     //     List<Item> _localData = await _localDb.getData();
//     //     // _localData.sort((a, b) => -a.completedAt.compareTo(b.completedAt));
//     //     yield SocialActionCountSuccess(obj: _localData);
//     //   }
//     // }

//     if (event is SocialAction) {
//       try {
//         yield Loading();

//         var data = await addSocailAction({
//           "Notification_Id__c":
//               event.id! + Overrides.SCHOOL_ID,
//           "Title__c": "${event.title}",
//           "Like__c": "${event.like}",
//           "Thanks__c": "${event.thanks}",
//           "Helpful__c": "${event.helpful}",
//           "Share__c": "${event.shared}",
//           "Test_School__c": Globals.appSetting.isTestSchool
//         });
//         yield SocialActionSuccess(
//           obj: data,
//         );
//       } catch (e) {
//         yield SocialErrorReceived(err: e);
//       }
//     }
//   }

//   Future getEventDetails() async {
//     try {
//      //  final link = Uri.parse("https://rss.app/feeds/1qKh7lUVpzyCuWOP.xml");
//       final link = Uri.parse("${Globals.appSetting.socialapiurlc}");
//       Xml2Json xml2json = new Xml2Json();
//       http.Response response = await http.get(link);
//       if (response.statusCode == 200) {
//         xml2json.parse(response.body);
//         final jsondata = xml2json.toGData();
//         final data = json.decode(jsondata);
//         final data1 = data["rss"]["channel"]["item"];
//         final data2 = data1 as List;
//         return data2.map((i) {
//           return Item(
//               title: i["title"] ?? '',
//               description: i["description"] ?? '',
//               link: i["link"] ?? '',
//               guid: i['guid'] ?? '',
//               creator: i['dc\$creator'] ?? '',
//               pubDate: i['pubDate'] ?? '',
//               content: i['content'] ?? '',
//               enclosure: i['enclosure'] ?? '',
//               mediaContent: i['media\$content'] ?? '',
//               id: Utility.generateUniqueId(i['pubDate']['\$t']));
//         }).toList();
//       } else {
//         throw ('something_went_wrong');
//       }
//     } catch (e) {
//       throw (e);
//     }
//   }

//   Future<List<ActionCountList>> fetchSocialActionCount() async {
//     try {
//       final ResponseModel response = await
//            _dbServices.postapi(Uri.parse(
//               'dummyFunction?schoolId=${Overrides.SCHOOL_ID}&objectName=Social'
//               ));
//           // _dbServices.getapi(Uri.parse(
//           //     'getUserAction?schoolId=${Overrides.SCHOOL_ID}&objectName=Social'));
//       if (response.statusCode == 200) {
//         var data = response.data["body"];
//         final _allNotificationsAction = data;
//         //  listActioncount.clear();
//         final data1 = _allNotificationsAction;
//         return data1
//             .map<ActionCountList>((i) => ActionCountList.fromJson(i))
//             .toList();
//       } else {
//         throw ('something_went_wrong');
//       }
//     } catch (e) {
//       throw (e);
//     }
//   }

//   Future addSocailAction(body) async {
//     try {
//       final ResponseModel response = await _dbServices.postapi(
//           "addUserAction?schoolId=${Overrides.SCHOOL_ID}&objectName=Social&withTimeStamp=false",
//           body: body);

//       if (response.statusCode == 200) {
//         var res = response.data;
//         var data = res["statusCode"];
//         return data;
//       } else {
//         throw ('something_went_wrong');
//       }
//     } catch (e) {
//       throw (e);
//     }
//   }
// }
