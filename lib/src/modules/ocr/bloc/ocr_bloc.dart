import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/modal/student_details_modal.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
              grade: data[0].toString().length == 1 && data[0].toString() != 'S'
                  ? data[0]
                  : '',
              studentName: data[2]);
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

    if (event is SearchSubjectDetails) {
      try {
        List<SubjectDetailList> data = await fatchSubjectDetails(
            type: event.type!,
            keyword: event.keyword!,
            isSearchPage: event.isSearchPage ?? false,
            gradeNo: event.grade,
            subjectSelected: event.subjectSelected);
        List<SubjectDetailList> list = [];

        if (event.type == 'subject') {
          //Subjects from database
          List<SubjectDetailList> subjectList = [];
          subjectList.addAll(data);

          //Custom subjects
          List<SubjectDetailList> list =
              await fatchLocalSubject(event.keyword!);
          subjectList.addAll(list);

          //Sorting the list based on subject name
          subjectList.forEach((element) {
            if (element.subjectNameC != null) {
              subjectList
                  .sort((a, b) => a.subjectNameC!.compareTo(b.subjectNameC!));
            }
          });

          bool check = false;
          for (int i = 0; i < subjectList.length; i++) {
            if (subjectList[i]
                .subjectNameC!
                .toUpperCase()
                .contains(event.searchKeyword!.toUpperCase())) {
              for (int j = 0; j < list.length; j++) {
                if (list[j].subjectNameC == subjectList[i].subjectNameC!) {
                  check = true;
                }
              }
              if (!check) {
                list.add(subjectList[i]);
              }
            }
          }
          yield SearchSubjectDetailsSuccess(
            obj: list,
          );
        } else if (event.type == 'nyc') {
          //Sorting the list based on subject name
          data.forEach((element) {
            if (element.domainNameC != null) {
              data.sort((a, b) => a.domainNameC!.compareTo(b.domainNameC!));
            }
          });

          for (int i = 0; i < data.length; i++) {
            if (data[i]
                .domainNameC!
                .toUpperCase()
                .contains(event.searchKeyword!.toUpperCase())) {
              list.add(data[i]);
            }
          }
          yield OcrLoading();
          yield SearchSubjectDetailsSuccess(
            obj: list,
          );
        } else if (event.type == 'nycSub') {
          for (int i = 0; i < data.length; i++) {
            if (data[i]
                .standardAndDescriptionC!
                .toUpperCase()
                .contains(event.searchKeyword!.toUpperCase())) {
              list.add(data[i]);
            }
          }
          yield OcrLoading();
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
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : //print(e);
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
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : //print(e);
            throw (e);
      }
    }

    if (event is FatchSubjectDetails) {
      try {
        LocalDatabase<SubjectDetailList> recentOptionDB =
            LocalDatabase('recent_option_subject');
        // yield OcrLoading();

        List<SubjectDetailList> data = await fatchSubjectDetails(
            type: event.type!,
            keyword: event.keyword!,
            isSearchPage: event.isSearchPage ?? false,
            gradeNo: event.grade,
            subjectSelected: event.subjectSelected);
        if (event.type == 'subject') {
          List<SubjectDetailList> subjectList = [];
          subjectList.addAll(data);

          List<SubjectDetailList> list =
              await fatchLocalSubject(event.keyword!);
          subjectList.addAll(list);
          yield OcrLoading();

          List<SubjectDetailList> recentSubjectlist =
              await recentOptionDB.getData();

          if (recentSubjectlist.isNotEmpty) {
            for (int i = 0; i < subjectList.length; i++) {
              for (int j = 0; j < recentSubjectlist.length; j++) {
                if (subjectList[i].subjectNameC ==
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
            if (element.subjectNameC != null) {
              subjectList
                  .sort((a, b) => a.subjectNameC!.compareTo(b.subjectNameC!));
            }
          });
          yield SubjectDataSuccess(obj: subjectList);
        } else if (event.type == 'nyc') {
          //Recent list created with onTap
          LocalDatabase<SubjectDetailList> learningRecentOptionDB =
              LocalDatabase('recent_option_learning_standard');

          List<SubjectDetailList> recentLearninglist =
              await learningRecentOptionDB.getData();

          if (recentLearninglist.isNotEmpty) {
            for (int i = 0; i < data.length; i++) {
              for (int j = 0; j < recentLearninglist.length; j++) {
                if (data[i].domainNameC == recentLearninglist[j].domainNameC) {
                  data[i].dateTime = recentLearninglist[j].dateTime;
                } else {
                  if (data[i].dateTime == null) {
                    //Using old/random date to make sue none of the record contains null date
                    data[i].dateTime = DateTime.parse('2012-02-27');
                  }
                }
              }
            }
          } else {
            data.forEach((element) {
              //Using old/random date to make sue none of the record contains null date
              element.dateTime = DateTime.parse('2012-02-27');
            });
          }

          data.forEach((element) {
            if (element.domainNameC != null) {
              data.sort((a, b) => a.domainNameC!.compareTo(b.domainNameC!));
            }
          });

          yield NycDataSuccess(
            obj: data,
          );
        } else if (event.type == 'nycSub') {
          yield NycSubDataSuccess(
            obj: data,
          );
        }
      } catch (e) {
        yield OcrErrorReceived(err: e);
      }
    }
    if (event is SaveSubjectListDetails) {
      try {
        bool result = await saveSubjectListDetails();
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : //print(e);
            throw (e);
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
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : //print(e);
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
          "Session_Id": "${event.sessionId}",
          "Teacher_Id": "${event.teacherId}",
          "Activity_Id": "${event.activityId}",
          "Account_Id": "${event.accountId}",
          "Account_Type": "${event.accountType}",
          "Date_Time": "${event.dateTime}",
          "Description": "${event.description}",
          "Operation_Result": "${event.operationResult}"
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

  Future<bool> saveSubjectListDetails() async {
    try {
      final ResponseModel response = await _dbServices.getapiNew(Uri.encodeFull(
              //   "${OcrOverrides.OCR_API_BASE_URL}getRecords/Standard__c",
              // ),
              'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Standard__c'),
          isGoogleAPI: true,
          headers: {"Content-type": "application/json; charset=utf-8"});

      if (response.statusCode == 200) {
        List<SubjectDetailList> _list =
            jsonDecode(jsonEncode(response.data['body']))
                .map<SubjectDetailList>((i) => SubjectDetailList.fromJson(i))
                .toList();
        ////print(_list);
        LocalDatabase<SubjectDetailList> _localDb =
            LocalDatabase(Strings.ocrSubjectObjectName);
        await _localDb.clear();

        _list.forEach((SubjectDetailList e) {
          //To decode the special characters
          utf8.decode(utf8.encode(_localDb.addData(e).toString()));
        });
        // _list.removeWhere((SubjectList element) => element.status == 'Hide');
        return true;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<SubjectDetailList>> fatchLocalSubject(String classNo) async {
    LocalDatabase<SubjectDetailList> _localDb =
        LocalDatabase('Subject_list$classNo');
    //Clear subject local data to resolve loading issue
    SharedPreferences clearSubjectCache = await SharedPreferences.getInstance();
    final clearChacheResult = clearSubjectCache.getBool('Clear_local_Subject');

    if (clearChacheResult != true) {
      _localDb.clear();
      await clearSubjectCache.setBool('Clear_local_Subject', true);
    }
    List<SubjectDetailList>? _localData = await _localDb.getData();
    return _localData;
  }

  Future<List<SubjectDetailList>> fatchSubjectDetails(
      {required String type,
      required String keyword,
      bool? isSearchPage,
      String? gradeNo,
      String? subjectSelected}) async {
    try {
      // String grade = '';
      // String selectedSubject = '';
      //Local list managing
      LocalDatabase<SubjectDetailList> _localDb =
          LocalDatabase(Strings.ocrSubjectObjectName);
      List<SubjectDetailList>? _localData = await _localDb.getData();

      //Common detail list to save all deatails of subject for specific grade. Include : Subject, Learning standard and sub learning standard
      List<SubjectDetailList> subjectDetailList = [];

      //Return subject details
      if (type == 'subject') {
        grade = keyword;
        //Using a seperate list to check only 'Subject' whether already exist or not.
        List subjectList = [];

        for (int i = 0; i < _localData.length; i++) {
          if (_localData[i].gradeC == keyword) {
            if (subjectDetailList.isNotEmpty &&
                !subjectList.contains(_localData[i].subjectNameC)) {
              subjectDetailList.add(_localData[i]);
              subjectList.add(_localData[i].subjectNameC);
            } else if (subjectDetailList.isEmpty) {
              subjectDetailList.add(_localData[i]);
              subjectList.add(_localData[i].subjectNameC);
            }
          }
        }
        return subjectDetailList;
      }
      //Return Learning standard details
      else if (type == 'nyc') {
        //Using a seperate list to check only 'Learning Standard' whether already exist or not.

        List learningStdList = [];

        selectedSubject = keyword;
        for (int i = 0; i < _localData.length; i++) {
          if (_localData[i].subjectNameC == keyword &&
              _localData[i].gradeC ==
                  (isSearchPage == true ? gradeNo : grade)) {
            if (subjectDetailList.isNotEmpty &&
                !learningStdList.contains(_localData[i].domainNameC)) {
              subjectDetailList.add(_localData[i]);
              learningStdList.add(_localData[i].domainNameC);
            } else if (subjectDetailList.isEmpty) {
              subjectDetailList.add(_localData[i]);
              learningStdList.add(_localData[i].domainNameC);
            }
          }
        }
        return subjectDetailList;
      } //Return Sub Learning standard details
      else if (type == 'nycSub') {
        //Using a seperate list to check only 'Sub Learning Standard' whether already exist or not.
        if (isSearchPage == true) {
          List<SubjectDetailList> list = [];
          List subLearningStdList = [];
          for (int i = 0; i < _localData.length; i++) {
            if (
                //_localData[i].subjectNameC == selectedSubject &&
                _localData[i].gradeC == gradeNo &&
                    _localData[i].subjectNameC == keyword) {
              if (list.isNotEmpty &&
                  !subLearningStdList
                      .contains(_localData[i].standardAndDescriptionC)) {
                list.add(_localData[i]);
                subLearningStdList.add(_localData[i].standardAndDescriptionC);
              } else if (list.isEmpty) {
                list.add(_localData[i]);
                subLearningStdList.add(_localData[i].standardAndDescriptionC);
              }
            }
          }
          return list;
        } else {
          List subLearningStdList = [];

          for (int i = 0; i < _localData.length; i++) {
            if (_localData[i].subjectNameC ==
                    (selectedSubject == ''
                        ? subjectSelected
                        : selectedSubject) &&
                (_localData[i].gradeC == (grade == '' ? gradeNo : grade)) &&
                _localData[i].domainNameC == keyword) {
              if (subjectDetailList.isNotEmpty &&
                  !subLearningStdList
                      .contains(_localData[i].standardAndDescriptionC)) {
                subjectDetailList.add(_localData[i]);
                subLearningStdList.add(_localData[i].standardAndDescriptionC);
              } else if (subjectDetailList.isEmpty) {
                subjectDetailList.add(_localData[i]);
                subLearningStdList.add(_localData[i].standardAndDescriptionC);
              }
            }
          }
          return subjectDetailList;
        }
      }
      return subjectDetailList;
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
        "Student_ID__c": studentId
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
          isGoogleAPI: true);
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
          isGoogleAPI: true);

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
          isGoogleAPI: true);
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
          isGoogleAPI: true);
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
}
