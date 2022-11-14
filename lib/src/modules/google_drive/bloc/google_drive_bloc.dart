import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/google_drive_access.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/google_drive/model/assessment_detail_modal.dart';
import 'package:Soc/src/modules/google_drive/model/spreadsheet_model.dart';
import 'package:Soc/src/modules/google_drive/overrides.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime_type/mime_type.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../services/db_service.dart';
import 'package:path/path.dart';
import '../../ocr/modal/custom_rubic_modal.dart';
import '../../ocr/modal/student_assessment_info_modal.dart';
import 'package:dio/dio.dart';
import '../model/user_profile.dart';
part 'google_drive_event.dart';
part 'google_drive_state.dart';

class GoogleDriveBloc extends Bloc<GoogleDriveEvent, GoogleDriveState> {
  GoogleDriveBloc() : super(GoogleDriveInitial());
  final DbServices _dbServices = DbServices();
  Dio dio = Dio();
  // final HiveDbServices _localDbService = HiveDbServices();
  GoogleDriveState get initialState => GoogleDriveInitial();
  int _totalRetry = 0;
  // String nextUrlLink = '';
  // String nextPageToken = '';

  @override
  Stream<GoogleDriveState> mapEventToState(
    GoogleDriveEvent event,
  ) async* {
    if (event is GetDriveFolderIdEvent) {
      try {
        var folderObject;
        // Globals.authorizationToken = event.token;

        if (event.isFromOcrHome!) {
          yield GoogleDriveLoading();
        }
        folderObject = await _getGoogleDriveFolderId(
            token: event.token, folderName: event.folderName);

        if (folderObject != 401 && folderObject != 500) {
          if (folderObject.length == 0) {
            await _createFolderOnDrive(
                token: event.token, folderName: event.folderName);

            if (event.isFromOcrHome! &&
                Globals.googleDriveFolderId!.isNotEmpty) {
              yield GoogleSuccess(assessmentSection: event.assessmentSection);
            }
          } else {
            Globals.googleDriveFolderId = folderObject['id'];
            Globals.googleDriveFolderPath = folderObject['webViewLink'];
            // Globals.
            if (event.isFromOcrHome! &&
                Globals.googleDriveFolderId!.isNotEmpty) {
              yield GoogleSuccess(assessmentSection: event.assessmentSection);
            }
            if (event.fetchHistory == true) {
              GetHistoryAssessmentFromDrive();
            }
          }
        } else {
          var result = await _toRefreshAuthenticationToken(event.refreshtoken!);

          if (result == true) {
            List<UserInformation> _userprofilelocalData =
                await UserGoogleProfile.getUserProfile();

            GetDriveFolderIdEvent(
                isFromOcrHome: true,
                //  filePath: file,
                token: _userprofilelocalData[0].authorizationToken,
                folderName: event.folderName,
                refreshtoken: _userprofilelocalData[0].refreshToken);
            yield GoogleSuccess(assessmentSection: event.assessmentSection);
          } else {
            // Utility.currentScreenSnackBar('Reauthentication is required');
            yield ErrorState(
                errorMsg: 'Reauthentication is required',
                isAssessmentSection: event.assessmentSection);
          }
        }

        if (Globals.googleDriveFolderId != "") {
          yield GoogleFolderCreated();
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        yield ErrorState();

        rethrow;
      } catch (e) {
        if (e == 'NO_CONNECTION') {
          Utility.currentScreenSnackBar("No Internet Connection", null);
        } else {
          yield ErrorState();
        }
        throw (e);
      }
    }

    if (event is CreateExcelSheetToDrive) {
      try {
        yield GoogleDriveLoading();

        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        Globals.assessmentName = event.name;

        String result = await createSheetOnDrive(
          name: event.name!,
          folderId: Globals.googleDriveFolderId,
          accessToken: _userprofilelocalData[0].authorizationToken,
          refreshToken: _userprofilelocalData[0].refreshToken,

          //  image: file
        );
        if (result == '') {
          CreateExcelSheetToDrive(name: event.name);
        } else if (result == 'Reauthentication is required') {
          yield ErrorState(errorMsg: 'Reauthentication is required');
        } else {
          yield ExcelSheetCreated(obj: result);
        }
      } on SocketException catch (e) {
        yield ErrorState(errorMsg: e.toString());
        rethrow;
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
        throw (e);
      }
    }

    if (event is UpdateDocOnDrive) {
      try {
        if (event.isLoading) {
          yield GoogleDriveLoading();
        }

        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        LocalDatabase<CustomRubicModal> customRubicLocalDb =
            LocalDatabase('custom_rubic');
        List<CustomRubicModal>? customRubicLocalData =
            await customRubicLocalDb.getData();

        List<StudentAssessmentInfo>? assessmentData = event.studentData;

        checkForGoogleExcelId(); //To check for excel sheet id
        if (assessmentData!.length > 0 && assessmentData[0].studentId == 'Id') {
          assessmentData.removeAt(0);
        }

        for (int i = 0; i < assessmentData.length; i++) {
          // Checking for 'Assessment Sheets Image' to get URL for specific index if not exist
          if (assessmentData[i].assessmentImage == null ||
              assessmentData[i].assessmentImage == '') {
            String imgExtension = assessmentData[i]
                .assessmentImgPath!
                .substring(
                    assessmentData[i].assessmentImgPath!.lastIndexOf(".") + 1);
            File assessmentImageFile =
                File(assessmentData[i].assessmentImgPath!);
            List<int> imageBytes = assessmentImageFile.readAsBytesSync();
            String imageB64 = base64Encode(imageBytes);

            String imgUrl = await _uploadImgB64AndGetUrl(
                imgBase64: imageB64,
                imgExtension: imgExtension,
                section: "assessment-sheet");

            imgUrl != ""
                ? assessmentData[i].assessmentImage = imgUrl
                : print("error");
          }
          // Checking for 'Custom rubric score Image' to get URL for specific index if not exist

          if (event.isCustomRubricSelcted == true &&
              (assessmentData[i].customRubricImage == null ||
                  assessmentData[i].customRubricImage!.isEmpty) &&
              event.selectedRubric != 0 &&
              customRubicLocalData[event.selectedRubric!].filePath != null &&
              customRubicLocalData[event.selectedRubric!]
                  .filePath!
                  .isNotEmpty) {
            if (customRubicLocalData[event.selectedRubric!].imgUrl != null ||
                customRubicLocalData[event.selectedRubric!]
                    .imgUrl!
                    .isNotEmpty) {
              assessmentData.forEach((element) {
                element.customRubricImage =
                    customRubicLocalData[event.selectedRubric!].imgUrl;
              });
            } else {
              File assessmentImageFile =
                  File(customRubicLocalData[event.selectedRubric!].filePath!);
              String imgExtension = assessmentImageFile.path
                  .substring(assessmentImageFile.path.lastIndexOf(".") + 1);

              String imgUrl = await _uploadImgB64AndGetUrl(
                  imgBase64:
                      customRubicLocalData[event.selectedRubric!].imgBase64,
                  imgExtension: imgExtension,
                  section: 'rubric-score');
              if (imgUrl != '') {
                assessmentData.forEach((element) {
                  element.customRubricImage = imgUrl;
                });
              }
            }
          }

          // Assessment Question Image
          if (Globals.questionImgFilePath != null &&
              Globals.questionImgFilePath!.path.isNotEmpty &&
              (assessmentData[i].questionImgUrl == null ||
                  assessmentData[i].questionImgUrl == '')) {
            if (event.questionImage != '' || event.questionImage.isEmpty) {
              assessmentData.forEach((element) {
                element.questionImgUrl = event.questionImage;
              });
            }
            //  else {
            //   String imgExtension = Globals.questionImgFilePath!.path.substring(
            //       Globals.questionImgFilePath!.path.lastIndexOf(".") + 1);

            //   List<int> imageBytes =
            //       Globals.questionImgFilePath!.readAsBytesSync();

            //   String imageB64 = base64Encode(imageBytes);

            //   Globals.questionImgUrl = await _uploadImgB64AndGetUrl(
            //       imgBase64: imageB64,
            //       imgExtension: imgExtension,
            //       section: 'rubric-score');

            //   Globals.questionImgUrl!.isNotEmpty
            //       ? assessmentData.forEach((element) {
            //           element.questionImgUrl = Globals.questionImgUrl;
            //         })
            //       : //print("image erooooooooooooooooo");
            // }
          }
        }

        assessmentData.insert(
            0,
            StudentAssessmentInfo(
              studentId:
                  Overrides.STANDALONE_GRADED_APP == true ? "Email Id" : "Id",
              studentName: "Name",
              studentGrade: "Points Earned",
              pointpossible: "Point Possible",
              questionImgUrl: Overrides.STANDALONE_GRADED_APP == true
                  ? "Assessment Image"
                  : "Assessment Question Img",
              grade: "Grade",
              className: "Class Name",
              subject: "Subject",
              learningStandard: "Learning Standard",
              subLearningStandard: "NY Next Generation Learning Standard",
              scoringRubric: "Scoring Rubric",
              customRubricImage: "Custom Rubric Image",
              assessmentImage: Overrides.STANDALONE_GRADED_APP == true
                  ? "Student Work Image"
                  : "Assessment Image",
            ));

//Generating excel file locally with all the result data
        File file = await GoogleDriveAccess.generateExcelSheetLocally(
            data: assessmentData,
            name: event.assessmentName!,
            createdAsPremium: event.createdAsPremium);

//Update the created excel file to drive with all the result data
        String excelSheetId = await uploadSheetOnDrive(
            file,
            event.fileId == null ? Globals.googleExcelSheetId : event.fileId,
            _userprofilelocalData[0].authorizationToken,
            _userprofilelocalData[0].refreshToken);

        if (excelSheetId.isEmpty) {
          // await _toRefreshAuthenticationToken(
          //     _userprofilelocalData[0].refreshToken!);

          String excelSheetId = await uploadSheetOnDrive(
              file,
              Globals.googleExcelSheetId,
              _userprofilelocalData[0].authorizationToken,
              _userprofilelocalData[0].refreshToken);
          // function to update property of excel sheet

          _updateFieldExcelSheet(
              assessmentData: assessmentData,
              excelId: excelSheetId,
              token: _userprofilelocalData[0].authorizationToken!);
        } else if (excelSheetId == 'Reauthentication is required') {
          yield ErrorState(errorMsg: 'Reauthentication is required');
        } else {
          // function to update property of excel sheet

          _updateFieldExcelSheet(
              assessmentData: assessmentData,
              excelId: excelSheetId,
              token: _userprofilelocalData[0].authorizationToken!);

          if (event.isLoading) {
            yield GoogleSuccess();
          }
        }
        bool deleted = await GoogleDriveAccess.deleteFile(file);
        if (!deleted) {
          GoogleDriveAccess.deleteFile(file);
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        throw (e);
      }
    }

    if (event is GetHistoryAssessmentFromDrive) {
      try {
        LocalDatabase<HistoryAssessment> _localDb =
            LocalDatabase("HistoryAssessment");
        // await _localDb.clear();
        List<HistoryAssessment>? _localData = await _localDb.getData();
        //Sort the list as per the modified date
        _localData = await listSort(_localData);

        if (_localData.isNotEmpty &&
            (event.searchKeywork == "" || event.searchKeywork == null)) {
          yield GoogleDriveGetSuccess(obj: _localData);
        } else {
          yield GoogleDriveLoading();
        }

        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        List<HistoryAssessment> assessmentList = [];

        if (Globals.googleDriveFolderId != null) {
          List pair = await _fetchHistoryAssessment(
              token: _userprofilelocalData[0].authorizationToken,
              isPagination: false,
              folderId: Globals.googleDriveFolderId,
              searchKey: event.searchKeywork ?? "");
          List<HistoryAssessment>? _list =
              pair != null && pair.length > 0 ? pair[0] : [];

          if (_list == null) {
            yield ErrorState(errorMsg: 'Reauthentication is required');
          } else {
            _list.forEach((element) {
              if (element.label['trashed'] != true &&
                  (element.description == "Graded+" ||
                      element.description ==
                          'Assessment \'${element.title}\' result has been generated.')) {
                assessmentList.add(element);
              }
            });

            //Sort the list as per the modified date
            assessmentList = await listSort(assessmentList);

            assessmentList != null && assessmentList.length > 0
                ? await _localDb.clear()
                : print("");

            assessmentList.forEach((HistoryAssessment e) {
              _localDb.addData(e);
            });

            yield GoogleDriveGetSuccess(
                obj: assessmentList,
                nextPageLink: pair != null && pair.length > 1 ? pair[1] : '');
          }
        } else {
          GetDriveFolderIdEvent(
              isFromOcrHome: false,
              //  filePath: file,
              token: _userprofilelocalData[0].authorizationToken,
              folderName: "SOLVED GRADED+",
              fetchHistory: true);
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : throw (e);
      }
    }

    if (event is UpdateHistoryAssessmentFromDrive) {
      try {
        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        List<HistoryAssessment> assessmentList = [];

        if (Globals.googleDriveFolderId != null) {
          List pair = await _fetchHistoryAssessment(
              token: _userprofilelocalData[0].authorizationToken,
              folderId: Globals.googleDriveFolderId,
              isPagination: true,
              nextPageUrl: event.nextPageUrl,
              searchKey: "");
          List<HistoryAssessment>? _list =
              pair != null && pair.length > 0 ? pair[0] : [];
          if (_list == null) {
            yield ErrorState(errorMsg: 'Reauthentication is required');
          } else {
            _list.forEach((element) {
              if (element.label['trashed'] != true) {
                assessmentList.add(element);
              }
            });

            //Sort the list as per the modified date
            assessmentList = await listSort(assessmentList);
            List<HistoryAssessment> updatedAssessmentList = event.obj;
            updatedAssessmentList.addAll(assessmentList);
            yield ShareLinkRecived(shareLink: '');
            yield GoogleDriveGetSuccess(
                obj: updatedAssessmentList,
                nextPageLink: pair != null && pair.length > 1 ? pair[1] : '');
          }
        } else {
          GetDriveFolderIdEvent(
              isFromOcrHome: false,
              //  filePath: file,
              token: _userprofilelocalData[0].authorizationToken,
              folderName: "SOLVED GRADED+",
              fetchHistory: true);
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e) {}
    }

    if (event is GetAssessmentDetail) {
      try {
        yield GoogleDriveLoading2();
        List<StudentAssessmentInfo> summaryList = [];
        List<UserInformation> _userprofilelocalData =
            await UserGoogleProfile.getUserProfile();
        var fildObject;
        fildObject = await _getAssessmentDetail(
            _userprofilelocalData[0].authorizationToken,
            event.fileId,
            _userprofilelocalData[0].refreshToken);

        if (fildObject != '' &&
            fildObject != null &&
            fildObject != 'Reauthentication is required' &&
            fildObject['exportLinks'] != null) {
          String savePath = await getFilePath(event.fileId);
          summaryList = await processCSVFile(
              fildObject['exportLinks']['text/csv'],
              _userprofilelocalData[0].authorizationToken,
              _userprofilelocalData[0].refreshToken,
              savePath);

          if (summaryList != []) {
            bool deleted = await GoogleDriveAccess.deleteFile(File(savePath));
            if (!deleted) {
              GoogleDriveAccess.deleteFile(File(savePath));
            }

            yield AssessmentDetailSuccess(
                obj: summaryList, webContentLink: fildObject['webViewLink']);
          } else {
            //Return empty list
            yield AssessmentDetailSuccess(
                obj: [], webContentLink: fildObject['webViewLink']);
          }
        } else if (fildObject == 'Reauthentication is required') {
          yield ErrorState(errorMsg: 'Reauthentication is required');
        } else {
          //Return empty list
          yield AssessmentDetailSuccess(
              obj: summaryList,
              webContentLink: fildObject != null && fildObject != ''
                  ? fildObject['webViewLink']
                  : '');
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e) {
        if (e == 'NO_CONNECTION') {
          Utility.currentScreenSnackBar("No Internet Connection", null);
        } else {
          yield AssessmentDetailSuccess(obj: [], webContentLink: null);
        }
        print(e);
        // throw (e);
      }
    }

    if (event is ImageToAwsBucked) {
      try {
        String imgUrl = await _uploadImgB64AndGetUrl(
            imgBase64: event.imgBase64,
            imgExtension: event.imgExtension,
            section: 'rubric-score');

        imgUrl != ""
            ? RubricScoreList.scoringList.last.imgUrl = imgUrl
            : _uploadImgB64AndGetUrl(
                imgBase64: event.imgBase64,
                imgExtension: event.imgExtension,
                section: 'rubric-score');
      } catch (e) {
        throw e;
      }
    }
    if (event is AssessmentImgToAwsBucked) {
      try {
        String imgUrl = await _uploadImgB64AndGetUrl(
            imgBase64: event.imgBase64,
            imgExtension: event.imgExtension,
            section: "assessment-sheet");

        if (imgUrl != "") {
          LocalDatabase<StudentAssessmentInfo> _studentInfoDb = LocalDatabase(
              event.isHistoryAssessmentSection == true
                  ? 'history_student_info'
                  : 'student_info');

          List<StudentAssessmentInfo> studentInfo =
              await Utility.getStudentInfoList(
                  tableName: event.isHistoryAssessmentSection == true
                      ? 'history_student_info'
                      : 'student_info');

          for (int i = 0; i < studentInfo.length; i++) {
            if (studentInfo[i].studentId == event.studentId) {
              StudentAssessmentInfo e = studentInfo[i];
              e.assessmentImage = imgUrl;

              await _studentInfoDb.putAt(i, e);
            }
          }
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        throw (e);
      }
    }
    if (event is QuestionImgToAwsBucked) {
      try {
        yield GoogleDriveLoading();

        String questionImgUrl = await _uploadImgB64AndGetUrl(
            imgBase64: event.imgBase64,
            imgExtension: event.imgExtension,
            section: 'rubric-score');

        yield QuestionImageSuccess(questionImageUrl: questionImgUrl);
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        throw (e);
      }
    }
    if (event is GetShareLink) {
      List<UserInformation> _userprofilelocalData =
          await UserGoogleProfile.getUserProfile();

      String link = await _getShareableLink(
          fileId: event.fileId ?? '',
          refreshToken: _userprofilelocalData[0].refreshToken,
          token: _userprofilelocalData[0].authorizationToken!);

      if (link != '' && link != 'Reauthentication is required') {
        Globals.shareableLink = link;
        yield ShareLinkRecived(shareLink: link);
      } else if (link == 'Reauthentication is required') {
        yield ErrorState(errorMsg: 'Reauthentication is required');
      }
    }

    if (event is GetAssessmentSearchDetails) {
      yield GoogleDriveLoading();
      LocalDatabase<HistoryAssessment> _localDb =
          LocalDatabase("HistoryAssessment");

      List<HistoryAssessment>? _localData = await _localDb.getData();
      //Sort the list as per the modified date
      if (_localData.isNotEmpty) {
        _localData = await listSort(_localData);
        List<HistoryAssessment> searchList = List.from(_localData.where((e) =>
            e.title!.toLowerCase().contains(event.keyword!.toLowerCase())));

        yield GoogleDriveGetSuccess(obj: searchList);
      } else {
        yield GoogleDriveGetSuccess(obj: []);
      }
    }
  }

  void errorThrow(msg) {
    BuildContext? context = Globals.navigatorKey.currentContext;
    Utility.currentScreenSnackBar(msg, null);
    Navigator.pop(context!);
  }

  void checkForGoogleExcelId() async {
    try {
      if (Globals.googleExcelSheetId!.isEmpty) {
        await Future.delayed(Duration(milliseconds: 200));

        checkForGoogleExcelId();
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<HistoryAssessment>> listSort(List<HistoryAssessment> list) async {
    try {
      list.forEach((element) {
        if (element.modifiedDate != null) {
          list.sort((a, b) => b.modifiedDate!.compareTo(a.modifiedDate!));
        }
      });
      return list;
    } catch (e) {
      throw (e);
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
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files',
          //'https://www.googleapis.com/drive/v2/files',
          headers: headers,
          body: body,
          isGoogleApi: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        //  String id = response.data['id'];

        return Globals.googleDriveFolderId = response.data['body']['id'];
      }
      return "";
    } catch (e) {
      throw (e);
    }
  }

  Future _getGoogleDriveFolderId(
      {required String? token, required String? folderName}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      String query =
          '(trashed = false and mimeType = \'application/vnd.google-apps.folder\' and name = \'SOLVED GRADED%2B\')';

      final ResponseModel response = await _dbServices.getApiNew(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}' +
              'https://www.googleapis.com/drive/v3/files?fields=%2A%26q=' +
              Uri.encodeFull(query),
          headers: headers,
          isCompleteUrl: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        var data = response.data['body']['files'];

        if (data.length == 0) {
          return data;
        } else {
          return data[0];
        }
      } else if (response.statusCode == 401 ||
          response.data['statusCode'] == 500) {
        return response.statusCode == 401 ? response.statusCode : 500;
      }
      return "";
    } catch (e) {
      throw (e);
    }
  }

  Future<String> createSheetOnDrive(
      {String? name,
      //  File? image,
      String? folderId,
      String? accessToken,
      String? refreshToken}) async {
    try {
      Map body = {
        'name': name,
        // 'description': 'Assessment \'$name\' result has been generated.',
        'description': 'Graded+',
        'mimeType': 'application/vnd.google-apps.spreadsheet',
        'parents': ['$folderId']
      };
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8'
      };

      final ResponseModel response = await _dbServices.postapi(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files',
          //  'https://www.googleapis.com/drive/v3/files',
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        String fileId = response.data['body']['id'];
        Globals.googleExcelSheetId = fileId;

        return 'Done';
      } else if ((response.statusCode == 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        _totalRetry++;
        //To regernerate fresh access token
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userprofilelocalData =
              await UserGoogleProfile.getUserProfile();

          String result = await createSheetOnDrive(
            name: name!,
            folderId: folderId,
            accessToken: _userprofilelocalData[0].authorizationToken,
            refreshToken: _userprofilelocalData[0].refreshToken,

            //  image: file
          );
          return result;
        } else {
          return 'Reauthentication is required';
        }
      }
      return '';
    } catch (e) {
      throw (e);
    }
  }

  Future<String> uploadSheetOnDrive(
      File? file, String? id, String? accessToken, String? refreshToken) async {
    try {
      // String accessToken = await Prefs.getToken();
      String? mimeType = mime(basename(file!.path).toLowerCase());

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': '$mimeType'
      };

      final ResponseModel response = await _dbServices.patchapi(
        '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/upload/drive/v3/files/$id?uploadType=media',
        //  "https://www.googleapis.com/upload/drive/v3/files/$id?uploadType=media",
        headers: headers,
        body: file.readAsBytesSync(),
      );
      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        return response.data['body']['id'];
      } else if ((response.statusCode == 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        _totalRetry++;

        var result = await _toRefreshAuthenticationToken(refreshToken!);

        if (result == true) {
          List<UserInformation> _userprofilelocalData =
              await UserGoogleProfile.getUserProfile();

          String uploadresult = await uploadSheetOnDrive(
              file,
              id,
              _userprofilelocalData[0].authorizationToken,
              _userprofilelocalData[0].refreshToken);
          return uploadresult;
        } else {
          return 'Reauthentication is required';
        }
      }
      return '';
    } catch (e) {
      throw (e);
    }
  }

  //To get sheet gridId From excel sheet id
  Future<int> _getSheetid({
    required String token,
    required String excelId,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      final ResponseModel response = await _dbServices.getApiNew(
          "https://sheets.googleapis.com/v4/spreadsheets/$excelId",
          headers: headers,
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        return response.data["sheets"][0]['properties']['sheetId'];
      }
      return 1;
    } catch (e) {
      return 0;
    }
  }

  // function to update property of excel sheet
  Future<void> _updateFieldExcelSheet(
      {required String token,
      required String excelId,
      //required int sheetID,
      required List<StudentAssessmentInfo> assessmentData}) async {
    try {
      //To get sheetId From excel sheet id
      int sheetID = await _getSheetid(excelId: excelId, token: token);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      List data = [];
      //To make title bold in the excel sheet
      data.add(_updateFieldExcelSheetRequestBody(
          isHyperLink: false,
          startRowIndex: 0,
          endRowIndex: 1,
          startColumnIndex: 0,
          endColumnIndex: 26,
          sheetId: sheetID));

      // To make assessment question image url hyperlinked //Same for all students
      if (assessmentData[1].questionImgUrl != 'NA') {
        data.add(_updateFieldExcelSheetRequestBody(
            isHyperLink: true,
            startRowIndex: 1,
            endRowIndex: assessmentData.length,
            startColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? 3
                : 4,
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? 4
                : 5,
            sheetId: sheetID,
            imageLink: assessmentData[1].questionImgUrl));
      }

      // To make custom rubric image url hyperlinked //Same for all students
      if (assessmentData[1].customRubricImage != 'NA') {
        data.add(_updateFieldExcelSheetRequestBody(
            isHyperLink: true,
            startRowIndex: 1,
            endRowIndex: assessmentData.length,
            startColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? 10
                : 11,
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? 11
                : 12,
            sheetId: sheetID,
            imageLink: assessmentData[1].customRubricImage));
      }

      // To make student assesment sheet image url hyperlinked  //Used loop to manage multiple student sheets
      for (int i = 1; i < assessmentData.length; i++) {
        data.add(_updateFieldExcelSheetRequestBody(
            isHyperLink: true,
            startRowIndex: i,
            endRowIndex: i + 1,
            startColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? 11
                : 12,
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? 12
                : 13,
            sheetId: sheetID,
            imageLink: assessmentData[i].assessmentImage));
      }

      Map<String, dynamic> body = {
        "requests": data,
        "includeSpreadsheetInResponse": true,
        "responseIncludeGridData": true
      };
      if (sheetID != 1 && sheetID != 0) {
        final ResponseModel response = await _dbServices.postapi(
            "https://sheets.googleapis.com/v4/spreadsheets/$excelId:batchUpdate",
            headers: headers,
            isGoogleApi: true,
            body: body);
        if (response.statusCode == '200') {}
      } else {
        print('Excel file grid if not found');
      }
    } catch (e) {
      print(e);
    }
  }

  Object _updateFieldExcelSheetRequestBody(
      {required bool isHyperLink,
      required int sheetId,
      required int startRowIndex,
      required int endRowIndex,
      required int startColumnIndex,
      required int endColumnIndex,
      String? imageLink}) {
    var updateDetail = {
      "repeatCell": {
        "range": {
          "sheetId": sheetId,
          "startRowIndex": startRowIndex,
          "endRowIndex": endRowIndex,
          "startColumnIndex": startColumnIndex,
          "endColumnIndex": endColumnIndex
        },
        "cell": isHyperLink
            ? {
                "userEnteredValue": {
                  "formulaValue": "=HYPERLINK(\"$imageLink\",\"$imageLink\")"
                }
              }
            : {
                "userEnteredFormat": {
                  "horizontalAlignment": "LEFT",
                  "textFormat": {"fontSize": 11, "bold": true}
                }
              },
        "fields": isHyperLink
            ? "*"
            : "userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"
      }
    };
    return updateDetail;
  }

  Future _fetchHistoryAssessment(
      {String? token,
      String? folderId,
      bool? isPagination,
      String? nextPageUrl,
      String? searchKey}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      String query =
          '(mimeType = \'application/vnd.google-apps.spreadsheet\' and \'$folderId\'+in+parents and title contains \'${searchKey}\')';
      final ResponseModel response = await _dbServices.getApiNew(
          isPagination == true
              ? "$nextPageUrl"
              : searchKey == ""
                  ? "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files?q='$folderId'+in+parents" //List Call
                  : "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files?q=" +
                      Uri.encodeFull(query), //Search call

          headers: headers,
          isCompleteUrl: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        String updatedNextUrlLink = '';
        try {
          updatedNextUrlLink = isPagination == true
              ? response.data["nextLink"]
              : response.data['body']["nextLink"];
        } catch (e) {
          updatedNextUrlLink = '';
        }

        List<HistoryAssessment> _list = isPagination == true
            ? response.data['items']
                .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
                .toList()
            : response.data['body']['items']
                .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
                .toList();

        List<AssessmentDetails> assessmentList = await getAssessmentList();
        for (int i = 0; i < _list.length; i++) {
          for (int j = 0; j < assessmentList.length; j++) {
            if (_list[i].fileid == assessmentList[j].googleFileId &&
                assessmentList[j].googleFileId != '') {
              _list[i].sessionId = assessmentList[j].sessionId;
              _list[i].isCreatedAsPremium = assessmentList[j].createdAsPremium;
            }
          }
        }
        return _list == null ? [] : [_list, updatedNextUrlLink];
      } else if ((response.statusCode == 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        _totalRetry++;

        List<UserInformation> userprofilelocalData =
            await UserGoogleProfile.getUserProfile();

        var result = await _toRefreshAuthenticationToken(
            userprofilelocalData[0].refreshToken!);
        if (result == true) {
          List<UserInformation> _userprofilelocalData =
              await UserGoogleProfile.getUserProfile();

          List pair = await _fetchHistoryAssessment(
              token: _userprofilelocalData[0].authorizationToken,
              folderId: Globals.googleDriveFolderId,
              isPagination: isPagination,
              nextPageUrl: nextPageUrl,
              searchKey: searchKey ?? "");

          return pair;
        } else {
          return null;
        }
      } else {
        List<HistoryAssessment> _list = [];
        return _list;
      }
    } on SocketException catch (e) {
      e.message == 'Connection failed'
          ? Utility.currentScreenSnackBar("No Internet Connection", null)
          : print(e);
      rethrow;
    } catch (e) {
      e == 'NO_CONNECTION'
          ? Utility.currentScreenSnackBar("No Internet Connection", null)
          : print(e);
      throw (e);
    }
  }

  Future<List<AssessmentDetails>> getAssessmentList() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Assessment__c/"School__c"=\'${Globals.appSetting.schoolNameC}\'',
          //  'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Assessment__c/"Google_File_Id"=\'$fileId\'',
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        List<AssessmentDetails> _list = response.data['body']
            .map<AssessmentDetails>((i) => AssessmentDetails.fromJson(i))
            .toList();
        return _list;
      }

      return [];
    } catch (e) {
      throw ('something_went_wrong');
    }
  }

  // _updateSheetPermission(
  //     String token, String fileId, String? refreshToken) async {
  //   try {
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'authorization': 'Bearer $token'
  //     };
  //     final body = {"role": "reader", "type": "anyone"};

  //     final ResponseModel response = await _dbServices.postapi(
  //         // 'https://www.googleapis.com/drive/v3/files/$fileId/permissions',
  //         '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$fileId/permissions',
  //         headers: headers,
  //         body: body,
  //         isGoogleApi: true);

  //     if (response.statusCode != 401 &&
  //         response.statusCode == 200 &&
  //         response.data['statusCode'] != 500) {
  //       return true;
  //     }
  //     if ((response.statusCode == 401 || response.data['statusCode'] == 500) &&
  //         _totalRetry < 3) {
  //       _totalRetry++;

  //       bool result = await _toRefreshAuthenticationToken(refreshToken!);

  //       if (result == true) {
  //         List<UserInformation> _userprofilelocalData =
  //             await UserGoogleProfile.getUserProfile();

  //         bool result = _updateSheetPermission(
  //             _userprofilelocalData[0].authorizationToken!,
  //             fileId,
  //             _userprofilelocalData[0].refreshToken);
  //         return result;
  //       }
  //     }
  //     return false;
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  _getShareableLink(
      {required String token,
      required String fileId,
      required String? refreshToken}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      final ResponseModel response = await _dbServices.getApiNew(
          // 'https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
          headers: headers,
          isCompleteUrl: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        // bool result = await _updateSheetPermission(token, fileId, refreshToken);
        // if (!result) {
        //   await _updateSheetPermission(token, fileId, refreshToken);
        // }

        // var data = response.data;
        return response.data['body']['webViewLink'];
      } else if ((response.statusCode == 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        _totalRetry++;
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          String link = await _getShareableLink(
              token: token, fileId: fileId, refreshToken: refreshToken);
          return link;
        } else {
          return 'Reauthentication is required';
        }
      }
      return "";
    } catch (e) {
      throw (e);
    }
  }

