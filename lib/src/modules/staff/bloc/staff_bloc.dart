import 'dart:async';
import 'package:Soc/src/modules/staff/models/staffmodal.dart';
import 'package:Soc/src/modules/staff/models/staff_sublist.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../globals.dart';
part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc() : super(StaffInitial());
  final DbServices _dbServices = DbServices();

  StaffState get initialState => StaffInitial();

  @override
  Stream<StaffState> mapEventToState(
    StaffEvent event,
  ) async* {
    if (event is StaffPageEvent) {
      try {
        yield StaffLoading();
        List<StaffList> list = await getStaffDetails();
        getCalendarId(list);
        if (list.length > 0) {
          list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));
          yield StaffDataSucess(
            obj: list,
          );
        }else{yield StaffDataSucess(
            obj: list,
          );}
      } catch (e) {
        yield ErrorInStaffLoading(err: e);
      }
    }

    if (event is StaffSubListEvent) {
      try {
        yield StaffLoading();
        List<StaffSubList> list = await getStaffSubList(event.id);
        if (list.length > 0) {
          list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));
          yield StaffSubListSucess(
            obj: list,
          );
        }else{yield StaffSubListSucess(
            obj: list,
          );}
      } catch (e) {
        yield ErrorInStaffLoading(err: e);
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

  Future<List<StaffList>> getStaffDetails() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,URL__c,Id,Name,PDF_URL__c,App_Icon_URL__c,Type__c, App_Icon__c,RTF_HTML__c,Sort_Order__c,Calendar_Id__c FROM Staff_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        return response.data["records"]
            .map<StaffList>((i) => StaffList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<StaffSubList>> getStaffSubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,URL__c,Id,Name,PDF_URL__c,Type__c,RTF_HTML__c,Sort_Order__c,App_Icon_URL__c  FROM Staff_Sub_Menu_App__c where   Staff_App__c ='$id'")}");
      if (response.statusCode == 200) {
        return response.data["records"]
            .map<StaffSubList>((i) => StaffSubList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
