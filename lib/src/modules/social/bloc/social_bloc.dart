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

  @override
  SocialState get initialState => SocialInitial();

  @override
  Stream<SocialState> mapEventToState(
    SocialEvent event,
  ) async* {
    if (event is SocialPageEvent) {
      try {
        yield Loading();
        List<Item> list = await getEventDetails();
        yield DataGettedSuccessfully(obj: list);
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
      // print(response.body);
      if (response.statusCode == 200) {
        // print("statusCode 200 ***********");
        xml2json.parse(response.body);
        var jsondata = xml2json.toGData();
        var data = json.decode(jsondata);
        final data1 = data["rss"]["channel"]["item"];
        final data2 = data1 as List;
        // List? searchRes;
        // print(data2.length);

        // List<Item> list = await data2.map<Item>((i) {
        return data1.map((i) {
          return Item(
            title: i["link"],
            // description: data["rss"]["channel"]["item"][1]["description"]
            //         ["__cdata"] ??
            //     '',
            // link:
            // i["description"],
            // i["link"] ?? '',
            // i["guid"],
            // // creator:
            // i["creator"] ?? '',
            // // pubDate: data["rss"]["channel"]["item"][1]["pubDate"] ?? '',
            // // content:
            // i["content"] ?? '',
            // // pubDate:
            // i["pubget"],
            // description:
          );
        }).toList();
      } else {
        print("else+++++++++++++");
        // if (response.data.contains("Failed host lookup")) {
        //   print("inside if");
        //   throw ("Failed host lookup.");
        // } else {
        //   print("inside else");
        //   throw ("Please check your Internet Connection.");
        // }
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
