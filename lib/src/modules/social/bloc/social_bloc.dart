import 'dart:async';

import 'package:Soc/src/modules/social/modal/models/channel.dart';
import 'package:Soc/src/modules/social/modal/models/item.dart';
import 'package:Soc/src/modules/social/modal/socialmodal.dart';
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
      // print("SocialPageEvent ");
      try {
        yield Loading();
        final cred = SocialPageEvent();
        data = getEventDetails();
        yield DataGettedSuccessfully();
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
      // xml2json.parse(response.body);
      // var jsondata = xml2json.toGData();

      // var data = json.decode(jsondata);
      // print("************************DATA*************************");
      // print(data);
      // var dio = Dio();
      // Response response = await dio.get(
      //   "${overrides.Overrides.socialPagexmlUrl}",
      //   options: Options(
      //     headers: {
      //       'Accept': 'application/json',
      //       // 'Authorization': 'Bearer ${globals.token}'
      //     },
      //   ),
      // );

      print(response.body);
      if (response.statusCode == 200) {
        print("statusCode 200 ***********");
        xml2json.parse(response.body);
        var jsondata = xml2json.toGData();

        var data = json.decode(jsondata);

        print(data);

        // var headline;
        // List? socialList = [];
        // var jsondata = data["rss"];
        // Map<String, dynamic> userMap = jsonDecode(jsondata);
        // var user = Welcome.fromJson(userMap);
        // print("************USER *****************");
        // print(user);

        // print('Howdy, ${user.rss!.channel!.item![0].title}!');

        // for (int i = 0; i < jsondata.length; i++) {
        //   headline =
        //       data["rss"]["channel"]["item"][i]["title"]["__cdata"] ?? '';
        //   print(headline);
        //   socialList.add(headline);
        //   // print(socialList);
        //   print(i);
        // }

        // print(" ***********HeadLine*****************");
        // print(searchRes);
        // return searchRes;
        // var headline = data["rss"]["channel"]["item"][1]["title"]["__cdata"];
        // print(headline);
        // Welcome obj = welcomeFromJson(jsondata);
        // return obj;

        // print(
        //     "**********************************headline ****************************************");

        final data1 = data;
        final data2 = data1 as List;
        List? searchRes;

        List<Item> list = await data2.map<Item>((i) {
          print("inside LIST");
          return Item(
            title: data["rss"]["channel"]["item"][1]["title"]["__cdata"] ?? '',
            description: data["rss"]["channel"]["item"][1]["description"]
                    ["__cdata"] ??
                '',
            link: data["rss"]["channel"]["item"][1]["link"] ?? '',
            creator:
                data["rss"]["channel"]["item"][1]["creator"]["__cdata"] ?? '',
            pubDate: data["rss"]["channel"]["item"][1]["pubDate"] ?? '',
            content: data["rss"]["channel"]["item"][1]["content"] ?? '',
            // pubget: i["pubget"],
            // description: i["description"]
          );
        }).toList();
      } else {
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
