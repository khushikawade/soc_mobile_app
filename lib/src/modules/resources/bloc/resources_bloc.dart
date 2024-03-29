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
part 'resources_event.dart';
part 'resources_state.dart';

class ResourcesBloc extends Bloc<ResourcesEvent, ResourcesState> {
  ResourcesBloc() : super(ResourcesInitial());
  final DbServices _dbServices = DbServices();

  ResourcesState get initialState => ResourcesInitial();
  var dataArray;
  @override
  Stream<ResourcesState> mapEventToState(
    ResourcesEvent event,
  ) async* {
    if (event is ResourcesListEvent) {
      try {
        // yield ResourcesLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        LocalDatabase<SharedList> _localDb =
            LocalDatabase(Strings.resourcesObjectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield ResourcesLoading();
        } else {
          yield ResourcesDataSuccess(obj: _localData);
        }
        // End local database
        List<SharedList> list = await getResourcesSDList();

        // Syncing the Local database with remote data
        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });
        // Syncing end

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        yield ResourcesLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield ResourcesDataSuccess(obj: list);
      } catch (e) {
        // Incase of error, fetching data from the local database.
        LocalDatabase<SharedList> _localDb =
            LocalDatabase(Strings.resourcesObjectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localDb.close();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        yield ResourcesLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield ResourcesDataSuccess(obj: _localData);
        // yield ResourcesErrorLoading(err: e);
      }
    }

    if (event is ResourcesSublistEvent) {
      try {
        // yield ResourcesLoading();
        String? _objectName =
            "${Strings.resourcesSubListObjectName}_${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);

        List<SharedList>? _localData = await _localDb.getData();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        if (_localData.isEmpty) {
          yield ResourcesLoading();
        } else {
          yield ResourcesSubListSuccess(obj: _localData);
        }
        //Local database end

        List<SharedList> list = await getResourcesSubList(event.id);

        // Syning local data with remote data
        await _localDb.clear();
        list.forEach((SharedList e) {
          _localDb.addData(e);
        });
        // Sync end

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        yield ResourcesLoading();
        yield ResourcesSubListSuccess(obj: list);
      } catch (e) {
        String? _objectName =
            "${Strings.resourcesSubListObjectName}_${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        _localDb.close();

        yield ResourcesLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield ResourcesSubListSuccess(obj: _localData);
        // yield ResourcesErrorLoading(err: e);
      }
    }
  }

  Future<List<SharedList>> getResourcesSDList() async {
    try {
      final ResponseModel response = await _dbServices.getApi(Uri.encodeFull(
          "getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=Resources_App__c"));
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

  Future<List<SharedList>> getResourcesSubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getApi(Uri.encodeFull(
          "getSubRecords?parentId=$id&parentName=Resources_App__c&objectName=Resources_Sub_Menu_App__c"));
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
