import 'dart:async';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xml2json/xml2json.dart';
import '../../../overrides.dart' as overrides;
import 'dart:convert';
import 'package:http/http.dart' as http;
part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  var data;
  SocialBloc() : super(SocialInitial());

  SocialState get initialState => SocialInitial();

  @override
  Stream<SocialState> mapEventToState(
    SocialEvent event,
  ) async* {
    if (event is SocialPageEvent) {
      try {
        yield Loading();
        List<Item> list = await getEventDetails();
        yield SocialDataSucess(obj: list);
      } catch (e) {
        yield Errorinloading(err: e);
      }
    }
  }

  Future getEventDetails() async {
    try {
      var link = Uri.parse("${overrides.Overrides.socialPagexmlUrl}");
      Xml2Json xml2json = new Xml2Json();
      http.Response response = await http.get(link);
      if (response.statusCode == 200) {
        xml2json.parse(response.body);
        var jsondata = xml2json.toGData();
        var data = json.decode(jsondata);
        final data1 = data["rss"]["channel"]["item"];
        final data2 = data1 as List;
        return data1.map((i) {
          return Item(
            title: i["title"] ?? '',
            description: i["description"] ?? '',
            link: i["link"] ?? '',
            guid: i['guid'] ?? '',
            creator: i['creator'] ?? '',
            pubDate: i['pubDate'] ?? '',
            content: i['content'] ?? '',
          );
        }).toList();
      } else {
        print("else");
      }
    } catch (e) {
      print(e);

      print(e.toString().contains("Failed host lookup"));
      if (e.toString().contains("Failed host lookup")) {
        print(e);
        print("inside if");
        throw ("Please check your Internet Connection.");
      } else {
        throw (e);
      }
    }
  }
}
