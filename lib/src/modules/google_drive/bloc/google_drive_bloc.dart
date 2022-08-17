import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/google_drive_access.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/google_drive/model/assessment_detail_modal.dart';
import 'package:Soc/src/modules/google_drive/overrides.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/cupertino.dart';
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
        //  //print('FolderId = ${folderObject['id']}');

        if (folderObject != 401 && folderObject != 500) {
          if (folderObject.length == 0) {
            //print(
            // 'Folder doesn\'t exist already. Creating new folder on drive');
            await _createFolderOnDrive(
                token: event.token, folderName: event.folderName);
            //print("Folder created successfully");

            if (event.isFromOcrHome! &&
                Globals.googleDriveFolderId!.isNotEmpty) {
              yield GoogleSuccess(assessmentSection: event.assessmentSection);
            }
          }
          // else if (folderObject.length == 0) {
          //   //print('No folder found');
          // }
          else {
            // //print("Folder Id received : ${folderObject['id']}");
            // //print("Folder path received : ${folderObject['webViewLink']}");

            Globals.googleDriveFolderId = folderObject['id'];
            Globals.googleDriveFolderPath = folderObject['webViewLink'];
            // Globals.
            if (event.isFromOcrHome! &&
                Globals.googleDriveFolderId!.isNotEmpty) {
              yield GoogleSuccess(assessmentSection: event.assessmentSection);
            }
            if (event.fetchHistory == true) {
              //Fetch history assessment
              GetHistoryAssessmentFromDrive();
            }
          }
        } else {
          //print('Authentication required');
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
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        yield ErrorState();

        rethrow;
      } catch (e) {
        if (e == 'NO_CONNECTION') {
          Utility.currentScreenSnackBar("No Internet Connection");
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
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {
        if (e == 'NO_CONNECTION') {
          Utility.currentScreenSnackBar("No Internet Connection");
        } else {
          yield ErrorState();
        }
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
              studentId: "Id",
              studentName: "Name",
              studentGrade: "Points Earned",
              pointpossible: "Point Possible",
              questionImgUrl: "Assessment Question Img",
              grade: "Grade",
              className: "Class Name",
              subject: "Subject",
              learningStandard: "Learning Standard",
              subLearningStandard: "NY Next Generation Learning Standard",
              scoringRubric: "Scoring Rubric",
              customRubricImage: "Custom Rubric Image",
              assessmentImage: "Assessment Image",
            ));

//Generating excel file locally with all the result data
        File file = await GoogleDriveAccess.generateExcelSheetLocally(
            data: assessmentData,
            name: event.assessmentName!,
            createdAsPremium: event.createdAsPremium);

//Update the created excel file to drive with all the result data
        String uploadresult = await uploadSheetOnDrive(
            file,
            event.fileId == null ? Globals.googleExcelSheetId : event.fileId,
            _userprofilelocalData[0].authorizationToken,
            _userprofilelocalData[0].refreshToken);

        if (uploadresult.isEmpty) {
          // await _toRefreshAuthenticationToken(
          //     _userprofilelocalData[0].refreshToken!);

          await uploadSheetOnDrive(
              file,
              Globals.googleExcelSheetId,
              _userprofilelocalData[0].authorizationToken,
              _userprofilelocalData[0].refreshToken);
        } else if (uploadresult == 'Reauthentication is required') {
          yield ErrorState(errorMsg: 'Reauthentication is required');
        } else {
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
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection")
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

        if (_localData.isNotEmpty) {
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
          );
          List<HistoryAssessment>? _list = pair[0];

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
            assessmentList.length > 0 ? await _localDb.clear() : print("");
            assessmentList.forEach((HistoryAssessment e) {
              _localDb.addData(e);
            });

            yield GoogleDriveGetSuccess(
                obj: assessmentList, nextPageLink: pair[1]);
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
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : throw (e);
      }
    }

    //hsadjkhfajkshfadjkshfdjsfsabhjkfbsjkcbasbcjdsabcjabdsjcabsjcbadhsbadsbadhis

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
              nextPageUrl: event.nextPageUrl);
          List<HistoryAssessment>? _list = pair[0];
          // //print('updatedList');
          // //print(
          //     "---------------------------------------------------------------listLength----------------------${_list!.length}");
          if (_list == null) {
            yield ErrorState(errorMsg: 'Reauthentication is required');
          } else {
            _list.forEach((element) {
              //print(element.label['trashed']);
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
                obj: updatedAssessmentList, nextPageLink: pair[1]);
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
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {}
    }

    if (event is GetAssessmentDetail) {
      try {
        yield GoogleDriveLoading2();
        List<StudentAssessmentInfo> _list = [];
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
          String file = await downloadFile(
              fildObject['exportLinks'][
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
              event.fileId!,
              (await getApplicationDocumentsDirectory()).path);

          // //print("assessment downloaded");

          if (file != "") {
            // //print("Assessment file found");
            //  List<StudentAssessmentInfo>
            _list = await GoogleDriveAccess.excelToJson(file);
            // //print("assessment data is converted into json ");

            bool deleted = await GoogleDriveAccess.deleteFile(File(file));
            if (!deleted) {
              GoogleDriveAccess.deleteFile(File(file));
            }
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

            //print("//printing length----------->${_list.length}");
            yield AssessmentDetailSuccess(
                obj: _list, webContentLink: fildObject['webViewLink']);
          } else {
            //print("Assessment file URL not found1");

            //Return empty list
            yield AssessmentDetailSuccess(
                obj: [], webContentLink: fildObject['webViewLink']);
          }
        } else if (fildObject == 'Reauthentication is required') {
          yield ErrorState(errorMsg: 'Reauthentication is required');
        } else {
          //Return empty list
          yield AssessmentDetailSuccess(
              obj: _list,
              webContentLink: fildObject != null && fildObject != ''
                  ? fildObject['webViewLink']
                  : '');
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {
        // e == 'NO_CONNECTION'
        //     ? Utility.currentScreenSnackBar("No Internet Connection")
        //     : errorThrow('Unable to open the blank file');
        if (e == 'NO_CONNECTION') {
          Utility.currentScreenSnackBar("No Internet Connection");
        } else {
          yield AssessmentDetailSuccess(obj: [], webContentLink: null);
        }
        ////print(e);
        throw (e);
      }
    }

    if (event is ImageToAwsBucked) {
      try {
        String imgUrl = await _uploadImgB64AndGetUrl(
            imgBase64: event.imgBase64,
            imgExtension: event.imgExtension,
            section: 'rubric-score');
        //  int index = RubricScoreList.scoringList.length - 1;
        //   //print(RubricScoreList.scoringList);
        imgUrl != ""
            ? RubricScoreList.scoringList.last.imgUrl = imgUrl
            : _uploadImgB64AndGetUrl(
                imgBase64: event.imgBase64,
                imgExtension: event.imgExtension,
                section: 'rubric-score');

        //print(RubricScoreList.scoringList);
        //print("//printing imag url : $imgUrl");
      } catch (e) {
        //print("image upload error");

      }
    }
    if (event is AssessmentImgToAwsBucked) {
      try {
        String imgUrl = await _uploadImgB64AndGetUrl(
            imgBase64: event.imgBase64,
            imgExtension: event.imgExtension,
            section: "assessment-sheet");
        //  int index = RubricScoreList.scoringList.length - 1;

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

          //print('Image bucket URL received : $imgUrl');
          int hhh = 0;
          for (int i = 0; i < studentInfo.length; i++) {
            if (studentInfo[i].studentId == event.studentId) {
              //print(hhh);
              //print(
              // 'gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');
              //print("updateing img url");

              StudentAssessmentInfo e = studentInfo[i];
              e.assessmentImage = imgUrl;

              await _studentInfoDb.putAt(i, e);
            }
          }
        }

        // //print("//printing imag url : $imgUrl");
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        rethrow;
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection")
            : print(e);
        throw (e);
      }
    }
    if (event is QuestionImgToAwsBucked) {
      try {
        yield GoogleDriveLoading();
        //  Globals.questionImgUrl = '';
        String questionImgUrl = await _uploadImgB64AndGetUrl(
            imgBase64: event.imgBase64,
            imgExtension: event.imgExtension,
            section: 'rubric-score');

        // questionImgUrl.isNotEmpty
        //     ? print("question image url upload done")
        //     : print("error uploading question img");
        yield QuestionImageSuccess(questionImageUrl: questionImgUrl);
      } catch (e) {
        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection")
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
      // await _localDb.clear();
      List<HistoryAssessment>? _localData = await _localDb.getData();
      //Sort the list as per the modified date
      if (_localData.isNotEmpty) {
        _localData = await listSort(_localData);
        List<HistoryAssessment> searchList = List.from(_localData.where((e) =>
            e.title!.toLowerCase().contains(event.keyword!.toLowerCase())));
        // //print('returntin--------------------------');
        // //print(searchList.length);
        yield GoogleDriveGetSuccess(obj: searchList);
      } else {
        yield GoogleDriveGetSuccess(obj: []);
      }
    }
  }

  void errorThrow(msg) {
    BuildContext? context = Globals.navigatorKey.currentContext;
    Utility.currentScreenSnackBar(msg);
    Navigator.pop(context!);
  }

  void checkForGoogleExcelId() async {
    try {
      if (Globals.googleExcelSheetId!.isEmpty) {
        await Future.delayed(Duration(milliseconds: 200));
        if (Globals.googleExcelSheetId!.isEmpty) {
          checkForGoogleExcelId();
        }
        // await createSheetOnDrive(
        //     name: Globals.assessmentName,
        //     folderId: Globals.googleDriveFolderId,
        //     accessToken: _userprofilelocalData[0].authorizationToken,
        //     refreshToken: _userprofilelocalData[0].refreshToken);
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

      final ResponseModel response = await _dbServices.getapiNew(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}' +
              'https://www.googleapis.com/drive/v3/files?fields=%2A%26q=' +
              Uri.encodeFull(query),
          headers: headers,
          isGoogleAPI: true);
      // final ResponseModel response = await _dbServices.getapiNew(
      //     'https://www.googleapis.com/drive/v3/files?fields=*&q=trashed = false and mimeType = \'application/vnd.google-apps.folder\' and name = \'SOLVED GRADED%2B\'',

      // Uri.encodeFull(

      //     '\'SOLVED GRADED%2B\''),

      //     '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files?fields=*',

      // headers: headers,
      // isGoogleAPI: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        var data = response.data['body']['files'];

        if (data.length == 0) {
          return data;
        } else {
          return data[0];
        }
        // return data[0];
        // for (int i = 0; i < data.length; i++) {
        //   if (data[i]['name'] == folderName &&
        //       data[i]["mimeType"] == "application/vnd.google-apps.folder" &&
        //       data[i]["trashed"] == false) {
        //     // //print("folder is already exits : ${data[i]['id']}");
        //    return data[i];
        //   }
        // }
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

        // bool result =
        //     await _updateSheetPermission(accessToken!, fileId, refreshToken);
        // if (!result) {
        //   await _updateSheetPermission(accessToken, fileId, refreshToken);
        // }

        // bool link = await _getShareableLink(accessToken, fileId, refreshToken);
        // if (!link) {
        //   await _getShareableLink(accessToken, fileId, refreshToken);
        // }
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
      //print(mimeType);
      //print(id);
      //print(accessToken);
      //print(file.readAsBytesSync());
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
        return 'Done';
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

  Future _fetchHistoryAssessment(
      {String? token,
      String? folderId,
      bool? isPagination,
      String? nextPageUrl}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      final ResponseModel response = await _dbServices.getapiNew(
          isPagination == true
              ? "$nextPageUrl"
              : "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files?q='$folderId'+in+parents",
          headers: headers,
          isGoogleAPI: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        //print("assessment list is received ");
        //print(response.data);
        String updatedNextUrlLink = '';
        try {
          updatedNextUrlLink = isPagination == true
              ? response.data["nextLink"]
              : response.data['body']["nextLink"];
        } catch (e) {
          updatedNextUrlLink = '';
        }
        //print(updatedNextUrlLink);
        // nextPageToken = response.data['body']["nextPageToken"];
        List<HistoryAssessment> _list = isPagination == true
            ? response.data['items']
                .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
                .toList()
            : response.data['body']['items'] //response.data['body']['items']

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
              nextPageUrl: nextPageUrl);
          // List<HistoryAssessment>? _list = pair[0];

          return pair;

          //   GetHistoryAssessmentFromDrive();
        } else {
          return null;
        }
      } else {
        List<HistoryAssessment> _list = [];
        return _list;
      }
    } on SocketException catch (e) {
      e.message == 'Connection failed'
          ? Utility.currentScreenSnackBar("No Internet Connection")
          : print(e);
      rethrow;
    } catch (e) {
      e == 'NO_CONNECTION'
          ? Utility.currentScreenSnackBar("No Internet Connection")
          : print(e);
      throw (e);
    }
  }

  Future<List<AssessmentDetails>> getAssessmentList() async {
    try {
      final ResponseModel response = await _dbServices.getapiNew(
          'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Assessment__c/"School__c"=\'${Globals.appSetting.schoolNameC}\'',
          //  'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/Assessment__c/"Google_File_Id"=\'$fileId\'',
          isGoogleAPI: true);
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

  _updateSheetPermission(
      String token, String fileId, String? refreshToken) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      final body = {"role": "reader", "type": "anyone"};

      final ResponseModel response = await _dbServices.postapi(
          // 'https://www.googleapis.com/drive/v3/files/$fileId/permissions',
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$fileId/permissions',
          headers: headers,
          body: body,
          isGoogleApi: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        return true;
      }
      if ((response.statusCode == 401 || response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        _totalRetry++;

        bool result = await _toRefreshAuthenticationToken(refreshToken!);

        if (result == true) {
          List<UserInformation> _userprofilelocalData =
              await UserGoogleProfile.getUserProfile();

          bool result = _updateSheetPermission(
              _userprofilelocalData[0].authorizationToken!,
              fileId,
              _userprofilelocalData[0].refreshToken);
          return result;
        }
      }
      return false;
    } catch (e) {
      throw (e);
    }
  }

  _getShareableLink(
      {required String token,
      required String fileId,
      required String? refreshToken}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      final ResponseModel response = await _dbServices.getapiNew(
          // 'https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
          headers: headers,
          isGoogleAPI: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        bool result = await _updateSheetPermission(token, fileId, refreshToken);
        if (!result) {
          await _updateSheetPermission(token, fileId, refreshToken);
        }

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
      final ResponseModel response = await _dbServices.getapiNew(
          //   'https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$fileId?fields=*',
          headers: headers,
          isGoogleAPI: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        return response.data['body'];
        // return 'Reauthentication is required';
        // //print('File URL Received :${data['webViewLink']}');
        // String downloadLink = data['exportLinks'] != null
        //     ? data['exportLinks'][
        //         'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
        //     : '';
        // return downloadLink;
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
        await file.writeAsBytes(bytes, flush: true);
        return filePath;
      }

      //print('Unable to download the file');
      return "";
    } catch (e) {
      //print("download exception");
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
