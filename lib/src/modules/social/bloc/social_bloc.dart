import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/strings.dart';
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
          );
        }).toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
