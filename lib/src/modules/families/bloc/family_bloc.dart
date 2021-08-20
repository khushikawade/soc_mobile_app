import 'dart:async';
import 'package:Soc/src/modules/families/modal/calendar_event/calendar_event_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Soc/src/modules/families/modal/family_list.dart';
import 'package:Soc/src/modules/families/modal/family_sublist.dart';
import 'package:Soc/src/modules/families/modal/stafflist.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  var data;
  FamilyBloc() : super(FamilyInitial());
  final DbServices _dbServices = DbServices();

  FamilyState get initialState => FamilyInitial();
  var dataArray;
  @override
  Stream<FamilyState> mapEventToState(
    FamilyEvent event,
  ) async* {
    if (event is FamiliesEvent) {
      try {
        yield FamilyLoading();
        List<FamiliesList> list = await getFamilyList();
        if (list.length > 0) {
          list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));
          yield FamiliesDataSucess(obj: list);
        }
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }

    if (event is FamiliesSublistEvent) {
      try {
        yield FamilyLoading();
        List<FamiliesSubList> list = await getFamilySubList(event.id);
        if (list.length > 0) {
          list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));
          yield FamiliesSublistSucess(obj: list);
        }
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }

    if (event is SDevent) {
      try {
        yield FamilyLoading();
        List<SDlist> list = await getStaffList();

        if (list.length > 0) {
          list.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));
          yield SDDataSucess(obj: list);
        }
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }

    if (event is CalendarListEvent) {
      try {
        yield FamilyLoading();
        List<CalendarEventList> list = await getCalendarEventList();
        // List<CalendarEventList>? futureListobj = [];
        // List<CalendarEventList>? pastListobj = [];
        // DateTime now = new DateTime.now();
        // final DateFormat formatter = DateFormat('yyyy-MM-dd');
        // final DateTime currentDate =
        //     DateTime.parse(formatter.format(now).toString());

        // for (int i = 0; i < list.length; i++) {
        //   DateTime temp = list[i].start!.dateTime!;

        //   if (temp.isBefore(currentDate)) {
        //     pastListobj.add(list[i]);
        //   } else {
        //     futureListobj.add(list[i]);
        //   }
        // }
        yield CalendarListSuccess(futureListobj: list, pastListobj: list);
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }
  }

  Future<List<FamiliesList>> getFamilyList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,App_Icon__c,App_Icon_URL__c,URL__c,Id,Name, Type__c, PDF_URL__c, RTF_HTML__c,Sort_Order__c FROM Families_App__c where School_App__c = '${Overrides.schoolID}'")}");
      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
            .map<FamiliesList>((i) => FamiliesList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<FamiliesSubList>> getFamilySubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,URL__c,Id,Name, Type__c, PDF_URL__c, RTF_HTML__c,Sort_Order__c FROM Family_Sub_Menu_App__c where Families_App__c='$id'")}");

      if (response.statusCode == 200) {
        return response.data["records"]
            .map<FamiliesSubList>((i) => FamiliesSubList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<SDlist>> getStaffList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,Image_URL__c,Id,Name,Description__c, Email__c,Sort_Order__c,Phone__c FROM Staff_Directory_App__c where School_App__c = '${Overrides.schoolID}'")}");

      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
            .map<SDlist>((i) => SDlist.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<CalendarEventList>> getCalendarEventList() async {
    try {
//       {
//         const String data = '''
// {
//     "kind": "calendar#events",
//     "etag": "\"p32ga1oufputf40g\"",
//     "summary": "appdevelopersdp7@gmail.com",
//     "updated": "2021-08-18T12:57:27.636Z",
//     "timeZone": "Asia/Kolkata",
//     "accessRole": "reader",
//     "defaultReminders": [],
//     "nextSyncToken": "CKCg48_PuvICEAAYASC72oe6AQ==",
//     "items": [
//         {
//             "kind": "calendar#event",
//             "etag": "\"3258582318644000\"",
//             "id": "7mco6hbb9m7r2g227if6q7gc0f",
//             "status": "confirmed",
//             "htmlLink": "https://www.google.com/calendar/event?eid=N21jbzZoYmI5bTdyMmcyMjdpZjZxN2djMGYgYXBwZGV2ZWxvcGVyc2RwN0Bt",
//             "created": "2021-08-18T12:52:39.000Z",
//             "updated": "2021-08-18T12:52:39.322Z",
//             "summary": "SOC Event",
//             "creator": {
//                 "email": "appdevelopersdp7@gmail.com",
//                 "self": true
//             },
//             "organizer": {
//                 "email": "appdevelopersdp7@gmail.com",
//                 "self": true
//             },
//             "start": {
//                 "dateTime": "2021-08-18T18:30:00+05:30"
//             },
//             "end": {
//                 "dateTime": "2021-08-18T19:30:00+05:30"
//             },
//             "iCalUID": "7mco6hbb9m7r2g227if6q7gc0f@google.com",
//             "sequence": 0,
//             "eventType": "default"
//         },
//         {
//             "kind": "calendar#event",
//             "etag": "\"3258582413458000\"",
//             "id": "36cbdc4ug2d6qtpalrnl4q00lk",
//             "status": "confirmed",
//             "htmlLink": "https://www.google.com/calendar/event?eid=MzZjYmRjNHVnMmQ2cXRwYWxybmw0cTAwbGsgYXBwZGV2ZWxvcGVyc2RwN0Bt",
//             "created": "2021-08-18T12:53:26.000Z",
//             "updated": "2021-08-18T12:53:26.729Z",
//             "summary": "School Opening Day",
//             "creator": {
//                 "email": "appdevelopersdp7@gmail.com",
//                 "self": true
//             },
//             "organizer": {
//                 "email": "appdevelopersdp7@gmail.com",
//                 "self": true
//             },
//             "start": {
//                 "date": "2021-08-20"
//             },
//             "end": {
//                 "date": "2021-08-21"
//             },
//             "transparency": "transparent",
//             "iCalUID": "36cbdc4ug2d6qtpalrnl4q00lk@google.com",
//             "sequence": 0,
//             "eventType": "default"
//         },
//         {
//             "kind": "calendar#event",
//             "etag": "\"3258582510148000\"",
//             "id": "1003p6bdnlpdokiacf3nv0iip7",
//             "status": "confirmed",
//             "htmlLink": "https://www.google.com/calendar/event?eid=MTAwM3A2YmRubHBkb2tpYWNmM252MGlpcDcgYXBwZGV2ZWxvcGVyc2RwN0Bt",
//             "created": "2021-08-18T12:54:15.000Z",
//             "updated": "2021-08-18T12:54:15.074Z",
//             "summary": "School holiday",
//             "description": "School holiday , All day",
//             "creator": {
//                 "email": "appdevelopersdp7@gmail.com",
//                 "self": true
//             },
//             "organizer": {
//                 "email": "appdevelopersdp7@gmail.com",
//                 "self": true
//             },
//             "start": {
//                 "dateTime": "2021-08-15T14:30:00+05:30"
//             },
//             "end": {
//                 "dateTime": "2021-08-15T15:30:00+05:30"
//             },
//             "iCalUID": "1003p6bdnlpdokiacf3nv0iip7@google.com",
//             "sequence": 0,
//             "eventType": "default"
//         },
//         {
//             "kind": "calendar#event",
//             "etag": "\"3258582895272000\"",
//             "id": "625kmupqj476snog5mj94c6kkt",
//             "status": "confirmed",
//             "htmlLink": "https://www.google.com/calendar/event?eid=NjI1a211cHFqNDc2c25vZzVtajk0YzZra3QgYXBwZGV2ZWxvcGVyc2RwN0Bt",
//             "created": "2021-08-18T12:57:27.000Z",
//             "updated": "2021-08-18T12:57:27.636Z",
//             "summary": "Holiday Announcement",
//             "description": "Holiday Announcement",
//             "creator": {
//                 "email": "appdevelopersdp7@gmail.com",
//                 "self": true
//             },
//             "organizer": {
//                 "email": "appdevelopersdp7@gmail.com",
//                 "self": true
//             },
//             "start": {
//                 "dateTime": "2021-08-08T01:30:00+05:30"
//             },
//             "end": {
//                 "dateTime": "2021-08-08T02:30:00+05:30"
//             },
//             "iCalUID": "625kmupqj476snog5mj94c6kkt@google.com",
//             "sequence": 0,
//             "eventType": "default"
//         }
//         ''';
//       }

      // var dio = Dio();
      // Response response = await dio.get(
      //   'https://www.googleapis.com/calendar/v3/calendars/${Overrides.calendar_API}/events?key=AIzaSyBZ27PUuzJBxZ2BpmMk-wJxLm6WGJK2Z2M',
      //   options: Options(
      //     headers: {},
      //   ),
      // );

      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/calendar/v3/calendars/${Overrides.calendar_Id}/events?key=AIzaSyBZ27PUuzJBxZ2BpmMk-wJxLm6WGJK2Z2M'),
      );
      // final response = json.decode(data);
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        dataArray = data["items"];
        return dataArray
            .map<CalendarEventList>((i) => CalendarEventList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
