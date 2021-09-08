import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/modal/calendar_event_list.dart';
import 'package:Soc/src/modules/families/modal/family_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Soc/src/modules/families/modal/family_sublist.dart';
import 'package:Soc/src/modules/families/modal/stafflist.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
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

        getCalendarId(list);

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
        // bool isempty;
        // for (final i in list) {
        //   if (list[i].sortOredr == null) {
        //     isempty = true;
        //   }
        // }

        // if (list.length > 0) {
        //   list.sort((a, b) => a.sortOredr != null && a.sortOredr != ""
        //       ? a.sortOredr.compareTo(b.sortOredr)
        //       : '');
        // }
        yield FamiliesSublistSucess(obj: list);
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
        List<CalendarEventList>? futureListobj = [];
        List<CalendarEventList>? pastListobj = [];
        DateTime now = new DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final DateTime currentDate =
            DateTime.parse(formatter.format(now).toString());
        for (int i = 0; i < list.length; i++) {
          var temp = list[i].start.toString().contains('dateTime')
              ? list[i].start['dateTime'].toString().substring(0, 10)
              : list[i].start['date'].toString().substring(0, 10);
          if (DateTime.parse(temp).isBefore(currentDate)) {
            pastListobj.add(list[i]);
          } else {
            futureListobj.add(list[i]);
          }
        }
        yield CalendarListSuccess(
            futureListobj: futureListobj, pastListobj: pastListobj);
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }
  }

  getCalendarId(list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].calendarId != null && list[i].calendarId != "") {
        Globals.calendar_Id = list[i].calendarId;
        break;
      }
    }
  }

  Future<List<FamiliesList>> getFamilyList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,App_Icon__c,App_Icon_URL__c,URL__c,Id,Name, Type__c, PDF_URL__c, RTF_HTML__c,Sort_Order__c,Calendar_Id__c FROM Families_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
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
          "query/?q=${Uri.encodeComponent("SELECT Title__c,Image_URL__c,Id,Name,Description__c, Email__c,Sort_Order__c,Phone__c FROM Staff_Directory_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");

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
      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/calendar/v3/calendars/${Globals.calendar_Id}/events?key=AIzaSyBZ27PUuzJBxZ2BpmMk-wJxLm6WGJK2Z2M'),
      );
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
