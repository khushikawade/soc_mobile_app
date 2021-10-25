import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/about/modal/family_list.dart';
import 'package:Soc/src/modules/about/modal/family_sublist.dart';
import 'package:Soc/src/modules/about/modal/stafflist.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
part 'about_event.dart';
part 'about_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  // var data;
  AboutBloc() : super(AboutInitial());
  final DbServices _dbServices = DbServices();

  AboutState get initialState => AboutInitial();
  var dataArray;
  @override
  Stream<AboutState> mapEventToState(
    AboutEvent event,
  ) async* {
    if (event is AboutEvent) {
      try {
        yield AboutLoading();
        List<AboutList> list = await getAboutList();

        getCalendarId(list);

        if (list.length > 0) {
          list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));

          yield AboutDataSucess(obj: list);
        } else {
          yield AboutDataSucess(obj: list);
        }
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }

    if (event is AboutSublistEvent) {
      try {
        yield AboutLoading();
        List<AboutSubList> list = await getAboutSubList(event.id);
        if (list.length > 0) {
          list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));

          yield AboutSublistSucess(obj: list);
        } else {
          yield AboutSublistSucess(obj: list);
        }
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }

    // if (event is SDevent) {
    //   try {
    //     yield AboutLoading();
    //     List<SDlist> list = await getStaffList();

    //     if (list.length > 0) {
    //       list.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));
    //       yield SDDataSucess(obj: list);
    //     } else {
    //       yield SDDataSucess(obj: list);
    //     }
    //   } catch (e) {
    //     yield ErrorLoading(err: e);
    //   }
    // }

  //   if (event is CalendarListEvent) {
  //     try {
  //       yield AboutLoading();
  //       List<CalendarEventList> list = await getCalendarEventList();
  //       List<CalendarEventList>? futureListobj = [];
  //       List<CalendarEventList>? pastListobj = [];
  //       DateTime now = new DateTime.now();
  //       final DateFormat formatter = DateFormat('yyyy-MM-dd');
  //       final DateTime currentDate =
  //           DateTime.parse(formatter.format(now).toString());
  //       for (int i = 0; i < list.length; i++) {
  //         try {
  //           var temp = list[i].start.toString().contains('dateTime')
  //               ? list[i].start['dateTime'].toString().substring(0, 10)
  //               : list[i].start['date'].toString().substring(0, 10);
  //           if (DateTime.parse(temp).isBefore(currentDate)) {
  //             pastListobj.add(list[i]);
  //           } else {
  //             futureListobj.add(list[i]);
  //           }
  //         } catch (e) {}
  //       }
  //       yield CalendarListSuccess(
  //           futureListobj: futureListobj, pastListobj: pastListobj);
  //     } catch (e) {
  //       yield ErrorLoading(err: e);
  //     }
  //   }
  // }
  }

  getCalendarId(list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].calendarId != null && list[i].calendarId != "") {
        Globals.calendar_Id = list[i].calendarId;
        break;
      }
    }
  }

  Future<List<AboutList>> getAboutList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,App_Icon__c,App_Icon_URL__c,URL__c,Id,Name, Type__c, PDF_URL__c, RTF_HTML__c,Sort_Order__c,Calendar_Id__c,Active_Status__c FROM About_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
            .map<AboutList>((i) => AboutList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<AboutSubList>> getAboutSubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,URL__c,Id,Name, Type__c, PDF_URL__c, RTF_HTML__c,Sort_Order__c,App_Icon_URL__c,Active_Status__c FROM About_Sub_Menu_App__c where About_App__c='$id'")}");

      if (response.statusCode == 200) {
        return response.data["records"]
            .map<AboutSubList>((i) => AboutSubList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  // Future<List<SDlist>> getStaffList() async {
  //   try {
  //     final ResponseModel response = await _dbServices.getapi(
  //         "query/?q=${Uri.encodeComponent("SELECT Title__c,Image_URL__c,Id,Name__c,Description__c, Email__c,Sort_Order__c,Phone__c FROM Staff_Directory_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");

  //     if (response.statusCode == 200) {
  //       dataArray = response.data["records"];
  //       return response.data["records"]
  //           .map<SDlist>((i) => SDlist.fromJson(i))
  //           .toList();
  //     } else {
  //       throw ('something_went_wrong');
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  // Future<List<CalendarEventList>> getCalendarEventList() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://www.googleapis.com/calendar/v3/calendars/${Globals.calendar_Id}/events?key=AIzaSyBZ27PUuzJBxZ2BpmMk-wJxLm6WGJK2Z2M'),
  //     );
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       dataArray = data["items"];
  //       return dataArray
  //           .map<CalendarEventList>((i) => CalendarEventList.fromJson(i))
  //           .toList();
  //     } else {
  //       throw ('something_went_wrong');
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }
}