  Future _getAssessmentDetail(
      String? token, String? fileId, String? refreshToken) async {
    try {
      Map<String, String> headers = {
        'authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8'
      };
      final ResponseModel response = await _dbServices.getApiNew(
          //   'https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
          headers: headers,
          isCompleteUrl: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        return response.data['body'];
      } else if ((response.statusCode == 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        _totalRetry++;
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userprofilelocalData =
              await UserGoogleProfile.getUserProfile();

          var fildObject = await _getAssessmentDetail(
              _userprofilelocalData[0].authorizationToken,
              fileId,
              _userprofilelocalData[0].refreshToken);
          return fildObject;
          // GetAssessmentDetail(fileId: fileId);
        } else {
          return 'Reauthentication is required';
        }
      }
      return "";
    } catch (e) {
      throw (e);
    }
  }

  Future<List<StudentAssessmentInfo>> processCSVFile(
      String? url, String? token, String? refreshToken, String savePath) async {
    try {
      List<ResultSpreadsheet> csvList = []; //Map the string list to Model
      List<StudentAssessmentInfo> listNew =
          []; //Map the ResultSpreadsheet list to StudentAssessmentInfo list to not chnage anything on UI
      List data = []; //To parse String to List
      bool? createdAsPremium = true;
      // bool? isStandalone = false;

      //Downloading file to specific path
      var response = await dio.download(
        url!,
        savePath,
        options: Options(
          headers: {
            'responseType': ResponseType.bytes,
            // 'Content-Type': 'application/json',
            'authorization': 'Bearer $token'
          },
          method: 'GET',
        ),
      );

      //Processing csv file
      final input = new File('$savePath').openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      if (fields.length > 1) {
        //Removing titles from the string list
        if (fields[0][0] == 'Name') {
          createdAsPremium = false;
        }

        fields.removeAt(0);

        fields.forEach((element) {
          if (createdAsPremium == false) {
            //To manage the first field of excel sheet in case of created as non-premium user.
            element.insert(0, '');
          }

          data.add(element
              .toString()
              .replaceAll('[', "")
              .replaceAll(']', "")
              .replaceAll("''", "'"));
        });

        for (var line in data) {
          csvList.add(ResultSpreadsheet.fromList(line.split(',')));
        }

        //Mapping values to required Model
        for (int i = 0; i < csvList.length; i++) {
          listNew.add(StudentAssessmentInfo(
              subject: csvList[i].subject.toString().replaceFirst(" ", ""),
              assessmentImage: csvList[i]
                  .assessmentImage
                  .toString()
                  .replaceAll("'", "")
                  .replaceAll(" ", ""),
              className: csvList[i].className.toString().replaceFirst(" ", ""),
              customRubricImage:
                  csvList[i].customRubricImage.toString().replaceFirst(" ", ""),
              grade: csvList[i].grade.toString().replaceFirst(" ", ""),
              learningStandard:
                  csvList[i].learningStandard.toString().replaceFirst(" ", ""),
              pointpossible:
                  csvList[i].pointPossible.toString().replaceFirst(" ", ""),
              questionImgUrl: csvList[i]
                  .assessmentQuestionImg
                  .toString()
                  .replaceFirst(" ", ""),
              scoringRubric:
                  csvList[i].scoringRubric.toString().replaceFirst(" ", ""),
              studentGrade:
                  csvList[i].pointsEarned.toString().replaceFirst(" ", ""),
              studentId: csvList[i].id.toString().replaceFirst(" ", ""),
              studentName: csvList[i].name.toString().replaceFirst(" ", ""),
              subLearningStandard: csvList[i]
                  .nyNextGenerationLearningStandard
                  .toString()
                  .replaceFirst(" ", "")));
        }

        return listNew;
      }
      return [];
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    //To get the path where file will be saved.
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path + '/file'}';
    return path;
  }

