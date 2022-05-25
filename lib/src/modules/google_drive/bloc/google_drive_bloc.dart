import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/google_drive_access.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:mime_type/mime_type.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        Globals.authorizationToken = event.token;
        parentId = await _getGoogleDriveFolderList(
            token: event.token, folderName: event.folderName);

        if (parentId == '') {
          await _createFolderOnDrive(
              token: event.token, folderName: event.folderName);
          print("Folder created successfully");
        } else {
          print("token & id---------->");
          print(event.token);
          print(parentId);
          Globals.folderId = parentId;
        }
      } catch (e) {
        throw (e);
      }
    }

    if (event is CreateExcelSheetToDrive) {
      try {
        // Globals.studentInfo!.insert(
        //     0,
        //     StudentAssessmentInfo(
        //         studentId: "Id",
        //         studentName: "Name",
        //         studentGrade: "PointsEarned",
        //         pointpossible: "PointsEarned"));

        // File file = await GoogleDriveAccess.createSheet(
        //     data: Globals.studentInfo!, name: event.name!);
        // print(event.name!);

        bool result = await createSheetOnDrive(
          name: event.name!,
          folderId: Globals.folderId,
          accessToken: Globals.authorizationToken,
          //  image: file
        );
        if (!result) {
          print(
              "Failed to create. Trying to create the excel sheet again : ${event.name!}");
          await createSheetOnDrive(
            folderId: Globals.folderId,
            accessToken: Globals.authorizationToken,
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
                pointpossible: "PointsEarned"));
        print(assessmentData);

        File file = await GoogleDriveAccess.createSheet(
            data: assessmentData, name: Globals.assessmentName!);

        bool uploadresult = await uploadSheetOnDrive(
            file, Globals.fileId, Globals.authorizationToken);
        if (!uploadresult) {
          await uploadSheetOnDrive(
              file, Globals.fileId, Globals.authorizationToken);
        }
      } catch (e) {}
    }

    if (event is GetHistoryAssessmentFromDrive) {
      try {
        yield GoogleDriveLoading();
        List<Assessment> _list = await _fetchHistoryAssessment(
            Globals.authorizationToken, Globals.folderId);
        if (_list.length > 0) {
          yield GoogleDriveGetSuccess(obj: _list);
        } else {
          yield GoogleNoAssessment();
        }
      } catch (e) {
        print(e);
      }
    }
    if (event is GetAssessmentDetail) {
      try {
        print("inside get assessment token ${Globals.token}");
        print(event.fileId);
        _getAssessmentDetail(Globals.authorizationToken, event.fileId);
      } catch (e) {}
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
        print("folder--------- created");
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
            //   String id = data[i]['id'];
            //  await addIdtoDataBase(id);
            //  await _uplaodfile(token);
            print("foler is already exits");
            return data[i]['id'];
          }
        }
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
      print("file created ----------->");
      print(response.data['id']);
      String fileId = response.data['id'];
      Globals.fileId = fileId;
      bool result = await spreadsheetSharable(accessToken!, fileId);
      if (!result) {
        await spreadsheetSharable(accessToken, fileId);
      }

      // bool uploadresult = await uploadSheetOnDrive(image, fileId, accessToken);
      // if (!uploadresult) {
      //   await uploadSheetOnDrive(image, fileId, accessToken);
      // }
      bool link = await _getShareableLink(accessToken, fileId);
      if (!link) {
        await _getShareableLink(accessToken, fileId);
      }
      return true;
    }
    return false;
    // var res = await http.post(
    //   Uri.parse('https://www.googleapis.com/drive/v3/files'),
    //   headers: {
    //     'Authorization': 'Bearer $accessToken',
    //     'Content-Type': 'application/json; charset=UTF-8'
    //   },
    //   body: jsonEncode(body),
    // );
    // if (res.statusCode == 200) {
    //   // Extract the ID of the file we just created so we
    //   // can upload file data into it
    //   String fileId = jsonDecode(res.body)['id'];
    //   // Upload the content into the empty file
    //   await uploadImageToFile(image, fileId, accessToken);
    //   // Get file (downloadable) link and use it for anything
    //   //  String link = await getFileLink(fileId);
    //   // return link;
    // } else {
    //   Map json = jsonDecode(res.body);
    //   throw ('${json['error']['message']}');
    // }
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
      print("upload file done ----------->");
      return true;
    }
    return false;
    // var res = await http.patch(
    //   Uri.parse(
    //       'https://www.googleapis.com/upload/drive/v3/files/$id?uploadType=media'),
    //   body: image.readAsBytesSync(),
    //   headers: {
    //     'Authorization': 'Bearer $accessToken',
    //     'Content-Type': '$mimeType'
    //   },
    // );
    // if (res.statusCode == 200) {
    //   return res.body;
    // } else {
    //   Map json = jsonDecode(res.body);
    //   throw ('${json['error']['message']}');
    // }
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
        var data = response.data['items'];
        print(data);
        List<Assessment> _list = response.data['items']
            .map<Assessment>((i) => Assessment.fromJson(i))
            .toList();
        return _list;
      }
    } catch (e) {
      print(e);
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
      print(" file permission sharebale  ----------->");
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

  Future _getAssessmentDetail(String? token, String? fileId) async {
    print(token);
    print(fileId);
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
    }
  }
}
