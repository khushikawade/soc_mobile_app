import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_presentation/google_presentation_bloc_method.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_course_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_course_work_model.dart';
import 'package:Soc/src/services/google_authentication.dart';
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
  int _totalRetry = 0;
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

    /* ------------------------- trigger in case of student in staff section ------------------------ */
    if (event is FetchStudentGradesEvent) {
      try {
        LocalDatabase<StudentPlusGradeModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${event.studentId}");

        List<StudentPlusGradeModel>? _localData = await _localDb.getData();

        if (_localData.isEmpty) {
          yield StudentPlusLoading();
        } else {
          yield StudentPlusGradeSuccess(
              obj: _localData,
              chipList:
                  getChipsList(list: _localData, fromStudentSection: false),
              courseList: []);
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
            obj: list,
            chipList: getChipsList(list: list, fromStudentSection: false),
            courseList: []);
      } catch (e) {
        LocalDatabase<StudentPlusGradeModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${event.studentId}");

        List<StudentPlusGradeModel>? _localData = await _localDb.getData();

        //_localData.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        yield StudentPlusGradeSuccess(
            obj: _localData,
            chipList: getChipsList(list: _localData, fromStudentSection: false),
            courseList: []);
      }
    }

    /* --------------------------- Function to fetch current grades with classRoom -------------------------- */
    if (event is FetchStudentGradesWithClassroomEvent) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        LocalDatabase<StudentPlusGradeModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${event.studentId}");
        LocalDatabase<StudentPlusCourseModel> _localCourseDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${userProfileLocalData[0].userEmail}");

        List<StudentPlusGradeModel>? _localData = await _localDb.getData();
        List<StudentPlusCourseModel>? _localCourseData =
            await _localCourseDb.getData();

        // if (_localData.isEmpty && _localCourseData.isEmpty) {
        //   yield StudentPlusLoading();
        // } else {
        //   yield StudentPlusGradeSuccess(
        //       obj: _localData,
        //       chipList:
        //           getChipsList(list: _localData, fromStudentSection: true),
        //       courseList: _localCourseData);
        // }

        List gradeList = await Future.wait([
          getStudentGradesDetails(studentId: event.studentId ?? ''),
          getClassroomCourseList(
              accessToken: userProfileLocalData[0].authorizationToken ?? '',
              refreshToken: userProfileLocalData[0].refreshToken ?? '')
        ]);

        List<StudentPlusGradeModel> list =
            gradeList[0] == null || gradeList[0].length == 0
                ? []
                : gradeList[0];
        List<StudentPlusCourseModel> studentCourseList = gradeList[1];
        await _localDb.clear();
        await _localCourseDb.clear();
        // list.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        list.forEach((StudentPlusGradeModel e) {
          _localDb.addData(e);
        });
        studentCourseList.forEach((StudentPlusCourseModel e) async {
          await _localCourseDb.addData(e);
        });
        yield StudentPlusLoading();
        yield StudentPlusGradeSuccess(
            obj: list,
            chipList: getChipsList(list: list, fromStudentSection: true),
            courseList: studentCourseList);
      } catch (e) {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        LocalDatabase<StudentPlusGradeModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${event.studentId}");

        List<StudentPlusGradeModel>? _localData = await _localDb.getData();

        LocalDatabase<StudentPlusCourseModel> _localCourseDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${userProfileLocalData[0].userEmail}");

        List<StudentPlusCourseModel>? _localCourseData =
            await _localCourseDb.getData();
        //_localData.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        yield StudentPlusGradeSuccess(
            obj: _localData,
            chipList: getChipsList(list: _localData, fromStudentSection: true),
            courseList: _localCourseData);
      }
    }

    //   if (event is FetchStudentCourseEvent) {
    //     try {

    //     } catch (e) {

    //     }
    //   }

    /* --------------- Event to get course work detail by course id  Google classroom --------------- */
    if (event is FetchStudentCourseWorkEvent) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        LocalDatabase<StudentPlusCourseWorkModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${event.courseWorkId}");

        List<StudentPlusCourseWorkModel>? _localData = await _localDb.getData();

        if (_localData.isEmpty) {
          yield StudentPlusLoading();
        } else {
          yield StudentPlusCourseWorkSuccess(
              obj: _localData, nextPageToken: 'localDb');
        }

        //yield StudentPlusLoading();
        List list = await getStudentCourseWorkDetails(
            courseId: event.courseWorkId,
            accessToken: userProfileLocalData[0].authorizationToken ?? '');
        List<StudentPlusCourseWorkModel> studentPlusCourseWorkModel = list[1];
        await _localDb.clear();
        // list.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        studentPlusCourseWorkModel.forEach((StudentPlusCourseWorkModel e) {
          _localDb.addData(e);
        });
        yield StudentPlusDemoLoading();
        yield StudentPlusCourseWorkSuccess(
            obj: studentPlusCourseWorkModel, nextPageToken: list[0]);
      } catch (e) {
        LocalDatabase<StudentPlusCourseWorkModel> _localDb = LocalDatabase(
            "${StudentPlusOverrides.studentGradeList}_${event.courseWorkId}");

        List<StudentPlusCourseWorkModel>? _localData = await _localDb.getData();

        // _localData.sort((a, b) => b.dateC!.compareTo(a.dateC!));
        yield StudentPlusCourseWorkSuccess(obj: _localData, nextPageToken: '');
      }
    }

    /* --------------- Event to get course work detail by course id  Google classroom --------------- */
    if (event is UpdateStudentCourseWorkEvent) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        List list = await getStudentCourseWorkDetails(
            courseId: event.courseWorkId,
            accessToken: userProfileLocalData[0].authorizationToken ?? '',
            nextPageToken: event.nextPageToken);
        List<StudentPlusCourseWorkModel> studentPlusCourseWorkModel = [];
        studentPlusCourseWorkModel.addAll(event.oldList);
        studentPlusCourseWorkModel.addAll(list[1]);
        yield StudentPlusDemoLoading();
        yield StudentPlusCourseWorkSuccess(
            obj: studentPlusCourseWorkModel, nextPageToken: list[0]);
      } catch (e) {
        throw (e);
      }
    }

    if (event is SaveStudentGooglePresentationWorkEvent) {
      try {
        // //update the student google Presentation Url
        // event.studentDetails.studentGooglePresentationUrl =
        //     StudentPlusOverrides.studentPlusGooglePresentationBaseUrl +
        //         (event.studentDetails.studentGooglePresentationId ?? '');

        var isStudentGooglePresentationWorkSaved =
            await saveStudentGooglePresentationWorkDetails(
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
    /* ----------------------------- Event to search student using Email ---------------------------- */
    if (event is StudentPlusSearchByEmail) {
      try {
        yield StudentPlusGetDetailsLoading();
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        List<StudentPlusDetailsModel> list = await getStudentPlusSearchByEmail(
            studentEmail: _userProfileLocalData[0].userEmail ?? '');

        yield StudentPlusSearchByEmailSuccess(
          obj: list.length > 0
              ? list[0]
              : StudentPlusDetailsModel(
                  emailC: _userProfileLocalData[0].userEmail,
                  firstNameC: _userProfileLocalData[0].userName),
        );
      } catch (e) {
        yield StudentPlusErrorReceived(err: e);
      }
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              List of functions                             */
  /* -------------------------------------------------------------------------- */

  /* --------------- Function to return chipList for grades page -------------- */
  List<String> getChipsList(
      {required List<StudentPlusGradeModel> list,
      required bool fromStudentSection}) {
    List<String> chipList = [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].markingPeriodC != null &&
          !chipList.contains(list[i].markingPeriodC)) {
        chipList.add(list[i].markingPeriodC!);
      }
    }
    chipList.sort();
    if (fromStudentSection == true) {
      chipList.insert(0, "Current");
    }
    return chipList;
  }

  /* -------------------------------------------------------------------------- */
  /* ---- Function to call search api and return response according to that --- */
  /* -------------------------------------------------------------------------- */

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
  Future saveStudentGooglePresentationWorkDetails(
      {required StudentPlusDetailsModel studentDetails}) async {
    try {
      final body = {
        "Student__c": studentDetails.studentIdC,
        "Student_Record_Id": studentDetails.id,
        "Teacher__c": Globals.teacherId ?? '',
        "DBN__c": Globals.schoolDbnC ?? "",
        "School_App__c": Overrides.SCHOOL_ID ?? '',
        "Google_Presentation_Id":
            studentDetails.studentGooglePresentationId ?? '',
        "Google_Presentation_URL":
            studentDetails.studentGooglePresentationUrl ?? ''
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

  /* ---- Function to call search api through email --- */

  Future getStudentPlusSearchByEmail({required String studentEmail}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Student__c/studentEmail/$studentEmail',
          isCompleteUrl: true,
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
            "Authorization": "r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx"
          }); //change DBN to dynamic
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

  /* ------------------ Function to call get student course list ------------------ */
  Future getClassroomCourseList(
      {required String accessToken, required String refreshToken}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
        'https://classroom.googleapis.com/v1/courses',
        isCompleteUrl: true,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        },
      );
      if (response.statusCode == 200) {
        List<StudentPlusCourseModel> list = response.data["courses"]
            .map<StudentPlusCourseModel>(
                (i) => StudentPlusCourseModel.fromJson(i))
            .toList();
        list.removeWhere((element) => element.teacherFolder != null);
        return list;
      } else if ((response.statusCode == 401 ||
              // response.data['body'][" status"] != 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        var result = await Authentication.refreshAuthenticationToken(
            refreshToken: refreshToken!);

        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          List responseList = await getClassroomCourseList(
              accessToken: _userProfileLocalData[0].authorizationToken ?? '',
              refreshToken: _userProfileLocalData[0].refreshToken ?? '');
          return responseList;
        }
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

  /* ------------------ Function to call get student Course work api ------------------ */
  Future getStudentCourseWorkDetails(
      {required String courseId,
      required String accessToken,
      String? nextPageToken}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://qlys9nyyb1.execute-api.us-east-2.amazonaws.com/production/studentPlus/grades/student-classroom-grade/course/$courseId?pageSize=10',
          isCompleteUrl: true,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx',
            'G_AuthToken': '$accessToken',
            'G_RefreshToken': '$accessToken',
            'nextPageToken': nextPageToken ?? ''
          });
      if (response.statusCode == 200) {
        List<StudentPlusCourseWorkModel> list = response.data["data"]
            .map<StudentPlusCourseWorkModel>(
                (i) => StudentPlusCourseWorkModel.fromJson(i))
            .toList();
        String nextPageToken = response.data.containsKey('nextPageToken')
            ? response.data["nextPageToken"]
            : '';
        return [nextPageToken, list];
      }
    } catch (e) {
      throw (e);
    }
  }
}
