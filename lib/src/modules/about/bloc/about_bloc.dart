import 'dart:async';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    if (event is AboutStaffDirectoryEvent) {
      try {
        // yield AboutLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        LocalDatabase<SharedList> _localDb =
            LocalDatabase(Strings.aboutObjectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield AboutLoading();
        } else {
          yield AboutDataSucess(obj: _localData);
        }
        // Local database end.

        List<SharedList> list = await getAboutSDList();

        // Syncing the Local database with remote data
        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });
        // Sync end

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        yield AboutLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield AboutDataSucess(obj: list);
      } catch (e) {
        // Fetching data from the local database instead.
        LocalDatabase<SharedList> _localDb =
            LocalDatabase(Strings.aboutObjectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localDb.close();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        yield AboutLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield AboutDataSucess(obj: _localData);
        // yield ErrorLoading(err: e);
      }
    }
    if (event is AboutSublistEvent) {
      try {
        // yield AboutLoading();
        // yield FamilyLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        String? _objectName = "${Strings.aboutSubListObjectName}${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);

        List<SharedList>? _localData = await _localDb.getData();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield AboutLoading();
        } else {
          yield AboutSublistSucess(obj: _localData);
        }
        // Local database end

        List<SharedList> list = await getAboutSubList(event.id);
        // Syncing remote data to local datatbase
        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });
        // Sync end.

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        yield AboutLoading(); // To mimic the state change
        yield AboutSublistSucess(obj: list);
      } catch (e) {
        // Fetching data from the local database instead.
        String? _objectName = "${Strings.aboutSubListObjectName}${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        _localDb.close();

        yield AboutLoading(); // To mimic the state change
        yield AboutSublistSucess(obj: _localData);
      }
    }
  }

  Future<List<SharedList>> getAboutSDList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(Uri.encodeFull(
          "getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=About_App__c"));
      if (response.statusCode == 200) {
        //  dataArray = response.data["records"];
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

  Future<List<SharedList>> getAboutSubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getapi(Uri.encodeFull(
          "getSubRecords?parentId=$id&parentName=About_App__c&objectName=About_Sub_Menu_App__c"));
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
}
