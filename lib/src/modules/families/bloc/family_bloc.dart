import 'dart:async';
import 'package:Soc/src/modules/families/modal/calendar_list.dart';
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
        List<CalendarList> list = await getCalendarEventList();

        yield CalendarListSuccess(obj: list);
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

  Future<List<CalendarList>> getCalendarEventList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,Start_Date__c,End_Date__c, Invite_Link__c, Description__c FROM Calendar_Events_App__c where School_App__c = '${Overrides.schoolID}'")}");

      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
            .map<CalendarList>((i) => CalendarList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
