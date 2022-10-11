import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/ocr/modal/state_object_modal.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/modal/student_details_modal.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:string_similarity/string_similarity.dart';
part 'ocr_event.dart';
part 'ocr_state.dart';

class OcrBloc extends Bloc<OcrEvent, OcrState> {
  OcrBloc() : super(OcrInitial());
  final DbServices _dbServices = DbServices();
  // final HiveDbServices _localDbService = HiveDbServices();
  OcrState get initialState => OcrInitial();
  String grade = '';
  String selectedSubject = '';
  // String? DeshboardId;

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
            procressAssessmentSheet(
                base64: event.base64, pointPossible: event.pointPossible)
          ]);
          String email = resultList[0][0];
          String name = resultList[0][1];
          String grade = resultList[1][0];
          if (email != '' && name != '' && grade != '') {
            yield FetchTextFromImageSuccess(
                studentId: email, grade: grade, studentName: name);
          } else {
            yield FetchTextFromImageFailure(
                studentId: email, grade: grade, studentName: name);
          }
        } else {
          List data = await procressAssessmentSheet(
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
      } catch (e) {
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
      } catch (e) {}
    }

    if (event is FetchStudentDetails) {
      try {
        //     yield FetchTextFromImageFailure(schoolId: '', grade: '');
        yield OcrLoading();
        StudentDetails data = await fetchStudentDetails(event.ossId);
        yield SuccessStudentDetails(
            studentName: "${data.firstNameC} ${data.lastNameC}");
      } catch (e) {
        //print(e);
      }
    }

    // ------------ Event to Search keyword in Standerd object -------------------
    if (event is SearchSubjectDetails) {
      try {
        List<SubjectDetailList> list = [];

        // IN Case of search page ==========================================
        //For Learning Search
        if (event.isSearchPage == true) {
          LocalDatabase<SubjectDetailList> _localDb =
              LocalDatabase("${event.stateName}_${event.subjectSelected}");
          List<SubjectDetailList>? _localData = await _localDb.getData();
          // fatch

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
                // isSearchPage true only case of nycsub  details ------------
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
          // To fatch and sort data as per requirement ================
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
      } catch (e) {
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
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        throw (e);
      }
    }

    if (event is VerifyUserWithDatabase) {
      try {
        //  var data =
        bool result =
            await verifyUserWithDatabase(email: event.email.toString());
        if (!result) {
          await verifyUserWithDatabase(email: event.email.toString());
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        throw (e);
      }
    }
    // Event to Fetch subjects As per requirements ====
    if (event is FetchSubjectDetails) {
      try {
        // To fetch recent selected subject list
        LocalDatabase<SubjectDetailList> recentOptionDB =
            LocalDatabase('recent_option_subject');
        // List<SubjectDetailList> data = await fatchSubjectDetails(
        //     type: event.type!,
        //     keyword: event.keyword!,
        //     isSearchPage: event.isSearchPage ?? false,
        //     gradeNo: event.grade,
        //     subjectSelected: event.subjectSelected);

        // Condition To Chnage respoance accoding to selection type
        if (event.type == 'subject') {
          // List<StateListObject> subjectList = [];
          // LocalDatabase<StateListObject> _localDb =
          //     LocalDatabase(Strings.stateObjectName);
          // List<StateListObject>? _localData = await _localDb.getData();
          // for (int i = 0; i < _localData.length; i++) {
          //   if (_localData[i].stateC == event.stateName) {
          //     subjectList.add(_localData[i]);
          //   }
          // }
          // List<StateListObject> list = await fatchLocalSubject(event.keyword!);
          // subjectList.addAll(list);
          // yield OcrLoading();
          List<SubjectDetailList> recentSubjectlist =
              await recentOptionDB.getData();
          List<StateListObject> subjectList = await getSubjectName(
            keyword: event.selectedKeyword!,
            stateName: event.stateName!,
          );

          if (recentSubjectlist.isNotEmpty) {
            for (int i = 0; i < subjectList.length; i++) {
              for (int j = 0; j < recentSubjectlist.length; j++) {
                if (subjectList[i].titleC ==
                    recentSubjectlist[j].subjectNameC) {
                  subjectList[i].dateTime = recentSubjectlist[j].dateTime;
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

          // Calling fuction to get subject list From the State Object List

          yield OcrLoading2();
          yield SubjectDataSuccess(obj: subjectList);
        } else if (event.type == 'nyc') {
          LocalDatabase<SubjectDetailList> _localDb =
              LocalDatabase("${event.stateName}_${event.subjectSelected}");
          List<SubjectDetailList>? _localData = await _localDb.getData();
          // To check perticular subject exist in local database on not
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

            yield NycDataSuccess(
              obj: recentAddedList,
            );
            return;
          }

          // calling function for getting perticular subject related data
          List<SubjectDetailList> _list =
              await saveSubjectListDetails(id: event.subjectId!);
          // calling function for getting perticular subject related data
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
          // returning state after successfully fatch data from Api
          yield NycDataSuccess(
            obj: recentAddedList,
          );
        } else if (event.type == 'nycSub') {
          LocalDatabase<SubjectDetailList> _localDb =
              LocalDatabase("${event.stateName}_${event.subjectSelected}");
          List<SubjectDetailList>? _localData = await _localDb.getData();
          // fatch
          List<SubjectDetailList> updatedList = await sortSubjectDetails(
              gradeNo: event.grade!,
              keyword: event.selectedKeyword!,
              list: _localData,
              type: event.type!);
          yield NycSubDataSuccess(
            obj: updatedList,
          );
        }
      } catch (e) {
        yield OcrErrorReceived(err: e);
      }
    }

    if (event is SaveAssessmentToDashboard) {
      try {
        yield OcrLoading();
        // List<UserInformation> _profileData =
        //     await UserGoogleProfile.getUserProfile();
        List list = await Utility.getStudentInfoList(tableName: 'student_info');
        if (event.previouslyAddedListLength != null &&
            event.previouslyAddedListLength! < list.length) {
          List<StudentAssessmentInfo> _list =
              await Utility.getStudentInfoList(tableName: 'student_info');

          //Removing the previous scanned records to save only latest scanned sheets to the dashboard
          _list.removeRange(0,
              event.previouslyAddedListLength!); //+1 - To remove title as well

          if (event.assessmentId != null && event.assessmentId!.isNotEmpty) {
            bool result = await saveResultToDashboard(
                assessmentId: event.assessmentId!,
                studentDetails: _list,
                previousListLength: event.previouslyAddedListLength ?? 0,
                isHistoryDetailPage: event.isHistoryAssessmentSection,
                schoolId: event.schoolId,
                assessmentSheetPublicURL: event.assessmentSheetPublicURL!);

            if (!result) {
              saveResultToDashboard(
                  assessmentId: event.assessmentId!,
                  studentDetails: _list,
                  previousListLength: event.previouslyAddedListLength ?? 0,
                  isHistoryDetailPage: event.isHistoryAssessmentSection,
                  schoolId: event.schoolId,
                  assessmentSheetPublicURL: event.assessmentSheetPublicURL!);
            } else {
              // await _sendEmailToAdmin(
              //   assessmentId: event.assessmentId!,
              //   name: _profileData[0]
              //       .userName!
              //       .replaceAll("%20", " ")
              //       .replaceAll("20", ""),
              //   studentResultDetails: _list,
              //   schoolId: event.schoolId,
              //   email: _profileData[0].userEmail!,
              //   assessmentSheetPublicURL: event.assessmentSheetPublicURL!,
              // );
              ////print("result Record is saved on DB");

              yield AssessmentSavedSuccessfully();
            }
          } else {
            Utility.showSnackBar(
                event.scaffoldKey,
                'Unable to save the result. Please try again.',
                event.context,
                null);

            yield OcrErrorReceived();
            throw ('something went wrong');
          }
        } else {
          //Using for history assessment details page
          String subjectId;
          String standardId;
          var standardObject;
          if (event.isHistoryAssessmentSection == true) {
            standardObject = await _getstandardIdAndsubjectId(
                grade: event.resultList.first.grade ?? '',
                subLearningCode:
                    event.resultList.first.subLearningStandard ?? '',
                subjectName: event.resultList.first.subject ?? '');

            standardId = standardObject != null && standardObject != ''
                ? standardObject['Id']
                : '';
            subjectId = standardObject != null && standardObject != ''
                ? standardObject['Subject__c']
                : '';
          }

          if (event.assessmentId != null && event.assessmentId!.isNotEmpty) {
            bool result = await saveResultToDashboard(
              assessmentId: event.assessmentId!,
              studentDetails: event.resultList,
              previousListLength: event.previouslyAddedListLength ?? 0,
              isHistoryDetailPage: event.isHistoryAssessmentSection,
              assessmentSheetPublicURL: event.assessmentSheetPublicURL!,
              schoolId: event.schoolId,
            );

            if (!result) {
              saveResultToDashboard(
                assessmentId: event.assessmentId!,
                studentDetails: event.resultList,
                previousListLength: event.previouslyAddedListLength ?? 0,
                isHistoryDetailPage: event.isHistoryAssessmentSection,
                assessmentSheetPublicURL: event.assessmentSheetPublicURL!,
                schoolId: event.schoolId,
              );
            } else {
              yield AssessmentSavedSuccessfully();
            }
          } else {
            Utility.showSnackBar(
                event.scaffoldKey,
                'Unable to save the result. Please try again.',
                event.context,
                null);
            throw ('something went wrong');
          }
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        throw (e);
      }
    }
    if (event is SaveAssessmentToDashboardAndGetId) {
      yield OcrLoading();
      String dashboardId = await saveAssessmentToDatabase(
          assessmentQueImage: event.assessmentQueImage,
          fileId: event.fileId,
          assessmentName: event.assessmentName,
          rubicScore: await rubricPickList(event.rubricScore),
          subjectName: event.subjectName,
          grade: event.grade,
          domainName: event.domainName,
          subDomainName: event.subDomainName,
          schoolId: event.schoolId,
          standardId: event.standardId,
          sessionId: event.sessionId,
          teacherContactId: event.teacherContactId,
          teacherEmail: event.teacherEmail);

      if (dashboardId.isNotEmpty) {
        Globals.currentAssessmentId = dashboardId;
        yield AssessmentIdSuccess(obj: dashboardId);
      }
    }
    if (event is LogUserActivityEvent) {
      //yield OcrLoading();
      try {
        var body = {
          "Session_Id": "${event.sessionId ?? ''}",
          "Teacher_Id": "${event.teacherId ?? ''}",
          "Activity_Id": "${event.activityId ?? ''}",
          "Account_Id": "${event.accountId ?? ''}",
          "Account_Type": "${event.accountType ?? ''}",
          "Date_Time": "${event.dateTime ?? ''}",
          "Description": "${event.description ?? ''}",
          "Operation_Result": "${event.operationResult ?? ''}"
        };
        await activityLog(body: body);
      } catch (e) {
        throw Exception('Something went wrong');
      }
    }

    if (event is GetDashBoardStatus) {
      try {
        yield OcrLoading2();
        List object;
        object = await _getTheDashBoardStatus(fileId: event.fileId);
        // await Future.delayed(Duration(seconds: 10));
        if (object[1] != '') {
          yield AssessmentDashboardStatus(
              resultRecordCount: object[0], assessmentId: object[1]);
        }
        yield AssessmentDashboardStatus(
            resultRecordCount: null, assessmentId: null);
      } catch (e) {
        yield AssessmentDashboardStatus(
            resultRecordCount: null, assessmentId: null);
      }
    }

    // ---------- Event to Save Selected State Subject List to Local DB ----------
    // if (event is SaveSubjectListDetailsToLocalDb) {
    //   try {
    //     yield OcrLoading();
    //     List<SubjectDetailList> list = [];
    //     // Condition to check selected Subject is Common core or other
    //     if (event.selectedState == 'Common Core') {
    //       list = await saveSubjectListDetails(isCommonCore: true);
    //     } else {
    //       // To get local data related to stateObjectList
    //       LocalDatabase<StateListObject> _localDb =
    //           LocalDatabase(Strings.stateObjectName);
    //       List<StateListObject> _localData = await _localDb.getData();
    //       // List of id related to selected state
    //       List<String> _id = [];
    //       // for loop to extract id releated selected subject
    //       for (int i = 0; i < _localData.length; i++) {
    //         if (_localData[i].stateC == event.selectedState &&
    //             _localData[i].id != null) {
    //           _id.add(_localData[i].id!);
    //         }
    //       }
    //       list = await saveSubjectListDetails(isCommonCore: false, idList: _id);
    //     }

    //     // Syncing the Local database with remote data
    //     LocalDatabase<SubjectDetailList> _localDb =
    //         LocalDatabase(Strings.ocrSubjectObjectName);
    //     await _localDb.clear();
    //     list.forEach((SubjectDetailList e) {
    //       //To decode the special characters
    //       utf8.decode(utf8.encode(_localDb.addData(e).toString()));
    //     });

    //     yield SubjectDetailsListSaveSuccessfully();
    //   } on SocketException catch (e) {
    //     e.message == 'Connection failed'
    //         ? Utility.currentScreenSnackBar("No Internet Connection")
    //         : print(e);
    //     yield OcrErrorReceived();
    //     rethrow;
    //   } catch (e) {
    //     e == 'NO_CONNECTION'
    //         ? Utility.currentScreenSnackBar("No Internet Connection")
    //         : print(e);
    //     yield OcrErrorReceived();
    //     throw (e);
    //   }

    //   // try {
    //   //   bool result = await saveSubjectListDetails();
    //   // } on SocketException catch (e) {
    //   //   e.message == 'Connection failed'
    //   //       ? Utility.currentScreenSnackBar("No Internet Connection")
    //   //       : print(e);
    //   //   rethrow;
    //   // } catch (e) {
    //   //   e == 'NO_CONNECTION'
    //   //       ? Utility.currentScreenSnackBar("No Internet Connection")
    //   //       : print(e);
    //   //   throw (e);
    //   // }

    // }

    // ---------- Event to Fetch State List for Api ----------
    if (event is FetchStateListEvant) {
      try {
        // To get local data if exist
        LocalDatabase<StateListObject> _localDb =
            LocalDatabase(Strings.stateObjectName);
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
              fromCreateAssesmentpage: event.fromCreateAssesment);

          yield StateListFetchSuccessfully(stateList: updatedStateList);
        }

        // Calling Function to fetch State_and_Standards_Gradedplus__c Object data
        List<StateListObject> stateObjectList = await fetchStateObjectList();

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
            fromCreateAssesmentpage: event.fromCreateAssesment);
        //stateList.add("Common Core");
        yield StateListFetchSuccessfully(stateList: updatedStateList);
      } catch (e) {
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
      } catch (e) {
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
      required bool fromCreateAssesmentpage}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? stateName = pref.getString('selected_state');
      // For loop to sort accoding to last selection
      if (fromCreateAssesmentpage == true) {
        String stateName = await Utility.getUserlocation();
        // Conditions to update list accoding to state name
        if (stateName == '' || !stateList.contains(stateName)) {
          stateList.removeWhere((element) => element == 'All States');
          stateList.insert(0, 'All States');
        } else {
          for (int i = 0; i < stateList.length; i++) {
            if (stateName == stateList[i]) {
              stateList.removeAt(i);
              stateList.sort();
              stateList.insert(0, stateName);
              if (stateName != 'All States') {
                stateList.removeWhere((element) => element == 'All States');
                stateList.insert(1, 'All States');
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
            if (stateName != 'All States') {
              stateList.removeWhere((element) => element == 'All States');
              stateList.insert(1, 'All States');
            }
            break;
          }
        }
      }

      return stateList;
    } catch (e) {
      // In case of any error return the same list
      return stateList;
    }
  }

  // ---------- Fuction to Extract State name from State Object List ---------
  List<String> extractStateName(
      {required List<StateListObject> stateObjectList}) {
    try {
      List<String> _subjectList = [];
      // For loop for extarcting state name
      for (int i = 0; i < stateObjectList.length; i++) {
        if (stateObjectList[i].stateC != null &&
            !_subjectList.contains(stateObjectList[i].stateC)) {
          _subjectList.add(stateObjectList[i].stateC!);
        }
      }
      return _subjectList;
    } catch (e) {
      throw (e);
    }
  }

  // ---------- Fuction to fetch StateObjectList From State_and_Standards_Gradedplus__c Object ---------
  Future<List<StateListObject>> fetchStateObjectList() async {
    try {
      final ResponseModel response = await _dbServices.getapiNew(
        Uri.encodeFull(
            "https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/State_and_Standards_Gradedplus__c"),
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
    } catch (e) {
      throw (e);
    }
  }

  Future<List<SubjectDetailList>> addRecentDateTimeDetails(
      {required List<SubjectDetailList> list}) async {
    try {
      //Recent list created with onTap
      LocalDatabase<SubjectDetailList> learningRecentOptionDB =
          LocalDatabase('recent_option_learning_standard');

      List<SubjectDetailList> recentLearninglist =
          await learningRecentOptionDB.getData();

      if (recentLearninglist.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          for (int j = 0; j < recentLearninglist.length; j++) {
            if (list[i].domainNameC == recentLearninglist[j].domainNameC) {
              list[i].dateTime = recentLearninglist[j].dateTime;
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
    } catch (e) {
      // In case of any error return the same list
      return list;
    }
  }

  // --------- Function to fetch Subject detail list from api according to user selection ----------
  Future<List<SubjectDetailList>> saveSubjectListDetails(
      {required String id}) async {
    try {
      // for loop to create api filter url according to id list
      // String filterString = '';
      // if (isCommonCore == false) {
      //   for (int i = 0; i < idList!.length; i++) {
      //     if (i == 0) {
      //       filterString = filterString +
      //           'filterRecords/"State_and_Standards__c" = \'${idList[i]}\'';
      //     } else {
      //       filterString =
      //           filterString + 'OR "State_and_Standards__c" = \'${idList[i]}\'';
      //     }
      //   }
      // }

      // Api Calling According to subject selection
      final ResponseModel response = await _dbServices.getapiNew(
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
    } catch (e) {
      throw (e);
    }
  }

  Future<void> activityLog({required body}) async {
    try {
      final ResponseModel response = await _dbServices.postapi(
        Uri.encodeFull(
            "https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/createRecord?objectName=Graded_Activity_Logs"),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
        },
        isGoogleApi: true,
      );

      if (response.statusCode == 200) {}
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  // Future<bool> saveSubjectListDetails() async {
  //   try {
  //     final ResponseModel response = await _dbServices.getapiNew(Uri.encodeFull(
  //             //   "${OcrOverrides.OCR_API_BASE_URL}getRecords/Standard__c",
  //             // ),
  //             'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Standard__c'),
  //         isCompleteUrl: true,
  //         headers: {"Content-type": "application/json; charset=utf-8"});

  //     if (response.statusCode == 200) {
  //       List<SubjectDetailList> _list =
  //           jsonDecode(jsonEncode(response.data['body']))
  //               .map<SubjectDetailList>((i) => SubjectDetailList.fromJson(i))
  //               .toList();
  //       ////print(_list);
  //       LocalDatabase<SubjectDetailList> _localDb =
  //           LocalDatabase(Strings.ocrSubjectObjectName);
  //       await _localDb.clear();

  //       _list.forEach((SubjectDetailList e) {
  //         //To decode the special characters
  //         utf8.decode(utf8.encode(_localDb.addData(e).toString()));
  //       });
  //       // _list.removeWhere((SubjectList element) => element.status == 'Hide');
  //       return true;
  //     } else {
  //       throw ('something_went_wrong');
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }
  // ---------  To Fetch local subject added by user -----------
  Future<List<StateListObject>> fatchLocalSubject(String classNo,
      {required String stateName}) async {
    LocalDatabase<StateListObject> _localDb =
        LocalDatabase('Subject_list$stateName$classNo');
    //Clear subject local data to resolve loading issue
    SharedPreferences clearSubjectCache = await SharedPreferences.getInstance();
    final clearChacheResult = clearSubjectCache.getBool('Clear_local_Subject');

    if (clearChacheResult != true) {
      _localDb.clear();
      await clearSubjectCache.setBool('Clear_local_Subject', true);
    }
    List<StateListObject>? _localData = await _localDb.getData();
    return _localData;
  }

  // --------- Fuction to sort and extract data as per requirement -----------
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
        //Using a seperate list to check only 'Learning Standard' whether already exist or not.
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
        //Using a seperate list to check only 'Sub Learning Standard' whether already exist or not.
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
      return [];

      ////////////////////-----------------old -------------------------------/////////////////////////
      // // String grade = '';
      // // String selectedSubject = '';
      // //Local list managing
      // LocalDatabase<SubjectDetailList> _localDb =
      //     LocalDatabase(Strings.ocrSubjectObjectName);
      // List<SubjectDetailList>? _localData = await _localDb.getData();

      // //Common detail list to save all deatails of subject for specific grade. Include : Subject, Learning standard and sub learning standard
      // List<SubjectDetailList> subjectDetailList = [];

      // //Return subject details
      // if (type == 'subject') {
      //   grade = keyword;
      //   //Using a seperate list to check only 'Subject' whether already exist or not.
      //   List subjectList = [];

      //   for (int i = 0; i < _localData.length; i++) {
      //     if (_localData[i].gradeC == keyword) {
      //       if (subjectDetailList.isNotEmpty &&
      //           !subjectList.contains(_localData[i].subjectNameC)) {
      //         subjectDetailList.add(_localData[i]);
      //         subjectList.add(_localData[i].subjectNameC);
      //       } else if (subjectDetailList.isEmpty) {
      //         subjectDetailList.add(_localData[i]);
      //         subjectList.add(_localData[i].subjectNameC);
      //       }
      //     }
      //   }
      //   return subjectDetailList;
      // }
      // //Return Learning standard details
      // else if (type == 'nyc') {
      //   //Using a seperate list to check only 'Learning Standard' whether already exist or not.

      //   List learningStdList = [];

      //   selectedSubject = keyword;
      //   for (int i = 0; i < _localData.length; i++) {
      //     if (_localData[i].subjectNameC == keyword &&
      //         _localData[i].gradeC ==
      //             (isSearchPage == true ? gradeNo : grade)) {
      //       if (subjectDetailList.isNotEmpty &&
      //           !learningStdList.contains(_localData[i].domainNameC)) {
      //         subjectDetailList.add(_localData[i]);
      //         learningStdList.add(_localData[i].domainNameC);
      //       } else if (subjectDetailList.isEmpty) {
      //         subjectDetailList.add(_localData[i]);
      //         learningStdList.add(_localData[i].domainNameC);
      //       }
      //     }
      //   }
      //   return subjectDetailList;
      // } //Return Sub Learning standard details
      // else if (type == 'nycSub') {
      //   //Using a seperate list to check only 'Sub Learning Standard' whether already exist or not.
      //   if (isSearchPage == true) {
      //     List<SubjectDetailList> list = [];
      //     List subLearningStdList = [];
      //     for (int i = 0; i < _localData.length; i++) {
      //       if (
      //           //_localData[i].subjectNameC == selectedSubject &&
      //           _localData[i].gradeC == gradeNo &&
      //               _localData[i].subjectNameC == keyword) {
      //         if (list.isNotEmpty &&
      //             !subLearningStdList
      //                 .contains(_localData[i].standardAndDescriptionC)) {
      //           list.add(_localData[i]);
      //           subLearningStdList.add(_localData[i].standardAndDescriptionC);
      //         } else if (list.isEmpty) {
      //           list.add(_localData[i]);
      //           subLearningStdList.add(_localData[i].standardAndDescriptionC);
      //         }
      //       }
      //     }
      //     return list;
      //   } else {
      //     List subLearningStdList = [];

      //     for (int i = 0; i < _localData.length; i++) {
      //       if (_localData[i].subjectNameC ==
      //               (selectedSubject == ''
      //                   ? subjectSelected
      //                   : selectedSubject) &&
      //           (_localData[i].gradeC == (grade == '' ? gradeNo : grade)) &&
      //           _localData[i].domainNameC == keyword) {
      //         if (subjectDetailList.isNotEmpty &&
      //             !subLearningStdList
      //                 .contains(_localData[i].standardAndDescriptionC)) {
      //           subjectDetailList.add(_localData[i]);
      //           subLearningStdList.add(_localData[i].standardAndDescriptionC);
      //         } else if (subjectDetailList.isEmpty) {
      //           subjectDetailList.add(_localData[i]);
      //           subLearningStdList.add(_localData[i].standardAndDescriptionC);
      //         }
      //       }
      //     }
      //     return subjectDetailList;
      //   }
      // }
      // return subjectDetailList;
    } catch (e) {
      throw (e);
    }
  }

  Future procressAssessmentSheet(
      {required String base64, required String pointPossible}) async {
    try {
      final ResponseModel response = await _dbServices.postapi(
        // Uri.encodeFull('https://361d-111-118-246-106.in.ngrok.io'),
        Uri.encodeFull('http://3.142.181.122:5050/ocr'),
        //'http://3.142.181.122:5050/ocr'), //https://1fb3-111-118-246-106.in.ngrok.io
        // Uri.encodeFull('https://1fb3-111-118-246-106.in.ngrok.io'),
        body: {
          'data': '$base64',
          'account_id': Globals.appSetting.schoolNameC,
          'point_possible': pointPossible
        },
        isGoogleApi: true,
      );

      if (response.statusCode == 200) {
        // ***********  Process The respoance and collecting OSS ID  ***********
        var result = response.data;

        return [
          result['StudentGrade'] == '2' ||
                  result['StudentGrade'] == '1' ||
                  result['StudentGrade'] == '0' ||
                  result['StudentGrade'] == '3' ||
                  result['StudentGrade'] == '4'
              ? result['StudentGrade']
              : '',
          result['studentId'] == 'Something Went Wrong'
              ? ''
              : result['studentId'],
          result['studentName'],
        ];
      } else {
        return ['', '', ''];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> saveStudentToSalesforce(
      {required String studentName, required studentId}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
      };
      final body = {
        "DBN__c": "05M194",
        "First_Name__c": studentName.split(" ")[0],
        "last_Name__c": studentName.split(" ")[0].length >= 1
            ? studentName.split(" ")[1]
            : '',
        "School__c": Globals.appSetting.schoolNameC,
        "Student_ID__c": studentId,
        "Teacher_added__c": true
      };

      final ResponseModel response = await _dbServices.postapi(
          "${OcrOverrides.OCR_API_BASE_URL}saveRecordToSalesforce/Student__c",
          isGoogleApi: true,
          body: body,
          headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
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
      final ResponseModel response = await _dbServices.postapi(
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
        } else if (data['Assessment_App_User__c'] != 'true') {
          var userType = data["GRADED_Premium__c"];
          if (userType == "true") {
            Globals.isPremiumUser = true;
          } else {
            Globals.isPremiumUser = false;
          }

          Globals.teacherId = data['Id'];
          bool result = await updateContactToSalesforce(recordId: data['Id']);
          if (!result) {
            await updateContactToSalesforce(recordId: data['Id']);
          }
        } else {
          var userType = data["GRADED_Premium__c"];
          if (userType == "true") {
            Globals.isPremiumUser = true;
          } else {
            Globals.isPremiumUser = false;
          }
        }
        Globals.teacherId = data['Id'];
        return true;
        // return data;
      } else {
        return false;
      }
    } catch (e) {
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
        "AccountId": "0014W00002uusl7QAA", //Static for graded+ account
        "RecordTypeId":
            "0124W0000003GVyQAM", //Static to save in a 'Teacher' catagory list
        "Assessment_App_User__c": "true",
        "LastName": email, //.split("@")[0],
        "Email": email,
        //UNCOMMENT
        // "GRADED_user_type__c":
        //     "Free" //Currently free but will be dynamic later on
      };

      final ResponseModel response = await _dbServices.postapi(
          "${OcrOverrides.OCR_API_BASE_URL}saveRecordToSalesforce/Contact",
          isGoogleApi: true,
          body: body,
          headers: headers);
      if (response.statusCode == 200) {
        Globals.teacherId = response.data["body"]["id"];

        return true;
      } else {
        return false;
      }
    } catch (e) {
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
      final ResponseModel response = await _dbServices.postapi(
          "${OcrOverrides.OCR_API_BASE_URL}saveRecordToSalesforce/Contact/$recordId",
          isGoogleApi: true,
          body: body,
          headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<String> saveAssessmentToDatabase({
    required String? assessmentName,
    required String? rubicScore,
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
  }) async {
    try {
      String currentDate = Utility.getCurrentDate(DateTime.now());

      Map<String, String> headers = {
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx',
        'Content-Type': 'application/json'
      };

      final body = {
        "Date__c": currentDate,
        "Name__c": assessmentName,
        "Rubric__c": rubicScore != '' ? rubicScore : null,
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
        "Created_As_Premium": Globals.isPremiumUser.toString(),
        "Assessment_Que_Image__c": assessmentQueImage
      };

      final ResponseModel response = await _dbServices.postapi(
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
    } catch (e) {
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

  Future<bool> saveResultToDashboard(
      {required String assessmentId,
      required List<StudentAssessmentInfo> studentDetails,
      required previousListLength,
      required isHistoryDetailPage,
      required schoolId,
      required assessmentSheetPublicURL}) async {
    try {
      List<Map> bodyContent = [];

      // studentDetails.removeAt(0);
      // int initIndex = isHistoryDetailPage == true
      //     ? previousListLength
      //     : previousListLength; // + 1;
      for (int i = 0; i < studentDetails.length; i++) {
        //To bypass the titles saving in the dashboard
        if (studentDetails[i].studentId != 'Id') {
          bodyContent.add(recordtoJson(
              assessmentId,
              Utility.getCurrentDate(DateTime.now()),
              studentDetails[i].studentGrade ?? '',
              studentDetails[i].studentId ?? '',
              studentDetails[i].assessmentImage ?? '',
              studentDetails[i].studentName ?? ''));
        }
      }
      final ResponseModel response = await _dbServices.postapi(
        "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/saveRecords?objectName=Result__c",
        isGoogleApi: true,
        body: bodyContent,
      );
      if (response.statusCode == 200) {
        // String id = response.data['body']['id'];

        List<UserInformation> _profileData =
            await UserGoogleProfile.getUserProfile();
        bool result = await _sendEmailToAdmin(
          assessmentId: assessmentId,
          name: _profileData[0]
              .userName!
              .replaceAll("%20", " ")
              .replaceAll("20", ""),
          studentResultDetails: studentDetails,
          schoolId: schoolId,
          email: _profileData[0].userEmail!,
          assessmentSheetPublicURL: assessmentSheetPublicURL!,
        );
        if (!result) {
          await _sendEmailToAdmin(
            assessmentId: assessmentId,
            name: _profileData[0]
                .userName!
                .replaceAll("%20", " ")
                .replaceAll("20", ""),
            studentResultDetails: studentDetails,
            schoolId: schoolId,
            email: _profileData[0].userEmail!,
            assessmentSheetPublicURL: assessmentSheetPublicURL!,
          );
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw (e);
    }
  }

  Map<String, String> recordtoJson(assessmentId, currentDate, pointsEarned,
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
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> _sendEmailToAdmin(
      {required String schoolId,
      required String name,
      required String email,
      required String assessmentId,
      required String assessmentSheetPublicURL,
      required List<StudentAssessmentInfo> studentResultDetails}) async {
    try {
      List<Map> bodyContent = [];

      // studentDetails.removeAt(0);
      for (int i = 0; i < studentResultDetails.length; i++) {
        if (studentResultDetails[i].studentId == "Id") {
          studentResultDetails.remove(i);
        }
        bodyContent.add(recordtoJson(
            assessmentId,
            Utility.getCurrentDate(DateTime.now()),
            studentResultDetails[i].studentGrade ?? '',
            studentResultDetails[i].studentId ?? '',
            studentResultDetails[i].assessmentImage ?? '',
            studentResultDetails[i].studentName ?? ''));
      }
      final body = {
        "from": "'Tech Admin <techadmin@solvedconsulting.com>'",
        "to": "techadmin@solvedconsulting.com", //, appdevelopersdp7@gmail.com",
        "subject": "Data Saved To The Dashboard",
        // "html":
        "text":
            '''School Id : $schoolId \n\nTeacher Details : \n\tTeacher Name : $name \n\tTeacher Email : $email  \n\nAssessment Sheet URL : $assessmentSheetPublicURL  \n\nResult detail : \n${bodyContent.toString().replaceAll(',', '\n').replaceAll('{', '\n ').replaceAll('}', ', \n')}'''
      };

      final ResponseModel response = await _dbServices.postapi(
        "${OcrOverrides.OCR_API_BASE_URL}sendsmtpEmail",
        isGoogleApi: true,
        body: body,
      );
      if (response.statusCode == 200) {
        //print("email send successfully");
        return true;
      } else {
        //print("email sending fail");

        return false;
      }
    } catch (e) {
      throw (e);
    }
  }

  _getstandardIdAndsubjectId(
      {required String grade,
      required String subjectName,
      required String subLearningCode}) async {
    try {
      final ResponseModel response = await _dbServices.getapiNew(
          "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Standard__c/\"Grade__c\"='$grade' AND \"Subject_Name__c\"='$subjectName' AND \"Name\"='$subLearningCode'",
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        return response.data['body'].length > 0 ? response.data['body'][0] : '';
      }
    } catch (e) {
      throw (e);
    }
  }

  // Future authenticateEmail(body) async {
  //   try {
  //     final ResponseModel response = await _dbServices
  //         .postapi("authorizeEmail?objectName=Contact", body: body);

  //     if (response.statusCode == 200) {
  //       var res = response.data;
  //       var data = res["body"];
  //       return data;
  //     } else {
  //       throw ('something_went_wrong');
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  Future fetchStudentDetails(ossId) async {
    try {
      final ResponseModel response = await _dbServices.getapiNew(
          "https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Student__c/studentOsis/$ossId",
          isCompleteUrl: true);

      if (response.statusCode == 200) {
        StudentDetails res = StudentDetails.fromJson(response.data['body']);

        return res;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List> _getTheDashBoardStatus({required String fileId}) async {
    try {
      final ResponseModel response = await _dbServices.getapiNew(
          'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Assessment__c/"Google_File_Id"=\'$fileId\'',
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        if (response.data['body'].length > 0) {
          String assessmentId = response.data['body'][0]['Assessment_Id'];

          if (assessmentId.isNotEmpty) {
            int result = await _getAssessmentRecord(assessmentId: assessmentId);

            return [result, assessmentId];
          }
        }
      }
      return [0, ''];
    } catch (e) {
      throw ('something_went_wrong');
    }
  }

  Future<int> _getAssessmentRecord({required String assessmentId}) async {
    try {
      final ResponseModel response = await _dbServices.getapiNew(
          "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Result__c/\"Assessment_Id\"='$assessmentId'",
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        var data = response.data["body"];
        if (data.length > 0) {
          return data.length;
        }
      }
      return 0;
    } catch (e) {
      throw ('something_went_wrong');
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
    } catch (e) {
      throw (e);
    }
  }

  // ----------- Function to get Subject Name according to the state ---------------
  Future<List<StateListObject>> getSubjectName({
    required String stateName,
    required String keyword,
  }) async {
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
        await fatchLocalSubject(keyword, stateName: stateName);
    subjectList.addAll(list);
    return subjectList;
  }

  Future<List> emailDetectionApi({required String base64}) async {
    try {
      final ResponseModel response = await _dbServices.postapi(
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
        // print(response.data);
        String data =
            response.data["responses"][0]["textAnnotations"][0]["description"];
        print(data);
        List nameAndemail = await checkEmailInsideRoster(respoanceText: data);
        return [nameAndemail[0], nameAndemail[1]];
      } else {
        print(response.statusCode);
        return ['', ''];
      }
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<List> checkEmailInsideRoster({required String respoanceText}) async {
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
      // List<String> studentList = [
      //   "test@gmail.com",
      //   "appdevelopersdp7@gmail.com",
      //   "rupeshparmar@gmail.com",
      //   "techadmin@solvedconsulting.com"
      // ];
      List<String> respoanceTextList = respoanceText.split(' ');
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      List result = extractEmailsFromString(respoanceText);

      List<String> emails = [];

      for (int i = 0; i < result.length; i++) {
        String extra = result[i];
        result.removeAt(i);
        result.insert(i, extra.split('@')[0]);

        var match = StringSimilarity.findBestMatch(
            result[i], studentEmailList); // result[i].bestMatch(studentList);
        print("--------------------------match-----------------------");
        print(match);
        emails.add("${match.bestMatch.target!}_${match.bestMatch.rating}");
        // return match.bestMatch.target!;

      }
      String newresult = emails.isNotEmpty ? emails[0].split('_')[0] : '';
      double confidence =
          emails.isNotEmpty ? double.parse(emails[0].split('_')[1]) : 0;

      for (int i = 1; i < emails.length; i++) {
        if (confidence < double.parse(emails[i].split('_')[1])) {
          newresult = emails.isNotEmpty ? emails[i].split('_')[0] : '';
        }
      }
      String studentName = '';
      for (var i = 0; i < _localData.length; i++) {
        for (var j = 0; j < _localData[i].studentList!.length; j++) {
          if (newresult ==
              _localData[i].studentList![j]['profile']['emailAddress']) {
            studentName =
                _localData[i].studentList![j]['profile']['name']['fullName'];
          }
        }
      }

      return [newresult, studentName];

      // if (result.isNotEmpty) {
      //   return result[0];
      // } else {
      //   for (int j = 0; j < respoanceTextList.length; j++) {
      //     if (regex.hasMatch(respoanceTextList[j]) &&
      //         studentList.contains(respoanceTextList[j])) {
      //       return respoanceTextList[j];
      //     } else {
      //       for (var i = 0; i < studentList.length; i++) {
      //         if (studentList[i].contains(respoanceTextList[j])) {
      //           return studentList[i];
      //         }
      //       }
      //     }

      //     //}

      //   }
      // }

      return ['', ''];
    } catch (e) {
      return ['', ''];
    }
  }

  List<String> extractEmailsFromString(String string) {
    //String newString = string.replaceAll(RegExp(r"\s+"), '');
    // newString

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

      // final test = RegExp('@',
      //   caseSensitive: false, multiLine: true);
      //   final data = test.allMatches(string);
      // for (final Match match in data) {
      //   emails.add(string.substring(match.start, match.end));

      // }

    }

    return emails;
  }
}
