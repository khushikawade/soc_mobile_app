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
import 'package:Soc/src/services/utility.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../families/modal/calendar_banner_image_modal.dart';
import '../../google_drive/overrides.dart';
part 'custom_event.dart';
part 'custom_state.dart';

class CustomBloc extends Bloc<CustomEvent, CustomState> {
  CustomBloc() : super(CustomInitial());
  final DbServices _dbServices = DbServices();
  CustomState get initialState => CustomInitial();
  List<CalendarEventList>? futureListobj = [];
  List<CalendarEventList>? pastListobj = [];

  @override
  Stream<CustomState> mapEventToState(
    CustomEvent event,
  ) async* {
    if (event is CustomEvents) {
      try {
        // yield CustomLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName = "${Strings.customObjectName}${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);
        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield CustomLoading();
        } else {
          getCalendarId(_localData);
          yield CustomDataSuccess(obj: _localData);
        }

        List<SharedList> list = await getCustomList(event.id);
        // Syncing the Local database with remote data
        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });
        getCalendarId(list);

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        yield CustomLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield CustomDataSuccess(obj: list);
      } catch (e) {
        String? _objectName = "${Strings.customObjectName}${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);
        List<SharedList>? _localData = await _localDb.getData();
        _localDb.close();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        getCalendarId(_localData);

        yield CustomLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield CustomDataSuccess(obj: _localData);
        // yield ErrorLoading();
      }
    }

    if (event is CustomSublistEvent) {
      try {
        // yield CustomLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName = "${Strings.customSubListObjectName}${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);
        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield CustomLoading();
        } else {
          yield CustomSublistSuccess(obj: _localData);
        }

        List<SharedList> list = await getCustomSubList(event.id);

        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        yield CustomLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield CustomSublistSuccess(obj: list);
      } catch (e) {
        String? _objectName = "${Strings.customSubListObjectName}${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);
        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        _localDb.close();

        yield CustomLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield CustomSublistSuccess(obj: _localData);
        // yield ErrorLoading(err: e);
      }
    }

    if (event is SDevent) {
      try {
        // yield CustomLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName =
            "${Strings.staffDirectoryObjectName}_${event.categoryId ?? ''}";
        LocalDatabase<SDlist> _localDb = LocalDatabase(_objectName);
        List<SDlist>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));

        if (_localData.isEmpty) {
          yield CustomLoading();
        } else {
          yield SDDataSuccess(obj: _localData);
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
        yield CustomLoading(); //
        yield SDDataSuccess(obj: list);
      } catch (e) {
        // yield ErrorLoading(err: e);
        String? _objectName =
            "${Strings.staffDirectoryObjectName}_${event.categoryId ?? ''}";
        LocalDatabase<SDlist> _localDb = LocalDatabase(_objectName);
        List<SDlist>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));
        _localDb.close();

        yield CustomLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield SDDataSuccess(obj: _localData);
      }
    }

    // if (event is CalendarListEvent) {
    //   print('calling custom calendar--------------------------------------');
    //   DateTime now = new DateTime.now();
    //   final DateFormat formatter = DateFormat('yyyy-MM-dd');
    //   final DateTime currentDate =
    //       DateTime.parse(formatter.format(now).toString());

    //   try {
    //     yield CustomLoading();
    //     String? _objectName =
    //         "${Strings.calendarObjectName}${event.calendarId}";
    //     LocalDatabase<CalendarEventList> _localDb = LocalDatabase(_objectName);
    //     List<CalendarEventList>? _localData = await _localDb.getData();

    //     LocalDatabase<CalendarBannerImageModal> _calendarBannerImagelocalDb =
    //         LocalDatabase(Strings.calendarBannerObjectName);
    //     List<CalendarBannerImageModal>? _calendarBannerImagelocalData = [];
    //     _calendarBannerImagelocalData =
    //         await _calendarBannerImagelocalDb.getData();

    //     //Clear calendar local data to resolve loading issue
    //     SharedPreferences clearCalendarCache =
    //         await SharedPreferences.getInstance();
    //     final clearChacheResult =
    //         clearCalendarCache.getBool('delete_local_calendar_custom');
    //     if (clearChacheResult != true) {
    //       _localData.clear();
    //       await clearCalendarCache.setBool(
    //           'delete_local_calendar_custom', true);
    //     }

    //     if (_localData.isEmpty) {
    //       yield CustomLoading();
    //     } else {
    //       filterFutureAndPastEvents(_localData, currentDate);
    //       futureListobj = sortCalendarEvents(futureListobj!);
    //       pastListobj = sortCalendarEvents(pastListobj!);

    //       yield CalendarListSuccess(
    //           calendarBannerImageList: _calendarBannerImagelocalData,
    //           futureListobj: mapListObj(futureListobj!),
    //           pastListobj: mapListObj(pastListobj!.reversed.toList()));
    //     }

    //     // List<CalendarEventList> list =
    //     //     await getCalendarEventList(event.calendarId);
    //     List<dynamic> responses = await Future.wait(
    //         [getCalendarEventList(event.calendarId), getCalendarBannerImage()]);

    //     await _localDb.clear();
    //     responses[0].forEach((CalendarEventList e) {
    //       _localDb.addData(e);
    //     });

    //     await _calendarBannerImagelocalDb.clear();
    //     responses[1].forEach((CalendarBannerImageModal e) {
    //       _calendarBannerImagelocalDb.addData(e);
    //     });

    //     filterFutureAndPastEvents(
    //         responses[0], currentDate); //Filter the furure and past events
    //     sortCalendarEvents(futureListobj!); //Sort the events date wise
    //     sortCalendarEvents(pastListobj!); //Sort the events date wise

    //     yield CalendarListSuccess(
    //         calendarBannerImageList: responses[1],
    //         futureListobj:
    //             mapListObj(futureListobj!), //Grouping the events by month
    //         pastListobj: mapListObj(
    //           pastListobj!.reversed.toList(),
    //         )
    //         // futureListobj: futureListMap, pastListobj: pastListMap
    //         );
    //   } catch (e) {
    //     //print(e);
    //     String? _objectName =
    //         "${Strings.calendarObjectName}${event.calendarId}";
    //     LocalDatabase<CalendarEventList> _localDb = LocalDatabase(_objectName);
    //     List<CalendarEventList>? _localData = await _localDb.getData();

    //     LocalDatabase<CalendarBannerImageModal> _calendarBannerImagelocalDb =
    //         LocalDatabase(Strings.calendarBannerObjectName);
    //     List<CalendarBannerImageModal>? _calendarBannerImagelocalData =
    //         await _calendarBannerImagelocalDb.getData();
    //     filterFutureAndPastEvents(_localData, currentDate);
    //     // futureListobj.whereNot((element) => element.status != "cancelled");
    //     futureListobj = sortCalendarEvents(futureListobj!);
    //     pastListobj = sortCalendarEvents(pastListobj!);

    //     yield CalendarListSuccess(
    //         futureListobj: mapListObj(futureListobj!),
    //         pastListobj: mapListObj(pastListobj!.reversed.toList()),
    //         calendarBannerImageList: _calendarBannerImagelocalData);
    //   }
    // }
  }

  filterFutureAndPastEvents(List<CalendarEventList> eventList, currentDate) {
    futureListobj!.clear();
    pastListobj!.clear();
    for (int i = 0; i < eventList.length; i++) {
      try {
        var temp = eventList[i].start.toString().contains('dateTime')
            ? eventList[i].start['dateTime'].toString().substring(0, 10)
            : eventList[i].start['date'].toString().substring(0, 10);
        if (DateTime.parse(temp).isBefore(currentDate)) {
          pastListobj!.add(eventList[i]);
        } else {
          futureListobj!.add(eventList[i]);
        }
      } catch (e) {
        throw (e);
      }
    }
  }

  sortCalendarEvents(List<CalendarEventList> list) {
    return list.sort((a, b) {
      var adate = DateTime.parse(a.start.toString().contains('dateTime')
          ? a.start['dateTime'].split('T')[0]
          : a.start['date'].toString());
      //before -> var adate = a.expiry;
      var bdate = DateTime.parse(b.start.toString().contains('dateTime')
          ? b.start['dateTime'].split('T')[0]
          : b.start['date'].toString()); //before -> var bdate = b.expiry;
      return adate.compareTo(
          bdate); //to get the order other way just switch `adate & bdate`
    });
  }

  mapListObj(List<CalendarEventList> listObj) {
    Map<String?, List<CalendarEventList>> mappingList =
        listObj.groupListsBy((element) => element.month);
    return mappingList;
  }

  getCalendarId(list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].calendarId != null && list[i].calendarId != "") {
        Globals.calendar_Id = list[i].calendarId;
        break;
      }
    }
  }

  Future<List<SharedList>> getCustomList(id) async {
    try {
      final ResponseModel response = await _dbServices.getApi(Uri.encodeFull(
          'getSubRecords?parentId=$id&parentName=Custom_App_Section__c&objectName=Custom_App_Menu__c'));
      if (response.statusCode == 200) {
        List<SharedList> _list = response.data['body']
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

  Future<List<SharedList>> getCustomSubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getApi(Uri.encodeFull(
          "getSubRecords?parentId=$id&parentName=Custom_App_Menu__c&objectName=Custom_App_Sub_Menu__c"));

      if (response.statusCode == 200) {
        List<SharedList> _list = response.data['body']
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
      final ResponseModel response = await _dbServices.getApi(categoryId == null
          ? Uri.encodeFull(
              'getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=Staff_Directory_App__c')
          : 'getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=Staff_Directory_App__c&About_App__c_Id=$categoryId');

      if (response.statusCode == 200) {
        List<SDlist> _list = response.data['body']
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

  Future<List<CalendarEventList>> getCalendarEventList(id) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/calendar/v3/calendars/$id/events?key=AIzaSyBZ27PUuzJBxZ2BpmMk-wJxLm6WGJK2Z2M'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List dataArray = data["body"]["items"];
        List<CalendarEventList> data1 = dataArray
            .map<CalendarEventList>((i) => CalendarEventList.fromJson(i))
            .toList();
        return data1.map((i) {
          var datetime = i.start != null
              ? (i.start.toString().contains('dateTime')
                  ? i.start['dateTime'].toString().substring(0, 10)
                  : i.start['date'].toString().substring(0, 10))
              : (i.originalStartTime.toString().contains('dateTime')
                  ? i.originalStartTime['dateTime'].toString().substring(0, 10)
                  : '1950-01-01');
          String month = Utility.convertTimestampToDateFormat(
              DateTime.parse(datetime), 'MMM yyyy');

          return CalendarEventList(
              kind: i.kind,
              etag: i.etag,
              id: i.id,
              status: i.status,
              htmlLink: i.htmlLink,
              created: i.created,
              updated: i.updated,
              summary: i.summary,
              description: i.description,
              start: i.start,
              end: i.end,
              iCalUid: i.iCalUid,
              sequence: i.sequence,
              eventType: i.eventType,
              month: month);
        }).toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<CalendarBannerImageModal>> getCalendarBannerImage() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          Uri.encodeFull(
              'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/getRecord/Calendar__c'),
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        List<CalendarBannerImageModal> _list = response.data['body']
            .map<CalendarBannerImageModal>(
                (i) => CalendarBannerImageModal.fromJson(i))
            .toList();

        return _list;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }
}
