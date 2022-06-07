import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/google_drive_access.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
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
import '../../ocr/modal/custom_rubic_modal.dart';
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
        print(event.token);
        print(event.folderName);

        folderObject = await _getGoogleDriveFolderList(
            token: event.token, folderName: event.folderName);
        //  print('FolderId = ${folderObject['id']}');

        if (folderObject != 401) {
          if (folderObject == '') {
            print(event.token);
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
          if (result) {
            List<UserInformation> _userprofilelocalData =
                await UserGoogleProfile.getUserProfile();
            GetDriveFolderIdEvent(
                //  filePath: file,
                token: _userprofilelocalData[0].authorizationToken,
                folderName: event.folderName,
                refreshtoken: _userprofilelocalData[0].refreshToken);
          } else if (!result) {
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
        //Sort the list as per the modified date
        _localData = await listSort(_localData);

        // _localData.clear();
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

          _list.forEach((element) {
            print(element.label['trashed']);
            if (element.label['trashed'] != true) {
              assessmentList.add(element);
            }
          });

          //Sort the list as per the modified date
          assessmentList = await listSort(assessmentList);

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
          print("detail assessment link is received");
          String file = await downloadFile(
              link, "test3", (await getApplicationDocumentsDirectory()).path);
          print("assessment downloaded");

          if (file != "") {
            print("Assessment file found");
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
            // if (!_list.contains('Id')) {
            // _list.insert(
            //     0,
            //     StudentAssessmentInfo(
            //         studentId: "Id",
            //         studentName: "Name",
            //         studentGrade: "Points Earned",
            //         pointpossible: "Point Possible",
            //         grade: "Grade",
            //         subject: "Subject",
            //         learningStandard: "Learning Standard",
            //         subLearningStandard: "Sub Learning Standard",
            //         scoringRubric: "Scoring Rubric"));
            // }
            print("printing length----------->${_list.length}");
            yield AssessmentDetailSuccess(obj: _list);
          } else {
            print("Assessment file URL not found1");
            //Return empty list
            yield AssessmentDetailSuccess(obj: _list);
          }
        } else {
          print("Assessment file URL not found2");
          //Return empty list
          yield AssessmentDetailSuccess(obj: _list);
        }
      } catch (e) {
        throw (e);
      }
    }

    if (event is ImageToAwsBucked) {
      try {
        String imgUrl =
            await _uploadImgB64AndGetUrl(event.imgBase64, event.imgExtension);
        //  int index = RubricScoreList.scoringList.length - 1;
        print(RubricScoreList.scoringList);
        imgUrl != ""
            ? RubricScoreList.scoringList.last.imgUrl = imgUrl
            : _uploadImgB64AndGetUrl(event.imgBase64, event.imgExtension);
        print(RubricScoreList.scoringList);
        print("printing imag url : $imgUrl");
      } catch (e) {
        print("image upload error");
      }
    }
  }

  Future<List<HistoryAssessment>> listSort(List<HistoryAssessment> list) async {
    list.forEach((element) {
      if (element.modifiedDate != null) {
        list.sort((a, b) => b.modifiedDate!.compareTo(a.modifiedDate!));
      }
    });
    return list;
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
          // '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files',
          'https://www.googleapis.com/drive/v2/files',
          headers: headers,
          body: body,
          isGoogleApi: true);

      if (response.statusCode == 200) {
        //  String id = response.data['id'];
        //   print("Folder created successfully : ${response.data['body']['id']}");
        return Globals.googleDriveFolderId = response.data
            // ['body']
            ['id'];
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

      final ResponseModel response = await _dbServices.getapiNew(
          'https://www.googleapis.com/drive/v3/files?fields=*',
          //     '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files?fields=*',
          headers: headers,
          isGoogleAPI: true);

      if (response.statusCode == 200) {
        var data = response.data
            //   ['body']
            ['files'];
        print(data);
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
        // '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files',
        'https://www.googleapis.com/drive/v3/files',
        body: body,
        headers: headers,
        isGoogleApi: true);

    if (response.statusCode == 200) {
      print("file created successfully : ${response.data['id']}");

      String fileId = response.data
          // ['body']
          ['id'];
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
    print(mimeType);
    print(id);
    print(accessToken);
    print(file.readAsBytesSync());
    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': '$mimeType'
    };

    final ResponseModel response = await _dbServices.patchapi(
      //'${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/upload/drive/v3/files/$id?uploadType=media',
      "https://www.googleapis.com/upload/drive/v3/files/$id?uploadType=media",
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

  Future _fetchHistoryAssessment(
    String? token,
    String? folderId,
  ) async {
    try {
      print(token);
      print(folderId);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      final ResponseModel response = await _dbServices.getapiNew(
          "https://www.googleapis.com/drive/v2/files?q='$folderId'+in+parents",
          headers: headers,
          isGoogleAPI: true);

      if (response.statusCode == 200) {
        print("assessment list is received ");
        print(response.data);
        List<HistoryAssessment> _list =
            response.data['items'] //response.data['body']['items']
                .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
                .toList();
        return _list;
      } else {
        print('Authentication required');
        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        bool result = await _toRefreshAuthenticationToken(
            _userprofilelocalData[0].refreshToken!);
        if (result) {
          GetHistoryAssessmentFromDrive();
        }
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
        // '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$folderId/permissions',
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
    final ResponseModel response = await _dbServices.getapiNew(
        'https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
        // '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
        headers: headers,
        isGoogleAPI: true);

    if (response.statusCode == 200) {
      print(" get file link   ----------->");
      var data = response.data;
      Globals.shareableLink = response.data
          //  ['body']
          ['webViewLink'];
      return true;
    }
    return false;
  }

  Future<String> _getAssessmentDetail(String? token, String? fileId) async {
    Map<String, String> headers = {
      'authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final ResponseModel response = await _dbServices.getapiNew(
        'https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
        //  '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
        headers: headers,
        isGoogleAPI: true);

    if (response.statusCode == 200) {
      var data = response.data;
      print('File URL Received :${data['webViewLink']}');
      String downloadLink = data['exportLinks'] != null
          ? data['exportLinks'][
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
          : '';
      //  data['webViewLink']!=null? data['webViewLink']:data['webContentLink'].length > 0
      //         ? data['webContentLink']['exportLinks'][
      //             'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
      //         : '';
      //  ['webViewLink']??response.data['webContentLink'];
      //['body'];

      // String downloadLink = data.length > 0
      //     ? data[0]['webContentLink']['exportLinks'][
      //         'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
      //     : '';

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
        print('File download success');
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
        return filePath;
      }
      print('Unable to download the file');
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
        String newToken = response.data['body']["access_token"];
        print("New access token received : $newToken");
        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();

        UserInformation updatedObj = UserInformation(
            userName: _userprofilelocalData[0].userName,
            userEmail: _userprofilelocalData[0].userEmail,
            profilePicture: _userprofilelocalData[0].profilePicture,
            refreshToken: _userprofilelocalData[0].refreshToken,
            authorizationToken: newToken);
        print("now updating the token on local db");
        // await UserGoogleProfile.updateUserProfileIntoDB(updatedObj);

        await UserGoogleProfile.updateUserProfile(updatedObj);

        //  await HiveDbServices().updateListData('user_profile', 0, updatedObj);

        print("token is updated ");
        return true;
      } else {
        return false;
        //  throw ('something_went_wrong');
      }
    } catch (e) {
      print(" errrrror  ");
      print(e);
      throw (e);
    }
  }

  Future<String> _uploadImgB64AndGetUrl(
      String? imgBase64, String? imgExtension) async {
    //  print(imgBase64);
    Map body = {
      "bucket": "graded/rubric-score",
      "fileExtension": imgExtension,
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
      print("url is not recived");
      return "";
    }
  }

  // Future updateLocalDb() async {
  //   //Save user profile to locally
  //   LocalDatabase<CustomRubicModal> _localDb = LocalDatabase('custom_rubic');

  //   await _localDb.clear();
  //   RubricScoreList.scoringList.forEach((CustomRubicModal e) {
  //     _localDb.addData(e);
  //   });
  //   print("rubic data is updated on local drive");
  // }
}
