import 'package:Soc/src/modules/google_classroom/modal/classroom_student_list.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../services/Strings.dart';
import '../../../services/db_service.dart';
import '../../../services/db_service_response.model.dart';
import '../../../services/local_database/local_db.dart';
import '../../google_drive/model/user_profile.dart';
import '../../google_drive/overrides.dart';
import '../../ocr/modal/user_info.dart';
import '../../ocr/overrides.dart';
part 'google_classroom_event.dart';
part 'google_classroom_state.dart';

class GoogleClassroomBloc
    extends Bloc<GoogleClassroomEvent, GoogleClassroomState> {
  GoogleClassroomBloc() : super(GoogleClassroomInitial());
  final DbServices _dbServices = DbServices();
  GoogleClassroomState get initialState => GoogleClassroomInitial();
  int _totalRetry = 0;

  @override
  Stream<GoogleClassroomState> mapEventToState(
    GoogleClassroomEvent event,
  ) async* {
    if (event is GetClassroomCourses) {
      try {
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        LocalDatabase<GoogleClassroomCourses> _localDb =
            LocalDatabase(Strings.googleClassroomCoursesList);

        List<GoogleClassroomCourses>? _localData = await _localDb.getData();
        //   _localData.sort((a, b) => a..compareTo(b.sortOrder));
        //  ldskvlnk

        if (_localData.isEmpty) {
          yield GoogleClassroomLoading();
        } else {
          sort(obj: _localData);
          yield GoogleClassroomCourseListSuccess(obj: _localData);
        }

        //API call to refresh with the latest data in the local DB
        List responseList = await getAllGoogleClassroomCourses(
            accessToken: userProfileLocalData[0].authorizationToken,
            refreshToken: userProfileLocalData[0].refreshToken);
        // print('Course list length : ${coursesList.length}');

        if (responseList[1] == '') {
          List<GoogleClassroomCourses> coursesList = responseList[0];

          await _localDb.clear();
          coursesList.forEach((GoogleClassroomCourses e) {
            _localDb.addData(e);
          });
          Utility.updateLoges(
              activityId: '24',
              // sessionId: widget.assessmentDetailPage == true
              //     ? widget.obj!.sessionId
              //     : '',
              description: 'Import Roster Successfully',
              operationResult: 'Success');

          yield GoogleClassroomLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
          sort(obj: coursesList);
          yield GoogleClassroomCourseListSuccess(obj: coursesList);
        } else {
          yield GoogleClassroomErrorState(
            errorMsg: 'Reauthentication is required',
          );
        }
      } catch (e) {
        print(e);
        LocalDatabase<GoogleClassroomCourses> _localDb =
            LocalDatabase(Strings.googleClassroomCoursesList);

        List<GoogleClassroomCourses>? _localData = await _localDb.getData();
        _localDb.close();

        yield GoogleClassroomLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        sort(obj: _localData);
        yield GoogleClassroomCourseListSuccess(obj: _localData);
      }
    }

    // if (event is GetClassroomStudentsByCourseId) {
    //   try {
    //     //Fetch logged in user profile
    //     List<UserInformation> userProfileLocalData =
    //         await UserGoogleProfile.getUserProfile();
    //     LocalDatabase<GoogleClassroomStudents> _localDb =
    //         LocalDatabase(Strings.googleClassroomStudentList);

    //     List<GoogleClassroomStudents>? _localData = await _localDb.getData();

    //     if (_localData.isEmpty) {
    //       yield GoogleClassroomLoading();
    //     } else {
    //       yield GoogleClassroomStudentListSuccess(obj: _localData);
    //     }

    //     //API call to refresh with the latest data in the local DB
    //     List responseList = await getClassroomStudentsByCoursesId(
    //         courseId: event.courseId,
    //         accessToken: userProfileLocalData[0].authorizationToken,
    //         refreshToken: userProfileLocalData[0].refreshToken);

    //     if (responseList[1] == '') {
    //       List<GoogleClassroomStudents> coursesList = responseList[0];

    //       await _localDb.clear();
    //       coursesList.forEach((GoogleClassroomStudents e) {
    //         _localDb.addData(e);
    //       });
    //       _localDb.close();
    //       yield GoogleClassroomLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
    //       yield GoogleClassroomStudentListSuccess(obj: coursesList);
    //     } else {
    //       yield GoogleClassroomErrorState(
    //         errorMsg: 'Reauthentication is required',
    //       );
    //     }
    //   } catch (e) {
    //     print(e);
    //     LocalDatabase<GoogleClassroomStudents> _localDb =
    //         LocalDatabase(Strings.googleClassroomStudentList);

    //     List<GoogleClassroomStudents>? _localData = await _localDb.getData();
    //     _localDb.close();

    //     yield GoogleClassroomLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
    //     yield GoogleClassroomStudentListSuccess(obj: _localData);
    //   }
    // }
  }

  Future<List> getAllGoogleClassroomCourses(
      {required String? accessToken, required String? refreshToken}) async {
    try {
      // Map<String, String> headers = {
      //   'Content-Type': 'application/json',
      //   'authorization': 'Bearer $accessToken'
      // };

      final ResponseModel response = await _dbServices.getapiNew(
          // '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}' +
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/importRoster/$accessToken',
          //'https://classroom.googleapis.com/v1/courses',
          // headers: headers,
          isCompleteUrl: true);

      if (response.statusCode != 401 &&
          response.data['body'] != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        List<GoogleClassroomCourses> data = response.data['body']
            .map<GoogleClassroomCourses>(
                (i) => GoogleClassroomCourses.fromJson(i))
            .toList();

        return [data, ''];
      } else if ((response.statusCode == 401 ||
              // response.data['body'][" status"] != 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        var result = await _toRefreshAuthenticationToken(refreshToken!);

        if (result == true) {
          List<UserInformation> _userprofilelocalData =
              await UserGoogleProfile.getUserProfile();

          List responseList = await getAllGoogleClassroomCourses(
              accessToken: _userprofilelocalData[0].authorizationToken,
              refreshToken: _userprofilelocalData[0].refreshToken);
          return responseList;
        } else {
          List<GoogleClassroomCourses> data = [];
          return [data, 'Reauthentication is required'];
        }
      } else {
        List<GoogleClassroomCourses> data = [];
        return [data, 'Reauthentication is required'];
      }
    } catch (e) {
      Utility.updateLoges(
          activityId: '24',
          // sessionId: widget.assessmentDetailPage == true
          //     ? widget.obj!.sessionId
          //     : '',
          description: 'Import Roster failure',
          operationResult: 'failure');

      throw (e);
    }
  }

  // Future getClassroomStudentsByCoursesId(
  //     {required String? accessToken,
  //     required String? refreshToken,
  //     required String? courseId}) async {
  //   try {
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'authorization': 'Bearer $accessToken'
  //     };

  //     final ResponseModel response = await _dbServices.getApiNew(
  //         '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}' +
  //             'https://classroom.googleapis.com/v1/courses/$courseId/students?fields=students(profile)',
  //         headers: headers,
  //         isGoogleAPI: true);

  //     if (response.statusCode != 401 &&
  //         response.data['body'] != 401 &&
  //         response.statusCode == 200 &&
  //         response.data['statusCode'] != 500) {
  //       // GoogleClassroomStudents responseData = googleStudentFromMap(response);
  //       // print(responseData.body!.students);
  //       // print(responseData.statusCode);
  //       List<GoogleClassroomStudents> data = response.data['body']['students']
  //           .map<GoogleClassroomStudents>(
  //               (i) => GoogleClassroomStudents.fromJson(i))
  //           .toList();
  //       return [data, ''];
  //       // return [responseData];
  //     } else if ((response.statusCode == 401 ||
  //             // response.data['body'][" status"] != 401 ||
  //             response.data['statusCode'] == 500) &&
  //         _totalRetry < 3) {
  //       print("Error in fetching student list");
  //       var result = await _toRefreshAuthenticationToken(refreshToken!);

  //       if (result == true) {
  //         List<UserInformation> _userprofilelocalData =
  //             await UserGoogleProfile.getUserProfile();

  //         String result = await getClassroomStudentsByCoursesId(
  //             courseId: courseId,
  //             accessToken: _userprofilelocalData[0].authorizationToken,
  //             refreshToken: _userprofilelocalData[0].refreshToken);
  //         print(result);
  //         return;
  //       } else {
  //         List<GoogleClassroomStudents> data = [];
  //         return [data, 'Reauthentication is required'];
  //       }
  //       // return [];
  //     }
  //   } catch (e) {
  //     print("inside catch");
  //     throw (e);
  //   }
  // }

  Future<bool> _toRefreshAuthenticationToken(String refreshToken) async {
    try {
      final body = {"refreshToken": refreshToken};
      final ResponseModel response = await _dbServices.postapi(
          "${OcrOverrides.OCR_API_BASE_URL}/refreshGoogleAuthentication",
          body: body,
          isGoogleApi: true);
      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        var newToken = response.data['body']; //["access_token"]
        //!=null?response.data['body']["access_token"]:response.data['body']["error"];
        if (newToken["access_token"] != null) {
          List<UserInformation> _userprofilelocalData =
              await UserGoogleProfile.getUserProfile();

          UserInformation updatedObj = UserInformation(
              userName: _userprofilelocalData[0].userName,
              userEmail: _userprofilelocalData[0].userEmail,
              profilePicture: _userprofilelocalData[0].profilePicture,
              refreshToken: _userprofilelocalData[0].refreshToken,
              authorizationToken: newToken["access_token"]);

          await UserGoogleProfile.updateUserProfile(updatedObj);

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  sort({required List<GoogleClassroomCourses> obj}) {
    obj.sort((a, b) => a.name!.compareTo(b.name!));
    try {
      for (int i = 0; i < obj.length; i++) {
        if (obj[i].studentList!.length > 0) {
          obj[i].studentList!.sort((a, b) => a['profile']['name']['givenName']!
              .toString()
              .toUpperCase()
              .compareTo(
                  b['profile']['name']['givenName']!.toString().toUpperCase()));
        }
      }
    } catch (e) {}
  }
}
