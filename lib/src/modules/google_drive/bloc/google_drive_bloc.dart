import 'dart:convert';

import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as httpClient;

import '../../../services/db_service.dart';
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
    if (event is CreateGoogleDriveFolderEvent) {
      try {
        bool isFolderExist = await _getGoogleDriveFolderList(
            token: event.token, folderName: event.folderName);

        if (!isFolderExist) {
          _createFolderOnDrive(
              token: event.token, folderName: event.folderName);
        }
      } catch (e) {}
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
      String id;
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
            id = data[i]['id'];

            return true;
          }
        }
      }
      return false;
    } catch (e) {
      throw (e);
    }
  }
}
