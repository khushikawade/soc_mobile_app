import 'dart:async';
import 'package:app/src/modules/social/modal/socialmodal.dart';
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
      print("SocialPageEvent ");
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
      xml2json.parse(response.body);
      var jsondata = xml2json.toGData();
      var data = json.decode(jsondata);
      print("*************************************************");
      print(data);
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

      if (response.statusCode == 200) {
        // final data = response.data;
        // final data2 = data as List;

        return data.map((i) {
          return SocialModel(
              tittle: i["rss"]["channel"]["item"][i]["title"]["tittle"]
                  ["tittle"],
              pubget: i["pubget"],
              description: i["description"]);
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
