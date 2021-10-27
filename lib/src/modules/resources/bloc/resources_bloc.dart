import 'dart:async';
import 'package:Soc/src/modules/resources/modal/resources_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
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
        yield ResourcesLoading();
        List<ResourcesList> list = await getResourcesSDList();
        if (list.length > 0) {
          list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));
          yield ResourcesDataSucess(obj: list);
        } else {
          yield ResourcesDataSucess(obj: list);
        }
      } catch (e) {
        yield ResourcesErrorLoading(err: e);
      }
    }  
  }

  Future<List<ResourcesList>> getResourcesSDList() async {
    try {
       final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,Image_URL__c,Id, Email__c,Sort_Order__c,Phone__c,Website_URL__c,RTF_HTML__c,Contact_Address__c,Contact_Office_Location__c FROM School_Directory_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
            .map<ResourcesList>((i) => ResourcesList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

}
