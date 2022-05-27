import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import '../../../services/local_database/local_db.dart';
import '../modal/subject_details_modal.dart';
import 'package:Soc/src/services/utility.dart';
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
        yield FetchTextFromImageFailure(schoolId: '', grade: '');
        yield OcrLoading();
        List data = await fatchAndProcessDetails(base64: event.base64);
        if (data[0] != '' && data[1] != '') {
          yield FetchTextFromImageSuccess(schoolId: data[0], grade: data[1]);
        } else {
          yield FetchTextFromImageFailure(schoolId: data[0], grade: data[1]);
        }
      } catch (e) {
        yield FetchTextFromImageFailure(schoolId: '', grade: '');
        print(e);
      }
    }
    if (event is SearchSubjectDetails) {
      try {
        List<SubjectDetailList> data = await fatchSubjectDetails(
            type: event.type!, keyword: event.keyword!);
        List<SubjectDetailList> list = [];
        if (event.type == 'subject') {
          for (int i = 0; i < data.length; i++) {
            if (data[i]
                .subjectNameC!
                .toUpperCase()
                .contains(event.searchKeyword!.toUpperCase())) {
              list.add(data[i]);
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
          yield SubjectDataSuccess(
            obj: data,
          );
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
  }

  Future<bool> saveSubjectListDetails() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          Uri.encodeFull(
              'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Standard__c'),
          isGoogleApi: true);

      if (response.statusCode == 200) {
        List<SubjectDetailList> _list = response.data['body']
            .map<SubjectDetailList>((i) => SubjectDetailList.fromJson(i))
            .toList();
        print('Subject List fetched : ${_list.length}');
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

  Future fatchAndProcessDetails({required String base64}) async {
    try {
      final ResponseModel response = await _dbServices.postapi(
        Uri.encodeFull('http://3.142.181.122:5050/ocr'),
        body: {'data': '$base64'},
        isGoogleApi: true,
      );

      if (response.statusCode == 200) {
        // ***********  Process The respoance and collecting OSS ID  ***********
        List schoolIdNew = [];
        if (response.data['text']['responses'][0] != null) {
          List text = response.data['text']['responses'][0]['textAnnotations'];
          for (var i = 0; i < text.length; i++) {
            if (text[i]['description'].toString().length == 9 &&
                text[i]['description'][0] == '2') {
              bool result = Utility.checkForInt(text[i]['description']);
              if (result) {
                schoolIdNew.add(text[i]['description']);
              }
            }
          }
          if (schoolIdNew.isEmpty) {
            for (var i = 0; i < text.length - 1; i++) {
              int sum = 0;
              String id = '';
              for (int j = i; j < text.length - (i + 1); j++) {
                sum = sum + text[j]['description'].toString().length;
                id = '$id${text[j]['description']}';
                if (sum == 9 && text[i]['description'].toString()[0] == '2') {
                  bool result = Utility.checkForInt(id);
                  if (result) {
                    schoolIdNew.add(id);
                  }
                } else if (sum > 9) {
                  break;
                }
              }
            }
          }
        }
        // ***********  Process The respoance and collecting Point Scored  ***********
        List schoolgrade = [];
        if (response.data['text']['responses'][0] != null &&
            response.data['coordinate'] != null) {
          List coordinate = response.data['coordinate'];
          List text = response.data['text']['responses'][0]['textAnnotations'];
          for (var i = 0; i < text.length; i++) {
            for (var j = 0; j < coordinate.length; j++) {
              int circleX =
                  Utility.covertStringtoInt(coordinate[j].split(',')[0]);
              int circleY =
                  Utility.covertStringtoInt(coordinate[j].split(',')[1]);
              int radiusR =
                  Utility.covertStringtoInt(coordinate[j].split(',')[1]);

              int textx = Utility.covertStringtoInt(
                  text[i]['boundingPoly']['vertices'][0]['x'].toString());
              int texty = Utility.covertStringtoInt(
                  text[i]['boundingPoly']['vertices'][0]['y'].toString());

              if (text[i]['description'].toString().length == 1 &&
                  textx < circleX + radiusR &&
                  textx > circleX - radiusR &&
                  texty < circleY + radiusR &&
                  texty > circleY - radiusR &&
                  (text[i]['description'] == '0' ||
                      text[i]['description'] == '1' ||
                      text[i]['description'] == '2')) {
                schoolgrade.add(text[i]['description']);
              }
            }
          }
        }

        print('School grades : ${schoolgrade.length}');
        return [
          schoolIdNew.isNotEmpty ? schoolIdNew[0] : '',
          schoolgrade.isNotEmpty ? schoolgrade[0] : ''
        ];
      }
    } catch (e) {
      print(
          '------------------------------------error-----------------------------------');
      print(e);
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
