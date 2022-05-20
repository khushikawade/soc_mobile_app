import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../services/Strings.dart';
import '../../../services/db_service.dart';
import '../../../services/local_database/hive_db_services.dart';
import 'package:path/path.dart';

import '../google_drive_access.dart';
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
    if (event is CreateFolderOnGoogleDriveEvent) {
      try {
        String parentId;

        parentId = await _getGoogleDriveFolderList(
            token: event.token, folderName: event.folderName);

        if (parentId == '') {
          parentId = await _createFolderOnDrive(
              token: event.token, folderName: event.folderName);
        }
        // File file = await GoogleDriveAccess.file();
        // if (parentId != "") {
        //   createSheetOnDrive(
        //       folderId: parentId, accessToken: event.token, image: file);
        // }
      } catch (e) {
        throw (e);
      }
    }

    if (event is CreateDoc) {
      try {
        GoogleDriveAccess.file();
      } catch (e) {
        print(e);
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
      // final response = await httpClient.post(
      //     Uri.parse('https://www.googleapis.com/drive/v2/files'),
      //     headers: headers,
      //     body: body);

      if (response.statusCode == 200) {
        //  String id = response.data['id'];
        return response.data['id'];
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
            return data[i]['id'];
          }
        }
      }
      return "";
    } catch (e) {
      throw (e);
    }
  }

  Future addIdtoDataBase(String log) async {
    await HiveDbServices().putData(Strings.googleDrive, log);
  }

  Future createSheetOnDrive(
      {File? image, String? folderId, String? accessToken}) async {
    Map body = {
      'name': 'test_sheet_A.xlsx',
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
      print(response.data['id']);
      String fileId = response.data['id'];
      await uploadSheetOnDrive(image, fileId, accessToken);
    }
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

  Future uploadSheetOnDrive(
      File? sheet, String? id, String? accessToken) async {
    // String accessToken = await Prefs.getToken();
    String? mimeType = mime(basename(sheet!.path).toLowerCase());

    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': '$mimeType'
    };

    final ResponseModel response = await _dbServices.patchapi(
      'https://www.googleapis.com/upload/drive/v3/files/$id?uploadType=media',
      headers: headers,
      body: sheet.readAsBytesSync(),
    );
    if (response.statusCode == 200) {
      print("heeeeeeeeeeeeeeeeeeeeeeelllllllllooooooooooo");
    }

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

  
}
