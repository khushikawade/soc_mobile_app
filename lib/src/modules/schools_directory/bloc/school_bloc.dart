import 'dart:async';
import 'package:Soc/src/modules/schools_directory/modal/school_directory_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'school_event.dart';
part 'school_state.dart';

class SchoolDirectoryBloc
    extends Bloc<SchoolDirectoryEvent, SchoolDirectoryState> {
  SchoolDirectoryBloc() : super(SchoolDirectoryInitial());
  final DbServices _dbServices = DbServices();

  SchoolDirectoryState get initialState => SchoolDirectoryInitial();
  var dataArray;
  @override
  Stream<SchoolDirectoryState> mapEventToState(
    SchoolDirectoryEvent event,
  ) async* {
    if (event is SchoolDirectoryListEvent) {
      try {
        // yield SchoolDirectoryLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        LocalDatabase<SchoolDirectoryList> _localDb = LocalDatabase(
            '${Strings.schoolDirectoryObjectName}${event.customRecordId}');

        List<SchoolDirectoryList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield SchoolDirectoryLoading();
        } else {
          yield SchoolDirectoryDataSucess(obj: _localData);
        }
        //Local database end.

        List<SchoolDirectoryList> list = await getSchoolDirectorySDList(
            event.customRecordId, event.isSubMenu);

        // Syncing the Local database with remote data
        await _localDb.clear();
        list.forEach((SchoolDirectoryList e) {
          _localDb.addData(e);
        });
        // Sync end

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        yield SchoolDirectoryLoading(); // Mimic state change
        yield SchoolDirectoryDataSucess(obj: list);
      } catch (e) {
        LocalDatabase<SchoolDirectoryList> _localDb = LocalDatabase(
            '${Strings.schoolDirectoryObjectName}${event.customRecordId}');

        List<SchoolDirectoryList>? _localData = await _localDb.getData();
        _localDb.close();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        yield SchoolDirectoryLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield SchoolDirectoryDataSucess(obj: _localData);
        // yield SchoolDirectoryErrorLoading(err: e);
      }
    }
  }

  Future<List<SchoolDirectoryList>> getSchoolDirectorySDList(
      parentId, isSubMenu) async {
    try {
      final ResponseModel response = await _dbServices.getApi(Uri.encodeFull(parentId ==
              null
          ? "getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=School_Directory_App__c"
          : (isSubMenu == true
              ? //'getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=School_Directory_App__c&Custom_App_Menu__c=$parentId'
              'getSubRecords?parentId=$parentId&parentName=Custom_App_Menu__c&objectName=School_Directory_App__c'
              : 'getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=School_Directory_App__c&Custom_App_Section__c=$parentId')));
      if (response.statusCode == 200) {
        List<SchoolDirectoryList> _list = response.data['body']
            .map<SchoolDirectoryList>((i) => SchoolDirectoryList.fromJson(i))
            .toList();
        _list.removeWhere(
            (SchoolDirectoryList element) => element.statusC == 'Hide');

        return _list;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
