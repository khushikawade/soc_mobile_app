import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/modal/subject_list_modal.dart';
import 'package:Soc/src/modules/ocr/overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
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
      String? grade;
      List schoolIdNew = [];
      yield OcrLoading();
      List data = await fatchDetails(base64: event.base64);
      for (var i = 0; i < data.length; i++) {
        if (data[i]['description'].toString().length == 9) {
          schoolIdNew.add(data[i]);
        }
      }
      grade = data[data.length - 1]['description'];
      print(data);
      yield FetchTextFromImageSuccess(
          schoolId: schoolIdNew[0]['description'] ?? '', grade: grade ?? '');
      try {} catch (e) {}
    }

    if (event is AuthenticateEmail) {
      try {
        yield OcrLoading();
        //  var data =
        bool result = await authenticateEmail(email: event.email.toString());
        if (!result) {
          await authenticateEmail(email: event.email.toString());
        }

        // yield EmailAuthenticationSuccess(
        //   obj: data,
        // );
      } catch (e) {
        await authenticateEmail(email: event.email.toString());
        // if (e.toString().contains('NO_CONNECTION')) {
        //   Utility.showSnackBar(event.scaffoldKey,
        //       'Make sure you have a proper Internet connection', event.context);
        // }
        yield OcrErrorReceived(err: e);
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

  // List processData({required List data, required List coordinate}) {
  //   List schoolIdNew = [];
  //   List schoolgrade = [];

  //   try {
  //     for (var i = 0; i < data.length; i++) {
  //       if (data[i]['description'].toString().length == 9) {
  //         String id = data[i]['description'];
  //         id.replaceAll('o', '0');
  //         id.replaceAll('O', '0');
  //         id.replaceAll('I', '1');
  //         id.replaceAll('i', '1');
  //         id.replaceAll('L', '1');
  //         id.replaceAll('l', '1');
  //         id.replaceAll('S', '5');
  //         id.replaceAll('s', '5');
  //         id.replaceAll('Y', '4');
  //         id.replaceAll('y', '4');
  //         id.replaceAll('q', '9');
  //         id.replaceAll('b', '6');
  //         schoolIdNew.add(id);

  //         //schoolIdNew!.add(data[i]);
  //       }
  //       for (var j = 0; j < coordinate.length; j++) {
  //         int circleX = covertStringtoint(coordinate[j].split(',')[0]);
  //         int circleY = covertStringtoint(coordinate[j].split(',')[1]);
  //         int textx = covertStringtoint(
  //             data[i]['boundingPoly']['vertices'][0]['x'].toString());
  //         int texty = covertStringtoint(
  //             data[i]['boundingPoly']['vertices'][0]['y'].toString());

  //         if (data[i]['description'].toString().length == 1 &&
  //             textx < circleX + 25 &&
  //             textx > circleX - 25 &&
  //             texty < circleY + 25 &&
  //             texty > circleY - 25) {
  //           schoolgrade.add(data[i]['description']);
  //         }
  //       }
  //     }
  //     print(schoolIdNew);
  //     return schoolgrade;
  //   } catch (e) {
  //     throw Exception('Something went wrong');
  //   }
  // }

  int covertStringtoint(String data) {
    try {
      int result = int.parse(data);
      return result;
    } catch (e) {
      return 0;
    }
  }

  Future fatchDetails({required String base64}) async {
    try {
      final ResponseModel response = await _dbServices.postapi(
          Uri.encodeFull('https://b32f-111-118-246-106.in.ngrok.io'),
          body: {'data': '$base64'},
          isGoogleApi: true

          // headers: {
          //   'Content-Type': 'application/json',
          //   'authorization': 'Bearer AIzaSyA309Qitrqstm3l207XVUQ0Yw5K_qgozag'
          // }
          );

      if (response.statusCode == 200) {
        // List<FullTextAnnotation> _list = response.data['text']['responses'][0]
        //     .map<FullTextAnnotation>((i) => FullTextAnnotation.fromJson(i))
        //     .toList();

        print(response.data['text']['responses'][0]['textAnnotations']);
        print(
            '------------------------------------test111111-----------------------------------');
        List text = response.data['text']['responses'][0]['textAnnotations'];
        //     List grade = response.data['coordinate'];

        //  List result = processData(data: text, coordinate: grade);

        // _list.removeWhere((CustomSetting element) => element.status == 'Hide');
        // _list.sort((a, b) => a.sortOrderC!.compareTo(b.sortOrderC!));
        // if (_list.length > 6) {
        //   _list.removeRange(6, _list.length);
        // }
        // Globals.customSetting = _list;
        // // To take the backup for all the sections.
        // _backupAppData();
        // return _list;
        return text;
      }
    } catch (e) {
      print(
          '------------------------------------test-----------------------------------');
      print(e);
    }
  }

  Future<bool> authenticateEmail({required String? email}) async {
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
        bool result = await _createAccount(email: email.toString());
        if (!result) {
          await _createAccount(email: email.toString());
        }
      } else {
        bool result = await _updateAccount(recordId: data['Id']);
        if (!result) {
          await _updateAccount(recordId: data['Id']);
        }
      }
      return true;
      // return data;
    } else {
      return false;
    }
  }

  Future<bool> _createAccount({required String? email}) async {
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
      print("created");

      return true;
    } else {
      return false;
    }
  }

  Future<bool> _updateAccount({required String? recordId}) async {
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
      print("updated");
      return true;
    } else {
      return false;
    }
  }
}
