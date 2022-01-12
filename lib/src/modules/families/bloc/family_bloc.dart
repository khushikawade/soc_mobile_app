import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/modal/calendar_event_list.dart';
import 'package:Soc/src/modules/families/modal/sd_list.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:flutter/foundation.dart';
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
part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  // var data;
  FamilyBloc() : super(FamilyInitial());
  final DbServices _dbServices = DbServices();

  FamilyState get initialState => FamilyInitial();

  @override
  Stream<FamilyState> mapEventToState(
    FamilyEvent event,
  ) async* {
    if (event is FamiliesEvent) {
      try {
        // yield FamilyLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        LocalDatabase<SharedList> _localDb =
            LocalDatabase(Strings.familiesObjectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield FamilyLoading();
        } else {
          getCalendarId(_localData);
          yield FamiliesDataSucess(obj: _localData);
        }

        List<SharedList> list = await getFamilyList();
        // Syncing the Local database with remote data
        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });

        getCalendarId(list);

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        yield FamilyLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield FamiliesDataSucess(obj: list);
      } catch (e) {
        LocalDatabase<SharedList> _localDb =
            LocalDatabase(Strings.familiesObjectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localDb.close();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        getCalendarId(_localData);

        yield FamilyLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield FamiliesDataSucess(obj: _localData);
        // yield ErrorLoading();
      }
    }

    if (event is FamiliesSublistEvent) {
      try {
        // yield FamilyLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName = "${Strings.familiesSubListObjectName}${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);

        List<SharedList>? _localData = await _localDb.getData();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield FamilyLoading();
        } else {
          yield FamiliesSublistSucess(obj: _localData);
        }

        List<SharedList> list = await getFamilySubList(event.id);

        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        yield FamilyLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield FamiliesSublistSucess(obj: list);
      } catch (e) {
        String? _objectName = "${Strings.familiesSubListObjectName}${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        _localDb.close();

        yield FamilyLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield FamiliesSublistSucess(obj: _localData);
        // yield ErrorLoading(err: e);
      }
    }

    if (event is SDevent) {
      try {
        // yield FamilyLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName =
            "${Strings.staffDirectoryObjectName}_${event.categoryId ?? ''}";
        LocalDatabase<SDlist> _localDb = LocalDatabase(_objectName);

        List<SDlist>? _localData = await _localDb.getData();

        _localData.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));

        if (_localData.isEmpty) {
          yield FamilyLoading();
        } else {
          yield SDDataSucess(obj: _localData);
        }

        // Local database end

        List<SDlist> list = await getStaffList(event.categoryId);
        // Syncing the remote data to the local database.
        await _localDb.clear();
        list.forEach((SDlist e) {
          _localDb.addData(e);
        });
        // Sync end

        list.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));
        yield FamilyLoading(); //
        yield SDDataSucess(obj: list);
      } catch (e) {
        // yield ErrorLoading(err: e);
        String? _objectName =
            "${Strings.staffDirectoryObjectName}_${event.categoryId ?? ''}";
        LocalDatabase<SDlist> _localDb = LocalDatabase(_objectName);

        List<SDlist>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));
        _localDb.close();

        yield FamilyLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield SDDataSucess(obj: _localData);
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
          try {
            var temp = list[i].start.toString().contains('dateTime')
                ? list[i].start['dateTime'].toString().substring(0, 10)
                : list[i].start['date'].toString().substring(0, 10);
            if (DateTime.parse(temp).isBefore(currentDate)) {
              pastListobj.add(list[i]);
            } else {
              futureListobj.add(list[i]);
            }
          } catch (e) {}
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

  Future<List<SharedList>> getFamilyList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(Uri.encodeFull(
          'getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=Families_App__c'));
      if (response.statusCode == 200) {
        //   var dataArray = response.data["records"];
        List<SharedList> _list = response.data['body']["Items"]
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

  Future<List<SharedList>> getFamilySubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getapi(Uri.encodeFull(
          "getSubRecords?parentId=$id&parentName=Families_App__c&objectName=Family_Sub_Menu_App__c"));

      if (response.statusCode == 200) {
        List<SharedList> _list = response.data['body']["Items"]
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

  Future<List<SDlist>> getStaffList(categoryId) async {
    try {
      final ResponseModel response = await _dbServices.getapi(categoryId == null
          ? "query/?q=${Uri.encodeComponent("SELECT Title__c,Image_URL__c,Id,Name__c,Description__c, Email__c,Sort_Order__c,Phone__c,Active_Status__c FROM Staff_Directory_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}"
          : "query/?q=${Uri.encodeComponent("SELECT Title__c,Image_URL__c,Id,Name__c,Description__c, Email__c,Sort_Order__c,Phone__c,Active_Status__c FROM Staff_Directory_App__c where About_App__c = '$categoryId'")}");

      if (response.statusCode == 200) {
        List<SDlist> _list = response.data["records"]
            .map<SDlist>((i) => SDlist.fromJson(i))
            .toList();
        _list.removeWhere((SDlist element) => element.status == 'Hide');
        return _list;
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
        List dataArray = data["items"];
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
