import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/modal/RubricPdfModal.dart';
import 'package:Soc/src/modules/graded_plus/modal/state_object_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_details_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_details_standard_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:string_similarity/string_similarity.dart';
import '../../google_drive/model/assessment_detail_modal.dart';
part 'graded_plus_event.dart';
part 'graded_plus_state.dart';

class OcrBloc extends Bloc<OcrEvent, OcrState> {
  OcrBloc() : super(OcrInitial());
  final DbServices _dbServices = DbServices();
  // final HiveDbServices _localDbService = HiveDbServices();
  OcrState get initialState => OcrInitial();
  String grade = '';
  String selectedSubject = '';
  // String? DashboardId;
  int _totalRetry = 0;
  @override
  Stream<OcrState> mapEventToState(
    OcrEvent event,
  ) async* {
    if (event is FetchTextFromImage) {
      try {
        //     yield FetchTextFromImageFailure(schoolId: '', grade: '');
        yield OcrLoading();

        if (Overrides.STANDALONE_GRADED_APP) {
          List resultList = await Future.wait([
            emailDetectionApi(base64: event.base64),
            event.isMcqSheet == true
                ? processMcqSheet(base64: event.base64)
                : processAssessmentSheet(
                    base64: event.base64, pointPossible: event.pointPossible)
          ]);
          String email = resultList[0][0];
          String name = resultList[0][1];
          String grade = resultList[1][0];
          String result = event.isMcqSheet == true
              ? getMcqAnswer(detectedAnswer: grade)
              : grade;
          if (email != '' && name != '' && grade != '') {
            yield FetchTextFromImageSuccess(
                studentId: email, grade: result, studentName: name);
          } else {
            yield FetchTextFromImageFailure(
                studentId: email, grade: result, studentName: name);
          }
        } else {
          if (event.isMcqSheet == true) {
            List resultList = await processMcqSheet(base64: event.base64);
            String email = resultList[1];
            String name = resultList[2];
            String grade = resultList[0];
            String result = getMcqAnswer(detectedAnswer: grade);

            if (email != '' && name != '' && grade != '') {
              yield FetchTextFromImageSuccess(
                  studentId: email, grade: result, studentName: name);
            } else {
              yield FetchTextFromImageFailure(
                  studentId: email, grade: result, studentName: name);
            }
            return;
          }
          List data = await processAssessmentSheet(
              base64: event.base64, pointPossible: event.pointPossible);
          if (data[0] != '' && data[1] != '' && data[2] != '') {
            yield FetchTextFromImageSuccess(
                studentId: data[1],
                grade: data[0].toString().length == 1 ? data[0] : '2',
                studentName: data[2]);
          } else {
            yield FetchTextFromImageFailure(
                studentId: data[1],
                grade:
                    data[0].toString().length == 1 && data[0].toString() != 'S'
                        ? data[0]
                        : '',
                studentName: data[2]);
          }
        }
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'FetchTextFromImage Event');

        yield FetchTextFromImageFailure(
            studentId: '', grade: '', studentName: '');
        //print(e);
      }
    }

