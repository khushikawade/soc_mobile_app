import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/fetch_google_sheet.dart';
import 'package:Soc/src/modules/google_drive/google_drive_access.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/google_drive/model/assessment_detail_modal.dart';
import 'package:Soc/src/modules/google_drive/model/spreadsheet_model.dart';
import 'package:Soc/src/modules/google_drive/overrides.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/graded_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
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

  GoogleDriveState get initialState => GoogleDriveInitial();
  int _totalRetry = 0;

  @override
  Stream<GoogleDriveState> mapEventToState(
    GoogleDriveEvent event,
  ) async* {
    print("googgggggggggle event ----->$event");

    // --------------------Event To Get Google Drive Folder ID------------------
    if (event is GetDriveFolderIdEvent) {
      try {
        var folderObject;
        if (event.isFromOcrHome!) {
          yield GoogleDriveLoading();
        }
        folderObject = await _getGoogleDriveFolderId(
            token: event.token, folderName: event.folderName);
        //Condition To Create Folder In Case Of It Is Not Exist
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

            if (event.isFromOcrHome! &&
                Globals.googleDriveFolderId!.isNotEmpty) {
              yield GoogleSuccess(assessmentSection: event.assessmentSection);
            }
            if (event.fetchHistory == true) {
              GetHistoryAssessmentFromDrive();
            }
          }
        } else {
          // To Refresh Authentication Token In Case Of Auth Token Expired
          var result = await _toRefreshAuthenticationToken(event.refreshToken!);
          if (result == true) {
            List<UserInformation> _userProfileLocalData =
                await UserGoogleProfile.getUserProfile();

            GetDriveFolderIdEvent(
                isFromOcrHome: true,
                token: _userProfileLocalData[0].authorizationToken,
                folderName: event.folderName,
                refreshToken: _userProfileLocalData[0].refreshToken);
            yield GoogleSuccess(assessmentSection: event.assessmentSection);
          } else {
            yield ErrorState(
                errorMsg: 'ReAuthentication is required',
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

    // --------------------Event To Create Excel Sheet On Drive------------------
    else if (event is CreateExcelSheetToDrive) {
      try {
        yield GoogleDriveLoading();
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        Globals.assessmentName = event.name;
        String result = await createSheetOnDrive(
          name: event.name!,
          folderId: Globals.googleDriveFolderId,
          accessToken: _userProfileLocalData[0].authorizationToken,
          refreshToken: _userProfileLocalData[0].refreshToken,
        );
        if (result == '') {
          //Managing extra state to call the same event again in case of token expired
          yield RecallTheEvent();
        } else if (result == 'ReAuthentication is required') {
          yield ErrorState(
            errorMsg: 'ReAuthentication is required',
          );
        } else {
          yield ExcelSheetCreated();
        }
      } on SocketException catch (e) {
        yield ErrorState(errorMsg: e.toString());
        rethrow;
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
        throw (e);
      }
    }

    // bloc to update google Slide on scan more condition
    else if (event is UpdateGoogleSlideOnScanMore) {
      try {
        yield ShowLoadingDialog();
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
            LocalDatabase('history_student_info');
        List<StudentAssessmentInfo> assessmentData =
            await _studentInfoDb.getData();
        for (var i = 0; i < assessmentData.length; i++) {
          if (assessmentData[i].assessmentImage == null ||
              assessmentData[i].assessmentImage!.isEmpty) {
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

            if (imgUrl != "") {
              assessmentData[i].assessmentImage = imgUrl;
            }
          }
        }
        //clear local DB
        _studentInfoDb.clear();

        //updating local DB with latest data
        assessmentData.forEach((StudentAssessmentInfo e) {
          _studentInfoDb.addData(e);
        });

        // Create new Google presentation in case already not exist // Will work for all the existing assessment which are not having already google slide presentation in case of scan more
        if (event.slidePresentationId == 'NA') {
          //To create Google Presentation
          String googleSlideId = await createSlideOnDrive(
            name: event.assessmentName, //event.fileTitle!,
            folderId: Globals.googleDriveFolderId,
            accessToken: _userProfileLocalData[0].authorizationToken,
            refreshToken: _userProfileLocalData[0].refreshToken,
          );

          //To add one or more blank slides in Google Presentation
          await createBlankSlidesInGooglePresentation(
              googleSlideId,
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken,
              isFromHistoryAssessment: false, //event.isFromHistoryAssessment,
              studentRecordList: assessmentData,
              isScanMore: false);

          //To update scanned images in the Google Slides
          await updateAssessmentImageToSlidesOnDrive(
              googleSlideId,
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken,
              assessmentData);

          //Get the Google Presentation URL
          String shareLink = await _getShareableLink(
            fileId: googleSlideId,
            token: _userProfileLocalData[0].authorizationToken!,
            refreshToken: _userProfileLocalData[0].refreshToken,
          );

          //Updating Google Presentation URL in the sheet where the URL doen't exist
          for (var i = 0; i < assessmentData.length; i++) {
            if (assessmentData[i].googleSlidePresentationURL == null ||
                assessmentData[i].googleSlidePresentationURL!.isEmpty ||
                assessmentData[i].googleSlidePresentationURL == 'NA') {
              assessmentData[i].googleSlidePresentationURL = shareLink;
            }
          }
          yield GoogleSheetUpdateOnScanMoreSuccess(list: assessmentData);
        } else {
          List<StudentAssessmentInfo> list = [];

          list.addAll(assessmentData);
          list.removeRange(0, event.lastAssessmentLength);

          if (list.isNotEmpty) {
            //To create Google Presentation
            await createBlankSlidesInGooglePresentation(
                event.slidePresentationId,
                _userProfileLocalData[0].authorizationToken,
                _userProfileLocalData[0].refreshToken,
                studentRecordList: list,
                isFromHistoryAssessment: event.isFromHistoryAssessment,
                isScanMore: true);

            //To update scanned images in the Google Slides
            await updateAssessmentImageToSlidesOnDrive(
                event.slidePresentationId,
                _userProfileLocalData[0].authorizationToken,
                _userProfileLocalData[0].refreshToken,
                list);
            yield GoogleSheetUpdateOnScanMoreSuccess(list: assessmentData);
          }

          yield GoogleSheetUpdateOnScanMoreSuccess(list: assessmentData);
        }
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
        throw (e);
      }
    }

    // --------------------Event To Update Excel Sheet On Drive------------------
    if (event is UpdateDocOnDrive) {
      if (event.isLoading) {
        yield GoogleDriveLoading();
      }
      List<UserInformation> _userProfileLocalData =
          await UserGoogleProfile.getUserProfile();
      LocalDatabase<CustomRubricModal> customRubicLocalDb =
          LocalDatabase('custom_rubic');
      List<CustomRubricModal>? customRubicLocalData =
          await customRubicLocalDb.getData();

      List<StudentAssessmentInfo>? assessmentData = event.studentData;
      checkForGoogleExcelId(); //To check for excel sheet id
      if (assessmentData!.length > 0 && assessmentData[0].studentId == 'Id') {
        assessmentData.removeAt(0);
      }

      try {
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

          // if (event.isCustomRubricSelcted == true &&
          //     (assessmentData[i].customRubricImage == null ||
          //         assessmentData[i].customRubricImage!.isEmpty) &&
          //     event.selectedRubric != 0 &&
          //     customRubicLocalData[event.selectedRubric!].filePath != null &&
          //     customRubicLocalData[event.selectedRubric!]
          //         .filePath!
          //         .isNotEmpty) {
          //   if (customRubicLocalData[event.selectedRubric!].imgUrl != null ||
          //       customRubicLocalData[event.selectedRubric!]
          //           .imgUrl!
          //           .isNotEmpty) {
          //     assessmentData.forEach((element) {
          //       element.customRubricImage =
          //           customRubicLocalData[event.selectedRubric!].imgUrl;
          //     });
          //   } else {
          //     File assessmentImageFile =
          //         File(customRubicLocalData[event.selectedRubric!].filePath!);
          //     String imgExtension = assessmentImageFile.path
          //         .substring(assessmentImageFile.path.lastIndexOf(".") + 1);

          //     String imgUrl = await _uploadImgB64AndGetUrl(
          //         imgBase64:
          //             customRubicLocalData[event.selectedRubric!].imgBase64,
          //         imgExtension: imgExtension,
          //         section: 'rubric-score');
          //     if (imgUrl != '') {
          //       assessmentData.forEach((element) {
          //         element.customRubricImage = imgUrl;
          //       });
          //     }
          //   }
          // }

          if ((assessmentData[i].customRubricImage == null ||
              assessmentData[i].customRubricImage!.isEmpty &&
                  customRubicLocalData.isNotEmpty)) {
            int? localCustomRubricIndex = 0;
            CustomRubricModal? customRubicModal = customRubicLocalData[0];

            for (int customRubricIndex = 0;
                customRubricIndex < customRubicLocalData.length;
                customRubricIndex++) {
              if (customRubicLocalData[customRubricIndex]
                          .customOrStandardRubic ==
                      "Custom" &&
                  '${customRubicLocalData[customRubricIndex].name}' +
                          ' ' +
                          '${customRubicLocalData[customRubricIndex].score}' ==
                      Globals.scoringRubric) {
                localCustomRubricIndex = customRubricIndex;
                customRubicModal = customRubicLocalData[customRubricIndex];
                break;
              }
            }

            //Updating custom rubric image in all student record if not exist already
            if (customRubicModal!.imgUrl != null &&
                customRubicModal.imgUrl!.isNotEmpty) {
              assessmentData.forEach((element) {
                element.customRubricImage = customRubicModal!.imgUrl;
              });
            } else {
              //If custom rubric image url not exist and path exist, uploading again the image to get the image URL
              if (customRubicModal.filePath != null &&
                  customRubicModal.filePath!.isNotEmpty) {
                File assessmentImageFile = File(customRubicModal.filePath!);
                String imgExtension = assessmentImageFile.path
                    .substring(assessmentImageFile.path.lastIndexOf(".") + 1);

                String imgUrl = await _uploadImgB64AndGetUrl(
                    imgBase64: customRubicModal.imgBase64,
                    imgExtension: imgExtension,
                    section: 'rubric-score');
                if (imgUrl != '') {
                  customRubicModal.imgUrl = imgUrl;
                  await customRubicLocalDb.putAt(
                      localCustomRubricIndex!, customRubicModal);
                  assessmentData.forEach((element) {
                    element.customRubricImage = imgUrl;
                  });
                }
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
          }
        }

        assessmentData.insert(
            0,
            StudentAssessmentInfo(
                studentId:
                    Overrides.STANDALONE_GRADED_APP == true ? "Email Id" : "Id",
                studentName: "Name",
                studentGrade: "Points Earned",
                pointPossible: "Point Possible",
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
                //googleSlidepresentationLink: "Presentation URL",
                answerKey: 'Answer Key',
                googleSlidePresentationURL: 'Presentation URL',
                studentResponseKey: 'Student Selection'));

        //Generating excel file locally with all the result data
        File file = await GoogleDriveAccess.generateExcelSheetLocally(
            isMcqSheet: event.isMcqSheet,
            data: assessmentData,
            name: event.assessmentName!,
            createdAsPremium: event.createdAsPremium);

        //Update the created excel file to drive with all the result data
        String excelSheetId = await uploadSheetOnDrive(
            file,
            event.fileId == null ? Globals.googleExcelSheetId : event.fileId,
            _userProfileLocalData[0].authorizationToken,
            _userProfileLocalData[0].refreshToken);

        if (excelSheetId.isEmpty) {
          // await _toRefreshAuthenticationToken(
          //     _userProfileLocalData[0].refreshToken!);

          String excelSheetId = await uploadSheetOnDrive(
              file,
              Globals.googleExcelSheetId,
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken);
          // function to update property of excel sheet

          _updateFieldExcelSheet(
              isMcqSheet: event.isMcqSheet ?? false,
              assessmentData: assessmentData,
              excelId: excelSheetId,
              token: _userProfileLocalData[0].authorizationToken!);
        } else if (excelSheetId == 'ReAuthentication is required') {
          yield ErrorState(errorMsg: 'ReAuthentication is required');
        } else {
          // function to update property of excel sheet

          _updateFieldExcelSheet(
              isMcqSheet: event.isMcqSheet ?? false,
              assessmentData: assessmentData,
              excelId: excelSheetId,
              token: _userProfileLocalData[0].authorizationToken!);

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

        List<HistoryAssessment>? _localData = await _localDb.getData();
        //Sort the list as per the modified date
        _localData = await listSort(_localData);

        if (_localData.isNotEmpty &&
            (event.searchKeyword == "" || event.searchKeyword == null)) {
          yield GoogleDriveGetSuccess(obj: _localData);
        } else {
          yield GoogleDriveLoading();
        }

        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        List<HistoryAssessment> assessmentList = [];

        if (Globals.googleDriveFolderId != null &&
            Globals.googleDriveFolderId != "") {
          List pair = await _fetchHistoryAssessment(
              token: _userProfileLocalData[0].authorizationToken,
              isPagination: false,
              folderId: Globals.googleDriveFolderId,
              searchKey: event.searchKeyword ?? "");
          List<HistoryAssessment>? _list =
              pair != null && pair.length > 0 ? pair[0] : [];

          if (_list == null) {
            yield ErrorState(errorMsg: 'ReAuthentication is required');
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
              token: _userProfileLocalData[0].authorizationToken,
              folderName: "SOLVED GRADED+",
              fetchHistory: true);
        }
      } on SocketException catch (e) {
        e.message == 'Connection failed'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : print(e);
        rethrow;
      } catch (e, s) {
        FirebaseAnalyticsService.firebaseCrashlytics(
            e, s, 'GetHistoryAssessmentFromDrive Event');

        e == 'NO_CONNECTION'
            ? Utility.currentScreenSnackBar("No Internet Connection", null)
            : throw (e);
      }
    }

    if (event is UpdateHistoryAssessmentFromDrive) {
      try {
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        List<HistoryAssessment> assessmentList = [];

        if (Globals.googleDriveFolderId != null) {
          List pair = await _fetchHistoryAssessment(
              token: _userProfileLocalData[0].authorizationToken,
              folderId: Globals.googleDriveFolderId,
              isPagination: true,
              nextPageUrl: event.nextPageUrl,
              searchKey: "");
          List<HistoryAssessment>? _list =
              pair != null && pair.length > 0 ? pair[0] : [];
          if (_list == null) {
            yield ErrorState(errorMsg: 'ReAuthentication is required');
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
            yield ShareLinkReceived(shareLink: '');
            yield GoogleDriveGetSuccess(
                obj: updatedAssessmentList,
                nextPageLink: pair != null && pair.length > 1 ? pair[1] : '');
          }
        } else {
          GetDriveFolderIdEvent(
              isFromOcrHome: false,
              //  filePath: file,
              token: _userProfileLocalData[0].authorizationToken,
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
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        var fileObject;
        fileObject = await _getAssessmentDetail(
            _userProfileLocalData[0].authorizationToken,
            event.fileId,
            _userProfileLocalData[0].refreshToken);

        if (fileObject != '' &&
            fileObject != null &&
            fileObject != 'ReAuthentication is required' &&
            fileObject['exportLinks'] != null) {
          String savePath = await getFilePath(event.fileId);
          summaryList = await processCSVFile(
              fileObject['exportLinks']['text/csv'],
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken,
              savePath);

          if (summaryList != []) {
            bool deleted = await GoogleDriveAccess.deleteFile(File(savePath));
            if (!deleted) {
              GoogleDriveAccess.deleteFile(File(savePath));
            }

            yield AssessmentDetailSuccess(
                obj: summaryList, webContentLink: fileObject['webViewLink']);
          } else {
            //Return empty list
            yield AssessmentDetailSuccess(
                obj: [], webContentLink: fileObject['webViewLink']);
          }
        } else if (fileObject == 'ReAuthentication is required') {
          yield ErrorState(errorMsg: 'ReAuthentication is required');
        } else {
          //Return empty list
          yield AssessmentDetailSuccess(
              obj: summaryList,
              webContentLink: fileObject != null && fileObject != ''
                  ? fileObject['webViewLink']
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

    if (event is ImageToAwsBucket) {
      try {
        print(event.getImageUrl);
        String imgUrl = await _uploadImgB64AndGetUrl(
            imgBase64: event.customRubricModal.imgBase64,
            imgExtension: Utility.getBase64FileExtension(
                event.customRubricModal.imgBase64!),
            section: 'rubric-score');

        if (!event.getImageUrl! && imgUrl.isNotEmpty) {
          RubricScoreList.scoringList.last.imgUrl = imgUrl;
        } else if (event.getImageUrl! && imgUrl.isNotEmpty) {
          yield ImageToAwsBucketSuccess(
              bucketImageUrl: imgUrl,
              customRubricModal: event.customRubricModal);
        } else {
          yield ErrorState(errorMsg: "image URL Not received ");
        }
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
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
      try {
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        String link = await _getShareableLink(
            fileId: event.fileId ?? '',
            refreshToken: _userProfileLocalData[0].refreshToken,
            token: _userProfileLocalData[0].authorizationToken!);

        if (link != '' && link != 'ReAuthentication is required') {
          if (!event.slideLink) {
            Globals.shareableLink = link;
          } else {
            yield ShareLinkReceived(shareLink: link);
          }
        } else if (link == 'ReAuthentication is required') {
          yield ErrorState(errorMsg: 'ReAuthentication is required');
        }
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
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

    if (event is AddBlankSlidesOnDrive) {
      yield ShowLoadingDialog();
      try {
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        String result = await createBlankSlidesInGooglePresentation(
            event.slidePresentationId!,
            _userProfileLocalData[0].authorizationToken,
            _userProfileLocalData[0].refreshToken,
            isFromHistoryAssessment: false,
            isScanMore: event.isScanMore);

        if (result == "Done") {
          yield AddBlankSlidesOnDriveSuccess();
        } else {
          yield ErrorState(errorMsg: result.toString());
        }
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
      }
    }

    if (event is CreateSlideToDrive) {
      try {
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        String result = await createSlideOnDrive(
          name: event.fileTitle!,
          folderId: Globals.googleDriveFolderId,
          accessToken: _userProfileLocalData[0].authorizationToken,
          refreshToken: _userProfileLocalData[0].refreshToken,

          //  image: file
        );
        if (result == '') {
          CreateSlideToDrive(fileTitle: event.fileTitle);
        } else if (result == 'ReAuthentication is required') {
          yield ErrorState(errorMsg: 'ReAuthentication is required');
        } else {
          yield GoogleSlideCreated(slideFiledId: result);
        }
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
      }
    }
    if (event is UpdateAssessmentImageToSlidesOnDrive) {
      try {
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
            LocalDatabase('student_info');
        List<StudentAssessmentInfo> assessmentData =
            await _studentInfoDb.getData();
        for (var i = 0; i < assessmentData.length; i++) {
          if (assessmentData[i].assessmentImage == null ||
              assessmentData[i].assessmentImage!.isEmpty) {
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

            if (imgUrl != "") {
              assessmentData[i].assessmentImage = imgUrl;
              await _studentInfoDb.putAt(i, assessmentData[i]);
            }
          }
        }

        String result = await updateAssessmentImageToSlidesOnDrive(
            event.slidePresentationId!,
            _userProfileLocalData[0].authorizationToken,
            _userProfileLocalData[0].refreshToken,
            assessmentData);

        if (result == "Done") {
          yield GoogleAssessmentImagesOnSlidesUpdated();
        } else {}
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
      }
    }

    if (event is UpdateAssignmentDetailsOnSlide) {
      try {
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        //Used to update assessment detail on very slide of the google presentation
        String result = await _updateAssignmentDetailsOnSlide(
            event.slidePresentationId,
            _userProfileLocalData[0].authorizationToken,
            _userProfileLocalData[0].refreshToken,
            '12345',
            event.studentAssessmentInfoObj);

        if (result == "Done") {
          yield UpdateAssignmentDetailsOnSlideSuccess();
        } else {
          ErrorState(errorMsg: result);
        }
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
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
      final ResponseModel response = await _dbServices.postApi(
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

      final ResponseModel response = await _dbServices.postApi(
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
        //To regenerated fresh access token
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          String result = await createSheetOnDrive(
            name: name!,
            folderId: folderId,
            accessToken: _userProfileLocalData[0].authorizationToken,
            refreshToken: _userProfileLocalData[0].refreshToken,

            //  image: file
          );
          return result;
        } else {
          return 'ReAuthentication is required';
        }
      }
      return '';
    } catch (e) {
      throw (e);
    }
  }

  Future<String> uploadSheetOnDrive(
    File? file,
    String? id,
    String? accessToken,
    String? refreshToken,
  ) async {
    try {
      // String accessToken = await Pref.getToken();
      String? mimeType = mime(basename(file!.path).toLowerCase());

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': '$mimeType'
      };

      final ResponseModel response = await _dbServices.patchApi(
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
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          String uploadResult = await uploadSheetOnDrive(
              file,
              id,
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken);
          return uploadResult;
        } else {
          return 'ReAuthentication is required';
        }
      }
      return '';
    } catch (e) {
      throw (e);
    }
  }

  //To get sheet gridId From excel sheet id
  Future<int> _getSheetId({
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
      required bool isMcqSheet,
      //required int sheetID,
      required List<StudentAssessmentInfo> assessmentData}) async {
    try {
      //To get sheetId From excel sheet id
      int sheetID = await _getSheetId(excelId: excelId, token: token);
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
        //Property Update in Excel Sheet // URL Hyperlink and Heading Bold
        data.add(_updateFieldExcelSheetRequestBody(
            isHyperLink: true,
            startRowIndex: 1,
            endRowIndex: assessmentData.length,
            startColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 5 : 3)
                : (isMcqSheet == true ? 6 : 4),
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 6 : 4)
                : (isMcqSheet == true ? 7 : 5),
            sheetId: sheetID,
            imageLink: assessmentData[1].questionImgUrl));
      }

      // To make custom rubric image url hyperlinked //Same for all students
      if (assessmentData[1].customRubricImage != 'NA') {
        //Property Update in Excel Sheet // URL Hyperlink and Heading Bold
        data.add(_updateFieldExcelSheetRequestBody(
            isHyperLink: true,
            startRowIndex: 1,
            endRowIndex: assessmentData.length,
            startColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 12 : 10)
                : (isMcqSheet == true ? 13 : 11),
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 13 : 11)
                : (isMcqSheet == true ? 14 : 12),
            sheetId: sheetID,
            imageLink: assessmentData[1].customRubricImage));
      }

      // To make presentation image url hyperlinked //Same for all students
      if (assessmentData[1].googleSlidePresentationURL != 'NA') {
        data.add(_updateFieldExcelSheetRequestBody(
            isHyperLink: true,
            startRowIndex: 1,
            endRowIndex: assessmentData.length,
            startColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 14 : 12)
                : (isMcqSheet == true ? 15 : 13),
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 15 : 13)
                : (isMcqSheet == true ? 16 : 14),
            sheetId: sheetID,
            imageLink: assessmentData[1].googleSlidePresentationURL));
      }

      // To make student assessment sheet image url hyperlinked  //Used loop to manage multiple student sheets
      for (int i = 1; i < assessmentData.length; i++) {
        data.add(_updateFieldExcelSheetRequestBody(
            isHyperLink: true,
            startRowIndex: i,
            endRowIndex: i + 1,
            startColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 13 : 11)
                : (isMcqSheet == true ? 14 : 12),
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 14 : 12)
                : (isMcqSheet == true ? 15 : 13),
            sheetId: sheetID,
            imageLink: assessmentData[i].assessmentImage));
      }

      Map<String, dynamic> body = {
        "requests": data,
        "includeSpreadsheetInResponse": true,
        "responseIncludeGridData": true
      };
      if (sheetID != 1 && sheetID != 0) {
        final ResponseModel response = await _dbServices.postApi(
            "https://sheets.googleapis.com/v4/spreadsheets/$excelId:batchUpdate",
            headers: headers,
            isGoogleApi: true,
            body: body);
        if (response.statusCode == 200) {}
      } else {
        print('Excel file grid is not found');
      }
    } catch (e) {
      print(e);
    }
  }

// excel sheet Property update request body
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
              _list[i].assessmentType = assessmentList[j].assessmentType;
            }
          }
        }
        return _list == null ? [] : [_list, updatedNextUrlLink];
      } else if ((response.statusCode == 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        _totalRetry++;

        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        var result = await _toRefreshAuthenticationToken(
            userProfileLocalData[0].refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          List pair = await _fetchHistoryAssessment(
              token: _userProfileLocalData[0].authorizationToken,
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
          return 'ReAuthentication is required';
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
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          var fileObject = await _getAssessmentDetail(
              _userProfileLocalData[0].authorizationToken,
              fileId,
              _userProfileLocalData[0].refreshToken);
          return fileObject;
          // GetAssessmentDetail(fileId: fileId);
        } else {
          return 'ReAuthentication is required';
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
        listNew = FetchGoogleSheet.fetchGoogleSheetData(fields: fields);
        fields.removeAt(0);

        // fields.forEach((element) {
        //   if (createdAsPremium == false) {
        //     //To manage the first field of excel sheet in case of created as non-premium user.
        //     element.insert(0, '');
        //   }

        //   data.add(element
        //       .toString()
        //       .replaceAll('[', "")
        //       .replaceAll(']', "")
        //       .replaceAll("''", "'"));
        // });

        // for (var line in data) {
        //   print(line);
        //   csvList.add(ResultSpreadsheet.fromList(line.split(',')));
        // }

        //Mapping values to required Model
        // for (var i = 0; i < fields.length; i++) {
        //   listNew.add(StudentAssessmentInfo(
        //       studentId: fields[i][0].toString().replaceFirst(" ", ""),
        //       studentName: fields[i][1].toString().replaceFirst(" ", ""),
        //       studentGrade: fields[i][2].toString().replaceFirst(" ", ""),
        //       pointPossible: fields[i][3].toString().replaceFirst(" ", ""),
        //       questionImgUrl: fields[i][4].toString().replaceFirst(" ", ""),
        //       grade: fields[i][5].toString().replaceFirst(" ", ""),
        //       className: fields[i][6].toString().replaceFirst(" ", ""),
        //       subject: fields[i][7].toString().replaceFirst(" ", ""),
        //       learningStandard: fields[i][8].toString().replaceFirst(" ", ""),
        //       subLearningStandard:
        //           fields[i][9].toString().replaceFirst(" ", ""),
        //       scoringRubric: fields[i][10].toString().replaceFirst(" ", ""),
        //       customRubricImage: fields[i][11].toString().replaceFirst(" ", ""),
        //       assessmentImage: fields[i][12]
        //           .toString()
        //           .replaceAll("'", "")
        //           .replaceAll(" ", ""),

        //       //

        //       answerKey: fields[i][13].toString().replaceFirst(" ", ""),
        //       studentResponseKey:
        //           fields[i][14].toString().replaceFirst(" ", ""),
        //       presentationURL: fields[i][15].toString().replaceFirst(" ", "")));
        // }
        // for (int i = 0; i < csvList.length; i++) {
        //   listNew.add(StudentAssessmentInfo(
        //       subject: csvList[i].subject.toString().replaceFirst(" ", ""),
        //       assessmentImage: csvList[i]
        //           .assessmentImage
        //           .toString()
        //           .replaceAll("'", "")
        //           .replaceAll(" ", ""),
        //       className: csvList[i].className.toString().replaceFirst(" ", ""),
        //       customRubricImage:
        //           csvList[i].customRubricImage.toString().replaceFirst(" ", ""),
        //       grade: csvList[i].grade.toString().replaceFirst(" ", ""),
        //       learningStandard:
        //           csvList[i].learningStandard.toString().replaceFirst(" ", ""),
        //       pointPossible:
        //           csvList[i].pointPossible.toString().replaceFirst(" ", ""),
        //       questionImgUrl: csvList[i]
        //           .assessmentQuestionImg
        //           .toString()
        //           .replaceFirst(" ", ""),
        //       scoringRubric:
        //           csvList[i].scoringRubric.toString().replaceFirst(" ", ""),
        //       studentGrade:
        //           csvList[i].pointsEarned.toString().replaceFirst(" ", ""),
        //       studentId: csvList[i].id.toString().replaceFirst(" ", ""),
        //       studentName: csvList[i].name.toString().replaceFirst(" ", ""),
        //       subLearningStandard: csvList[i]
        //           .nyNextGenerationLearningStandard
        //           .toString()
        //           .replaceFirst(" ", ""),
        //       answerKey: csvList[i].answerKey.toString().replaceFirst(" ", ""),
        //       studentResponseKey: csvList[i]
        //           .studentResponseKey
        //           .toString()
        //           .replaceFirst(" ", ""),
        //       presentationURL:
        //           csvList[i].presentationURL.toString().replaceFirst(" ", "")));
        // }

        return listNew;
      }
      return [];
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  // // Function to map sheet data
  // mapAssessmentSheetData({required List fields}){
  //   try {
  //     //Mapping values to required Model
  //       List<StudentAssessmentInfo> listNew = [];
  //       if (Overrides.STANDALONE_GRADED_APP == true) {
  //         if (fields[0].length == 16) {
  //          for (var i = 0; i < fields.length; i++) {
  //         listNew.add(StudentAssessmentInfo(
  //             studentId: fields[i][0].toString().replaceFirst(" ", ""),
  //             studentName: fields[i][1].toString().replaceFirst(" ", ""),
  //             studentGrade: fields[i][2].toString().replaceFirst(" ", ""),
  //             pointPossible: fields[i][3].toString().replaceFirst(" ", ""),
  //             questionImgUrl: fields[i][4].toString().replaceFirst(" ", ""),
  //             grade: fields[i][5].toString().replaceFirst(" ", ""),
  //             className: fields[i][6].toString().replaceFirst(" ", ""),
  //             subject: fields[i][7].toString().replaceFirst(" ", ""),
  //             learningStandard: fields[i][8].toString().replaceFirst(" ", ""),
  //             subLearningStandard:
  //                 fields[i][9].toString().replaceFirst(" ", ""),
  //             scoringRubric: fields[i][10].toString().replaceFirst(" ", ""),
  //             customRubricImage: fields[i][11].toString().replaceFirst(" ", ""),
  //             assessmentImage: fields[i][12]
  //                 .toString()
  //                 .replaceAll("'", "")
  //                 .replaceAll(" ", ""),

  //             //

  //             answerKey: fields[i][13].toString().replaceFirst(" ", ""),
  //             studentResponseKey:
  //                 fields[i][14].toString().replaceFirst(" ", ""),
  //             presentationURL: fields[i][15].toString().replaceFirst(" ", "")));
  //       }
  //       }else if(fields[0].length == 13){
  //          for (var i = 0; i < fields.length; i++) {
  //         listNew.add(StudentAssessmentInfo(
  //             studentId: fields[i][0].toString().replaceFirst(" ", ""),
  //             studentName: fields[i][1].toString().replaceFirst(" ", ""),
  //             studentGrade: fields[i][2].toString().replaceFirst(" ", ""),
  //             pointPossible: fields[i][3].toString().replaceFirst(" ", ""),
  //             questionImgUrl: fields[i][4].toString().replaceFirst(" ", ""),
  //             grade: fields[i][5].toString().replaceFirst(" ", ""),
  //             className: fields[i][6].toString().replaceFirst(" ", ""),
  //             subject: fields[i][7].toString().replaceFirst(" ", ""),
  //             learningStandard: fields[i][8].toString().replaceFirst(" ", ""),
  //             subLearningStandard:
  //                 fields[i][9].toString().replaceFirst(" ", ""),
  //             scoringRubric: fields[i][10].toString().replaceFirst(" ", ""),
  //             customRubricImage: fields[i][11].toString().replaceFirst(" ", ""),
  //             assessmentImage: fields[i][12]
  //                 .toString()
  //                 .replaceAll("'", "")
  //                 .replaceAll(" ", "")

  //             //

  //         ));
  //       }

  //       }
  //       } else {
  //          if (fields[0].length == 16) {
  //          for (var i = 0; i < fields.length; i++) {
  //         listNew.add(StudentAssessmentInfo(
  //             studentId: fields[i][0].toString().replaceFirst(" ", ""),
  //             studentName: fields[i][1].toString().replaceFirst(" ", ""),
  //             studentGrade: fields[i][2].toString().replaceFirst(" ", ""),
  //             pointPossible: fields[i][3].toString().replaceFirst(" ", ""),
  //             questionImgUrl: fields[i][4].toString().replaceFirst(" ", ""),
  //             grade: fields[i][5].toString().replaceFirst(" ", ""),
  //             className: fields[i][6].toString().replaceFirst(" ", ""),
  //             subject: fields[i][7].toString().replaceFirst(" ", ""),
  //             learningStandard: fields[i][8].toString().replaceFirst(" ", ""),
  //             subLearningStandard:
  //                 fields[i][9].toString().replaceFirst(" ", ""),
  //             scoringRubric: fields[i][10].toString().replaceFirst(" ", ""),
  //             customRubricImage: fields[i][11].toString().replaceFirst(" ", ""),
  //             assessmentImage: fields[i][12]
  //                 .toString()
  //                 .replaceAll("'", "")
  //                 .replaceAll(" ", ""),

  //             //

  //             answerKey: fields[i][13].toString().replaceFirst(" ", ""),
  //             studentResponseKey:
  //                 fields[i][14].toString().replaceFirst(" ", ""),
  //             presentationURL: fields[i][15].toString().replaceFirst(" ", "")));
  //       }
  //       }else if(fields[0].length == 13){
  //          for (var i = 0; i < fields.length; i++) {
  //         listNew.add(StudentAssessmentInfo(
  //             studentId: fields[i][0].toString().replaceFirst(" ", ""),
  //             studentName: fields[i][1].toString().replaceFirst(" ", ""),
  //             studentGrade: fields[i][2].toString().replaceFirst(" ", ""),
  //             pointPossible: fields[i][3].toString().replaceFirst(" ", ""),
  //             questionImgUrl: fields[i][4].toString().replaceFirst(" ", ""),
  //             grade: fields[i][5].toString().replaceFirst(" ", ""),
  //             className: fields[i][6].toString().replaceFirst(" ", ""),
  //             subject: fields[i][7].toString().replaceFirst(" ", ""),
  //             learningStandard: fields[i][8].toString().replaceFirst(" ", ""),
  //             subLearningStandard:
  //                 fields[i][9].toString().replaceFirst(" ", ""),
  //             scoringRubric: fields[i][10].toString().replaceFirst(" ", ""),
  //             customRubricImage: fields[i][11].toString().replaceFirst(" ", ""),
  //             assessmentImage: fields[i][12]
  //                 .toString()
  //                 .replaceAll("'", "")
  //                 .replaceAll(" ", "")

  //             //

  //         ));
  //       }

  //       }else{
  //         for (var i = 0; i < fields.length; i++) {
  //         listNew.add(StudentAssessmentInfo(
  //             //studentId: fields[i][0].toString().replaceFirst(" ", ""),
  //             studentName: fields[i][0].toString().replaceFirst(" ", ""),
  //             studentGrade: fields[i][1].toString().replaceFirst(" ", ""),
  //             pointPossible: fields[i][2].toString().replaceFirst(" ", ""),
  //             questionImgUrl: fields[i][3].toString().replaceFirst(" ", ""),
  //             grade: fields[i][4].toString().replaceFirst(" ", ""),
  //             className: fields[i][5].toString().replaceFirst(" ", ""),
  //             subject: fields[i][6].toString().replaceFirst(" ", ""),
  //             learningStandard: fields[i][7].toString().replaceFirst(" ", ""),
  //             subLearningStandard:
  //                 fields[i][8].toString().replaceFirst(" ", ""),
  //             scoringRubric: fields[i][9].toString().replaceFirst(" ", ""),
  //             customRubricImage: fields[i][10].toString().replaceFirst(" ", ""),
  //             assessmentImage: fields[i][11]
  //                 .toString()
  //                 .replaceAll("'", "")
  //                 .replaceAll(" ", "")

  //             //

  //         ));
  //       }

  //       }

  //       }

  //   } catch (e) {

  //   }
  // }

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
      final ResponseModel response = await _dbServices.postApi(
          "${OcrOverrides.OCR_API_BASE_URL}/refreshGoogleAuthentication",
          body: body,
          isGoogleApi: true);
      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        var newToken = response.data['body']; //["access_token"]
        //!=null?response.data['body']["access_token"]:response.data['body']["error"];
        if (newToken["access_token"] != null) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          UserInformation updatedObj = UserInformation(
              userName: _userProfileLocalData[0].userName,
              userEmail: _userProfileLocalData[0].userEmail,
              profilePicture: _userProfileLocalData[0].profilePicture,
              refreshToken: _userProfileLocalData[0].refreshToken,
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
    print(imgExtension);
    Map body = {
      "bucket": "graded/$section",
      "fileExtension": imgExtension,
      "image": imgBase64
    };
    // Map<String, String> headers = {
    //   'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
    // };

    final ResponseModel response = await _dbServices.postApi(
        "${OcrOverrides.OCR_API_BASE_URL}/uploadImage",
        body: body,
        // headers: headers,
        isGoogleApi: true);

    if (response.statusCode != 401 &&
        response.statusCode == 200 &&
        response.data['statusCode'] != 500) {
      print("image response recived");
      return response.data['body']['Location'];
    } else if ((response.statusCode == 401 ||
            response.data['statusCode'] == 500) &&
        _totalRetry < 3) {
      _totalRetry++;
      return await _uploadImgB64AndGetUrl(
          imgBase64: imgBase64, imgExtension: imgExtension, section: section);
    }
    return "";
  }

  deleteFirstSlide(
      {String? presentationId,
      String? accessToken,
      String? refreshToken}) async {
    Map body = {
      "requests": [
        {
          "deleteObject": {"objectId": "p"}
        }
      ]
    };
    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    try {
      final ResponseModel response = await _dbServices.postApi(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        return true;
      } else if ((response.statusCode == 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        _totalRetry++;
        //To regernerate fresh access token
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          bool result = await deleteFirstSlide(
            presentationId: presentationId,
            accessToken: _userProfileLocalData[0].authorizationToken,
            refreshToken: _userProfileLocalData[0].refreshToken,
          );
          return result;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<String> createSlideOnDrive(
      {String? name,
      String? folderId,
      String? accessToken,
      String? refreshToken}) async {
    Map body = {
      'name': name,
      'mimeType': 'application/vnd.google-apps.presentation',
      'parents': ['$folderId']
    };
    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json; charset=UTF-8'
    };

    try {
      final ResponseModel response = await _dbServices.postApi(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files',
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        deleteFirstSlide(
            accessToken: accessToken,
            refreshToken: refreshToken,
            presentationId: response.data['body']['id']);
        return response.data['body']['id'];
      } else if ((response.statusCode == 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        _totalRetry++;
        //To regernerate fresh access token
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          String result = await createSlideOnDrive(
            name: name!,
            folderId: folderId,
            accessToken: _userProfileLocalData[0].authorizationToken,
            refreshToken: _userProfileLocalData[0].refreshToken,
          );
          return result;
        } else {
          return 'ReAuthentication is required';
        }
      }
      return '';
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future createBlankSlidesInGooglePresentation(
      String? presentationId, String? accessToken, String? refreshToken,
      {List<StudentAssessmentInfo>? studentRecordList,
      required bool isFromHistoryAssessment,
      required bool? isScanMore}) async {
    try {
      Map body = {
        //Adding no. of blank slides as per the length of student records
        "requests": await prepareEachSlideObjects(
            list: studentRecordList,
            isFromHistoryAssessment: isFromHistoryAssessment,
            isScanMore: isScanMore)
      };

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };

      final ResponseModel response = await _dbServices.postApi(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode == 200 && response.data["statusCode"] == 200) {
        return 'Done';
      } else if (response.statusCode == 401 && _totalRetry < 3) {
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          String result = await createBlankSlidesInGooglePresentation(
              presentationId,
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken,
              studentRecordList: studentRecordList,
              isFromHistoryAssessment: isFromHistoryAssessment,
              isScanMore: isScanMore);
          return result;
        } else {
          return 'ReAuthentication is required';
        }
      }
      return response.statusCode;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateAssessmentImageToSlidesOnDrive(
      String? presentationId,
      String? accessToken,
      String? refreshToken,
      List<StudentAssessmentInfo> assessmentData) async {
    try {
      Map body = {
        "requests":
            prepareRequestBodyToUpdateSlideImage(assessmentData: assessmentData)
      };

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };

      final ResponseModel response = await _dbServices.postApi(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          body: body,
          headers: headers,
          isGoogleApi: true);
      if (response.statusCode == 200) {
        return 'Done';
      } else if (response.statusCode == 401 && _totalRetry < 3) {
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          String result = await updateAssessmentImageToSlidesOnDrive(
              presentationId,
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken,
              assessmentData);
          return result;
        } else {
          return 'ReAuthentication is required';
        }
      }
      return response.statusCode.toString();
    } catch (e) {
      return e.toString();
    }
  }

  List<Map> prepareRequestBodyToUpdateSlideImage(
      {required List<StudentAssessmentInfo> assessmentData}) {
    List<Map> body = [];
    assessmentData.asMap().forEach((index, element) {
      if (element.slideObjectId != "AlreadyUpdated") {
        Map obj = {
          "createImage": {
            "url": element.assessmentImage,
            "elementProperties": {
              "pageObjectId": element.slideObjectId,
            },
            "objectId": DateTime.now().microsecondsSinceEpoch.toString()
          }
        };
        body.add(obj);
      }
    });

    return body;
  }

  Future<List<Map>> prepareEachSlideObjects(
      {List<StudentAssessmentInfo>? list,
      required bool isFromHistoryAssessment,
      required bool? isScanMore}) async {
    LocalDatabase<StudentAssessmentInfo> _studentInfoDb = LocalDatabase(
        isFromHistoryAssessment == true
            ? 'history_student_info'
            : 'student_info');
    List<StudentAssessmentInfo> assessmentData =
        list == null ? await _studentInfoDb.getData() : list;

    //Preparing very first slide to add assignment details //Blank slide with the type mentioned // request body will be blank in case of history as details already added
    List<Map> slideObjects = isFromHistoryAssessment || isScanMore == true
        ? []
        : [
            {
              "createSlide": {
                "objectId": "Slide1",
                "slideLayoutReference": {"predefinedLayout": "TITLE_ONLY"},
                "placeholderIdMappings": [
                  {
                    "layoutPlaceholder": {"type": "TITLE"},
                    "objectId": "Title1"
                  }
                ]
              }
            }
          ];
    print(slideObjects);
    assessmentData.asMap().forEach((index, element) async {
      if (element.slideObjectId == null || element.slideObjectId!.isEmpty) {
        String uniqueId = DateTime.now().microsecondsSinceEpoch.toString();

        // Preparing blank slide type to add assessment images
        Map slideObject = {
          "createSlide": {
            "objectId": uniqueId,
            "slideLayoutReference": {"predefinedLayout": "BLANK"}
          }
        };

        slideObjects.add(slideObject);
        element.slideObjectId = uniqueId;

        //updating local database with slideObjectId
        await _studentInfoDb.putAt(index, element);
      } else {
        element.slideObjectId = "AlreadyUpdated";
        await _studentInfoDb.putAt(index, element);
      }
    });
    return slideObjects;
  }

//Used to update assessment detail on very slide of the google presentation
  Future<String> _updateAssignmentDetailsOnSlide(
      String? presentationId,
      String? accessToken,
      String? refreshToken,
      String? slideObjectId,
      StudentAssessmentInfo studentAssessmentInfoObj) async {
    try {
      var body = {
        "requests": await _getListOfAssignmentDetails(
            assignmentName: Globals.assessmentName,
            studentAssessmentInfoObj: studentAssessmentInfoObj)
      };

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };

      final ResponseModel response = await _dbServices.postApi(
          'https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          body: body,
          headers: headers,
          isGoogleApi: true);
      if (response.statusCode == 200) {
        return 'Done';
      } else if (response.statusCode == 401 && _totalRetry < 3) {
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          String result = await _updateAssignmentDetailsOnSlide(
              presentationId,
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken,
              slideObjectId,
              studentAssessmentInfoObj);
          return result;
        } else {
          return 'ReAuthentication is required';
        }
      }
      return response.statusCode.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<Map>> _getListOfAssignmentDetails(
      {required String? assignmentName,
      required StudentAssessmentInfo studentAssessmentInfoObj}) async {
    // List of title for slide details table
    List<String> listOfFields = [
      'Subject',
      'Grade',
      'Class',
      'Domain',
      'Sub-Domain'
    ];

    // start adding request objects in list
    List<Map> body = [
      //to update the assignment title
      {
        "insertText": {"objectId": "Title1", "text": "$assignmentName"}
      },

      //prepare blank table on slide
      {
        "createTable": {
          "objectId": "123456",
          "elementProperties": {"pageObjectId": "Slide1"},
          "rows": listOfFields.length, //pass no. of names
          "columns": 2 //key:value
        }
      }
    ];

// To update table cells with title and value
    listOfFields.asMap().forEach((rowIndex, value) {
      for (int columnIndex = 0; columnIndex < 2; columnIndex++) {
        body.add(
          {
            "insertText": {
              "objectId": "123456",
              "cellLocation": {
                "rowIndex": rowIndex,
                "columnIndex": columnIndex
              },
              "text": columnIndex == 0
                  ? listOfFields[rowIndex] //Keys
                  : prepareTableCellValue(
                      studentAssessmentInfoObj, rowIndex) //Values
            }
          },
        );
      }
    });

    return body;
  }

  String prepareTableCellValue(
      StudentAssessmentInfo studentAssessmentInfoObj, int index) {
    // detail update on cell in slide table
    Map map = {
      0: studentAssessmentInfoObj.subject ?? 'NA',
      1: studentAssessmentInfoObj.grade ?? 'NA',
      2: studentAssessmentInfoObj.className ?? 'NA',
      3: studentAssessmentInfoObj.learningStandard ?? 'NA',
      4: studentAssessmentInfoObj.subLearningStandard ?? 'NA',
    };

    return map[index] ?? 'NA';
  }
}
