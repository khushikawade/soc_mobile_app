import 'dart:async';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial());
  final DbServices _dbServices = DbServices();

  StudentState get initialState => StudentInitial();

  @override
  Stream<StudentState> mapEventToState(
    StudentEvent event,
  ) async* {
    if (event is StudentPageEvent) {
      try {
        // yield Loading();
        LocalDatabase<StudentApp> _localDb =
            LocalDatabase(Strings.studentsObjectName);
        List<StudentApp> _localData = await _localDb.getData();
        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        if (_localData.isEmpty) {
          yield Loading();
        } else {
          List<StudentApp> appList = [];

          for (int i = 0; i < _localData.length; i++) {
            if (_localData[i].status == "Show" ||
                _localData[i].status == null) {
              // list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
              if (_localData[i].appFolderc == null ||
                  _localData[i].appFolderc == "") {
                appList.add(_localData[i]);
              }
            }
          }
          yield StudentDataSucess(obj: appList, subFolder: _localData);
        }
        // Local Database End
        List<StudentApp> list = await getStudentDetails();
        // Syncing the Local database with remote data
        await _localDb.clear();
        list.forEach((StudentApp e) {
          _localDb.addData(e);
        });
        // Sync end.

        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        List<StudentApp> appList = [];
        if (list.length > 0) {
          for (int i = 0; i < list.length; i++) {
            if (list[i].status == "Show" || list[i].status == null) {
              // list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
              if (list[i].appFolderc == null || list[i].appFolderc == "") {
                appList.add(list[i]);
              }
            }
          }
        }
        yield Loading(); // Mimic state change.
        yield StudentDataSucess(obj: appList, subFolder: list);
      } catch (e) {
        // Fetching the data from the local database instead.
        LocalDatabase<StudentApp> _localDb =
            LocalDatabase(Strings.studentsObjectName);
        List<StudentApp> _localData = await _localDb.getData();

        _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        List<StudentApp> appList = [];

        for (int i = 0; i < _localData.length; i++) {
          if (_localData[i].status == "Show" || _localData[i].status == null) {
            if (_localData[i].appFolderc == null ||
                _localData[i].appFolderc == "") {
              appList.add(_localData[i]);
            }
          }
        }
        yield Loading(); // Mimic state change.
        yield StudentDataSucess(obj: appList, subFolder: _localData);
        // yield StudentError(err: e);
      }
    }
  }

  Future<List<StudentApp>> getStudentDetails() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,App_Icon_URL__c,App_URL__c,Deep_Link__c,Id,Name,App_Folder__c,Sort_Order__c,Active_Status__c,Is_Folder__c FROM Student_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        return response.data["records"]
            .map<StudentApp>((i) => StudentApp.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
