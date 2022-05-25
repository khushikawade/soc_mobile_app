import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/modal/subject_list_modal.dart';
import 'package:Soc/src/modules/ocr/overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
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

  @override
  Stream<OcrState> mapEventToState(
    OcrEvent event,
  ) async* {
    if (event is FetchTextFromImage) {
      try {
        yield OcrLoading();
        List data = await fetchAndProcessDetails(base64: event.base64);
        if (data[0] != '' && data[1] != '') {
          yield FetchTextFromImageSuccess(schoolId: data[0], grade: data[1]);
        } else {
          yield FetchTextFromImageFailure(schoolId: data[0], grade: data[1]);
        }
      } catch (e) {
        print(e);
      }
    }

    if (event is VerifyUserWithDatabase) {
      try {
        yield OcrLoading();
        //  var data =
        bool result =
            await verifyUserWithDatabase(email: event.email.toString());
        if (!result) {
          await verifyUserWithDatabase(email: event.email.toString());
        }
      } catch (e) {
        await verifyUserWithDatabase(email: event.email.toString());

        // yield OcrErrorReceived(err: e);
      }
    }

    if (event is FatchSubjectDetails) {
      try {
        if (event.type == 'subject') {
          yield OcrLoading();
        }

        List<SubjectList> data = await fatchSubjectDetails();
        if (event.type == 'subject') {
          yield SubjectDataSuccess(
            obj: data,
          );
        } else if (event.type == 'nyc') {
          List<SubjectList> list = [];

          for (int i = 0; i < Globals.nycDetailsList.length; i++) {
            SubjectList subjectList = SubjectList();
            subjectList.subjectNameC = Globals.nycDetailsList[i];
            list.insert(i, subjectList);
          }
          yield NycDataSuccess(
            obj: list,
          );
        } else if (event.type == 'nycSub') {
          List<SubjectList> list = [];

          for (int i = 0; i < Globals.subjectDetailsList.length; i++) {
            SubjectList subjectList = SubjectList();
            subjectList.subjectNameC = Globals.subjectDetailsList[i];
            list.insert(i, subjectList);
          }
          yield NycSubDataSuccess(
            obj: list,
          );
        }
      } catch (e) {
        // if (e.toString().contains('NO_CONNECTION')) {
        //   Utility.showSnackBar(event.scaffoldKey,
        //       'Make sure you have a proper Internet connection', event.context);
        // }
        yield OcrErrorReceived(err: e);
      }
    }
  }

  Future<List<SubjectList>> fatchSubjectDetails() async {
    try {
      final ResponseModel response = await _dbServices.getapi(Uri.encodeFull(
          "getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=Subject__c&fetchType=All"));

      if (response.statusCode == 200) {
        List<SubjectList> _list = response.data['body']
            .map<SubjectList>((i) => SubjectList.fromJson(i))
            .toList();
        // _list.removeWhere((SubjectList element) => element.status == 'Hide');
        return _list;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future fetchAndProcessDetails({required String base64}) async {
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

        print(schoolgrade);
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
        bool result = await _createContact(email: email.toString());
        if (!result) {
          await _createContact(email: email.toString());
        }
      } else if(data['Assessment_App_User__c']!='true') {
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
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
    };
    final body = {
      "AccountId": "0017h00000k3TgjAAE",
      "Assessment_App_User__c": "true",
      "LastName": email!.split("@")[0],
      "Email": email
    };

    final ResponseModel response = await _dbServices.postapi(
        "${OcrOverrides.OCR_API_BASE_URL}saveRecordToSalesforce/Contact",
        isGoogleApi: true,
        body: body,
        headers: headers);
    if (response.statusCode == 200) {
      print("contact created");

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
      print("contact updated");
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