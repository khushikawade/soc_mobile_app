import 'dart:convert';

import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as httpClient;
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import '../../../services/Strings.dart';
import '../../../services/db_service.dart';
import '../../../services/local_database/hive_db_services.dart';
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
        bool isFolderExist = await _getGoogleDriveFolderList(
            token: event.token, folderName: event.folderName);

        if (!isFolderExist) {
          _createFolderOnDrive(
              token: event.token, folderName: event.folderName);
        }else{
         // _uploadFileToGoogleDrive();
        }
      } catch (e) {
        throw (e);
      }
    }
  }

  Future<void> _createFolderOnDrive(
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
        print("Folder is Created");
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> _getGoogleDriveFolderList(
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
            String id = data[i]['id'];
            await addIdtoDataBase(id);
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      throw (e);
    }
  }

  Future addIdtoDataBase(String log) async {
    await HiveDbServices().putData(Strings.googleDrive, log);
  }

// _uploadFileToGoogleDrive() async {  
//    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);  
//   // var drive = ga.DriveApi(client);  
//   //  ga.File fileToUpload = ga.File();  
//   //  var file = await FilePicker.getFile();  
//   //  fileToUpload.parents = ["appDataFolder"];  
//   //  fileToUpload.name = path.basename(file.absolute.path);  
//   //  var response = await drive.files.create(  
//   //    fileToUpload,  
//   //    uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
//   //  );  
//   // print(response);  
//  } 
}


// class GoogleHttpClient extends IOClient {
//   Map<String, String> _headers;

//   GoogleHttpClient(this._headers) : super();

//   @override
//   Future<StreamedResponse> send(BaseRequest request) =>
//       super.send(request..headers.addAll(_headers));

//   @override
//   Future<Response> head(Object url, {Map<String, String> headers}) =>
//       super.head(url, headers: headers..addAll(_headers));

// }