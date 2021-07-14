// import 'dart:async';
// import 'package:Soc/src/modules/social/modal/models/item.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:xml2json/xml2json.dart';
// import '../../../overrides.dart' as overrides;
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// part 'student_event.dart';
// part 'student_state.dart';

// class StudentBloc extends Bloc<StudentEvent, StudentState> {
//   var data;
//   StudentBloc() : super(StudentInitial());

//   @override
//   StudentState get initialState => StudentInitial();

//   @override
//   Stream<StudentState> mapEventToState(
//     StudentEvent event,
//   ) async* {
//     if (event is StudentPageEvent) {
//       try {
//         yield Loading();
//         List<Item> list = await getEventDetails();
//         yield DataGettedSuccessfully(obj: list);
//       } catch (e) {
//         yield Errorinloading(err: e);
//       }
//     }
//   }

//   Future getEventDetails() async {
//     try {
//       // var link = Uri.parse(https://solvedconsultingdev--flutter.my.salesforce.com/services/data/v52.0);
//       // Xml2Json xml2json = new Xml2Json();
//       // http.Response response = await http.get(link);
//       // print(response.body);
//       // if (response.statusCode == 200) {
//       //   print("statusCode 200 ***********");
//       //   xml2json.parse(response.body);
//       //   var jsondata = xml2json.toGData();
//       //   var data = json.decode(jsondata);
//       //   final data1 = data["rss"]["channel"]["item"];
//       //   final data2 = data1 as List;
//       //   // List? searchRes;
//       //   print(data2.length);

//       //   // List<Item> list = await data2.map<Item>((i) {
//       //   return data1.map((i) {
//       //     return Item(
//       //       title: i["link"],
//       //       // description: data["rss"]["channel"]["item"][1]["description"]
//       //       //         ["__cdata"] ??
//       //       //     '',
//       //       // link:
//       //       // i["description"],
//       //       // i["link"] ?? '',
//       //       // i["guid"],
//       //       // // creator:
//       //       // i["creator"] ?? '',
//       //       // // pubDate: data["rss"]["channel"]["item"][1]["pubDate"] ?? '',
//       //       // // content:
//       //       // i["content"] ?? '',
//       //       // // pubDate:
//       //       // i["pubget"],
//       //       // description:
//       //     );
//       //   }).toList();
//       } else {
//         print("else+++++++++++++");
//         // if (response.data.contains("Failed host lookup")) {
//         //   print("inside if");
//         //   throw ("Failed host lookup.");
//         // } else {
//         //   print("inside else");
//         //   throw ("Please check your Internet Connection.");
//         // }
//       }
//     } catch (e) {
//       print(e);

//       print(e.toString().contains("Failed host lookup"));
//       if (e.toString().contains("Failed host lookup")) {
//         print(e);
//         print("inside if");
//         throw ("Please check your Internet Connection.");
//       } else {
//         throw (e);
//       }
//     }
//   }
// }
