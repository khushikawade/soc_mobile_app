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
  // var data;
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
          yield ResourcesDataSucess(obj: _localData);
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
        yield ResourcesDataSucess(obj: list);
      } catch (e) {
        // Incase of error, fetching data from the local database.
        LocalDatabase<SharedList> _localDb =
            LocalDatabase(Strings.resourcesObjectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localDb.close();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        yield ResourcesLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield ResourcesDataSucess(obj: _localData);
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
          yield ResourcesSubListSucess(obj: _localData);
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
        yield ResourcesSubListSucess(obj: list);
      } catch (e) {
        String? _objectName =
            "${Strings.resourcesSubListObjectName}_${event.id}";
        LocalDatabase<SharedList> _localDb = LocalDatabase(_objectName);

        List<SharedList>? _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        _localDb.close();

        yield ResourcesLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        yield ResourcesSubListSucess(obj: _localData);
        // yield ResourcesErrorLoading(err: e);

      }
    }
  }

  Future<List<SharedList>> getResourcesSDList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,Id,Sort_Order__c,URL__c,App_Icon_URL__c,Active_Status__c,Type__c,RTF_HTML__c,PDF_URL__c FROM Resources_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        dataArray = response.data["records"];
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

  Future<List<SharedList>> getResourcesSubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,URL__c,Id,Name, Type__c, PDF_URL__c, RTF_HTML__c,Sort_Order__c,App_Icon_URL__c,Active_Status__c FROM Resources_Sub_Menu_App__c where Resources_App__c='$id'")}");
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