  // Future<String> downloadFile(String url, String fileName, String dir) async {
  //   try {
  //     HttpClient httpClient = new HttpClient();
  //     File file;
  //     String filePath = '';
  //     String myUrl = '';

  //     myUrl = url;
  //     var request = await httpClient.getUrl(Uri.parse(myUrl));
  //     var response = await request.close();
  //     if (response.statusCode == 200) {
  //       var bytes = await consolidateHttpClientResponseBytes(response);
  //       filePath = '$dir/$fileName';
  //       file = File(filePath);
  //       await file.writeAsBytes(bytes, flush: true);
  //       return filePath;
  //     }

  //     //print('Unable to download the file');
  //     return "";
  //   } catch (e) {
  //     //print("download exception");
  //     print(e);
  //     throw (e);
  //   }
  // }

  Future<bool> _toRefreshAuthenticationToken(String refreshToken) async {
    try {
      final body = {"refreshToken": refreshToken};
      final ResponseModel response = await _dbServices.postapi(
          "${OcrOverrides.OCR_API_BASE_URL}/refreshGoogleAuthentication",
          body: body,
          isGoogleApi: true);
      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        var newToken = response.data['body']; //["access_token"]
        //!=null?response.data['body']["access_token"]:response.data['body']["error"];
        if (newToken["access_token"] != null) {
          List<UserInformation> _userprofilelocalData =
              await UserGoogleProfile.getUserProfile();

          UserInformation updatedObj = UserInformation(
              userName: _userprofilelocalData[0].userName,
              userEmail: _userprofilelocalData[0].userEmail,
              profilePicture: _userprofilelocalData[0].profilePicture,
              refreshToken: _userprofilelocalData[0].refreshToken,
              authorizationToken: newToken["access_token"]);

          // await UserGoogleProfile.updateUserProfileIntoDB(updatedObj);

          await UserGoogleProfile.updateUserProfile(updatedObj);

          //  await HiveDbServices().updateListData('user_profile', 0, updatedObj);

          return true;
        } else {
          return false;
        }
      } else {
        return false;
        //  throw ('something_went_wrong');
      }
    } catch (e) {
      //print(" errrrror  ");
      print(e);
      throw (e);
    }
  }

  Future<String> _uploadImgB64AndGetUrl(
      {required String? imgBase64,
      required String? imgExtension,
      required String? section}) async {
    //  //print(imgBase64);
    Map body = {
      "bucket": "graded/$section",
      "fileExtension": imgExtension,
      "image": imgBase64
    };
    // Map<String, String> headers = {
    //   'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
    // };

    final ResponseModel response = await _dbServices.postapi(
        "${OcrOverrides.OCR_API_BASE_URL}/uploadImage",
        body: body,
        // headers: headers,
        isGoogleApi: true);

    if (response.statusCode != 401 &&
        response.statusCode == 200 &&
        response.data['statusCode'] != 500) {
      return response.data['body']['Location'];
    } else if ((response.statusCode == 401 ||
            response.data['statusCode'] == 500) &&
        _totalRetry < 3) {
      _totalRetry++;
      await _uploadImgB64AndGetUrl(
          imgBase64: imgBase64, imgExtension: imgExtension, section: section);
    }
    return "";
  }
}
