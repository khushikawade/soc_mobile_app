import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'student_plus_event.dart';
part 'student_plus_state.dart';

class StudentPlusBloc extends Bloc<StudentPlusEvent, StudentPlusState> {
  StudentPlusBloc() : super(StudentPlusInitial());
  final DbServices _dbServices = DbServices();
  // final HiveDbServices _localDbService = HiveDbServices();
  StudentPlusState get initialState => StudentPlusInitial();

  @override
  Stream<StudentPlusState> mapEventToState(
    StudentPlusEvent event,
  ) async* {
    if (event is StudentPlusSearchEvent) {
      try {
        yield StudentPlusLoading();
        List<StudentPlusDetailsModel> list =
            await getStudentPlusSearch(keyword: event.keyword ?? '');

        yield StudentPlusSearchSuccess(
          obj: list,
        );
      } catch (e) {
        yield StudentPlusErrorReceived(err: e);
      }
    }

    if (event is FetchStudentWorkEvent) {
      try {
        LocalDatabase<StudentPlusWorkModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentWorkList}_${event.studentId}");

        List<StudentPlusWorkModel>? _localData = await _localDb.getData();
        _localData.sort((a, b) => b.dateC!.compareTo(a.dateC!));

        if (_localData.isEmpty) {
          yield StudentPlusLoading();
        } else {
          yield StudentPlusWorkSuccess(
            obj: _localData,
          );
        }

        //yield StudentPlusLoading();
        List<StudentPlusWorkModel> list =
            await getStudentWorkDetails(studentId: event.studentId ?? '');
        await _localDb.clear();
        list.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        list.forEach((StudentPlusWorkModel e) {
          _localDb.addData(e);
        });

        yield StudentPlusWorkSuccess(
          obj: list,
        );
      } catch (e) {
        LocalDatabase<StudentPlusWorkModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentWorkList}_${event.studentId}");

        List<StudentPlusWorkModel>? _localData = await _localDb.getData();
        _localData.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        yield StudentPlusWorkSuccess(
          obj: _localData,
        );
      }
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              List of functions                             */
  /* -------------------------------------------------------------------------- */

  /* ---- Function to call search api and return response according to that --- */

  Future getStudentPlusSearch({required String keyword}) async {
    try {
      final ResponseModel response = await _dbServices.getApi(
          'filterRecords/Student__c/"First_Name__c" ilike \'%25$keyword%25\'And "DBN__c" = \'BB0456\''); //change DBN to dynamic
      if (response.statusCode == 200) {
        return response.data["body"]
            .map<StudentPlusDetailsModel>(
                (i) => StudentPlusDetailsModel.fromJson(i))
            .toList();
      }
    } catch (e) {
      throw (e);
    }
  }

  /* ------------------ Function to call get student work api ------------------ */
  Future getStudentWorkDetails({required String studentId}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://qlys9nyyb1.execute-api.us-east-2.amazonaws.com/production/getStudentWork/$studentId',
          isCompleteUrl: true,
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
            "Authorization": "r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx"
          });
      if (response.statusCode == 200) {
        return response.data["body"]
            .map<StudentPlusWorkModel>((i) => StudentPlusWorkModel.fromJson(i))
            .toList();
      }
    } catch (e) {
      throw (e);
    }
  }
}