    if (event is FetchRecentSearch) {
      try {
        List<SubjectDetailList> recentDetails = await fetchRecentList(
            type: event.type,
            className: event.className,
            subjectName: event.subjectName);
        yield RecentListSuccess(obj: recentDetails);
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'FetchRecentSearch Event');
        throw (e);
      }
    }

    if (event is FetchStudentDetails) {
      try {
        //     yield FetchTextFromImageFailure(schoolId: '', grade: '');
        yield OcrLoading();
        StudentDetails data = await fetchStudentDetails(event.ossId);
        // yield SuccessStudentDetails(
        //     studentName: "${data.firstNameC} ${data.lastNameC}");

        //adding stduent First name and last Name
        yield SuccessStudentDetails(
            studentName: Utility.addStrings(
                data.firstNameC ?? '', data.lastNameC ?? ''));
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'FetchStudentDetails Event');

        throw (e);
        //print(e);
      }
    }

    // ------------ Event to Search keyword in Standard object -------------------
    if (event is SearchSubjectDetails) {
      try {
        List<SubjectDetailList> list = [];

        // IN Case of search page ==========================================
        //For Learning Search
        if (event.isSearchPage == true) {
          LocalDatabase<SubjectDetailList> _localDb =
              LocalDatabase("${event.stateName}_${event.subjectSelected}");
          List<SubjectDetailList>? _localData = await _localDb.getData();
          // fetch

          //Check is usign to differentiate the list at search screen
          if (event.type == 'nyc') {
            List<SubjectDetailList> updatedList = await sortSubjectDetails(
                gradeNo: event.grade!,
                keyword: event.selectedKeyword!,
                list: _localData,
                type: event.type!);
            for (int i = 0; i < updatedList.length; i++) {
              if (updatedList[i]
                  .domainNameC!
                  .toUpperCase()
                  .contains(event.searchKeyword!.toUpperCase())) {
                list.add(updatedList[i]);
              }
            }
            yield OcrLoading2();
            yield SearchSubjectDetailsSuccess(
              obj: list,
            );
          } else {
            List<SubjectDetailList> updatedList = await sortSubjectDetails(
                gradeNo: event.grade!,
                // isSearchPage true only case of nycSub  details ------------
                isSearchPage: true,
                keyword: event.selectedKeyword!,
                list: _localData,
                type: event.type!);

            for (int i = 0; i < updatedList.length; i++) {
              if (updatedList[i]
                  .standardAndDescriptionC!
                  .toUpperCase()
                  .contains(event.searchKeyword!.toUpperCase())) {
                list.add(updatedList[i]);
              }
            }

            yield OcrLoading2();
            yield SearchSubjectDetailsSuccess(
              obj: list,
            );
          }
        } else {
          // In case of sub-learning search page ==========
          LocalDatabase<SubjectDetailList> _localDb =
              LocalDatabase("${event.stateName}_${event.subjectSelected}");
          List<SubjectDetailList>? _localData = await _localDb.getData();
          // To fetch and sort data as per requirement ================
          List<SubjectDetailList> updatedList = await sortSubjectDetails(
              gradeNo: event.grade!,
              keyword: event.selectedKeyword!,
              list: _localData,
              type: event.type!);
          for (int i = 0; i < updatedList.length; i++) {
            if (updatedList[i]
                .standardAndDescriptionC!
                .toUpperCase()
                .contains(event.searchKeyword!.toUpperCase())) {
              list.add(updatedList[i]);
            }
          }
          yield OcrLoading2();
          yield SearchSubjectDetailsSuccess(
            obj: list,
          );
        }
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'SearchSubjectDetails Event');

        List<SubjectDetailList> list = [];
        yield SearchSubjectDetailsSuccess(
          obj: list,
        );
      }
    }

    if (event is SaveStudentDetails) {
      try {
        saveStudentToSalesforce(
            studentName: event.studentName, studentId: event.studentId);
      } on SocketException catch (e, s) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'SaveStudentDetails Method');

        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        throw (e);
      }
    }

    if (event is AuthorizedUserWithDatabase) {
      try {
        //  var data =
        yield AuthorizedUserLoading();
        bool result = event.isAuthorizedUser == true
            ? await authorizedUserWithDatabase(email: event.email)
            : await verifyUserWithDatabase(email: event.email.toString());
        if (result == true) {
          yield AuthorizedUserSuccess();
        } else {
          yield AuthorizedUserError();
        }
        // if (!result) {
        //   await verifyUserWithDatabase(email: event.email.toString());
        // }
      } on SocketException catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'VerifyUserWithDatabase SocketException');

        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        yield AuthorizedUserError();
        rethrow;
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'VerifyUserWithDatabase Event');

        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        yield AuthorizedUserError();
        throw (e);
      }
    }
    // Event to Fetch subjects As per requirements ====
    if (event is FetchSubjectDetails) {
      try {
        // To fetch recent selected subject list
        LocalDatabase<SubjectDetailList> recentOptionDB =
            LocalDatabase('recent_option_subject');

        if (event.type == 'subject') {
          List<SubjectDetailList> recentSubjectList =
              await recentOptionDB.getData();
          await recentOptionDB.close();
          List<StateListObject> subjectList = await getSubjectName(
            keyword: event.selectedKeyword!,
            stateName: event.stateName!,
          );

          if (recentSubjectList.isNotEmpty) {
            for (int i = 0; i < subjectList.length; i++) {
              for (int j = 0; j < recentSubjectList.length; j++) {
                if (subjectList[i].titleC ==
                    recentSubjectList[j].subjectNameC) {
                  subjectList[i].dateTime = recentSubjectList[j].dateTime;
                } else {
                  // if (data[i].dateTime == null)
                  // FIX SUBJECT ISSUE
                  if (subjectList[i].dateTime == null) {
                    //Using old/random date to make sue none of the record contains null date
                    subjectList[i].dateTime = DateTime.parse('2012-02-27');
                  }
                }
              }
            }
          } else {
            subjectList.forEach((element) {
              //Using old/random date to make sure none of the record contains null date
              element.dateTime = DateTime.parse('2012-02-27');
            });
          }
          subjectList.forEach((element) {
            if (element.titleC != null) {
              subjectList.sort((a, b) => a.titleC!.compareTo(b.titleC!));
            }
          });

          // Calling function to get subject list From the State Object List

          yield OcrLoading2();
          yield SubjectDataSuccess(obj: subjectList);
        } else if (event.type == 'nyc') {
          LocalDatabase<SubjectDetailList> _localDb =
              LocalDatabase("${event.stateName}_${event.subjectSelected}");
          List<SubjectDetailList>? _localData = await _localDb.getData();
          // To check particular subject exist in local database on not
          if (_localData.isEmpty) {
            yield OcrLoading();
          } else {
            List<SubjectDetailList> _list = await sortSubjectDetails(
                gradeNo: event.grade!,
                keyword: event.selectedKeyword!,
                list: _localData,
                type: event.type!);

            List<SubjectDetailList> recentAddedList =
                await addRecentDateTimeDetails(list: _list);

            // it would change after pushing the app
            if (_list.isEmpty || _list == null || _list.length == 0) {
              yield OcrLoading();
            } else {
              yield NycDataSuccess(
                obj: recentAddedList,
              );
              return;
            }
          }

          // calling function for getting particular subject related data

          List<SubjectDetailList> _list =
              await saveSubjectListDetails(id: event.subjectId!);
          // calling function for getting particular subject related data
          List<SubjectDetailList> updatedList = await sortSubjectDetails(
              gradeNo: event.grade!,
              keyword: event.selectedKeyword!,
              list: _list,
              type: event.type!);
          // Syncing the Local database with remote data
          await _localDb.clear();
          _list.forEach((SubjectDetailList e) {
            _localDb.addData(e);
          });
          // Adding DateTime field for recent list IN main List
          List<SubjectDetailList> recentAddedList =
              await addRecentDateTimeDetails(list: updatedList);
          // returning state after successfully fetch data from Api
          yield NycDataSuccess(
            obj: recentAddedList,
          );
        } else if (event.type == 'nycSub') {
          LocalDatabase<SubjectDetailList> _localDb =
              LocalDatabase("${event.stateName}_${event.subjectSelected}");
          List<SubjectDetailList>? _localData = await _localDb.getData();
          // fetch
          List<SubjectDetailList> updatedList = await sortSubjectDetails(
              gradeNo: event.grade!,
              keyword: event.selectedKeyword!,
              list: _localData,
              type: event.type!);
          yield NycSubDataSuccess(
            obj: updatedList,
          );
        }
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'FetchSubjectDetails Event');

        yield OcrErrorReceived(err: e);
      }
    }

    if (event is GradedPlusSaveResultToDashboard) {
      try {
        List<UserInformation> userInformation =
            await UserGoogleProfile.getUserProfile();

        List isResultSaved = await saveResultToDashboard(
            assessmentId: event.assessmentId,
            studentInfoDb: event.studentInfoDb,
            schoolId: event.schoolId,
            assessmentSheetPublicURL: event.assessmentSheetPublicURL,
            userInformation: userInformation[0]);

        if (isResultSaved[0] == true) {
          yield GradedPlusSaveResultToDashboardSuccess();
        } else {
          yield OcrErrorReceived(err: isResultSaved[1]?.toString() ?? '');
        }
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'SaveAssessmentToDashboard Event');

        // if (e == 'NO_CONNECTION') {
        //   Utility.currentScreenSnackBar("No Internet Connection", null);

        // }
        yield OcrErrorReceived(err: e.toString());
        throw (e);
      }
    }

    if (event is SaveAssessmentToDashboardAndGetId) {
      yield OcrLoading();
      String dashboardId = await saveAssessmentToDatabase(
          isMcqSheet: event.isMcqSheet,
          assessmentQueImage: event.assessmentQueImage,
          fileId: event.fileId,
          assessmentName: event.assessmentName,
          rubricScore: await rubricPickList(event.rubricScore),
          subjectName: event.subjectName,
          grade: event.grade,
          domainName: event.domainName,
          subDomainName: event.subDomainName,
          schoolId: event.schoolId,
          standardId: event.standardId,
          sessionId: event.sessionId,
          teacherContactId: event.teacherContactId,
          teacherEmail: event.teacherEmail,
          classroomCourseId: event.classroomCourseId,
          classroomCourseWorkId: event.classroomCourseWorkId,
          classroomCourseWorkUrl: event.classroomCourseWorkUrl);

      if (dashboardId.isNotEmpty) {
        Globals.currentAssessmentId = dashboardId;
        yield AssessmentIdSuccess(dashboardAssignmentsId: dashboardId);
      }
    }
    // Event call to  update assessment to DB --------
    if (event is UploadAssessmentToDB) {
      yield OcrLoading();
      await updateImageUrlToDB(
          assessmentId: event.assessmentId,
          studentDetails:
              event.studentDetails); // Function will always open ended
    }

    if (event is LogUserActivityEvent) {
      //yield OcrLoading();
      try {
        var body = {
          "Activity_Type": event.activityType,
          "Session_Id": event.sessionId ?? '',
          "Teacher_Id": event.teacherId ?? '',
          "Activity_Id": event.activityId ?? '',
          "Account_Id": event.accountId ?? '',
          "Account_Type": event.accountType ?? '',
          "Date_Time": event.dateTime ?? '',
          "Description": event.description ?? '',
          "Operation_Result": event.operationResult ?? '',
          "App_Type__c":
              Overrides.STANDALONE_GRADED_APP ? "Standalone" : "Standard",
          "User_Type": event.userType ?? '',
          "Email": event.email
        };
        await activityLog(body: body);
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'SaveAssessmentToDashboardAndGetId Event');

        throw Exception('Something went wrong');
      }
    }

    //Used in Standalone // This will be removed later on
    if (event is GetAssessmentAndSavedStudentResultSummaryForStandaloneApp) {
      try {
        yield OcrLoading2();

        if (event.assessmentObj?.assessmentCId?.isEmpty ?? true) {
          AssessmentDetails obj =
              await _getAssessmentIdByGoogleFileId(fileId: event.fileId ?? '');

          //Updating details to assessment object
          event.assessmentObj!.assessmentCId = obj.assessmentId;
          event.assessmentObj!.courseId = obj.classroomCourseId;
          event.assessmentObj!.courseWorkId = obj.classroomCourseWorkId;
        }

        yield AssessmentDashboardStatusForStandaloneApp(
            resultRecordCount: Overrides.STANDALONE_GRADED_APP
                ? 0
                //to get save student list from result object
                : await _getSavedStudentListFromDashboardByAssessmentId(
                    assessmentId: event.assessmentObj!.assessmentCId),
            assessmentObj: event.assessmentObj);
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'GetDashBoardStatus Event');

        yield AssessmentDashboardStatusForStandaloneApp(
            resultRecordCount: 0, assessmentObj: GoogleClassroomCourses());
      }
    }

    //Used in Standard App
    if (event is GetAssessmentAndSavedStudentResultSummaryForStandardApp) {
      try {
        yield OcrLoading2();

        //Fetch Assessment Id by Google File Id
        if (event.assessmentObj?.assessmentCId?.isEmpty ?? true) {
          AssessmentDetails obj =
              await _getAssessmentIdByGoogleFileId(fileId: event.fileId ?? '');

          //Updating details to assessment object
          event.assessmentObj!.assessmentCId = obj.assessmentId;
          event.assessmentObj!.id = obj.classroomCourseId;
          event.assessmentObj!.courseWorkId = obj.classroomCourseWorkId;
          event.assessmentObj!.courseWorkURL = obj.classroomCourseWorUrl;
        }
        //Fetch Saved Student List from Database/Dashboard
        yield AssessmentDashboardStatusForStandardApp(
            resultRecordCount: Overrides.STANDALONE_GRADED_APP
                ? 0
                //to get save student list from result object
                : await _getSavedStudentListFromDashboardByAssessmentId(
                    assessmentId: event.assessmentObj!.assessmentCId),
            assessmentObj: event.assessmentObj);
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'GetDashBoardStatus Event');

        yield AssessmentDashboardStatusForStandardApp(
            resultRecordCount: 0, assessmentObj: ClassroomCourse());
      }
    }

    if (event is GetRubricPdf) {
      LocalDatabase<RubricPdfModal> _localDb =
          LocalDatabase(Strings.rubricPdfObjectName);
      List<RubricPdfModal>? _localData = await _localDb.getData();
      List<RubricPdfModal> separatedList = [];
      try {
        yield OcrLoading();
        if (_localData.isNotEmpty) {
          yield GetRubricPdfSuccess(
            objList: _localData,
          );
        }
        //Fetch overall list from API
        List<RubricPdfModal> pdfList = await getRubricPdfList();
        if (pdfList.length > 0) {
          //Sort pdf list app wise (Standard/Standalone)
          separatedList = await sortRubricPDFList(pdfList);
        }

        await _localDb.clear();
        separatedList.forEach((element) async {
          await _localDb.addData(element);
        });

        if (separatedList.isNotEmpty && _localData.isEmpty) {
          yield GetRubricPdfSuccess(
            objList: separatedList,
          );
        } else if (separatedList.isEmpty && _localData.isEmpty) {
          yield NoRubricAvailable();
        }
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'GetRubricPdf Event');

        yield OcrErrorReceived(err: e);
      }
    }

    // ---------- Event to Fetch State List for Api ----------
    if (event is FetchStateListEvent) {
      try {
        // To get local data if exist
        LocalDatabase<StateListObject> _localDb =
            LocalDatabase(Strings.stateObjectName);

// Clear  state and subject local data to manage loading issue
        SharedPreferences clearNewsCache =
            await SharedPreferences.getInstance();
        final clearCacheResult =
            clearNewsCache.getBool('delete_local_all_state_and_subject_cache1');

        if (clearCacheResult != true) {
          print('Inside clear state');
          await _localDb.clear();
          await clearNewsCache.setBool(
              'delete_local_all_state_and_subject_cache1', true);
        }

        List<StateListObject>? _localData = await _localDb.getData();

        // Condition to show state list if local data exist
        if (_localData.isEmpty) {
          yield OcrLoading2();
        } else {
          yield OcrLoading2();
          List<String> stateList =
              extractStateName(stateObjectList: _localData);
          // stateList.add("Common Core");
          List<String> updatedStateList = await updateStateList(
              stateList: stateList,
              fromCreateAssessmentPage: event.fromCreateAssessment);

          yield StateListFetchSuccessfully(stateList: updatedStateList);
        }

        // Calling Function to fetch State_and_Standards_Gradedplus__c Object data
        List<StateListObject> stateObjectList =
            await fetchStateObjectList(stateName: event.stateName);

        // Syncing the Local database with remote data
        await _localDb.clear();
        stateObjectList.forEach((StateListObject e) {
          _localDb.addData(e);
        });

        // Calling Function to Extract State name from State Object List
        List<String> stateList =
            extractStateName(stateObjectList: stateObjectList);
        List<String> updatedStateList = await updateStateList(
            stateList: stateList,
            fromCreateAssessmentPage: event.fromCreateAssessment);
        //stateList.add("Common Core");
        yield StateListFetchSuccessfully(stateList: updatedStateList);
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'FetchStateListEvent Event');
        // In case of error or no internet Showing data from Local DB
        // To get local data if exist
        LocalDatabase<StateListObject> _localDb =
            LocalDatabase(Strings.stateObjectName);
        List<StateListObject>? _localData = await _localDb.getData();

        List<String> stateList = extractStateName(stateObjectList: _localData);
        // stateList.add("Common Core");
        yield StateListFetchSuccessfully(stateList: stateList);
      }
    }

    // ---------- Event to Local search in State List ----------
    if (event is LocalStateSearchEvent) {
      try {
        // To get local data if exist (State List)
        LocalDatabase<StateListObject> _localDb =
            LocalDatabase(Strings.stateObjectName);
        List<StateListObject>? _localData = await _localDb.getData();

        // Calling extractStateName to get stateName from the object
        List<String> stateList = extractStateName(stateObjectList: _localData);
        // stateList.add("Common Core");
        List<String> searchList = [];

        for (int i = 0; i < stateList.length; i++) {
          if (stateList[i]
              .toUpperCase()
              .contains(event.keyWord!.toUpperCase())) {
            searchList.add(stateList[i]);
          }
        }
        yield OcrLoading2();
        yield LocalStateSearchResult(stateList: searchList);
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'LocalStateSearchEvent Event');
        // In case of error or no internet Showing data from Local DB
        // To get local data if exist
        LocalDatabase<StateListObject> _localDb =
            LocalDatabase(Strings.stateObjectName);
        List<StateListObject>? _localData = await _localDb.getData();

        List<String> stateList = extractStateName(stateObjectList: _localData);
        // stateList.add("Common Core");
        yield StateListFetchSuccessfully(stateList: stateList);
      }
    }
  }

  // ---------- Function to update stateList according to to user location and last selection ---------
  Future<List<String>> updateStateList(
      {required List<String> stateList,
      required bool fromCreateAssessmentPage}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? stateName = pref.getString('selected_state');
      // For loop to sort according to last selection
      if (fromCreateAssessmentPage == true) {
        String stateName = await Utility.getUserLocation();
        // Conditions to update list according to state name
        if (stateName == '' || !stateList.contains(stateName)) {
          stateList.removeWhere((element) => element == 'Common Core');
          stateList.insert(0, 'Common Core');
        } else {
          for (int i = 0; i < stateList.length; i++) {
            if (stateName == stateList[i]) {
              stateList.removeAt(i);
              stateList.sort();
              stateList.insert(0, stateName);
              if (stateName != 'Common Core') {
                stateList.removeWhere((element) => element == 'Common Core');
                stateList.insert(1, 'Common Core');
              }
              break;
            }
          }
        }
      } else {
        for (int i = 0; i < stateList.length; i++) {
          if (stateName == stateList[i]) {
            stateList.removeAt(i);
            stateList.sort();
            stateList.insert(0, stateName!);
            if (stateName != 'Common Core') {
              stateList.removeWhere((element) => element == 'Common Core');
              stateList.insert(1, 'Common Core');
            }
            break;
          }
        }
      }
      print('State List Updatelist method');
      print(stateList);
      return stateList;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'updateStateList Method');
      // In case of any error return the same list
      return stateList;
    }
  }

  // ---------- Function to Extract State name from State Object List ---------
  List<String> extractStateName(
      {required List<StateListObject> stateObjectList}) {
    try {
      List<String> _subjectList = [];
      // For loop for extracting state name
      for (int i = 0; i < stateObjectList.length; i++) {
        if (stateObjectList[i].stateC != null &&
            !_subjectList.contains(stateObjectList[i].stateC)) {
          _subjectList.add(stateObjectList[i].stateC!);
        }
      }
      return _subjectList;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'extractStateName Method');

      throw (e);
    }
  }

  // ---------- Fuction to fetch StateObjectList From State_and_Standards_Gradedplus__c Object ---------
  Future<List<StateListObject>> fetchStateObjectList(
      {required String? stateName}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
        Uri.encodeFull(stateName == "GetAllState"
            ? "https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/State_and_Standards_Gradedplus__c"
            : 'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/State_and_Standards_Gradedplus__c/"State__c" = \'$stateName\''),
        headers: {
          'Content-Type': 'application/json',
          // 'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
        },
        isCompleteUrl: true,
      );

      if (response.statusCode == 200) {
        List<StateListObject> _list =
            jsonDecode(jsonEncode(response.data['body']))
                .map<StateListObject>((i) => StateListObject.fromJson(i))
                .toList();

        _list.removeWhere((element) => Overrides.STANDALONE_GRADED_APP == true
            ? element.usedInC == "school"
            : element.usedInC == "Standalone");
        return _list;
      }
      return [];
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'fetchStateObjectList Method');

      throw (e);
    }
  }

  Future<List<SubjectDetailList>> addRecentDateTimeDetails(
      {required List<SubjectDetailList> list}) async {
    try {
      //Recent list created with onTap
      LocalDatabase<SubjectDetailList> learningRecentOptionDB =
          LocalDatabase('recent_option_learning_standard');

      List<SubjectDetailList> recentLearningList =
          await learningRecentOptionDB.getData();

      if (recentLearningList.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          for (int j = 0; j < recentLearningList.length; j++) {
            if (list[i].domainNameC == recentLearningList[j].domainNameC) {
              list[i].dateTime = recentLearningList[j].dateTime;
            } else {
              if (list[i].dateTime == null) {
                //Using old/random date to make sue none of the record contains null date
                list[i].dateTime = DateTime.parse('2012-02-27');
              }
            }
          }
        }
      } else {
        list.forEach((element) {
          //Using old/random date to make sue none of the record contains null date
          element.dateTime = DateTime.parse('2012-02-27');
        });
      }

      list.forEach((element) {
        if (element.domainNameC != null) {
          list.sort((a, b) => a.domainNameC!.compareTo(b.domainNameC!));
        }
      });

      return list;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'addRecentDateTimeDetails Method');

      // In case of any error return the same list
      return list;
    }
  }

  // --------- Function to fetch Subject detail list from api according to user selection ----------
  Future<List<SubjectDetailList>> saveSubjectListDetails(
      {required String id}) async {
    try {
      // Api Calling According to subject selection
      final ResponseModel response = await _dbServices.getApiNew(
          Uri.encodeFull(
              'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Standard__c/filterRecords/"State_and_Standards__c" = \'$id\''),
          headers: {"Content-type": "application/json; charset=utf-8"},
          isCompleteUrl: true);

      if (response.statusCode == 200) {
        List<SubjectDetailList> _list =
            jsonDecode(jsonEncode(response.data['body']))
                .map<SubjectDetailList>((i) => SubjectDetailList.fromJson(i))
                .toList();
        return _list;
      } else {
        return [];
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'addRecentDateTimeDetails Method');

      throw (e);
    }
  }

  Future<void> activityLog({required body}) async {
    try {
      final ResponseModel response = await _dbServices.postApi(
        Uri.encodeFull(
            "https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/createRecord?objectName=User_Activity_Logs"),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
        },
        isGoogleApi: true,
      );

      if (response.statusCode == 200) {
        print('Activity Log Success');
        // print(response.data);
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(e, s, 'activityLog Method');

      throw Exception("Something went wrong");
    }
  }

  // ---------  To Fetch local subject added by user -----------
  Future<List<StateListObject>> fetchLocalSubject(String classNo,
      {required String stateName}) async {
    try {
      LocalDatabase<StateListObject> _localDb =
          LocalDatabase('Subject_list$stateName$classNo');
      //Clear subject local data to resolve loading issue
      SharedPreferences clearSubjectCache =
          await SharedPreferences.getInstance();
      final clearChacheResult =
          clearSubjectCache.getBool('Clear_local_Subject');

      if (clearChacheResult != true) {
        _localDb.clear();
        await clearSubjectCache.setBool('Clear_local_Subject', true);
      }
      List<StateListObject>? _localData = await _localDb.getData();
      return _localData;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'fetchLocalSubject Method');

      throw (e);
    }
  }

  // --------- Function to sort and extract data as per requirement -----------
  Future<List<SubjectDetailList>> sortSubjectDetails(
      {required List<SubjectDetailList> list,
      required String type,
      required String keyword,
      bool? isSearchPage,
      required String gradeNo,
      String? subjectSelected}) async {
    try {
      // condition to get learning standard
      if (type == 'nyc') {
        //Using a separate list to check only 'Learning Standard' whether already exist or not.
        List learningStdList = [];
        List<SubjectDetailList> subjectDetailList = [];
        selectedSubject = keyword;
        for (int i = 0; i < list.length; i++) {
          if (list.isNotEmpty &&
              !learningStdList.contains(list[i].domainNameC) &&
              list[i].gradeC == gradeNo) {
            subjectDetailList.add(list[i]);
            learningStdList.add(list[i].domainNameC);
          } else if (subjectDetailList.isEmpty && list[i].gradeC == gradeNo) {
            subjectDetailList.add(list[i]);
            learningStdList.add(list[i].domainNameC);
          }
        }
        return subjectDetailList;
      } else {
        //Using a separate list to check only 'Sub Learning Standard' whether already exist or not.
        List learningStdList = [];
        List<SubjectDetailList> subjectDetailList = [];
        for (int i = 0; i < list.length; i++) {
          if (list.isNotEmpty &&
              !learningStdList.contains(
                list[i].standardAndDescriptionC,
              ) &&
              list[i].gradeC == gradeNo &&
              // Condition because in case of search we need to add all nyc sub record ------------
              (list[i].domainNameC == keyword || isSearchPage == true)) {
            subjectDetailList.add(list[i]);
            learningStdList.add(list[i].standardAndDescriptionC);
          } else if (subjectDetailList.isEmpty &&
              list[i].gradeC == gradeNo &&
              list[i].domainNameC == keyword) {
            subjectDetailList.add(list[i]);
            learningStdList.add(list[i].standardAndDescriptionC);
          }
        }
        return subjectDetailList;
      }

      // return subjectDetailList;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'sortSubjectDetails Method');
      throw (e);
    }
  }

  String getMcqAnswer({required String detectedAnswer}) {
    try {
      switch (detectedAnswer) {
        case '0':
          {
            return 'A';
          }
        case '1':
          {
            return 'B';
          }
        case '2':
          {
            return 'C';
          }
        case '3':
          {
            return 'D';
          }
        case '4':
          {
            return 'E';
          }

        default:
          {
            return '';
          }
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(e, s, 'getMcqAnswer Method');
      return '';
    }
  }

  // ----------Function to process MCQ sheet ------------
  Future processMcqSheet(
      {required String base64, String? pointPossible}) async {
    try {
      final ResponseModel response = await _dbServices.postApi(
        // Url for Production
        Uri.encodeFull(
            'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/processMcqSheet'),

        body: {
          'data': '$base64',
          'account_id': Globals.appSetting.schoolNameC,
          'point_possible': pointPossible ?? ''
        },
        isGoogleApi: true,
      );

      if (response.statusCode == 200) {
        // ***********  Process The response and collecting OSSIS ID  ***********
        var result = response.data;
        List<StudentDetailsModal> _list = jsonDecode(
                jsonEncode(response.data['studentListDetails']))
            .map<StudentDetailsModal>((i) => StudentDetailsModal.fromJson(i))
            .toList();
        await addStudentDetailsToLocalDb(list: _list);

        final String? studentGrade = result['detectedAnswer'] == '2' ||
                result['detectedAnswer'] == '1' ||
                result['detectedAnswer'] == '0' ||
                result['detectedAnswer'] == '3' ||
                result['detectedAnswer'] == '4'
            ? result['detectedAnswer']
            : '';

        final String? studentId = result['studentId'] == 'Something Went Wrong'
            ? ''
            : result['studentId'].toString();
        return [
          studentGrade,
          studentId,
          result['studentName'],
        ];
      } else {
        return ['', '', ''];
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'processMcqSheet Method');
      print(e);
      return ['', '', ''];
    }
  }

  Future processAssessmentSheet(
      {required String base64, required String pointPossible}) async {
    try {
      final ResponseModel response = await _dbServices.postApi(
        // Url for Production
        //  Uri.encodeFull(
        //     'https://da70-111-118-246-106.in.ngrok.io/processAssessmentSheet'),
        //  Url For testing and development
        // Uri.encodeFull(
        //     'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/processAssessmentSheetDev'),
        // Url For testing and development
        Uri.encodeFull(
            'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/processAssessmentSheet'),

        body: {
          'data': '$base64',
          'account_id': Globals.appSetting.schoolNameC,
          'point_possible': pointPossible
        },
        isGoogleApi: true,
      );

      if (response.statusCode == 200) {
        // ***********  Process The response and collecting OSSIS ID  ***********
        var result = response.data;
        List<StudentDetailsModal> _list = jsonDecode(
                jsonEncode(response.data['studentListDetails']))
            .map<StudentDetailsModal>((i) => StudentDetailsModal.fromJson(i))
            .toList();
        await addStudentDetailsToLocalDb(list: _list);

        final String? studentGrade = result['StudentGrade'] == '2' ||
                result['StudentGrade'] == '1' ||
                result['StudentGrade'] == '0' ||
                result['StudentGrade'] == '3' ||
                result['StudentGrade'] == '4'
            ? result['StudentGrade']
            : '';

        final String? studentId = result['studentId'] == 'Something Went Wrong'
            ? ''
            : result['studentId'];
        return [
          studentGrade,
          studentId,
          result['studentName'],
        ];
      } else {
        return ['', '', ''];
      }
    } catch (e, s) {
      print(e);
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'processAssessmentSheet Method');
    }
  }

  Future addStudentDetailsToLocalDb(
      {required List<StudentDetailsModal> list}) async {
    LocalDatabase<StudentDetailsModal> _localDb =
        LocalDatabase(Strings.studentDetailList);
    //List<StateListObject>? _localData = await _localDb.getData();
    // Syncing the Local database with remote data
    await _localDb.clear();
    list.forEach((StudentDetailsModal e) {
      _localDb.addData(e);
    });
  }

  Future<bool> saveStudentToSalesforce(
      {required String studentName, required studentId}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
      };
      // print(Globals.schoolDbnC);
      // print(Globals.isPremiumUser);
      final body = {
        "DBN__c": Globals.schoolDbnC ?? "",
        "First_Name__c": studentName.split(" ")[0],
        "last_Name__c":
            studentName.split(" ").length > 1 ? studentName.split(" ")[1] : '',
        "School__c": Globals.appSetting.schoolNameC,
        "Student_ID__c": studentId,
        "Teacher_added__c": true
      };

      final ResponseModel response = await _dbServices.postApi(
          "${OcrOverrides.OCR_API_BASE_URL}saveRecordToSalesforce/Student__c",
          isGoogleApi: true,
          body: body,
          headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.log("saveStudentToSalesforce Method, $e");
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'saveStudentToSalesforce Method');
      throw (e);
    }
  }

  Future<bool> authorizedUserWithDatabase({required String? email}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
      };
      final body = {
        "email": email.toString(),
        "DBN": Globals.schoolDbnC,
        "Schoolid": Overrides.SCHOOL_ID,
        "teacherid": Globals.teacherId
      };
      final ResponseModel response = await _dbServices.postApi(
          "https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/authorizeEmail",
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode == 200) {
        var res = response.data;
        var data = res["body"];
        if (data == true) {
          return true;
        } else {
          return false;
        }

        // return data;
      } else {
        return false;
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'verifyUserWithDatabase Method');
      throw (e);
    }
  }

  Future<bool> verifyUserWithDatabase({required String? email}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
      };
      final body = {"email": email.toString()};
      final ResponseModel response = await _dbServices.postApi(
          "https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/authorizeEmail?objectName=Contact",
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode == 200) {
        var res = response.data;
        var data = res["body"];

        if (data == false) {
          bool result =
              await createContactToSalesforce(email: email.toString());
          if (!result) {
            await createContactToSalesforce(email: email.toString());
          }
        } else {
          Globals.teacherId = data['Id'];

          if (data['Assessment_App_User__c'] != 'true') {
            Globals.teacherId = data['Id'];
            bool result = await updateContactToSalesforce(recordId: data['Id']);
            if (!result) {
              await updateContactToSalesforce(recordId: data['Id']);
            }
          }
        }

        return true;

        // return data;
      } else {
        return false;
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'verifyUserWithDatabase Method');
      throw (e);
    }
  }

  Future<bool> createContactToSalesforce({required String? email}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
      };
      final body = {
        //"0014W00002uusl7QAA", //Static for graded+ account
        "AccountId": Overrides.STANDALONE_GRADED_APP
            ? '0014W000030jqbbQAA' //Graded+  Standalone
            : '0014W00002uusl7QAA', //Graded+ Schools

        "RecordTypeId":
            "0124W0000003GVyQAM", //Static to save in a 'Teacher' category listView
        "Assessment_App_User__c": "true",
        "LastName": email, //.split("@")[0],
        "Email": email,
        "DBN_for_account_lookup__c": Overrides.STANDALONE_GRADED_APP == true
            ? "STANDALONE"
            : "GRADEDSCHOOLS"
        //UNCOMMENT
        // "GRADED_user_type__c":
        //     "Free" //Currently free but will be dynamic later on
      };

      final ResponseModel response = await _dbServices.postApi(
          "${OcrOverrides.OCR_API_BASE_URL}saveRecordToSalesforce/Contact",
          isGoogleApi: true,
          body: body,
          headers: headers);
      if (response.statusCode == 200) {
        // print(response.data["body"]);
        Globals.teacherId = response.data["body"]["id"];
        // print(response.data["body"]["id"]);
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'createContactToSalesforce Method');

      throw (e);
    }
  }

  Future<bool> updateContactToSalesforce({required String? recordId}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
      };
      final body = {
        "Assessment_App_User__c": "true",
      };
      final ResponseModel response = await _dbServices.postApi(
          "${OcrOverrides.OCR_API_BASE_URL}saveRecordToSalesforce/Contact/$recordId",
          isGoogleApi: true,
          body: body,
          headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'updateContactToSalesforce Method');
      throw (e);
    }
  }

  Future<String> saveAssessmentToDatabase(
      {required String? assessmentName,
      required String? rubricScore,
      required String? subjectName,
      required String? grade,
      required String? domainName,
      required String? subDomainName,
      required String? schoolId,
      required String? standardId,
      required String? fileId,
      required String sessionId,
      required String teacherContactId,
      required String teacherEmail,
      required String assessmentQueImage,
      required bool isMcqSheet,
      required String? classroomCourseId,
      required String? classroomCourseWorkId,
      required String? classroomCourseWorkUrl}) async {
    try {
      String currentDate = Utility.getCurrentDate(DateTime.now());

      Map<String, String> headers = {
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx',
        'Content-Type': 'application/json'
      };

      final body = {
        "Date__c": currentDate,
        "Name__c": assessmentName,
        "Rubric__c": rubricScore != '' ? rubricScore : null,
        "School__c": schoolId,
        "School_year__c": currentDate.split("-")[0],
        "Standard__c": standardId != '' ? standardId : null,
        "Subject__c": subjectName,
        "Grade__c": grade,
        "Domain__c": domainName,
        "Sub_Domain__c": subDomainName,
        "Google_File_Id": fileId ?? '',
        "Session_Id": sessionId,
        "Teacher_Contact_Id": teacherContactId,
        "Teacher_Email": teacherEmail,
        "Created_As_Premium": true,
        "Assessment_Que_Image__c": assessmentQueImage,
        "Assessment_Type":
            isMcqSheet == true ? 'Multiple Choice' : 'Constructed Response',
        "Classroom_Course_Id": classroomCourseId,
        "Classroom_Course_Work_Id": classroomCourseWorkId,
        "Classroom_Coursework_URL": classroomCourseWorkUrl
      };

      final ResponseModel response = await _dbServices.postApi(
        "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/saveRecord?objectName=Assessment__c",
        isGoogleApi: true,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        String id = response.data['body']['Assessment_Id'];

        //print("Assessment has been saved successfully : $id");
        return id;
      } else {
        //print("not 200 ---> r${response.statusCode}");

        return "";
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'saveAssessmentToDatabase Method');

      throw (e);
    }
  }

  rubricPickList(rubricScore) {
    if (rubricScore == null) {
      return null;
    } else if (rubricScore == 'NYS 0-2') {
      return "0,1 or 2";
    } else if (rubricScore == 'NYS 0-3') {
      return "0,1,2 or 3";
    } else {
      return "0,1,2 or 4";
    }
  }

  Future<List> saveResultToDashboard({
    required String assessmentId,
    required final LocalDatabase<StudentAssessmentInfo> studentInfoDb,
    required schoolId,
    required String assessmentSheetPublicURL,
    required UserInformation userInformation,
    int retry = 3,
  }) async {
    try {
      //Get all students for localDb
      List<StudentAssessmentInfo> assessmentData =
          await studentInfoDb.getData();

//get only non saved students on dashboard
      List<StudentAssessmentInfo> studentDetails =
          await _getOnlyNonSavedStudents(studentList: assessmentData);

      List<Map> bodyContent = [];

      for (int i = 0; i < studentDetails.length; i++) {
        //convert dart objects to json
        bodyContent.add(recordToJson(
            assessmentId,
            Utility.getCurrentDate(DateTime.now()),
            studentDetails[i].studentGrade ?? '',
            studentDetails[i].studentId ?? '',
            studentDetails[i].assessmentImage ?? '',
            studentDetails[i].studentName ?? ''));
      }

      final ResponseModel response = await _dbServices.postApi(
        "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/saveRecords?objectName=Result__c",
        isGoogleApi: true,
        body: bodyContent,
      );
      if (response.statusCode == 200) {
        List<StudentAssessmentInfo> assessmentData =
            await studentInfoDb.getData();
        // update the local-db only after assignment are updated on dashboard to manage the next scan more sheets to not repeat in the list
        assessmentData.asMap().forEach((index, element) async {
          element.isStudentResultAssignmentSavedOnDashboard = true;
          //updating local database
          await studentInfoDb.putAt(index, element);
        });

        _sendEmailToAdmin(
          name: userInformation.userName!
              .replaceAll("%20", " ")
              .replaceAll("20", ""),
          schoolId: schoolId,
          email: userInformation.userEmail!,
          assessmentSheetPublicURL: assessmentSheetPublicURL!,
          bodyContent: bodyContent,
        );

        return [true, response.statusCode];
      } else if (retry > 0) {
        return saveResultToDashboard(
            assessmentId: assessmentId,
            assessmentSheetPublicURL: assessmentSheetPublicURL,
            schoolId: schoolId,
            studentInfoDb: studentInfoDb,
            userInformation: userInformation,
            retry: retry - 1);
      }
      return [false, response.statusCode];
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'saveResultToDashboard Method');
      throw (e);
    }
  }

  Map<String, String> recordToJson(assessmentId, currentDate, pointsEarned,
      studentOsisId, assessmentImageURl, sudentName) {
    try {
      Map<String, String> body = {
        "Assessment_Id": assessmentId,
        "Date__c": currentDate.toString(),
        "Result__c": pointsEarned,
        "Student__c": studentOsisId, //Scanned from the sheet
        "Assessment_Image__c": assessmentImageURl,
        "Student_Name__c": sudentName
      };
      return body;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(e, s, 'recordToJson Method');
      throw (e);
    }
  }

  _sendEmailToAdmin({
    required String schoolId,
    required String name,
    required String email,
    required String assessmentSheetPublicURL,
    required List<Map> bodyContent,
    int retry = 3,
  }) async {
    try {
      final body = {
        "from": "'Tech Admin <techadmin@solvedconsulting.com>'",
        "to": "techadmin@solvedconsulting.com",
        // "appdevelopersdp7@gmail.com",
        "subject": "Data Saved To The Dashboard",
        "text":
            '''School Id : $schoolId \n\nTeacher Details : \n\tTeacher Name : $name \n\tTeacher Email : $email  \n\nAssessment Sheet URL : $assessmentSheetPublicURL  \n\nResult detail : \n${bodyContent.toString().replaceAll(',', '\n').replaceAll('{', '\n ').replaceAll('}', ', \n')}'''
      };

      final ResponseModel response = await _dbServices.postApi(
        "${OcrOverrides.OCR_API_BASE_URL}sendsmtpEmail",
        isGoogleApi: true,
        body: body,
      );

      if (response.statusCode == 200) {
      } else if (retry > 0) {
        return _sendEmailToAdmin(
            schoolId: schoolId,
            assessmentSheetPublicURL: assessmentSheetPublicURL,
            bodyContent: bodyContent,
            email: email,
            name: name,
            retry: retry - 1);
      }
      ;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, '_sendEmailToAdmin Method');
      throw (e);
    }
  }

  _getStandardIdAndsubjectId(
      {required String grade,
      required String subjectName,
      required String subLearningCode}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Standard__c/\"Grade__c\"='$grade' AND \"Subject_Name__c\"='$subjectName' AND \"Name\"='$subLearningCode'",
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        return response.data['body'].length > 0 ? response.data['body'][0] : '';
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, '_getStandardIdAndsubjectId Method');

      throw (e);
    }
  }

  Future fetchStudentDetails(ossId) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          //API from global API
          "https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Student__c/studentOsis/$ossId",

          //Filter API
          // Uri.encodeFull(
          //     "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Student__c/\"School__c\" = \'${Globals.appSetting.schoolNameC}\' and \"Student_ID__c\" = \'$ossId\'"),
          isCompleteUrl: true);

      if (response.statusCode == 200) {
        //Resposne from global API
        StudentDetails res = StudentDetails.fromJson(response.data['body']);

        return res;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'fetchStudentDetails Method');

      throw (e);
    }
  }

  Future<AssessmentDetails> _getAssessmentIdByGoogleFileId(
      {required String fileId, int retry = 3}) async {
    AssessmentDetails data = AssessmentDetails();
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Assessment__c/"Google_File_Id"=\'$fileId\'',
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        return response?.data['body']?.isNotEmpty ?? false
            ? AssessmentDetails.fromJson(response.data['body'][0])
            : data;
      } else if (retry > 0) {
        return _getAssessmentIdByGoogleFileId(fileId: fileId, retry: retry - 1);
      }

      return data;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, '_getTheDashBoardStatus Method');
      return data;
      // throw ('something_went_wrong');
    }
  }

  Future<int> _getSavedStudentListFromDashboardByAssessmentId(
      {required String? assessmentId, int retry = 3}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Result__c/\"Assessment_Id\"='$assessmentId'",
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        return response?.data["body"]?.isNotEmpty ?? false
            ? response?.data["body"].length
            : 0;
      } else if (retry > 0) {
        return _getSavedStudentListFromDashboardByAssessmentId(
            assessmentId: assessmentId, retry: retry - 1);
      }
      return 0;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, '_getAssessmentRecord Method');

      return 0;
    }
  }

  Future fetchRecentList({
    required String? type,
    required String? className,
    required String? subjectName,
  }) async {
    try {
      LocalDatabase<SubjectDetailList> _localDb =
          LocalDatabase("$className$subjectName${type}RecentList");

      List<SubjectDetailList>? _localData = await _localDb.getData();
      return _localData;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'fetchRecentList Method');
      throw (e);
    }
  }

  // ----------- Function to get Subject Name according to the state ---------------
  Future<List<StateListObject>> getSubjectName({
    required String stateName,
    required String keyword,
  }) async {
    try {
      List<StateListObject> subjectList = [];
      // to get state list object from localDb
      LocalDatabase<StateListObject> _localDb =
          LocalDatabase(Strings.stateObjectName);
      List<StateListObject>? _localData = await _localDb.getData();
      for (int i = 0; i < _localData.length; i++) {
        if (_localData[i].stateC == stateName) {
          subjectList.add(_localData[i]);
        }
      }
      // Calling Function to fetch Local subject created by user
      List<StateListObject> list =
          await fetchLocalSubject(keyword, stateName: stateName);
      subjectList.addAll(list);
      return subjectList;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'getSubjectName Method');

      throw (e);
    }
  }

  Future<List> emailDetectionApi({required String base64}) async {
    try {
      final ResponseModel response = await _dbServices.postApi(
        Uri.encodeFull(
            'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyA309Qitrqstm3l207XVUQ0Yw5K_qgozag'),
        body: {
          "requests": [
            {
              "image": {"content": base64.toString()},
              "features": [
                {"type": "DOCUMENT_TEXT_DETECTION"}
              ]
            }
          ]
        },
        isGoogleApi: true,
      );
      if (response.statusCode == 200) {
        String data =
            response.data["responses"][0]["textAnnotations"][0]["description"];

        List nameAndemail = await checkEmailInsideRoster(responseText: data);
        return [nameAndemail[0], nameAndemail[1]];
      } else {
        return ['', ''];
      }
    } catch (e, s) {
      print(e);

      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'emailDetectionApi Method');
      return ['', ''];
      // throw (e);
    }
  }

  Future<List> checkEmailInsideRoster({required String responseText}) async {
    try {
      LocalDatabase<GoogleClassroomCourses> _localDb =
          LocalDatabase(Strings.googleClassroomCoursesList);

      List<GoogleClassroomCourses>? _localData = await _localDb.getData();
      List<String> studentEmailList = [];
      for (var i = 0; i < _localData.length; i++) {
        for (var j = 0; j < _localData[i].studentList!.length; j++) {
          studentEmailList
              .add(_localData[i].studentList![j]['profile']['emailAddress']);
        }
      }

      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      List result = extractEmailsFromString(responseText);

      List<String> emails = [];

      for (int i = 0; i < result.length; i++) {
        String extra = result[i];
        result.removeAt(i);
        result.insert(i, extra.split('@')[0]);

        var match = StringSimilarity.findBestMatch(
            result[i], studentEmailList); // result[i].bestMatch(studentList);

        emails.add("${match.bestMatch.target!}_${match.bestMatch.rating}");
        // return match.bestMatch.target!;
      }
      String newResult = ''; //emails.isNotEmpty ? emails[0].split('_')[0] : '';
      double confidence = 0;
      //emails.isNotEmpty ? double.parse(emails[0].split('_')[1]) : 0;

      for (int i = 0; i < emails.length; i++) {
        if (confidence < double.parse(emails[i].split('_')[1])) {
          newResult = emails.isNotEmpty ? emails[i].split('_')[0] : '';
        }
      }
      String studentName = '';
      for (var i = 0; i < _localData.length; i++) {
        for (var j = 0; j < _localData[i].studentList!.length; j++) {
          if (newResult ==
              _localData[i].studentList![j]['profile']['emailAddress']) {
            studentName =
                _localData[i].studentList![j]['profile']['name']['fullName'];
          }
        }
      }

      return [newResult, studentName];

      // return ['', ''];
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'checkEmailInsideRoster Method');
      return ['', ''];
    }
  }

  List<String> extractEmailsFromString(String string) {
    //String newString = string.replaceAll(RegExp(r"\s+"), '');
    // newString
    try {
      List<String> respoanceTextList = string.split(' ');
      string = '';
      for (int i = 0; i < respoanceTextList.length; i++) {
        //  string = '';
        if (respoanceTextList[i].toString().contains('@')) {
          string = '$string${respoanceTextList[i].toString()}';
        } else {
          string = "$string ${respoanceTextList[i].toString()}";
        }
      }

      final emailPattern = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b',
          caseSensitive: false, multiLine: true);
      string = string.replaceAll(",", "");
      final matches = emailPattern.allMatches(string);
      final List<String> emails = [];
      if (matches != null) {
        for (final Match match in matches) {
          emails.add(string.substring(match.start, match.end));
        }
      }
      if (emails.isEmpty) {
        List<String> respoanceTextList = string.split(' ');
        for (var i = 0; i < respoanceTextList.length; i++) {
          if (respoanceTextList[i].contains('@')) {
            emails.add(respoanceTextList[i]);
          }
        }
      }

      return emails;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'extractEmailsFromString Method');
      throw (e);
    }
  }

  Future<List<RubricPdfModal>> getRubricPdfList() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          Uri.encodeFull(
              "https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Gradedplus_Rubric__c"),
          isCompleteUrl: true);

      if (response.statusCode == 200) {
        List<RubricPdfModal> _list = response.data['body']
            .map<RubricPdfModal>((i) => RubricPdfModal.fromJson(i))
            .toList();

        return _list;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'getRubricPdfList Method');
      throw (e);
    }
  }

  Future<List<RubricPdfModal>> sortRubricPDFList(
      List<RubricPdfModal> list) async {
    try {
      List<RubricPdfModal> newList = [];
      for (int i = 0; i < list.length; i++) {
        if (Overrides.STANDALONE_GRADED_APP == true) {
          //Create list to show standalone rubric pdf
          if (list[i].usedInC != 'Schools') {
            newList.add(list[i]);
          }
        } else {
          //Create list to show school rubric pdf
          if (list[i].usedInC != 'Standalone') {
            newList.add(list[i]);
          }
        }
      }

      return newList;
    } catch (e, s) {
      FirebaseAnalyticsService.firebaseCrashlytics(
          e, s, 'sortRubricPDFList Method');
      throw (e);
    }
  }

  // Function to update all images to PostgresSQL database (For automatic modal training)
  Future<bool> updateImageUrlToDB({
    required String assessmentId,
    required List<StudentAssessmentInfo> studentDetails,
  }) async {
    try {
      List<Map> bodyContent = [];

      for (int i = 0; i < studentDetails.length; i++) {
        //To bypass the titles saving in the dashboard
        if (studentDetails[i].studentId != 'Id') {
          bodyContent.add(objectToJson(
              uniqueId: studentDetails[i].uniqueId!,
              assessmentId: assessmentId,
              assessmentImage: studentDetails[i].assessmentImage!,
              resultC: studentDetails[i].studentGrade!,
              scoreChanged: studentDetails[i].isRubricChanged!));
        }
      }
      final ResponseModel response = await _dbServices.postApi(
        "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/saveRecords?objectName=Assessment_Scans",
        isGoogleApi: true,
        body: bodyContent,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw (e);
    }
  }

  // Function to create body for updateImageUrlToDB function
  Map<String, String> objectToJson(
      {required String assessmentId,
      required String uniqueId,
      required String resultC,
      required String assessmentImage,
      required String scoreChanged}) {
    try {
      Map<String, String> body = {
        "Assessment_Id": assessmentId,
        "Result__c": resultC,
        "Assessment_Image__c": assessmentImage,
        "Score_Changed": scoreChanged,
        "Id": uniqueId
      };
      return body;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> updateAssessmentOnDashboardOnHistoryScanMore(
      {required String? assessmentId,
      required String? classroomCourseId,
      required String? classroomCourseWorkId,
      int retry = 3}) async {
    try {
      final ResponseModel response = await _dbServices.postApi(
          "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/saveRecords?objectName=Assessment__c",
          isGoogleApi: true,
          headers: {
            'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx',
            'Content-Type': 'application/json'
          },
          body: [
            {
              "Assessment_Id": assessmentId,
              "Classroom_Course_Id": classroomCourseId,
              "Classroom_Course_Work_Id": classroomCourseWorkId
            },
          ]);
      if (response.statusCode == 200) {
        return true;
      } else if (retry > 0) {
        return updateAssessmentOnDashboardOnHistoryScanMore(
            assessmentId: assessmentId,
            classroomCourseId: assessmentId,
            classroomCourseWorkId: assessmentId,
            retry: retry - 1);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

//Used to update the student result to dashboard // Checking only non-saved records
  Future<List<StudentAssessmentInfo>> _getOnlyNonSavedStudents(
      {required final List<StudentAssessmentInfo> studentList}) async {
    try {
      List<StudentAssessmentInfo> nonSavedStudentsOnDashboard = [];

      studentList.forEach((student) {
        if (student.isStudentResultAssignmentSavedOnDashboard == false &&
            student.studentId != 'Id') {
          nonSavedStudentsOnDashboard.add(student);
        }
      });

      return nonSavedStudentsOnDashboard;
    } catch (e) {
      return [];
    }
  }
}
