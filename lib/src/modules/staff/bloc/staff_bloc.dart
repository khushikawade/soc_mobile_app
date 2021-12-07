import 'dart:async';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/modules/staff/models/staff_sublist.dart';
import 'package:Soc/src/modules/staff/models/staffmodal.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
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
        // yield StaffLoading();
        // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        LocalDatabase<SharedList> _localDb =
            LocalDatabase(Strings.staffObjectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield StaffLoading();
        } else {
          getCalendarId(_localData);
          yield StaffDataSucess(obj: _localData);
        }

        List<SharedList> list = await getStaffDetails();
        getCalendarId(list);

        // Syncing the Local database with remote data
        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        yield StaffLoading();
        yield StaffDataSucess(
          obj: list,
        );
      } catch (e) {
        print(e);
        // yield ErrorInStaffLoading(err: e);
        LocalDatabase<SharedList> _localDb =
            LocalDatabase(Strings.staffObjectName);

        List<SharedList>? _localData = await _localDb.getData();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        _localDb.close();
        getCalendarId(_localData);
        yield StaffLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield StaffDataSucess(obj: _localData);
      }
    }

    if (event is StaffSubListEvent) {
      try {
        // yield StaffLoading();
        // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName = "${Strings.staffSubListObjectName}${event.id}";

        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield StaffLoading();
        } else {
          yield StaffSubListSucess(obj: _localData);
        }
        //Local Database End

        List<SharedList> list = await getStaffSubList(event.id);

        // Syncing the Local database with remote data
        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        yield StaffLoading();
        yield StaffSubListSucess(
          obj: list,
        );
      } catch (e) {
        // Fetching the data from the Local database instead.
        String? _objectName = "${Strings.staffSubListObjectName}${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        _localDb.close();

        yield StaffLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield StaffSubListSucess(obj: _localData);
        // yield ErrorInStaffLoading(err: e);
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

  Future<List<SharedList>> getStaffDetails() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,URL__c,Id,Name,PDF_URL__c,App_Icon_URL__c,Type__c, App_Icon__c,RTF_HTML__c,Sort_Order__c,Calendar_Id__c,Active_Status__c FROM Staff_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        List<SharedList> _list = response.data["records"]
            .map<SharedList>((i) => SharedList.fromJson(i))
            .toList();
        _list.removeWhere((SharedList element) => element.status == 'Hide');
        return _list;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<SharedList>> getStaffSubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,URL__c,Id,Name,PDF_URL__c,Type__c,RTF_HTML__c,Sort_Order__c,App_Icon_URL__c,Active_Status__c  FROM Staff_Sub_Menu_App__c where   Staff_App__c ='$id'")}");
      if (response.statusCode == 200) {
        List<SharedList> _list = response.data["records"]
            .map<SharedList>((i) => SharedList.fromJson(i))
            .toList();
        _list.removeWhere((SharedList element) => element.status == 'Hide');
        return _list;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
