import 'package:Soc/src/modules/google_classroom/modal/classroom_student_profile_modal.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/Strings.dart';
import '../../../services/db_service.dart';
import '../../../services/db_service_response.model.dart';
import '../../../services/local_database/local_db.dart';
import '../../google_drive/model/user_profile.dart';
import '../../ocr/modal/student_assessment_info_modal.dart';
import '../../ocr/modal/user_info.dart';
import '../../ocr/graded_overrides.dart';
import 'dart:convert';
import 'dart:io';
import '../google_classroom_globals.dart';
part 'google_classroom_event.dart';
part 'google_classroom_state.dart';

class GoogleClassroomBloc
    extends Bloc<GoogleClassroomEvent, GoogleClassroomState> {
  GoogleClassroomBloc() : super(GoogleClassroomInitial());

  final DbServices _dbServices = DbServices();
  int _totalRetry = 0;
  GoogleDriveBloc _googleDriveBloc = GoogleDriveBloc();
  final OcrBloc _bloc = new OcrBloc();
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
          Utility.updateLogs(
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
            errorMsg: 'ReAuthentication is required',
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

    if (event is CreateClassRoomCourseWork) {
      try {
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        //get the student records from localdb to prepare assessment request body
        List<StudentAssessmentInfo>? assessmentData =
            await event.studentAssessmentInfoDb.getData();

        //event.studentClassObj = Google classroom Course Object come from import roster
        if ((event.studentClassObj.courseWorkId?.isEmpty ?? true) &&
            (event.isFromHistoryAssessmentScanMore ?? false)) {
          // courseWorkId is null or empty, and isHistorySanMore is either null or false
          LocalDatabase<GoogleClassroomCourses> _googleClassRoomLocalDb =
              LocalDatabase(Strings.googleClassroomCoursesList);
          List<GoogleClassroomCourses> _googleClassRoomLocalData =
              await _googleClassRoomLocalDb.getData();

          //Preparing student list for classroom request
          if (_googleClassRoomLocalData?.isNotEmpty == true &&
              assessmentData?.isNotEmpty == true) {
            for (GoogleClassroomCourses classroom
                in _googleClassRoomLocalData) {
              for (var student in classroom.studentList!) {
                if (student['profile']['emailAddress'] ==
                    assessmentData.first.studentId) {
                  event.studentClassObj.courseId = classroom.courseId;
                  // event.studentClassObj.studentList is always empty from history screen
                  event.studentClassObj.studentList = classroom.studentList;
                }
              }
            }
          }
        }

        print(event.studentClassObj);
        // get local stored classroom course list
        List<dynamic> classRoomCoursesStuentList =
            event.studentClassObj?.studentList ?? [];

        //create student details as per the request body keys
        List<ClassRoomStudentProfile> studentAssessmentDetails = [];

        //update if any assessment images is not updated and update student profile list
        for (int i = 0; i < assessmentData.length; i++) {
          if (assessmentData[i].assessmentImage?.isNotEmpty != true) {
            // if any assessment images url is not updated
            String imgExtension = assessmentData[i]
                .assessmentImgPath!
                .substring(
                    assessmentData[i].assessmentImgPath!.lastIndexOf(".") + 1);
            File assessmentImageFile =
                File(assessmentData[i].assessmentImgPath!);
            List<int> imageBytes = assessmentImageFile.readAsBytesSync();
            String imageB64 = base64Encode(imageBytes);

            String imgUrl = await _googleDriveBloc.uploadImgB64AndGetUrl(
                imgBase64: imageB64,
                imgExtension: imgExtension,
                section: "assessment-sheet");

            if (imgUrl.isNotEmpty) {
              assessmentData[i].assessmentImage = imgUrl;
              await event.studentAssessmentInfoDb.putAt(i, assessmentData[i]);
            }
          }

          //update student googleClassRoomStudentProfileId into list
          classRoomCoursesStuentList.forEach((studentProfileObj) async {
            // true &&   true && false
            if (studentProfileObj?['profile']?['emailAddress']?.isNotEmpty ==
                    true &&
                assessmentData[i]
                        .studentId == //studentId contains student email address
                    studentProfileObj['profile']['emailAddress'] &&
                !assessmentData[i].isgoogleClassRoomStudentProfileUpdated) {
              //adding student profile list

              studentAssessmentDetails.add(ClassRoomStudentProfile(
                  earnedPoint: int.parse(assessmentData[i].studentGrade ?? '0'),
                  studentAssessmentImage: assessmentData[i].assessmentImage,
                  studentId: studentProfileObj['profile']['id']));

              //updating the google profile id in local student assignment list
              assessmentData[i].googleClassRoomStudentProfileId =
                  studentProfileObj['profile']['id'];
              await event.studentAssessmentInfoDb.putAt(i, assessmentData[i]);
            }
          });
        }

// //adding student profile list
//         assessmentData.forEach((e) {
//           if (e.googleClassRoomStudentProfileId?.isNotEmpty == true &&
//               !e.isgoogleClassRoomStudentProfileUpdated) {
//             studentProfileDetails.add(ClassRoomStudentProfile(
//                 earnedPoint: int.parse(e.studentGrade ?? '0'),
//                 studentAssessmentImage: e.assessmentImage,
//                 studentId: e.googleClassRoomStudentProfileId));
//           }
//         });

        if (studentAssessmentDetails.isNotEmpty) {
          var result = await _createClassRoomCourseWork(
              isEditStudentinfo: event.isEditStudentInfo,
              isFromHistoryAssessmentScanMore:
                  event.isFromHistoryAssessmentScanMore,
              authorizationToken:
                  userProfileLocalData[0].authorizationToken ?? '',
              refreshToken: userProfileLocalData[0].refreshToken ?? '',
              maxPoints: int.parse(event.pointPossible ?? "0") ?? 0,
              studentProfileDetails: studentAssessmentDetails,
              title: event.title,
              studentClassObj: event.studentClassObj);

          if (result[0] && result[1]?.isNotEmpty == true) {
            //   print("upting list and courseworid");
            GoogleClassroomGlobals.studentClassRoomObj!.courseWorkId =
                result[1];

// Updating local database with already scanned students data true to avoid include them in next scan more case
            assessmentData.asMap().forEach((i, obj) {
              studentAssessmentDetails.forEach((e) async {
                if (obj.googleClassRoomStudentProfileId == e.studentId) {
                  obj.isgoogleClassRoomStudentProfileUpdated = true;
                  await event.studentAssessmentInfoDb.putAt(i, obj);
                }
              });
            });

            yield CreateClassroomCourseWorkSuccess();
          } else {
            yield GoogleClassroomErrorState(errorMsg: result[1].toString());
          }
        } else {
          yield CreateClassroomCourseWorkSuccess();
        }
      } catch (e) {
        yield GoogleClassroomErrorState(errorMsg: e.toString());
      }
    }
  }

  GoogleClassroomState get initialState => GoogleClassroomInitial();

  Future<List> getAllGoogleClassroomCourses(
      {required String? accessToken, required String? refreshToken}) async {
    try {
      // Map<String, String> headers = {
      //   'Content-Type': 'application/json',
      //   'authorization': 'Bearer $accessToken'
      // };

      final ResponseModel response = await _dbServices.getApiNew(
          // '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}' +
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/importRoster/$accessToken',
          //'https://classroom.googleapis.com/v1/courses',
          // headers: headers,
          isCompleteUrl: true);

      if (response.statusCode != 401 &&
          response.data['body'] != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        // print(response.data['body']);
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
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          List responseList = await getAllGoogleClassroomCourses(
              accessToken: _userProfileLocalData[0].authorizationToken,
              refreshToken: _userProfileLocalData[0].refreshToken);
          return responseList;
        } else {
          List<GoogleClassroomCourses> data = [];
          return [data, 'ReAuthentication is required'];
        }
      } else {
        List<GoogleClassroomCourses> data = [];
        return [data, 'ReAuthentication is required'];
      }
    } catch (e) {
      Utility.updateLogs(
          activityId: '24',
          // sessionId: widget.assessmentDetailPage == true
          //     ? widget.obj!.sessionId
          //     : '',
          description: 'Import Roster failure',
          operationResult: 'failure');

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

  Future<bool> _toRefreshAuthenticationToken(String refreshToken) async {
    try {
      final body = {"refreshToken": refreshToken};
      final ResponseModel response = await _dbServices.postApi(
          "${OcrOverrides.OCR_API_BASE_URL}/refreshGoogleAuthentication",
          body: body,
          isGoogleApi: true);
      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        var newToken = response.data['body']; //["access_token"]
        //!=null?response.data['body']["access_token"]:response.data['body']["error"];
        if (newToken["access_token"] != null) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          UserInformation updatedObj = UserInformation(
              userName: _userProfileLocalData[0].userName,
              userEmail: _userProfileLocalData[0].userEmail,
              profilePicture: _userProfileLocalData[0].profilePicture,
              refreshToken: _userProfileLocalData[0].refreshToken,
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

  Future<List> _createClassRoomCourseWork(
      {required String authorizationToken,
      required String refreshToken,
      required String title,
      required int maxPoints,
      required List<ClassRoomStudentProfile> studentProfileDetails,
      required bool? isFromHistoryAssessmentScanMore,
      required GoogleClassroomCourses? studentClassObj,
      required bool? isEditStudentinfo}) async {
    try {
      final url =
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/googleClassroomCoursework';

      final headers = {
        'G_AuthToken': authorizationToken,
        'G_RefreshToken': refreshToken,
        'Content-Type': 'application/json',
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
      };

      Map<String, dynamic> body = {
        "courseId": studentClassObj!.courseId,
        "maxPoints": maxPoints,
        "studentAssessmentDetails": studentProfileDetails
            .map((data) => isEditStudentinfo ?? false
                //user edit the student info.
                ? data.editStudentInfotoJson()
                : data.toJson())
            .toList()
      };
//if courseWorkId is available need to update the classroom with new student or edit th student info
      if (studentClassObj.courseWorkId?.isNotEmpty == true) {
        body['courseWorkId'] = studentClassObj.courseWorkId;
      } else {
        body['title'] = title;
      }

      final ResponseModel response = await _dbServices.postApi(url,
          headers: headers, body: body, isGoogleApi: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        if ((studentClassObj.courseWorkId?.isEmpty ?? true) &&
            (isFromHistoryAssessmentScanMore == true)) {
          // courseWorkId is null or empty, and isHistorySanMore is either null or false
//Adding courseWorkId on DATABASE ASSESSMENT_C on historyScanMore

          await _bloc.updateAssessmentOnDashboardOnHistoryScanMore(
              assessmentId: studentClassObj?.assessmentCId,
              classroomCourseId: studentClassObj?.courseId,
              classroomCourseWorkId: response.data['courseWorkId']);
        }

        return [true, response.data['courseWorkId']];
      } else if ((response.statusCode != 200 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        var result = await _toRefreshAuthenticationToken(refreshToken);

        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          return await _createClassRoomCourseWork(
              isEditStudentinfo: isEditStudentinfo,
              isFromHistoryAssessmentScanMore: isFromHistoryAssessmentScanMore,
              authorizationToken: _userProfileLocalData[0].authorizationToken!,
              maxPoints: maxPoints,
              refreshToken: _userProfileLocalData[0].refreshToken!,
              studentProfileDetails: studentProfileDetails,
              title: title,
              studentClassObj: studentClassObj);
        }
      }

      return [false, 'ReAuthentication is required'];
    } catch (e) {
      return [false, e.toString()];
    }
  }
}
