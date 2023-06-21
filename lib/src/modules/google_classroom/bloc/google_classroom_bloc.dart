import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/classroom_student_profile_modal.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_modal.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/overrides.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/Strings.dart';
import '../../../services/db_service.dart';
import '../../../services/db_service_response.model.dart';
import '../../../services/local_database/local_db.dart';
import '../../../services/user_profile.dart';
import '../../graded_plus/modal/user_info.dart';
import 'dart:convert';
import 'dart:io';
import '../services/google_classroom_globals.dart';
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
          PlusUtility.updateLogs(
              activityType: 'GRADED+',
              activityId: '24',
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

    /*----------------------------------------------------------------*/
    /*----------------------------------------------------------------*/
    /*----------------------------------------------------------------*/

    if (event is CreateClassRoomCourseWork) {
      try {
        yield GoogleClassroomLoading();
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        //get the student records from localdb to prepare assessment request body
        List<StudentAssessmentInfo>? assessmentData =
            await event.studentAssessmentInfoDb.getData();

        //event.studentClassObj = Google classroom Course Object come from import roster
        if ((event.studentClassObj.courseWorkId?.isEmpty ?? true) &&
            // (event.isFromHistoryAssessmentScanMore == true)
            (event.isFromHistoryAssessmentScanMore ?? false)) {
          // courseWorkId is null or empty, and isHistorySanMore is either null or false
          LocalDatabase<GoogleClassroomCourses> _googleClassRoomLocalDb =
              LocalDatabase(Strings.googleClassroomCoursesList);
          List<GoogleClassroomCourses> _googleClassRoomLocalData =
              await _googleClassRoomLocalDb.getData();

//Update the studentclassobject when the user tries to scan older records that are not available on Google Classroom
// checking the class name by title
          bool isClassroomCourseAdded = false;
          if ((_googleClassRoomLocalData?.isNotEmpty ?? false) &&
              (assessmentData?.isNotEmpty ?? false)) {
            if ((event.title?.isNotEmpty ?? false) &&
                (event.title.contains('_'))) {
              for (GoogleClassroomCourses classroom
                  in _googleClassRoomLocalData) {
                // always check last "_" contains in title and get the subject
                if ((event.title.split("_").last == classroom.name)) {
                  // print("insdie if loopppp");
                  isClassroomCourseAdded = true;
                  event.studentClassObj.courseId = classroom.courseId;
                  event.studentClassObj.studentList = classroom.studentList;
                  break;
                }
              }
            }

//check the class name is updated if not update the class name by student first records details - Worst scenario
            if (!isClassroomCourseAdded) {
              for (GoogleClassroomCourses classroom
                  in _googleClassRoomLocalData) {
                for (var student in classroom.studentList!) {
                  if (student['profile']['emailAddress'] ==
                      assessmentData.first.studentId) {
                    // print("insdie second if loop");
                    event.studentClassObj.courseId = classroom.courseId;
                    // event.studentClassObj.studentList is always empty from history screen
                    event.studentClassObj.studentList = classroom.studentList;
                    break;
                  }
                }
              }
            }
          }
        }

        // print(event.studentClassObj);
        // get local stored classroom course list
        List<dynamic> classRoomCoursesStudentList =
            event.studentClassObj?.studentList ?? [];

        //create student details as per the request body keys
        List<ClassRoomStudentProfile> studentAssessmentDetails = [];

        //update if any assessment images is not updated and update student profile list
        for (int i = 0; i < assessmentData.length; i++) {
          if (assessmentData[i].assessmentImage?.isNotEmpty != true) {
            // if any assessment images url is not updated
            String imgUrl = await updateImg(
                filePath: assessmentData[i]?.assessmentImgPath ?? '');

            if (imgUrl?.isNotEmpty ?? false) {
              assessmentData[i].assessmentImage = imgUrl;
              await event.studentAssessmentInfoDb.putAt(i, assessmentData[i]);
            }
          }

          //Check if assignment image and update in case found empty
          if ((i == 0) &&
              (assessmentData[0]?.questionImgUrl?.isEmpty ?? true) &&
              (assessmentData[0]?.questionImgFilePath?.isNotEmpty ?? false)) {
            String imgUrl = await updateImg(
                filePath: assessmentData[0]?.questionImgFilePath ?? '');
            if (imgUrl?.isNotEmpty ?? false) {
              assessmentData[0].questionImgUrl = imgUrl;
              await event.studentAssessmentInfoDb.putAt(0, assessmentData[0]);
            }
          }

          //update student googleClassRoomStudentProfileId into list
          classRoomCoursesStudentList.forEach((studentProfileObj) async {
            if ((studentProfileObj['profile']['emailAddress']?.isNotEmpty ??
                    false) &&
                (assessmentData[i]
                        .studentId == //studentId contains student email address
                    studentProfileObj['profile']['emailAddress']) &&
                (!assessmentData[i].isgoogleClassRoomStudentProfileUpdated!)) {
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

        if (studentAssessmentDetails.isNotEmpty) {
          List<dynamic> result = await _createClassRoomCourseWork(
              questionImageUrl: assessmentData.first.questionImgUrl,
              isEditStudentInfo: event.isEditStudentInfo,
              isFromHistoryAssessmentScanMore:
                  event.isFromHistoryAssessmentScanMore,
              authorizationToken:
                  userProfileLocalData[0].authorizationToken ?? '',
              refreshToken: userProfileLocalData[0].refreshToken ?? '',
              maxPoints: int.parse(event.pointPossible ?? "0") ?? 0,
              studentProfileDetails: studentAssessmentDetails,
              title: event.title,
              studentClassObj: event.studentClassObj);

          bool isClassRoomUpdated = result[0];

          dynamic obj =
              GoogleClassroomCourseworkModal(); // `dynamic` type is used here to allow either `GoogleClassroomCourseworkModal` or `String`

          // Conditionally cast the `obj` based on the value of `isClassRoomUpdated`
          if (isClassRoomUpdated) {
            obj = result[1]
                as GoogleClassroomCourseworkModal; // cast to `GoogleClassroomCourseworkModal` if `isClassRoomUpdated` is true
          } else {
            obj = result[1]
                as String; // set to a string if `isClassRoomUpdated` is false
          }

          if (isClassRoomUpdated && obj?.courseWorkId?.isNotEmpty == true) {
            if (event.studentClassObj?.courseWorkId?.isEmpty ?? true) {
              GoogleClassroomOverrides.studentAssessmentAndClassroomObj
                  .courseWorkId = obj.courseWorkId;

              GoogleClassroomOverrides.studentAssessmentAndClassroomObj
                  .courseWorkURL = obj.courseWorkURL;
            }

// // Updating local database with already scanned students data true to avoid include them in next scan more case
//             assessmentData.asMap().forEach((i, obj) {
//               studentAssessmentDetails.forEach((e) async {
//                 if (obj.googleClassRoomStudentProfileId == e.studentId) {
//                   obj.isgoogleClassRoomStudentProfileUpdated = true;
//                   await event.studentAssessmentInfoDb.putAt(i, obj);
//                 }
//               });
//             });

// Updating local database with already scanned students data true to avoid include them in next scan more case
            assessmentData.asMap().forEach(
              (i, element) async {
                if (element.isgoogleClassRoomStudentProfileUpdated != true) {
                  element.isgoogleClassRoomStudentProfileUpdated = true;
                  await event.studentAssessmentInfoDb.putAt(i, element);
                }
              },
            );

            yield CreateClassroomCourseWorkSuccess();
          } else {
            yield GoogleClassroomErrorState(errorMsg: obj[1].toString());
          }
        } else {
          yield CreateClassroomCourseWorkSuccess();
        }
      } catch (e) {
        yield GoogleClassroomErrorState(errorMsg: e.toString());
      }
    }

    /*----------------------------------------------------------------*/
    /*----------------------------------------------------------------*/
    /*----------------------------------------------------------------*/
    if (event is GetClassroomCourseWorkURL) {
      try {
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        List<dynamic> result = await _getClassroomCourseWorkURL(
            obj: event.obj,
            accessToken: _userProfileLocalData[0].authorizationToken,
            refreshToken: _userProfileLocalData[0].refreshToken);

        yield GetClassroomCourseWorkURLSuccess(
            isLinkAvailable: result[0], classroomCouseWorkURL: result[1]);
      } catch (e) {
        yield GetClassroomCourseWorkURLSuccess(
            isLinkAvailable: false, classroomCouseWorkURL: e.toString());
      }
    }

    /*----------------------------------------------------------------*/
    /*----------------------------------------------------------------*/
    /*----------------------------------------------------------------*/
    if (event is CreatePBISClassroomCoursework) {
      try {
        yield GoogleClassroomLoading();
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        var result = await _createPBISCoursework(
            authorizationToken:
                userProfileLocalData[0].authorizationToken ?? '',
            refreshToken: userProfileLocalData[0].refreshToken ?? '',
            teacherEmail: userProfileLocalData[0].userEmail ?? '',
            maxPoints: int.parse(event.pointPossible ?? "0") ?? 0,
            // studentProfileDetails: [],
            courseAndStudentList: event.courseAndStudentList);

        if (result[1] == '') {
          yield CreateClassroomCourseWorkSuccess();
        } else {
          yield GoogleClassroomErrorState(errorMsg: result[1]);
        }
      } catch (e) {
        print(e);
        yield GoogleClassroomErrorState(errorMsg: e.toString());
      }
    }

    if (event is CreateClassroomCourseWorkForStandardApp) {
      try {
        yield GoogleClassroomLoading();

        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        //get the student records from local db to prepare assessment request body
        List<StudentAssessmentInfo>? assessmentData =
            await event.studentAssessmentInfoDb.getData();

        //---------------------------------------------------------------------------------------------------------------------------------------------
        //Execute in case of scan more only
        //event.studentClassObj = Google classroom Course Object come from import roster
        if ((event.studentClassObj.id?.isEmpty ?? true) &&
            // (event.isFromHistoryAssessmentScanMore == true)
            (event.isFromHistoryAssessmentScanMore ?? false)) {
          // courseWorkId is null or empty, and isHistorySanMore is either null or false
          LocalDatabase<ClassroomCourse> _googleClassRoomLocalDb =
              LocalDatabase(OcrOverrides.gradedPlusStandardClassroomDB);
          List<ClassroomCourse> _googleClassRoomLocalData =
              await _googleClassRoomLocalDb.getData();

          //---------------------------------------------------------------------------------------------------------------------------------------------
          //Update the studentclassobject when the user tries to scan older records that are not available on Google Classroom
          // checking the class name by title
          bool isClassroomCourseAdded = false;
          if ((_googleClassRoomLocalData?.isNotEmpty ?? false) &&
              (assessmentData?.isNotEmpty ?? false)) {
            if ((event.title?.isNotEmpty ?? false) &&
                (event.title.contains('_'))) {
              for (ClassroomCourse classroom in _googleClassRoomLocalData) {
                // always check last "_" contains in title and get the subject
                if ((event.title.split("_").last == classroom.name)) {
                  // print("insdie if loopppp");
                  isClassroomCourseAdded = true;
                  event.studentClassObj.id = classroom.id;
                  event.studentClassObj.students = classroom.students;
                  break;
                }
              }
            }

            //---------------------------------------------------------------------------------------------------------------------------------------------
            //check the class name is updated if not update the class name by student first records details - Worst scenario
            if (!isClassroomCourseAdded) {
              for (ClassroomCourse classroom in _googleClassRoomLocalData) {
                for (var student in classroom.students!) {
                  if (student.profile!.emailAddress ==
                      assessmentData.first.studentId) {
                    // print("insdie second if loop");
                    event.studentClassObj.id = classroom.id;
                    // event.studentClassObj.studentList is always empty from history screen
                    event.studentClassObj.students = classroom.students;
                    break;
                  }
                }
              }
            }
          }
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------
        // get local stored classroom course list
        List<ClassroomStudents> classRoomCoursesStudentList =
            event.studentClassObj?.students ?? [];

        //create student details as per the request body keys
        List<ClassRoomStudentProfile> studentAssessmentDetails = [];

        //---------------------------------------------------------------------------------------------------------------------------------------------
        //update if any student assessment images is not updated and update student profile list
        for (int i = 0; i < assessmentData.length; i++) {
          if (assessmentData[i].assessmentImage?.isEmpty ?? true) {
            // if any assessment images url is not updated
            String imgUrl = await updateImg(
                filePath: assessmentData[i]?.assessmentImgPath ?? '');

            if (imgUrl?.isNotEmpty ?? false) {
              assessmentData[i].assessmentImage = imgUrl;
              await event.studentAssessmentInfoDb.putAt(i, assessmentData[i]);
            }
          }

          //---------------------------------------------------------------------------------------------------------------------------------------------
          //Check assignment question image and update in case found empty
          // Checking only at index 0 and then will copy the same for all students //same que image for all students
          if ((i == 0) &&
              (assessmentData[0]?.questionImgUrl?.isEmpty ?? true) &&
              (assessmentData[0]?.questionImgFilePath?.isNotEmpty ?? false)) {
            String imgUrl = await updateImg(
                filePath: assessmentData[0]?.questionImgFilePath ?? '');
            if (imgUrl?.isNotEmpty ?? false) {
              assessmentData[0].questionImgUrl = imgUrl;
              await event.studentAssessmentInfoDb.putAt(0, assessmentData[0]);
            }
          }

          //---------------------------------------------------------------------------------------------------------------------------------------------
          //update student googleClassRoomStudentProfileId into list // userid
          classRoomCoursesStudentList.forEach((studentProfileObj) async {
            if ((studentProfileObj.profile?.emailAddress?.isNotEmpty ??
                    false) &&
                (assessmentData[i]
                        .studentEmail == //studentId contains student email address
                    studentProfileObj.profile!.emailAddress) &&
                (!assessmentData[i].isgoogleClassRoomStudentProfileUpdated!)) {
              //adding student profile list

              studentAssessmentDetails.add(ClassRoomStudentProfile(
                  earnedPoint: int.parse(assessmentData[i].studentGrade ?? '0'),
                  studentAssessmentImage: assessmentData[i].assessmentImage,
                  studentId: studentProfileObj.profile!.id));

              //updating the google profile id in local student assignment list
              assessmentData[i].googleClassRoomStudentProfileId =
                  studentProfileObj.profile!.emailAddress;
              await event.studentAssessmentInfoDb.putAt(i, assessmentData[i]);
            }
          });
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------
        if (studentAssessmentDetails.isNotEmpty) {
          List<dynamic> result = await _createClassRoomCourseWorkForStanDardApp(
              questionImageUrl: assessmentData.first.questionImgUrl,
              isEditStudentInfo: event.isEditStudentInfo,
              isFromHistoryAssessmentScanMore:
                  event.isFromHistoryAssessmentScanMore,
              authorizationToken:
                  userProfileLocalData[0].authorizationToken ?? '',
              refreshToken: userProfileLocalData[0].authorizationToken ??
                  '', //!userProfileLocalData[0].refreshToken ?? '', Issue because refresh token is null
              maxPoints: int.parse(event.pointPossible ?? "0") ?? 0,
              studentProfileDetails: studentAssessmentDetails,
              title: event.title,
              studentClassObj: event.studentClassObj);

          bool isClassRoomUpdated = result[0];

          dynamic obj =
              GoogleClassroomCourseworkModal(); // `dynamic` type is used here to allow either `GoogleClassroomCourseworkModal` or `String`

          //---------------------------------------------------------------------------------------------------------------------------------------------
          // Conditionally cast the `obj` based on the value of `isClassRoomUpdated`
          if (isClassRoomUpdated) {
            obj = result[1]
                as GoogleClassroomCourseworkModal; // cast to `GoogleClassroomCourseworkModal` if `isClassRoomUpdated` is true
          } else {
            obj = result[1]
                as String; // set to a string if `isClassRoomUpdated` is false
          }

          //---------------------------------------------------------------------------------------------------------------------------------------------
          if (isClassRoomUpdated && obj?.courseWorkId?.isNotEmpty == true) {
            if (event.studentClassObj?.courseWorkId?.isEmpty ?? true) {
              if (event.isFromHistoryAssessmentScanMore == true) {
                GoogleClassroomOverrides
                    .historyStudentResultSummaryForStandardApp
                    .courseWorkId = obj.courseWorkId;

                GoogleClassroomOverrides
                    .historyStudentResultSummaryForStandardApp
                    .courseWorkURL = obj.courseWorkURL;
              } else {
                GoogleClassroomOverrides
                    .recentStudentResultSummaryForStandardApp
                    .courseWorkId = obj.courseWorkId;

                GoogleClassroomOverrides
                    .recentStudentResultSummaryForStandardApp
                    .courseWorkURL = obj.courseWorkURL;
              }
            }

            //---------------------------------------------------------------------------------------------------------------------------------------------
            // Updating local database with already scanned students data true to avoid include them in next scan more case
            assessmentData.asMap().forEach(
              (i, element) async {
                if (element.isgoogleClassRoomStudentProfileUpdated != true) {
                  element.isgoogleClassRoomStudentProfileUpdated = true;
                  await event.studentAssessmentInfoDb.putAt(i, element);
                }
              },
            );

            yield CreateClassroomCourseWorkSuccessForStandardApp();
          } else {
            yield GoogleClassroomErrorState(errorMsg: obj[1].toString());
          }
        } else {
// Updating local database with already scanned students data true to avoid include them in next scan more case
          assessmentData.asMap().forEach(
            (i, element) async {
              if (element.isgoogleClassRoomStudentProfileUpdated != true) {
                element.isgoogleClassRoomStudentProfileUpdated = true;
                await event.studentAssessmentInfoDb.putAt(i, element);
              }
            },
          );

          yield CreateClassroomCourseWorkSuccessForStandardApp();
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
        var result = await toRefreshAuthenticationToken(refreshToken!);

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
      PlusUtility.updateLogs(
          activityType: 'GRADED+',
          activityId: '24',
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

  Future<bool> toRefreshAuthenticationToken(String refreshToken) async {
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

  Future<List<dynamic>> _createClassRoomCourseWork(
      {required String authorizationToken,
      required String refreshToken,
      required String title,
      required int maxPoints,
      required List<ClassRoomStudentProfile> studentProfileDetails,
      required bool? isFromHistoryAssessmentScanMore,
      required GoogleClassroomCourses? studentClassObj,
      required bool? isEditStudentInfo,
      required String? questionImageUrl,
      int retry = 3}) async {
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
            .map((data) => isEditStudentInfo ?? false
                //user edit the student info.
                ? data.editStudentInfotoJson()
                : data.toJson())
            .toList()
      };

//if courseWorkId is available need to update the classroom with new student or edit the student info
      body['courseWorkId'] = studentClassObj.courseWorkId?.isNotEmpty == true
          ? studentClassObj.courseWorkId
          : null;

//If courseWorkId is null, prepare request body to add a assignment in Google Classroom
      if (body['courseWorkId'] == null) {
        int lastUnderscoreIndex = title.lastIndexOf(
            "_"); // find the index of the last underscore character
        title = lastUnderscoreIndex == -1
            ? title
            : title.substring(0, lastUnderscoreIndex);

        body.addAll({
          'title': title,
          if (questionImageUrl?.isNotEmpty ?? false)
            'materials': [
              {
                "link": {
                  "thumbnailUrl": questionImageUrl,
                  "url": questionImageUrl
                }
              }
            ]
        });
      }

      final ResponseModel response = await _dbServices.postApi(url,
          headers: headers, body: body, isGoogleApi: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        GoogleClassroomCourseworkModal data =
            GoogleClassroomCourseworkModal.fromJson(response.data);
        if ((studentClassObj.courseWorkId?.isEmpty ?? true) &&
            (isFromHistoryAssessmentScanMore == true)) {
          // If courseWorkId is null or empty, and isHistorySanMore is either null or false

          //Updating classroomCourseId and courseWorkId on DATABASE ASSESSMENT_C for recent assessment scan only
          await _bloc.updateAssessmentOnDashboardOnHistoryScanMore(
              assessmentId: studentClassObj?.assessmentCId,
              classroomCourseId: studentClassObj?.courseId,
              classroomCourseWorkId: data.courseWorkId);
        }

        return [true, data];
      }
      //retry =3 max
      else if (retry > 0) {
        var result = await toRefreshAuthenticationToken(refreshToken);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          return await _createClassRoomCourseWork(
              questionImageUrl: questionImageUrl,
              retry: retry - 1,
              isEditStudentInfo: isEditStudentInfo,
              isFromHistoryAssessmentScanMore: isFromHistoryAssessmentScanMore,
              authorizationToken: _userProfileLocalData[0].authorizationToken!,
              maxPoints: maxPoints,
              refreshToken: _userProfileLocalData[0].refreshToken!,
              studentProfileDetails: studentProfileDetails,
              title: title,
              studentClassObj: studentClassObj);
        }
      } else if ((response.statusCode == 401 ||
          // response.data['body'][" status"] != 401 ||
          response.data['statusCode'] == 500)) {
        return [false, 'ReAuthentication is required'];
      }
      return [];
    } catch (e) {
      return [false, e.toString()];
    }
  }

  Future<String> updateImg({required String filePath}) async {
    try {
      String imgExtension = filePath.substring(filePath.lastIndexOf(".") + 1);
      File assessmentImageFile = File(filePath);
      List<int> imageBytes = assessmentImageFile.readAsBytesSync();
      String imageB64 = base64Encode(imageBytes);

      return await _googleDriveBloc.uploadImgB64AndGetUrl(
          imgBase64: imageB64,
          imgExtension: imgExtension,
          section: "assessment-sheet");
    } catch (e) {
      return '';
    }
  }

  Future<List<dynamic>> _getClassroomCourseWorkURL({
    required GoogleClassroomCourses? obj,
    required String? accessToken,
    required String? refreshToken,
    int retry = 3,
  }) async {
    try {
      String? courseId = obj?.courseId ?? '';
      String? courseWorkId = obj?.courseWorkId ?? '';

      if ((courseId?.isEmpty ?? true) || (courseWorkId?.isEmpty ?? true)) {
        return [true, ''];
      }
      final ResponseModel response = await _dbServices.getApiNew(
          // 'https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://classroom.googleapis.com/v1/courses/$courseId/courseWork/$courseWorkId',
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $accessToken'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        final url = response?.data?['body']?['alternateLink'] as String?;
        return [url?.isNotEmpty == true, url ?? ''];
      } else if (retry > 0) {
        var result = await toRefreshAuthenticationToken(refreshToken!);

        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          return await _getClassroomCourseWorkURL(
              obj: obj,
              accessToken: _userProfileLocalData[0].authorizationToken,
              refreshToken: _userProfileLocalData[0].refreshToken,
              retry: retry - 1);
        }
      }
      return [false, ''];
    } catch (e) {
      print(e);
      return [false, e.toString()];
    }
  }

  Future<List<dynamic>> _createPBISCoursework({
    required String authorizationToken,
    required String refreshToken,
    required String teacherEmail,
    required int maxPoints,
    required List<ClassroomCourse> courseAndStudentList,
    int retry = 3,
  }) async {
    final pbisBloc = PBISPlusBloc();

    try {
      final currentDate =
          Utility.convertTimestampToDateFormat(DateTime.now(), "MM/dd/yy");
      //Remove manually added 'All' option from the list
      if (courseAndStudentList.length > 0 &&
          courseAndStudentList[0].name == 'All') {
        courseAndStudentList.removeAt(0);
      }

      for (int i = 0; i < courseAndStudentList.length; i++) {
        // print('index i : $i');

        // To add only course related student for single course
        if (courseAndStudentList[i].students!.length > 0) {
          final studentProfileDetails = courseAndStudentList[i]
              .students!
              .map((student) => ClassRoomStudentProfile(
                    studentId: student.profile!.id,
                    studentAssessmentImage: '',
                    earnedPoint: student.profile!.engaged! +
                        student.profile!.niceWork! +
                        student.profile!.helpful!,
                  ))
              .toList();

          final url =
              'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/googleClassroomCoursework';

          final headers = {
            'G_AuthToken': authorizationToken,
            'G_RefreshToken': refreshToken,
            'Content-Type': 'application/json',
            'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx',
          };

          final body = {
            "courseId": courseAndStudentList[i].id,
            "title": 'PBIS_${Globals.appSetting.contactNameC}_$currentDate',
            "description":
                'PBIS_${Globals.appSetting.contactNameC}_$currentDate',
            "maxPoints": maxPoints,
            "studentAssessmentDetails":
                studentProfileDetails.map((data) => data.toJson()).toList(),
          };

          final response = await _dbServices.postApi(url,
              headers: headers, body: body, isGoogleApi: true);

          // print('_createPBISCoursework :$response');
          if (response.statusCode == 200 &&
              response.data['statusCode'] == 200) {
            //If classroom assignment successfully created, add the record with url in the database

            await pbisBloc.createPBISPlusHistoryData(
              type: 'Classroom',
              url: response.data['courseWorkURL'],
              teacherEmail: teacherEmail,
              classroomCourseName: courseAndStudentList[i].name,
            );
          } else if (retry > 0) {
            final result = await toRefreshAuthenticationToken(refreshToken);

            if (result == true) {
              final userProfileLocalData =
                  await UserGoogleProfile.getUserProfile();

              return _createPBISCoursework(
                retry: retry - 1,
                authorizationToken: userProfileLocalData[0].authorizationToken!,
                teacherEmail: teacherEmail,
                maxPoints: maxPoints,
                refreshToken: userProfileLocalData[0].refreshToken!,
                courseAndStudentList: courseAndStudentList,
              );
            }
          }
        }
      }

      return [true, ''];
    } catch (e) {
      print(e);
      return [false, e];
    }
  }

  Future<List<dynamic>> _createClassRoomCourseWorkForStanDardApp(
      {required String authorizationToken,
      required String refreshToken,
      required String title,
      required int maxPoints,
      required List<ClassRoomStudentProfile> studentProfileDetails,
      required bool? isFromHistoryAssessmentScanMore,
      required ClassroomCourse? studentClassObj,
      required bool? isEditStudentInfo,
      required String? questionImageUrl,
      int retry = 3}) async {
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
        "courseId": studentClassObj!.id,
        "maxPoints": maxPoints,
        "studentAssessmentDetails": studentProfileDetails
            .map((data) => isEditStudentInfo ?? false
                //user edit the student info.
                ? data.editStudentInfotoJson()
                : data.toJson())
            .toList()
      };

      //if courseWorkId is available need to update the classroom with new student or edit the student info
      body['courseWorkId'] = studentClassObj.courseWorkId?.isNotEmpty == true
          ? studentClassObj.courseWorkId
          : null;
      // body['courseWorkId'] = null;

      //If courseWorkId is null, prepare request body to add a assignment in Google Classroom
      if (body['courseWorkId'] == null) {
        // find the index of the last underscore character and pick the title before last underscore
        int lastUnderscoreIndex = title.lastIndexOf("_");
        title = lastUnderscoreIndex == -1
            ? title
            : title.substring(0, lastUnderscoreIndex);

        body.addAll({
          'title': title,
          if (questionImageUrl?.isNotEmpty ?? false)
            'materials': [
              {
                "link": {
                  "thumbnailUrl": questionImageUrl,
                  "url": questionImageUrl
                }
              }
            ]
        });
      }

      final ResponseModel response = await _dbServices.postApi(url,
          headers: headers, body: body, isGoogleApi: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        GoogleClassroomCourseworkModal data =
            GoogleClassroomCourseworkModal.fromJson(response.data);

        //Call only in case of scan more
        if ((studentClassObj.id?.isEmpty ?? true) &&
            (isFromHistoryAssessmentScanMore == true)) {
          // If courseWorkId is null or empty, and isHistorySanMore is either null or false
          //Updating classroomCourseId and courseWorkId on DATABASE ASSESSMENT_C for recent assessment scan only
          await _bloc.updateAssessmentOnDashboardOnHistoryScanMore(
              assessmentId: studentClassObj.assessmentCId,
              classroomCourseId: studentClassObj.id,
              classroomCourseWorkId: data.courseWorkId);
        }

        return [true, data];
      }
      //retry =3 max
      else if (retry > 0) {
        var result = await toRefreshAuthenticationToken(refreshToken);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          return await _createClassRoomCourseWorkForStanDardApp(
              questionImageUrl: questionImageUrl,
              retry: retry - 1,
              isEditStudentInfo: isEditStudentInfo,
              isFromHistoryAssessmentScanMore: isFromHistoryAssessmentScanMore,
              authorizationToken: _userProfileLocalData[0].authorizationToken!,
              maxPoints: maxPoints,
              refreshToken: _userProfileLocalData[0].refreshToken!,
              studentProfileDetails: studentProfileDetails,
              title: title,
              studentClassObj: studentClassObj);
        }
      } else if ((response.statusCode == 401 ||
          // response.data['body'][" status"] != 401 ||
          response.data['statusCode'] == 500)) {
        return [false, 'ReAuthentication is required'];
      }
      return [];
    } catch (e) {
      return [false, e.toString()];
    }
  }
}
