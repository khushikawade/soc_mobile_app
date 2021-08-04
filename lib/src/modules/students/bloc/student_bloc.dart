import 'dart:async';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
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
        List<StudentApp> appList = [];
        yield Loading();
        List<StudentApp> list = await getStudentDetails();
        if (list.length > 0) {
          for (int i = 0; i < list.length; i++) {
            list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));
            if (list[i].appFolderc == null || list[i].appFolderc == "") {
              appList.add(list[i]);
            }
          }
        }
        yield StudentDataSucess(obj: appList, subFolder: list);
      } catch (e) {
        yield StudentError(err: e);
      }
    }
  }

  Future<List<StudentApp>> getStudentDetails() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,App_Icon__c,App_Icon_URL__c, App_URL__c,Deep_Link__c,Id,Name,App_Folder__c,Sort_Order__c FROM Student_App__c where School_App__c = 'a1T3J000000RHEKUA4'")}");
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
