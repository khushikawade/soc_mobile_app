import 'dart:async';
import 'package:Soc/src/modules/schools/modal/school_directory.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'school_event.dart';
part 'school_state.dart';

class SchoolDirectoryBloc extends Bloc<SchoolDirectoryEvent, SchoolDirectoryState> {
  // var data;
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
        yield SchoolDirectoryLoading();
        List<SchoolDirectoryList> list = await getSchoolDirectorySDList();
        if (list.length > 0) {
          list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));
          yield SchoolDirectoryDataSucess(obj: list);
        } else {
          yield SchoolDirectoryDataSucess(obj: list);
        }
      } catch (e) {
        yield SchoolDirectoryErrorLoading(err: e);
      }
    }  
  }

  Future<List<SchoolDirectoryList>> getSchoolDirectorySDList() async {
    try {
       final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,Image_URL__c,Id, Email__c,Sort_Order__c,Phone__c,Website_URL__c,RTF_HTML__c,Contact_Address__c,Contact_Office_Location__c FROM School_Directory_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
            .map<SchoolDirectoryList>((i) => SchoolDirectoryList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

}
