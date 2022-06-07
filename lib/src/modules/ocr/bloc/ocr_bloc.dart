import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:intl/intl.dart';
import '../../../services/local_database/local_db.dart';
import '../modal/subject_details_modal.dart';
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

  @override
  Stream<OcrState> mapEventToState(
    OcrEvent event,
  ) async* {
    if (event is FetchTextFromImage) {
      try {
        //     yield FetchTextFromImageFailure(schoolId: '', grade: '');
        yield OcrLoading();
        List data = await fatchAndProcessDetails(
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
                  : '2',
              studentName: data[2]);
        }
      } catch (e) {
        // yield FetchTextFromImageFailure(
        //     studentId: '', grade: '', studentName: '');
        print(e);
      }
    }
    if (event is SearchSubjectDetails) {
      try {
        List<SubjectDetailList> data = await fatchSubjectDetails(
            type: event.type!, keyword: event.keyword!);
        List<SubjectDetailList> list = [];
        if (event.type == 'subject') {
          List<SubjectDetailList> subjectList = [];
          subjectList.addAll(data);
          List<SubjectDetailList> list =
              await fatchLocalSubject(event.keyword!);
          subjectList.addAll(list);
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
          print(list.length);
          yield SearchSubjectDetailsSuccess(
            obj: list,
          );
        } else if (event.type == 'nyc') {
          for (int i = 0; i < data.length; i++) {
            if (data[i]
                .domainNameC!
                .toUpperCase()
                .contains(event.searchKeyword!.toUpperCase())) {
              list.add(data[i]);
            }
          }
          print(list.length);
          yield SearchSubjectDetailsSuccess(
            obj: list,
          );
        } else if (event.type == 'nycSub') {
          for (int i = 0; i < data.length; i++) {
            if (data[i]
                .descriptionC!
                .toUpperCase()
                .contains(event.searchKeyword!.toUpperCase())) {
              list.add(data[i]);
            }
          }
          print(list.length);
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
        _saveStudentName(
            studentName: event.studentName, studentId: event.studentId);
      } catch (e) {}
    }

    if (event is VerifyUserWithDatabase) {
      try {
        print("calling api to verifyUserWithDatabase");
        //  var data =
        bool result =
            await verifyUserWithDatabase(email: event.email.toString());
        if (!result) {
          await verifyUserWithDatabase(email: event.email.toString());
        }
      } catch (e) {
        print(e);
        throw (e);

        // yield OcrErrorReceived(err: e);
      }
    }

    if (event is FatchSubjectDetails) {
      try {
        // yield OcrLoading();

        List<SubjectDetailList> data = await fatchSubjectDetails(
            type: event.type!, keyword: event.keyword!);
        if (event.type == 'subject') {
          List<SubjectDetailList> subjectList = [];
          subjectList.addAll(data);

          List<SubjectDetailList> list =
              await fatchLocalSubject(event.keyword!);
          subjectList.addAll(list);
          yield OcrLoading();
          yield SubjectDataSuccess(obj: subjectList);
        } else if (event.type == 'nyc') {
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
      } catch (e) {}
    }

    if (event is SaveAssessmentIntoDataBase) {
      try {
        print("calling save record to sales Force");

        String id = await _saveAssessmetRecordToSalesForce(
            assessmentName: event.assessmentName,
            rubicScore: await rubricPickList(event.rubricScore),
            subjectId: event.subjectId,
            schoolId: event.schoolId,
            standardId: event.standardId);

        if (id != '') {
          bool result = await _addStudentRecordOnSalesForce(
              assessmentId: id, studentDetails: Globals.studentInfo!);

          !result
              ? _addStudentRecordOnSalesForce(
                  assessmentId: id, studentDetails: Globals.studentInfo!)
              : print("result Record is saved on DB");
        } else {
          throw ('something_went_wrong');
        }
      } catch (e) {
        throw (e);
      }
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
        List<SubjectDetailList> _list = response.data['body']
            .map<SubjectDetailList>((i) => SubjectDetailList.fromJson(i))
            .toList();
        //print(_list);
        LocalDatabase<SubjectDetailList> _localDb =
            LocalDatabase(Strings.ocrSubjectObjectName);
        await _localDb.clear();
        _list.forEach((SubjectDetailList e) {
          _localDb.addData(e);
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
    List<SubjectDetailList>? _localData = await _localDb.getData();
    return _localData;
  }

  Future<List<SubjectDetailList>> fatchSubjectDetails(
      {required String type, required String keyword}) async {
    try {
      LocalDatabase<SubjectDetailList> _localDb =
          LocalDatabase(Strings.ocrSubjectObjectName);
      List<SubjectDetailList>? _localData = await _localDb.getData();
      print('Subject Local data : ${_localData.length}');
      List<SubjectDetailList> detailsList = [];
      if (type == 'subject') {
        grade = keyword;
        List id = [];
        for (int i = 0; i < _localData.length; i++) {
          if (_localData[i].gradeC == keyword) {
            if (detailsList.isNotEmpty &&
                !id.contains(_localData[i].subjectNameC)) {
              detailsList.add(_localData[i]);
              id.add(_localData[i].subjectNameC);
            } else if (detailsList.isEmpty) {
              detailsList.add(_localData[i]);
              id.add(_localData[i].subjectNameC);
            }
          }
        }
        return detailsList;
      } else if (type == 'nyc') {
        List id = [];
        selectedSubject = keyword;
        for (int i = 0; i < _localData.length; i++) {
          if (_localData[i].subjectNameC == keyword &&
              _localData[i].gradeC == grade) {
            if (detailsList.isNotEmpty &&
                !id.contains(_localData[i].domainNameC)) {
              detailsList.add(_localData[i]);
              id.add(_localData[i].domainNameC);
            } else if (detailsList.isEmpty) {
              detailsList.add(_localData[i]);
              id.add(_localData[i].domainNameC);
            }
          }
        }
        return detailsList;
      } else if (type == 'nycSub') {
        List id = [];

        for (int i = 0; i < _localData.length; i++) {
          if (_localData[i].subjectNameC == selectedSubject &&
              _localData[i].gradeC == grade &&
              _localData[i].domainNameC == keyword) {
            if (detailsList.isNotEmpty &&
                !id.contains(_localData[i].standardAndDescriptionC)) {
              detailsList.add(_localData[i]);
              id.add(_localData[i].standardAndDescriptionC);
            } else if (detailsList.isEmpty) {
              detailsList.add(_localData[i]);
              id.add(_localData[i].standardAndDescriptionC);
            }
          }
          // if (_localData[i].subjectNameC == keyword &&
          //     _localData[i].gradeC == grade) {
          //   nycList.add(_localData[i]);
          // }
        }
        return detailsList;
      }
      return detailsList;
    } catch (e) {
      throw (e);
    }
  }

  int covertStringtoInt(String data) {
    try {
      int result = int.parse(data);
      return result;
    } catch (e) {
      return 0;
    }
  }

  Future fatchAndProcessDetails(
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
      print(
          '------------------------------------error-----------------------------------');
      print(e);
    }
  }

  Future<bool> _saveStudentName(
      {required String studentName, required studentId}) async {
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
      print("created");

      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyUserWithDatabase({required String? email}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
    };
    final body = {"email": email.toString()};
    final ResponseModel response = await _dbServices.postapi(
        "authorizeEmail?objectName=Contact",
        body: body,
        headers: headers);

    if (response.statusCode == 200) {
      var res = response.data;
      var data = res["body"];
      if (data == false) {
        print("this is a new uer now create a user contaact inside database");
        bool result = await _createContact(email: email.toString());
        if (!result) {
          await _createContact(email: email.toString());
        }
      } else if (data['Assessment_App_User__c'] != 'true') {
        print("this is a older user now updating datils in database");
        bool result = await _updateContact(recordId: data['Id']);
        if (!result) {
          await _updateContact(recordId: data['Id']);
        }
      }
      return true;
      // return data;
    } else {
      return false;
    }
  }

  Future<bool> _createContact({required String? email}) async {
    print(email!.split("@")[0]);
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
    };
    final body = {
      "AccountId": "0017h00000k3TgjAAE",
      "Assessment_App_User__c": "true",
      "LastName": email.split("@")[0],
      "Email": email
    };

    final ResponseModel response = await _dbServices.postapi(
        "${OcrOverrides.OCR_API_BASE_URL}saveRecordToSalesforce/Contact",
        isGoogleApi: true,
        body: body,
        headers: headers);
    if (response.statusCode == 200) {
      print("new user created ---->sucessfully ");
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _updateContact({required String? recordId}) async {
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
      print("old user data updated --> sucessfully ");
      return true;
    } else {
      return false;
    }
  }

  Future<String> _saveAssessmetRecordToSalesForce({
    required String? assessmentName,
    required String? rubicScore,
    required String? subjectId,
    required String? schoolId,
    required String? standardId,
  }) async {
    String currentDate = _getCurrentDate(DateTime.now());

    Map<String, String> headers = {
      'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx',
      'Content-Type': 'application/json'
    };

    final body = {
      "Date__c": currentDate,
      "Name__c": assessmentName,
      "Rubric__c": rubicScore,
      "School__c": schoolId,
      "School_year__c": currentDate.split("-")[0],
      "Standard__c": standardId,
      "Subject__c": subjectId
    };
    final ResponseModel response = await _dbServices.postapi(
      "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/saveRecord?objectName=Assessment__c",
      isGoogleApi: true,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      String id = response.data['body']['Assessment_Id'];

      print("record is saved now ");
      return id;
    } else {
      print("not 200 ---> r${response.statusCode}");
      return "";
    }
  }

  _getCurrentDate(DateTime dateTime) {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  rubricPickList(rubricScore) {
    if (rubricScore == null) {
      return null;
    }
    if (rubricScore == '0-2') {
      return "0,1 or 2";
    }
    if (rubricScore == '0-3') {
      return "0,1,2 or 3";
    } else {
      return "0,1,2 or 4";
    }
  }

  Future<bool> _addStudentRecordOnSalesForce(
      {required String assessmentId,
      required List<StudentAssessmentInfo> studentDetails}) async {
    List<Map> bodyContent = [];

    studentDetails.removeAt(0);

    for (int i = 0; i < studentDetails.length; i++) {
      bodyContent.add(recordtoJson(
          assessmentId,
          _getCurrentDate(DateTime.now()),
          studentDetails[i].studentGrade,
          studentDetails[i].studentId,
          "NA"));
    }

    final ResponseModel response = await _dbServices.postapi(
      "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/saveRecords?objectName=Result__c",
      isGoogleApi: true,
      body: bodyContent,
    );
    if (response.statusCode == 200) {
      // String id = response.data['body']['id'];
      print("result record is saved successfully ");
      return true;
    } else {
      return false;
    }
  }

  Map<String, String> recordtoJson(assessmentId, currentDate, pointsEarned,
      studentOsisId, assessmentImageURl) {
    Map<String, String> body = {
      "Assessment_Id": assessmentId,
      "Date__c": currentDate.toString(),
      "Result__c": pointsEarned,
      "Student__c": studentOsisId, //Scanned from the sheet
      "Assessment_Image__c": assessmentImageURl
    };
    return body;
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
}
