import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/google_drive_access.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:flutter/foundation.dart';
import 'package:mime_type/mime_type.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../services/db_service.dart';
import 'package:path/path.dart';
import '../../ocr/modal/student_assessment_info_modal.dart';
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
        String parentId;
        // Globals.authorizationToken = event.token;
        parentId = await _getGoogleDriveFolderList(
            token: event.token, folderName: event.folderName);
        print('FolderId = $parentId');

        if (parentId != '401') {
          if (parentId == '') {
            await _createFolderOnDrive(
                token: event.token, folderName: event.folderName);
            print("Folder created successfully");
          } else {
            print("Folder Id received");
            Globals.folderId = parentId;
            if (event.fetchHistory == true) {
              //Fetch history assessment
              GetHistoryAssessmentFromDrive();
            }
          }
        } else {
          print('Authentication required');
        }
      } catch (e) {
        throw (e);
      }
    }

    if (event is CreateExcelSheetToDrive) {
      try {
        Globals.assessmentName = event.name;
        bool result = await createSheetOnDrive(
            name: event.name!,
            folderId: Globals.folderId,
            accessToken: Globals.userprofilelocalData[0].authorizationToken
            //  image: file
            );
        if (!result) {
          print(
              "Failed to create. Trying to create the excel sheet again : ${event.name!}");
          await createSheetOnDrive(
              folderId: Globals.folderId,
              accessToken: Globals.userprofilelocalData[0].authorizationToken
              // image: file
              );
        } else {
          print("Excel sheet created successfully : ${event.name!}");
        }
      } catch (e) {
        print(e);
      }
    }

    if (event is UpdateDocOnDrive) {
      try {
        List<StudentAssessmentInfo>? assessmentData = event.studentData;
        assessmentData!.insert(
            0,
            StudentAssessmentInfo(
                studentId: "Id",
                studentName: "Name",
                studentGrade: "PointsEarned",
                pointpossible: "pointPossible"));
        print(assessmentData);

        File file = await GoogleDriveAccess.createSheet(
            data: assessmentData, name: Globals.assessmentName!);

        bool uploadresult = await uploadSheetOnDrive(
            file, Globals.fileId, Globals.authorizationToken);
        if (!uploadresult) {
          await uploadSheetOnDrive(
              file, Globals.fileId, Globals.authorizationToken);
        }
        bool deleted = await GoogleDriveAccess.deleteFile(file);
        if (!deleted) {
          GoogleDriveAccess.deleteFile(file);
        }
      } catch (e) {}
    }

    if (event is GetHistoryAssessmentFromDrive) {
      try {
        yield GoogleDriveLoading();
        List<HistoryAssessment> assessmentList = [];
        if (Globals.folderId != null) {
          List<HistoryAssessment> _list = await _fetchHistoryAssessment(
              Globals.userprofilelocalData[0].authorizationToken,
              Globals.folderId);
          if (_list.length > 0) {
            // for (int i = 0; i < data.length; i++) {
            _list.forEach((element) {
              print(element.label['trashed']);
              if (element.label['trashed'] != true) {
                assessmentList.add(element);
              }
            });

            yield GoogleDriveGetSuccess(obj: assessmentList);
          } else {
            yield GoogleNoAssessment();
          }
        } else {
          GetDriveFolderIdEvent(
              //  filePath: file,
              token: Globals.userprofilelocalData[0].authorizationToken,
              folderName: "Assessments",
              fetchHistory: true);
        }
      } catch (e) {
        print(e);
      }
    }
    if (event is GetAssessmentDetail) {
      try {
        String link = await _getAssessmentDetail(
            Globals.userprofilelocalData[0].authorizationToken, event.fileId);

        if (link != "") {
          String file = await downloadFile(
              link, "test3", (await getExternalStorageDirectory())!.path);

          if (file != "") {
            List<StudentAssessmentInfo> _list =
                await GoogleDriveAccess.excelToJson(file);

            bool deleted = await GoogleDriveAccess.deleteFile(File(file));
            if (!deleted) {
              GoogleDriveAccess.deleteFile(File(file));
            }
            if (_list.length > 0) {
              yield AssessmentDetailSuccess(obj: _list);
            } else {
              yield GoogleNoAssessment();
            }
          }
        }
      } catch (e) {
        throw (e);
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
        return Globals.folderId = response.data['id'];
      }
      return "";
    } catch (e) {
      throw (e);
    }
  }

  Future<String> _getGoogleDriveFolderList(
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
            print("foler is already exits : ${data[i]['id']}");
            return data[i]['id'];
          }
        }
      } else if (response.statusCode == 401) {
        print("Invalid credentials");
        return response.statusCode.toString();
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
      bool result = await spreadsheetSharable(accessToken!, fileId);
      if (!result) {
        await spreadsheetSharable(accessToken, fileId);
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
        List<HistoryAssessment> _list = response.data['items']
            .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
            .toList();
        return _list;
      }
    } catch (e) {
      throw (e);
    }
  }

  spreadsheetSharable(String token, String folderId) async {
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
      throw (e);
    }
  }
}
