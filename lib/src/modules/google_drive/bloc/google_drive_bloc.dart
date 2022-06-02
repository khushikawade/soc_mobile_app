import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/google_drive_access.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:flutter/foundation.dart';
import 'package:mime_type/mime_type.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../services/db_service.dart';
import 'package:path/path.dart';
import '../../ocr/modal/student_assessment_info_modal.dart';
import '../model/user_profile.dart';
part 'google_drive_event.dart';
part 'google_drive_state.dart';

class GoogleDriveBloc extends Bloc<GoogleDriveEvent, GoogleDriveState> {
  GoogleDriveBloc() : super(GoogleDriveInitial());
  final DbServices _dbServices = DbServices();
  // final HiveDbServices _localDbService = HiveDbServices();
  GoogleDriveState get initialState => GoogleDriveInitial();

  @override
  Stream<GoogleDriveState> mapEventToState(
    GoogleDriveEvent event,
  ) async* {
    if (event is GetDriveFolderIdEvent) {
      try {
        var folderObject;
        // Globals.authorizationToken = event.token;
        folderObject = await _getGoogleDriveFolderList(
            token: event.token, folderName: event.folderName);
        //  print('FolderId = ${folderObject['id']}');

        if (folderObject != 401) {
          if (folderObject == '') {
            await _createFolderOnDrive(
                token: event.token, folderName: event.folderName);
            print("Folder created successfully");
          } else {
            print("Folder Id received : ${folderObject['id']}");
            print("Folder path received : ${folderObject['webViewLink']}");
            Globals.googleDriveFolderId = folderObject['id'];
            Globals.googleDriveFolderPath = folderObject['webViewLink'];
            // Globals.
            if (event.fetchHistory == true) {
              //Fetch history assessment
              GetHistoryAssessmentFromDrive();
            }
          }
        } else {
          print('Authentication required');
          bool result =
              await _toRefreshAuthenticationToken(event.refreshtoken!);
          if (!result) {
            await _toRefreshAuthenticationToken(event.refreshtoken!);
          }
        }
      } catch (e) {
        throw (e);
      }
    }

    if (event is CreateExcelSheetToDrive) {
      try {
        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        Globals.assessmentName = event.name;
        bool result = await createSheetOnDrive(
            name: event.name!,
            folderId: Globals.googleDriveFolderId,
            accessToken: _userprofilelocalData[0].authorizationToken
            //  image: file
            );
        if (!result) {
          print(
              "Failed to create. Trying to create the excel sheet again : ${event.name!}");
          await createSheetOnDrive(
              folderId: Globals.googleDriveFolderId,
              accessToken: _userprofilelocalData[0].authorizationToken
              // image: file
              );
        } else {
          print("Excel sheet created successfully : ${event.name!}");
        }
      } catch (e) {
        print("error");
        print(e);
      }
    }

    if (event is UpdateDocOnDrive) {
      try {
        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        List<StudentAssessmentInfo>? assessmentData = event.studentData;
        assessmentData!.insert(
            0,
            StudentAssessmentInfo(
                studentId: "Id",
                studentName: "Name",
                studentGrade: "Points Earned",
                pointpossible: "Point Possible",
                grade: "Grade",
                subject: "Subject",
                learningStandard: "Learning Standard",
                subLearningStandard: "Sub Learning Standard",
                scoringRubric: "Scoring Rubric",
                customRubricImage: "Custom Rubric Image"));
        print(assessmentData);

        File file = await GoogleDriveAccess.createSheet(
            data: assessmentData, name: Globals.assessmentName!);

        bool uploadresult = await uploadSheetOnDrive(
            file, Globals.fileId, _userprofilelocalData[0].authorizationToken);
        if (!uploadresult) {
          await uploadSheetOnDrive(file, Globals.fileId,
              _userprofilelocalData[0].authorizationToken);
        }
        bool deleted = await GoogleDriveAccess.deleteFile(file);
        if (!deleted) {
          GoogleDriveAccess.deleteFile(file);
        }
      } catch (e) {
        print("inside bloc catch");
        print(e);
      }
    }

    if (event is GetHistoryAssessmentFromDrive) {
      try {
        LocalDatabase<HistoryAssessment> _localDb =
            LocalDatabase("HistoryAssessment");

        List<HistoryAssessment>? _localData = await _localDb.getData();
        _localData.clear();
        if (_localData.isNotEmpty) {
          yield GoogleDriveGetSuccess(obj: _localData);
        }
        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        List<HistoryAssessment> assessmentList = [];
        if (Globals.googleDriveFolderId != null) {
          List<HistoryAssessment> _list = await _fetchHistoryAssessment(
              _userprofilelocalData[0].authorizationToken,
              Globals.googleDriveFolderId);
          //     if (_list.length > 0) {
          // for (int i = 0; i < data.length; i++) {
          _list.forEach((element) {
            print(element.label['trashed']);
            if (element.label['trashed'] != true) {
              assessmentList.add(element);
            }
          });
          await _localDb.clear();
          assessmentList.forEach((HistoryAssessment e) {
            _localDb.addData(e);
          });

          yield GoogleDriveGetSuccess(obj: assessmentList);
          //   }
        } else {
          GetDriveFolderIdEvent(
              //  filePath: file,
              token: _userprofilelocalData[0].authorizationToken,
              folderName: "Assessments",
              fetchHistory: true);
        }
      } catch (e) {
        print(e);
      }
    }
    if (event is GetAssessmentDetail) {
      try {
        List<StudentAssessmentInfo> _list = [];
        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        String link = await _getAssessmentDetail(
            _userprofilelocalData[0].authorizationToken, event.fileId);

        if (link != "") {
          String file = await downloadFile(
              link, "test3", (await getApplicationDocumentsDirectory()).path);
          print("assessment downloaded");

          if (file != "") {
            //  List<StudentAssessmentInfo>
            _list = await GoogleDriveAccess.excelToJson(file);
            print("assessment data is converted into json ");
            bool deleted = await GoogleDriveAccess.deleteFile(File(file));
            if (!deleted) {
              GoogleDriveAccess.deleteFile(File(file));
            }
            print("local assessment file is deleted");
            // if (_list.length > 0) {
            //   yield AssessmentDetailSuccess(obj: _list);
            // } else {
            //   yield GoogleNoAssessment();
            // }
            _list.insert(
                0,
                StudentAssessmentInfo(
                    studentId: "Id",
                    studentName: "Name",
                    studentGrade: "Points Earned",
                    pointpossible: "Point Possible",
                    grade: "Grade",
                    subject: "Subject",
                    learningStandard: "Learning Standard",
                    subLearningStandard: "Sub Learning Standard",
                    scoringRubric: "Scoring Rubric"));
            yield AssessmentDetailSuccess(obj: _list);
          }
        }
      } catch (e) {
        throw (e);
      }
    }

    if (event is ImageToAwsBucked) {
      try {
        String imgUrl = await _uploadImgB64AndGetUrl(event.imgBase64);
        //  int index = Globals.scoringList.length - 1;
        print(Globals.scoringList);
        imgUrl != ""
            ? Globals.scoringList.last.imgUrl = imgUrl
            : _uploadImgB64AndGetUrl(event.imgBase64);
        print(Globals.scoringList);
        print("printing imag url");
        // updateLocalDb();
      } catch (e) {
        print("image upload error");
      }
    }
  }

