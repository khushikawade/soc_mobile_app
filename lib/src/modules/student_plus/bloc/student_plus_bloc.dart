import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_presentation/google_presentation_bloc_method.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_details_modal.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_grades_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_search_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        List<StudentPlusSearchModel> list = await getStudentPlusSearch(
            keyword: event.keyword ?? '',
            teacherEmail: _userProfileLocalData[0].userEmail ?? '');

        yield StudentPlusSearchSuccess(
          obj: list,
        );
      } catch (e) {
        yield StudentPlusErrorReceived(err: e);
      }
    }

    /* ------------------- Event to get student detail from id ------------------ */
    if (event is GetStudentPlusDetails) {
      try {
        LocalDatabase<StudentPlusDetailsModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentPlusDetails}_${event.studentIdC}");

        //Clear student_plus_details local data
        SharedPreferences clearNewsCache =
            await SharedPreferences.getInstance();
        final clearCacheResult = await clearNewsCache
            .getBool('delete_local_student_plus_details_cache');

        if (clearCacheResult != true) {
          await _localDb.clear();
          await clearNewsCache.setBool(
              'delete_local_student_plus_details_cache', true);
        }

        List<StudentPlusDetailsModel> _localData = await _localDb.getData();

        if (_localData.length > 0) {
          yield StudentPlusInfoSuccess(
            obj: _localData[0],
          );
        } else {
          yield StudentPlusGetDetailsLoading();
        }

        StudentPlusDetailsModel studentDetails =
            await getStudentDetailsFromOsis(studentIdC: event.studentIdC);

        await _localDb.clear();
        await _localDb.addData(studentDetails);
        yield StudentPlusInfoSuccess(
          obj: studentDetails,
        );
      } catch (e) {
        LocalDatabase<StudentPlusDetailsModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentPlusDetails}_${event.studentIdC}");

        List<StudentPlusDetailsModel> _localData = await _localDb.getData();

        if (_localData.length > 0) {
          yield StudentPlusInfoSuccess(
            obj: _localData[0],
          );
        } else {
          yield StudentPlusErrorReceived(err: e);
        }
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
          yield StudentPlusWorkSuccess(obj: _localData);
        }

        //yield StudentPlusLoading();
        List<StudentPlusWorkModel> list =
            await getStudentWorkDetails(studentId: event.studentId ?? '');

        // list.asMap().forEach((i, element) {
        //   print(i);
        //   print(element.standardAndDescriptionC);
        // });

        await _localDb.clear();
        list.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        list.forEach((StudentPlusWorkModel e) {
          _localDb.addData(e);
        });

        yield StudentPlusLoading();
        yield StudentPlusWorkSuccess(obj: list);
      } catch (e) {
        LocalDatabase<StudentPlusWorkModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentWorkList}_${event.studentId}");

        List<StudentPlusWorkModel>? _localData = await _localDb.getData();
        _localData.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        yield StudentPlusWorkSuccess(obj: _localData);
      }
    }

    if (event is FetchStudentGradesEvent) {
      try {
        LocalDatabase<StudentPlusGradeModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${event.studentId}");

        List<StudentPlusGradeModel>? _localData = await _localDb.getData();

        if (_localData.isEmpty) {
          yield StudentPlusLoading();
        } else {
          yield StudentPlusGradeSuccess(
              obj: _localData, chipList: getChipsList(list: _localData));
        }

        //yield StudentPlusLoading();
        List<StudentPlusGradeModel> list =
            await getStudentGradesDetails(studentId: event.studentId ?? '');
        await _localDb.clear();
        // list.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        list.forEach((StudentPlusGradeModel e) {
          _localDb.addData(e);
        });

        yield StudentPlusGradeSuccess(
            obj: list, chipList: getChipsList(list: list));
      } catch (e) {
        LocalDatabase<StudentPlusGradeModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${event.studentId}");

        List<StudentPlusGradeModel>? _localData = await _localDb.getData();

        //_localData.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        yield StudentPlusGradeSuccess(
            obj: _localData, chipList: getChipsList(list: _localData));
      }
    }

    if (event is SaveStudentGooglePresentationWorkEvent) {
      try {
        //update the student google Presentation Url
        event.studentDetails.studentgooglePresentationUrl =
            StudentPlusOverrides.studentPlusGooglePresentationBaseUrl +
                (event.studentDetails.studentgooglePresentationId ?? '');

        var isStudentGooglePresentationWorkSaved =
            await saveStudentGooglePresentationWorkEvent(
                studentDetails: event.studentDetails);

        if (isStudentGooglePresentationWorkSaved == true) {
          await GooglePresentationBlocMethods
              .updateStudentLocalDBWithGooglePresentationUrl(
            studentDetails: event.studentDetails,
          );

          yield SaveStudentGooglePresentationWorkEventSuccess(
              studentDetails: event.studentDetails);
        } else {
          yield StudentPlusErrorReceived(
              err: isStudentGooglePresentationWorkSaved);
        }
      } catch (e) {
        yield StudentPlusErrorReceived(err: e.toString());
      }
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              List of functions                             */
  /* -------------------------------------------------------------------------- */

  /* --------------- Function to return chipList for grades page -------------- */
  List<String> getChipsList({required List<StudentPlusGradeModel> list}) {
    List<String> chipList = [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].markingPeriodC != null &&
          !chipList.contains(list[i].markingPeriodC)) {
        chipList.add(list[i].markingPeriodC!);
      }
    }
    return chipList;
  }

  /* ---- Function to call search api and return response according to that --- */

  Future getStudentPlusSearch(
      {required String keyword, required String teacherEmail}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          '${StudentPlusOverrides.studentPlusBaseUrl}/studentPlus/search/${Globals.schoolDbnC}/student?keyword=$keyword&teacher_email=$teacherEmail',
          isCompleteUrl: true,
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
            "Authorization": "r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx"
          }); //change DBN to dynamic
      if (response.statusCode == 200) {
        return response.data["body"]
            .map<StudentPlusSearchModel>(
                (i) => StudentPlusSearchModel.fromJson(i))
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
          '${StudentPlusOverrides.studentPlusBaseUrl}/studentPlus/studentWork/$studentId',
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

  // /* ------------- Function to get student details for student id ------------- */
  // Future getStudentDetailsFromId({required String studentId}) async {
  //   try {
  //     final ResponseModel response = await _dbServices.getApiNew(
  //         '${Overrides.API_BASE_URL}getRecord/Student__c/${studentId}',
  //         isCompleteUrl: true,
  //         headers: {
  //           "Content-Type": "application/json;charset=UTF-8",
  //           "Authorization": "r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx"
  //         }); //change DBN to dynamic
  //     if (response.statusCode == 200) {
  //       return StudentPlusDetailsModel.fromJson(response.data['body']);
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  /* ------------- Function to get student details for student Osis ------------- */
  Future getStudentDetailsFromOsis({required String studentIdC}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Student__c/studentOsis/${studentIdC}',
          isCompleteUrl: true,
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
            "Authorization": "r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx"
          }); //change DBN to dynamic
      if (response.statusCode == 200) {
        return StudentPlusDetailsModel.fromJson(response.data['body']);
      }
    } catch (e) {
      throw (e);
    }
  }

  /* ------------------ Function to call get student grades api ------------------ */
  Future getStudentGradesDetails({required String studentId}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          '${StudentPlusOverrides.studentPlusBaseUrl}/studentPlus/grades/$studentId',
          isCompleteUrl: true,
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
            "Authorization": "r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx"
          });
      if (response.statusCode == 200) {
        return response.data["body"]
            .map<StudentPlusGradeModel>(
                (i) => StudentPlusGradeModel.fromJson(i))
            .toList();
      }
    } catch (e) {
      throw (e);
    }
  }

  /* ------------- Function to save Student Google Presentation Work on database ------------- */
  Future saveStudentGooglePresentationWorkEvent(
      {required StudentPlusDetailsModel studentDetails}) async {
    try {
      final body = {
        "Student__c": studentDetails.studentIdC,
        "Student_Record_Id": studentDetails.id,
        "Teacher__c": Globals.teacherId ?? '',
        "DBN__c": Globals.schoolDbnC ?? "",
        "School_App__c": Overrides.SCHOOL_ID ?? '',
        "Google_Presentation_Id":
            studentDetails.studentgooglePresentationId ?? '',
        "Google_Presentation_URL":
            studentDetails.studentgooglePresentationUrl ?? ''
      };
      final headers = {
        "Content-Type": "application/json;charset=UTF-8",
        "Authorization": "r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx"
      };
      final url =
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/createRecord?objectName=Student_Work';

      final ResponseModel response = await _dbServices.postApi(url,
          headers: headers, body: body, isGoogleApi: true);
      print(body);
      print(
          "saveStudentGooglePresentationWorkEvent api response rec. ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