  Future<String> _createFolderOnDrive(
      {required String? token, required String? folderName}) async {
    try {
      final body = {
        "mimeType": "application/vnd.google-apps.folder",
        "title": folderName
      };
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      final ResponseModel response = await _dbServices.postapi(
          'https://www.googleapis.com/drive/v2/files',
          headers: headers,
          body: body,
          isGoogleApi: true);

      if (response.statusCode == 200) {
        //  String id = response.data['id'];
        print("Folder created successfully : ${response.data['id']}");
        return Globals.googleDriveFolderId = response.data['id'];
      }
      return "";
    } catch (e) {
      throw (e);
    }
  }

  Future _getGoogleDriveFolderList(
      {required String? token, required String? folderName}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      final ResponseModel response = await _dbServices.getapi(
          'https://www.googleapis.com/drive/v3/files?fields=*',
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode == 200) {
        var data = response.data['files'];

        for (int i = 0; i < data.length; i++) {
          if (data[i]['name'] == folderName &&
              data[i]["mimeType"] == "application/vnd.google-apps.folder" &&
              data[i]["trashed"] == false) {
            // print("folder is already exits : ${data[i]['id']}");
            return data[i];
          }
        }
      } else if (response.statusCode == 401) {
        print("Invalid credentials");
        return response.statusCode;
      }
      return "";
    } catch (e) {
      throw (e);
    }
  }

  Future createSheetOnDrive(
      {String? name,
      //  File? image,
      String? folderId,
      String? accessToken}) async {
    Map body = {
      'name': name,
      'description': 'Newly created file',
      'mimeType': 'application/vnd.google-apps.spreadsheet',
      'parents': ['$folderId']
    };
    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final ResponseModel response = await _dbServices.postapi(
        'https://www.googleapis.com/drive/v3/files',
        body: body,
        headers: headers,
        isGoogleApi: true);

    if (response.statusCode == 200) {
      print("file created successfully : ${response.data['id']}");

      String fileId = response.data['id'];
      Globals.fileId = fileId;
      bool result = await _updateSheetPermission(accessToken!, fileId);
      if (!result) {
        await _updateSheetPermission(accessToken, fileId);
      }

      bool link = await _getShareableLink(accessToken, fileId);
      if (!link) {
        await _getShareableLink(accessToken, fileId);
      }
      return true;
    }
    return false;
  }

  Future uploadSheetOnDrive(File? file, String? id, String? accessToken) async {
    // String accessToken = await Prefs.getToken();
    String? mimeType = mime(basename(file!.path).toLowerCase());

    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': '$mimeType'
    };

    final ResponseModel response = await _dbServices.patchapi(
      'https://www.googleapis.com/upload/drive/v3/files/$id?uploadType=media',
      headers: headers,
      body: file.readAsBytesSync(),
    );
    if (response.statusCode == 200) {
      print("upload result data to assessment file completed");
      return true;
    } else {
      print("errorrrrr-------------> upload on drive");
      print(response.statusCode);
    }
    return false;
  }

  Future _fetchHistoryAssessment(String? token, String? folderId) async {
    try {
      print(token);
      print(folderId);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      final ResponseModel response = await _dbServices.getapi(
          "https://www.googleapis.com/drive/v2/files?q='$folderId'+in+parents",
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode == 200) {
        print("assessment list is received ");
        print(response.data);
        List<HistoryAssessment> _list = response.data['items']
            .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
            .toList();
        return _list;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  _updateSheetPermission(String token, String folderId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    final body = {"role": "reader", "type": "anyone"};

    final ResponseModel response = await _dbServices.postapi(
        'https://www.googleapis.com/drive/v3/files/$folderId/permissions',
        headers: headers,
        body: body,
        isGoogleApi: true);

    if (response.statusCode == 200) {
      print("File permission has been updated");
      return true;
    }
    return false;
  }

  _getShareableLink(String token, String fileId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    final ResponseModel response = await _dbServices.getapi(
        'https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
        headers: headers,
        isGoogleApi: true);

    if (response.statusCode == 200) {
      print(" get file link   ----------->");
      var data = response.data;
      Globals.shareableLink = response.data['webViewLink'];
      return true;
    }
    return false;
  }

  Future<String> _getAssessmentDetail(String? token, String? fileId) async {
    Map<String, String> headers = {
      'authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final ResponseModel response = await _dbServices.getapi(
        //'https://www.googleapis.com/drive/v3/files/$fileId?fields=webContentLink',
        'https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
        headers: headers,
        isGoogleApi: true);

    if (response.statusCode == 200) {
      print("detail assessment link is received");
      var data = response.data;

      String downloadLink = data['exportLinks']
          ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'];

      return downloadLink;
    }
    return "";
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    try {
      HttpClient httpClient = new HttpClient();
      File file;
      String filePath = '';
      String myUrl = '';

      myUrl = url;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
        return filePath;
      }
      return "";
    } catch (e) {
      print("donload exception");
      print(e);
      throw (e);
    }
  }

  Future<bool> _toRefreshAuthenticationToken(String refreshToken) async {
    try {
      final body = {"refreshToken": refreshToken};
      final ResponseModel response = await _dbServices.postapi(
          "${OcrOverrides.OCR_API_BASE_URL}/refreshGoogleAuthentication",
          body: body,
          isGoogleApi: true);
      if (response.statusCode == 200) {
        print("New access token received");
        String newToken = response.data['body']["access_token"];

        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();

        UserInformation updatedObj = UserInformation(
            userName: _userprofilelocalData[0].userName,
            userEmail: _userprofilelocalData[0].userEmail,
            profilePicture: _userprofilelocalData[0].profilePicture,
            refreshToken: _userprofilelocalData[0].refreshToken,
            authorizationToken: newToken);
        await UserGoogleProfile.updateUserProfileIntoDB(updatedObj);
        //  await HiveDbServices().updateListData('user_profile', 0, updatedObj);

        return true;
      } else {
        return false;
        //  throw ('something_went_wrong');
      }
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<String> _uploadImgB64AndGetUrl(String? imgBase64) async {
    //  print(imgBase64);
    Map body = {
      "bucket": "graded/rubric-score",
      "fileExtension": "png",
      "image": imgBase64
    };
    // Map<String, String> headers = {
    //   'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
    // };
    print("calling api ");
    final ResponseModel response = await _dbServices.postapi(
        "${OcrOverrides.OCR_API_BASE_URL}/uploadImage",
        body: body,
        // headers: headers,
        isGoogleApi: true);

    if (response.statusCode == 200) {
      print("url is recived");
      return response.data['body']['Location'];
    } else {
      print(response.statusCode);

      return "";
    }
  }

  // Future updateLocalDb() async {
  //   //Save user profile to locally
  //   LocalDatabase<CustomRubicModal> _localDb = LocalDatabase('custom_rubic');

  //   await _localDb.clear();
  //   Globals.scoringList.forEach((CustomRubicModal e) {
  //     _localDb.addData(e);
  //   });
  //   print("rubic data is updated on local drive");
  // }
}
