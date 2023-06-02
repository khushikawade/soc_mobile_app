// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/fetch_google_sheet.dart';
import 'package:Soc/src/modules/google_drive/google_drive_access.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/google_drive/model/assessment_detail_modal.dart';
import 'package:Soc/src/modules/google_drive/model/spreadsheet_model.dart';
import 'package:Soc/src/modules/google_drive/overrides.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/db_service.dart';
import 'package:path/path.dart';
import '../../google_classroom/google_classroom_globals.dart';
import '../../graded_plus/modal/custom_rubic_modal.dart';
import '../../graded_plus/modal/student_assessment_info_modal.dart';

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
    // print("drive bloc event recived ---------------->> $event");

    // --------------------Event To Get Google Drive Folder ID------------------
    if (event is GetDriveFolderIdEvent) {
      try {
        var folderObject;

        //isReturnState is used to check if the we are waiting for state on UI or not to move further
        if (event.isReturnState!) {
          yield GoogleDriveLoading();
        }
        //  folderObject = await _getGoogleDriveFolderId(
        //     token: event.token, folderName: event.folderName);

        // To get updated auth toke for google login
        await _toRefreshAuthenticationToken(event.refreshToken ?? '');
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        //Get Folder Id if folder already exist
        folderObject = await _getGoogleDriveFolderId(
            token: _userProfileLocalData[0].authorizationToken, // event.token,
            folderName: event.folderName,
            refreshToken: _userProfileLocalData[0]
                .authorizationToken); // event.refreshToken);

        //Condition To Create Folder In Case Of It Is Not Exist
        if (folderObject != 401 && folderObject != 500) {
          //Which means folder API return 200 but folder not found
          if (folderObject.length == 0) {
            //Create the folder now
            String? folderId = await _createFolderOnDrive(
                token: _userProfileLocalData[0].authorizationToken,
                folderName: event.folderName);

            if (event.isReturnState! && (folderId?.isNotEmpty ?? false)) {
              //fromGradedPlusAssessmentSection is used to check if API call from assessment section or not //Used in Graded+ //No used in PBIS+
              yield GoogleSuccess(
                  fromGradedPlusAssessmentSection:
                      event.fromGradedPlusAssessmentSection);
            }
          } else {
            // Globals.googleDriveFolderId = folderObject['id'];
            // Globals.googleDriveFolderPath = folderObject['webViewLink'];

            //FOR GRADED+
            if (event.folderName == "SOLVED GRADED+") {
              Globals.googleDriveFolderId = folderObject['id'];
              Globals.googleDriveFolderPath = folderObject['webViewLink'];
            } else if (event.folderName == "SOLVED PBIS+") {
              //FOR PBIS PLUS
              PBISPlusOverrides.pbisPlusGoogleDriveFolderId =
                  folderObject['id'];
              PBISPlusOverrides.pbisPlusGoogleDriveFolderPath =
                  folderObject['webViewLink'];
            }

            if (event.isReturnState! &&
                (folderObject['id'].isNotEmpty == true)) {
              //fromGradedPlusAssessmentSection is used to check if API call from assessment section or not //Used in Graded+ //No used in PBIS+
              yield GoogleSuccess(
                  fromGradedPlusAssessmentSection:
                      event.fromGradedPlusAssessmentSection);
            }

            //Used to fetch Graded+ assessment history
            if (event.fetchHistory == true) {
              GetHistoryAssessmentFromDrive(
                  filterType: event.filterType!, isSearchPage: false);
            }
          }
        } else {
          // To Refresh Authentication Token In Case Of Auth Token Expired
          var result = await _toRefreshAuthenticationToken(event.refreshToken!);
          if (result == true) {
            List<UserInformation> _userProfileLocalData =
                await UserGoogleProfile.getUserProfile();

            GetDriveFolderIdEvent(
                isReturnState: true,
                token: _userProfileLocalData[0].authorizationToken,
                folderName: event.folderName,
                refreshToken: _userProfileLocalData[0].refreshToken);

            //fromGradedPlusAssessmentSection is used to check if API call from assessment section or not //Used in Graded+ //No used in PBIS+
            yield GoogleSuccess(
                fromGradedPlusAssessmentSection:
                    event.fromGradedPlusAssessmentSection);
          } else {
            yield ErrorState(
                errorMsg: 'ReAuthentication is required',
                isAssessmentSection: event.fromGradedPlusAssessmentSection);
          }
        }

        //Return the final state of Folder Created
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

    // // --------------------Event To Create Excel Sheet On Drive------------------
    // else if (event is CreateExcelSheetToDrive) {
    //   try {
    //     yield GoogleDriveLoading();
    //     List<UserInformation> _userProfileLocalData =
    //         await UserGoogleProfile.getUserProfile();

    //     // Globals.assessmentName = event.name;

    //     // String result = await createSheetOnDrive(
    //     //   isMcqSheet: event.isMcqSheet,
    //     //   name: event.name!,
    //     //   folderId: Globals.googleDriveFolderId,
    //     //   accessToken: _userProfileLocalData[0].authorizationToken,
    //     //   refreshToken: _userProfileLocalData[0].refreshToken,
    //     // );

    //     final List result = await createSheetOnDrive(
    //       isMcqSheet: event.isMcqSheet,
    //       name: event.name!,
    //       folderId: event.folderId,
    //       accessToken: _userProfileLocalData[0].authorizationToken,
    //       refreshToken: _userProfileLocalData[0].refreshToken,
    //     );

    //     if (result[1] == '') {
    //       //Managing extra state to call the same event again in case of token expired
    //       yield RecallTheEvent();
    //     } else if (result[1] == 'ReAuthentication is required') {
    //       yield ErrorState(
    //         errorMsg: 'ReAuthentication is required',
    //       );
    //     } else if (result[0]) {
    //       yield ExcelSheetCreated(googleSpreadSheetFileId: result[1]);
    //     }
    //   } on SocketException catch (e) {
    //     yield ErrorState(errorMsg: e.toString());
    //     rethrow;
    //   } catch (e) {
    //     yield ErrorState(errorMsg: e.toString());
    //     throw (e);
    //   }
    // }
    // --------------------Event To Create Excel Sheet On Drive------------------
    else if (event is CreateExcelSheetToDrive) {
      try {
        yield GoogleDriveLoading();
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        final List result = await createSheetOnDrive(
            description: event.description ?? '',
            name: event.name ?? '',
            folderId: event.folderId,
            userProfile: _userProfileLocalData[0]);

        if (result[0]) {
          yield ExcelSheetCreated(googleSpreadSheetFileObj: result[1]);
        } else {
          yield ErrorState(errorMsg: result[1]);
        }
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

        // List<StudentAssessmentInfo> assessmentDataList =
        //     await event.studentInfoDb.getData();

        List<StudentAssessmentInfo> assessmentDataList =
            List.unmodifiable(await event.studentInfoDb.getData());
        for (var i = 0; i < assessmentDataList.length; i++) {
          if ((assessmentDataList[i].assessmentImage == null ||
                  assessmentDataList[i].assessmentImage!.isEmpty) &&
              (assessmentDataList[i].assessmentImgPath?.isNotEmpty ?? false)) {
            String imgExtension = assessmentDataList[i]
                .assessmentImgPath!
                .substring(
                    assessmentDataList[i].assessmentImgPath!.lastIndexOf(".") +
                        1);

            File assessmentImageFile =
                File(assessmentDataList[i].assessmentImgPath!);

            List<int> imageBytes = assessmentImageFile.readAsBytesSync();

            String imageB64 = base64Encode(imageBytes);

            String? imgUrl = await uploadImgB64AndGetUrl(
                imgBase64: imageB64,
                imgExtension: imgExtension,
                section: "assessment-sheet");

            if (imgUrl?.isNotEmpty ?? false) {
              assessmentDataList[i].assessmentImage = imgUrl;
              await event.studentInfoDb.putAt(i, assessmentDataList[i]);
            }
          }
        }

        // Create new Google presentation in case already not exist // Will work for all the existing assessment which are not having already google slide presentation in case of scan more
        if (event.slidePresentationId == 'NA') {
          //To create Google Presentation
          List result = await createSlideOnDrive(
            isMcqSheet: event.isMcqSheet,
            excelSheetId: Globals.googleExcelSheetId,
            name: event.assessmentName, //event.fileTitle!,
            folderId: Globals.googleDriveFolderId,
            accessToken: _userProfileLocalData[0].authorizationToken,
            refreshToken: _userProfileLocalData[0].refreshToken,
          );

          //
          // await createBlankSlidesInGooglePresentation(
          //     googleSlideId,
          //     _userProfileLocalData[0].authorizationToken,
          //     _userProfileLocalData[0].refreshToken,
          //     isFromHistoryAssessment: false, //event.isFromHistoryAssessment,
          //     studentRecordList: assessmentData,
          //     isScanMore: false);

          //
          // await updateAssessmentImageToSlidesOnDrive(
          //     googleSlideId,
          //     _userProfileLocalData[0].authorizationToken,
          //     _userProfileLocalData[0].refreshToken,
          //     assessmentData,
          //     _studentInfoDb);
          //To add one or more blank slides in Google Presentation
//To update scanned images in the Google Slides
          await addAndUpdateStudentAssessmentDetailsToSlide(
              presentationId: result[1] ?? '',
              accessToken: _userProfileLocalData[0].authorizationToken ?? '',
              refreshToken: _userProfileLocalData[0].refreshToken ?? '',
              studentInfoDb: event.studentInfoDb,
              isScanMore: false);

          //Used to update assessment detail on very fisrt slide of the google presentation
          await _updateAssignmentDetailsOnSlide(
              result[1] ?? '',
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken,
              '12345',
              event.studentInfoDb,
              // assessmentDataList[0],
              event.assessmentName);

          //Get the Google Presentation URL
          List res = await _getShareableLink(
            fileId: result[1],
            token: _userProfileLocalData[0].authorizationToken!,
            refreshToken: _userProfileLocalData[0].refreshToken,
          );

          if (res[0]) {
            // update googleslidespresentaion url on student info data list to update the Google Excel Sheet
            // assessmentDataList.forEach((element) {
            //   if ((element.googleSlidePresentationURL?.isEmpty ?? true) ||
            //       element.googleSlidePresentationURL == 'NA') {
            //     element.googleSlidePresentationURL = res[1];
            //   }
            // });
            if ((assessmentDataList?.isNotEmpty ?? false) &&
                ((assessmentDataList
                            .first?.googleSlidePresentationURL?.isEmpty ??
                        true) ||
                    (assessmentDataList.first.googleSlidePresentationURL ==
                        'NA'))) {
              assessmentDataList.first.googleSlidePresentationURL = res[1];
            }
            yield GoogleSheetUpdateOnScanMoreSuccess(
                list: List.from(assessmentDataList));
          } else {
            yield ErrorState(errorMsg: res[1].toString());
          }
        } else {
          //Execute when presentation already exist and we need to add only new slides for new scans
          // for (int index = 0;
          //     index < event.lastAssessmentLength &&
          //         index < assessmentDataList.length;
          //     index++) {
          //   assessmentDataList[index].isSlideObjUpdated = true;
          //   await event.studentInfoDb.putAt(index, assessmentDataList[index]);
          // }
          // print(assessmentDataList);
          // //To create Google Presentation
          // await createBlankSlidesInGooglePresentation(
          //     event.slidePresentationId,
          //     _userProfileLocalData[0].authorizationToken,
          //     _userProfileLocalData[0].refreshToken,
          //     studentRecordList: list,
          //     isFromHistoryAssessment: event.isFromHistoryAssessment,
          //     isScanMore: true);

          //To create Google Presentation
          //To update scanned images in the Google Slides
          String result = await addAndUpdateStudentAssessmentDetailsToSlide(
              presentationId: event.slidePresentationId ?? '',
              accessToken: _userProfileLocalData[0].authorizationToken ?? '',
              refreshToken: _userProfileLocalData[0].refreshToken ?? '',
              studentInfoDb: event.studentInfoDb,
              isScanMore: true);
          if (result == "Done") {
            yield GoogleSheetUpdateOnScanMoreSuccess(
                list: List.from(assessmentDataList));
          } else {
            yield ErrorState(errorMsg: result.toString());
          }
          //}

          // yield GoogleSheetUpdateOnScanMoreSuccess(list: assessmentData);
        }

        //Saving Scanned images to database for dashboard management //also using to train model
        Utility.updateAssessmentToDb(
            studentInfoList: List.from(assessmentDataList),
            //assessmentId: Globals.historyAssessmentId,
            assessmentId: GoogleClassroomGlobals
                    .studentAssessmentAndClassroomObj.assessmentCId ??
                '');
        // yield ErrorState(errorMsg: 'ReAuthentication is required');
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

            String imgUrl = await uploadImgB64AndGetUrl(
                imgBase64: imageB64,
                imgExtension: imgExtension,
                section: "assessment-sheet");

            imgUrl != ""
                ? assessmentData[i].assessmentImage = imgUrl
                : print("error");
          }

          if ((assessmentData[i].customRubricImage == null ||
                  assessmentData[i].customRubricImage!.isEmpty) &&
              customRubicLocalData.isNotEmpty) {
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

                String imgUrl = await uploadImgB64AndGetUrl(
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

//Check the question image and generate the image URL in case found empty
          if ((i == 0) &&
              (assessmentData[0]?.questionImgUrl?.isEmpty ?? true) &&
              (assessmentData[0]?.questionImgFilePath?.isNotEmpty ?? false)) {
            File questionImgFilePath =
                File(assessmentData[0].questionImgFilePath ?? '');

            String imgExtension = questionImgFilePath.path
                .substring(questionImgFilePath!.path.lastIndexOf(".") + 1);

            List<int> imageBytes = questionImgFilePath!.readAsBytesSync();

            String imageB64 = base64Encode(imageBytes);

            String questionImgUrl = await uploadImgB64AndGetUrl(
                imgBase64: imageB64,
                imgExtension: imgExtension,
                section: 'rubric-score');

            if (questionImgUrl?.isNotEmpty ?? false) {
              assessmentData[0].questionImgUrl = questionImgUrl;
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
                learningStandard:
                    "Domain", // Update as shared by client "Learning Standard",
                subLearningStandard:
                    "Learning Standard", // Update as shared by client , "NY Next Generation Learning Standard",
                scoringRubric: "Scoring Rubric",
                customRubricImage: "Custom Rubric Image",
                standardDescription: "Standard Description",
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
        yield ErrorState(errorMsg: e.toString());
        throw (e);
      }
    }

    if (event is GetHistoryAssessmentFromDrive) {
      try {
        LocalDatabase<HistoryAssessment> _localDb = LocalDatabase(
            event.filterType == "All"
                ? "HistoryAssessment"
                : (event.filterType == "Multiple Choice"
                    ? "MultipleChoiceAssessment"
                    : "ConstructedResponseAssessment"));

        List<HistoryAssessment>? _localData = await _localDb.getData();

        //Clear news notification local data to manage loading issue
        SharedPreferences clearNewsCache =
            await SharedPreferences.getInstance();
        final clearCacheResult = await clearNewsCache
            .getBool('delete_local_history_assessment_cache');

        if (clearCacheResult != true) {
          await _localDb.close();
          _localData.clear();
          await clearNewsCache.setBool(
              'delete_local_history_assessment_cache', true);
        }

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
        List<HistoryAssessment> spreadsheetList = [];

        if (Globals.googleDriveFolderId != null &&
            Globals.googleDriveFolderId != "") {
          List pair = await _fetchHistoryAssessment(
              isSearchPage: event.isSearchPage,
              filterType: event.filterType,
              token: _userProfileLocalData[0].authorizationToken,
              isPagination: false,
              folderId: Globals.googleDriveFolderId,
              searchKey: event.searchKeyword ?? "");
          List<HistoryAssessment>? mainListWithSlideAndSheet =
              pair != null && pair.length > 0 ? pair[0] : [];
          if (mainListWithSlideAndSheet == null) {
            yield ErrorState(errorMsg: 'ReAuthentication is required');
          } else {
            List<HistoryAssessment>? slideList = [];

            //--start
            mainListWithSlideAndSheet.forEach((element) {
              //Separate SpreadSheet from the drive folder
              if (element.label['trashed'] != true &&
                      ((element.description == "Graded+"
                          // ||
                          //         element.description ==
                          //             "Constructed Response sheet"
                          ) ||
                          element.description ==
                              'Assessment \'${element.title}\' result has been generated.') ||
                  element.description == "Multiple Choice Sheet") {
                spreadsheetList.add(element);
              }
              //Separate Slide from the drive folder having some description
              else if (element.label['trashed'] != true &&
                  element.description != null &&
                  element.description!.isNotEmpty) {
                slideList.add(element);
              }
            });
            //  --End

            spreadsheetList.forEach((element) {
              slideList.forEach((item) {
                if (item.description!.contains(element.fileId!)) {
                  element.presentationLink = item.webContentLink;
                }
              });
            });

            //Sort the list as per the modified date
            if (event.searchKeyword == null || event.searchKeyword!.isEmpty) {
              spreadsheetList = await listSort(spreadsheetList);
            }

            spreadsheetList != null && spreadsheetList.length > 0
                ? await _localDb.clear()
                : print("");

            spreadsheetList.forEach((HistoryAssessment e) async {
              await _localDb.addData(e);
            });

            yield GoogleDriveGetSuccess(
                obj: spreadsheetList,
                nextPageLink: pair != null && pair.length > 1 ? pair[1] : '');
          }
        } else {
          GetDriveFolderIdEvent(
              filterType: event.filterType,
              isReturnState: false,
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
        List<HistoryAssessment> spreadsheetList = [];

        if (Globals.googleDriveFolderId != null) {
          List pair = await _fetchHistoryAssessment(
              isSearchPage: false,
              filterType: event.filterType, //   "All",
              token: _userProfileLocalData[0].authorizationToken,
              folderId: Globals.googleDriveFolderId,
              isPagination: true,
              nextPageUrl: event.nextPageUrl,
              searchKey: "");
          List<HistoryAssessment>? mainListWithSlideAndSheet =
              pair != null && pair.length > 0 ? pair[0] : [];
          if (mainListWithSlideAndSheet == null) {
            yield ErrorState(errorMsg: 'ReAuthentication is required');
          } else {
            List<HistoryAssessment>? slideList = [];

            //Separate Spreadsheet and Slide
            //------Start
            mainListWithSlideAndSheet.forEach((element) {
              if (element.label['trashed'] != true &&
                      ((element.description == "Graded+"
                          // ||
                          //         element.description ==
                          //             "Constructed Response sheet"
                          ) ||
                          element.description ==
                              'Assessment \'${element.title}\' result has been generated.') ||
                  element.description == "Multiple Choice Sheet") {
                spreadsheetList.add(element);
              } else if (element.label['trashed'] != true &&
                  element.description != null &&
                  element.description!.isNotEmpty) {
                slideList.add(element);
              }
            });
            //------End

            spreadsheetList.forEach((element) {
              slideList.forEach((item) {
                if (item.description!.contains(element.fileId!)) {
                  element.presentationLink = item.webContentLink;
                }
              });
            });
            //Sort the list as per the modified date
            spreadsheetList = await listSort(spreadsheetList);
            List<HistoryAssessment> updatedAssessmentList = event.obj;
            updatedAssessmentList.addAll(spreadsheetList);
            yield ShareLinkReceived(shareLink: '');
            yield GoogleDriveGetSuccess(
                obj: updatedAssessmentList,
                nextPageLink: pair != null && pair.length > 1 ? pair[1] : '');
          }
        } else {
          GetDriveFolderIdEvent(
              filterType: event.filterType,
              isReturnState: false,
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
        // print(event.getImageUrl);
        String imgUrl = await uploadImgB64AndGetUrl(
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
        String imgUrl = await uploadImgB64AndGetUrl(
            imgBase64: event.imgBase64,
            imgExtension: event.imgExtension,
            section: "assessment-sheet");

        if (imgUrl != "") {
          LocalDatabase<StudentAssessmentInfo> _studentInfoDb = LocalDatabase(
              event.isHistoryAssessmentSection == true
                  ? 'history_student_info'
                  : 'student_info');

          List<StudentAssessmentInfo> studentInfo =
              await OcrUtility.getStudentInfoList(
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
    if (event is QuestionImgToAwsBucket) {
      try {
        // yield GoogleDriveLoading();

        String imgExtension = event.imageFile!.path
            .substring(event.imageFile!.path.lastIndexOf(".") + 1);
        List<int> imageBytes = event.imageFile!.readAsBytesSync();
        String imageB64 = base64Encode(imageBytes);

        String questionImgUrl = await uploadImgB64AndGetUrl(
            imgBase64: imageB64,
            imgExtension: imgExtension,
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

        List res = await _getShareableLink(
            fileId: event.fileId ?? '',
            refreshToken: _userProfileLocalData[0].refreshToken,
            token: _userProfileLocalData[0].authorizationToken!);

        if (res[0]) {
          if (!event.slideLink) {
            Globals.shareableLink = res[1];
          } else {
            yield ShareLinkReceived(shareLink: res[1]);
          }
        } else {
          yield ErrorState(errorMsg: res[1]);
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

    if (event is CreateSlideToDrive) {
      try {
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        List result = await createSlideOnDrive(
            isMcqSheet: event.isMcqSheet,
            name: event.fileTitle!,
            folderId: Globals.googleDriveFolderId,
            accessToken: _userProfileLocalData[0].authorizationToken,
            refreshToken: _userProfileLocalData[0].refreshToken,
            excelSheetId: event.excelSheetId
            //  image: file
            );
        if (result[0]) {
          yield GoogleSlideCreated(slideFiledId: result[1]);
        } else {
          yield ErrorState(errorMsg: result[1]);
        }
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
      }
    }

//Used to update first slide of the presentation only
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
            event.studentAssessmentInfoDB,
            Globals.assessmentName ?? '');

        if (result == "Done") {
          yield UpdateAssignmentDetailsOnSlideSuccess();
        } else {
          yield ErrorState(errorMsg: result.toString());
        }
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
      }
    }

//Performing both create and update detail to slide together
    if (event is AddAndUpdateAssessmentImageToSlidesOnDrive) {
      try {
        yield ShowLoadingDialog();

        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        // LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
        //     LocalDatabase('student_info');
        List<StudentAssessmentInfo> assessmentData =
            await event.studentInfoDb.getData();

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

            String imgUrl = await uploadImgB64AndGetUrl(
                imgBase64: imageB64,
                imgExtension: imgExtension,
                section: "assessment-sheet");

            if (imgUrl?.isNotEmpty ?? false) {
              assessmentData[i].assessmentImage = imgUrl;
              await event.studentInfoDb.putAt(i, assessmentData[i]);
            }
          }
        }

        String result = await addAndUpdateStudentAssessmentDetailsToSlide(
            presentationId: event.slidePresentationId ?? '',
            accessToken: _userProfileLocalData[0].authorizationToken ?? '',
            refreshToken: _userProfileLocalData[0].refreshToken ?? '',
            studentInfoDb: event.studentInfoDb,
            isScanMore: event.isScanMore);

        if (result == "Done") {
          yield AddAndUpdateStudentAssessmentDetailsToSlideSuccess();
        } else {
          yield ErrorState(errorMsg: result.toString());
        }
      } catch (e) {
        yield ErrorState(errorMsg: e.toString());
      }
    }
//

    //deleting slide from presentation
    if (event is DeleteSlideFromPresentation) {
      try {
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        deleteSlide(
          slideObjId: event.slideObjId!,
          presentationId: event.slidePresentationId,
          refreshToken: _userProfileLocalData[0].refreshToken,
          accessToken: _userProfileLocalData[0].authorizationToken,
        );
      } catch (e) {
        print(e);
      }
    }

    if (event is EditSlideFromPresentation) {
      try {
        //updating the student record on sldies
        List<UserInformation> _userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        // var newSlideIndex = null;

        // if (event.oldSlideIndex != null) {
        //   print("olde index is available ${event.oldSlideIndex}");
        //   List<StudentAssessmentInfo> allStudents =
        //       await OcrUtility.getStudentInfoList(
        //           isEdit: true, tableName: Strings.studentInfoDbName);

        //   allStudents
        //       .asMap()
        //       .forEach((int index, StudentAssessmentInfo student) {
        //     if (student.studentId == event.studentAssessmentInfo.studentId) {
        //       if (index != event.oldSlideIndex) {
        //         print("new index is found $index");
        //         newSlideIndex = index;
        //       }
        //     }
        //   });
        // }

        _editSlideFromPresentation(
            studentAssessmentInfo: event.studentAssessmentInfo,
            presentationId: event.slidePresentationId,
            refreshToken: _userProfileLocalData[0].refreshToken,
            accessToken: _userProfileLocalData[0].authorizationToken,
            oldSlideIndex: event.oldSlideIndex);
      } catch (e) {
        print(e);
      }
    }

    if (event is PBISPlusUpdateDataOnSpreadSheetTabs) {
      try {
        //GET THE USER DETAILS
        final List<UserInformation> _profileData =
            await UserGoogleProfile.getUserProfile();

        //Just to save the event data to the local list to make sure data is not getting empty on continue hitting the spreadsheet
        List<ClassroomCourse> localClassroomCourseworkList = [];
        localClassroomCourseworkList.addAll(event.classroomCourseworkList);

        //REMOVE THE ALL OBJECT FROM LIST IF EXISTS
        if (localClassroomCourseworkList.length > 0 &&
            localClassroomCourseworkList[0].name == 'All') {
          localClassroomCourseworkList.removeAt(0);
        }
        //sub Join Count To Duplicates courses
        localClassroomCourseworkList = updateSheetTabTitleForDuplicateNames(
            allCourses: localClassroomCourseworkList);
        var isBlankSpreadsheetTabsAdded;
        var isSpreadsheetTabsUpdated;

        //FIRST CREATE TABS ON SPREADSHEET DRIVE AS PER THE CHOSEN COURSES
        isBlankSpreadsheetTabsAdded = await addTabsOnSpreadSheet(
            spreadSheetFileObj: event.spreadSheetFileObj,
            userProfile: _profileData[0],
            classroomCourseList: localClassroomCourseworkList);

        //only if tabs created then update tabs on sheet
        if (isBlankSpreadsheetTabsAdded == true) {
          //update all tabs with data once blank tabs crated in the sheet
          isSpreadsheetTabsUpdated = await updateAllTabsDataInsideSpreadSheet(
            spreadSheetFileObj: event.spreadSheetFileObj,
            classroomCourseworkList: localClassroomCourseworkList,
            userProfile: _profileData[0],
          );
        }

        if (isBlankSpreadsheetTabsAdded == true &&
            isSpreadsheetTabsUpdated == true) {
          yield PBISPlusUpdateDataOnSpreadSheetSuccess();
        } else {
          yield ErrorState(
              errorMsg: isBlankSpreadsheetTabsAdded != true
                  ? isBlankSpreadsheetTabsAdded.toString()
                  : isSpreadsheetTabsUpdated.toString());
        }
      } catch (e) {
        yield ErrorState(
          errorMsg: e.toString(),
        );
      }
    }
  }

  void errorThrow(msg) {
    BuildContext? context = Globals.navigatorKey.currentContext;
    Utility.currentScreenSnackBar(msg, null);
    Navigator.pop(context!);
  }

//Waiting for excel sheet Id to process the data
  void checkForGoogleExcelId() async {
    try {
      if (Globals.googleExcelSheetId?.isEmpty ?? true) {
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

  Future<String?> _createFolderOnDrive(
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

      // if (response.statusCode != 401 &&
      //     response.statusCode == 200 &&
      //     response.data['statusCode'] != 500) {
      //   //  String id = response.data['id'];

      //   return Globals.googleDriveFolderId = response.data['body']['id'];
      // }
      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        //  String id = response.data['id'];

        //   return Globals.googleDriveFolderId = response.data['body']['id'];

        String folderId = response.data['body']['id'];
        //for GARDED+
        if (folderName == "SOLVED GRADED+") {
          Globals.googleDriveFolderId = folderId;
        } else if (folderName == "SOLVED PBIS+") {
          //FOR PBIS PLUS
          PBISPlusOverrides.pbisPlusGoogleDriveFolderId = folderId;
        }
        return folderId;
      }
      return "";
    } catch (e) {
      throw (e);
    }
  }

  Future _getGoogleDriveFolderId(
      {required String? token,
      required String? folderName,
      required String? refreshToken,
      int retry = 3}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      String query =
          //   '(trashed = false and mimeType = \'application/vnd.google-apps.folder\' and name = \'SOLVED GRADED%2B\')';
          folderName == "SOLVED GRADED+"
              ? '(trashed = false and mimeType = \'application/vnd.google-apps.folder\' and name = \'SOLVED GRADED%2B\')'
              : '(trashed = false and mimeType = \'application/vnd.google-apps.folder\' and name = \'SOLVED PBIS%2B\')';

      final ResponseModel response = await _dbServices.getApiNew(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}' +
              'https://www.googleapis.com/drive/v3/files?fields=%2A%26q=' +
              Uri.encodeFull(query),
          headers: headers,
          isCompleteUrl: true);

      // if (response.statusCode != 401 &&
      //     response.statusCode == 200 &&
      //     response.data['statusCode'] != 500) {
      //   var data = response.data['body']['files'];

      //   if (data.length == 0) {
      //     return data;
      //   } else {
      //     return data[0];
      //   }
      // } else if (response.statusCode == 401 ||
      //     response.data['statusCode'] == 500) {
      //   return response.statusCode == 401 ? response.statusCode : 500;
      // }
      // return "";
      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        var data = response.data['body']['files'];

        if (data.length == 0) {
          return data;
        } else {
          return data[0];
        }
      } else if (retry > 0) {
        var result = await _toRefreshAuthenticationToken(refreshToken!);

        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          return await _getGoogleDriveFolderId(
              folderName: folderName,
              token: _userProfileLocalData[0].authorizationToken,
              refreshToken: _userProfileLocalData[0].refreshToken,
              retry: retry - 1);
        }

        return response.statusCode == 401 ? response.statusCode : 500;
      }
      return "";
    } catch (e) {
      // throw (e);
      return e.toString();
    }
  }

  // Future<List> createSheetOnDrive(
  //     {String? name,
  //     bool? isMcqSheet,
  //     String? folderId,
  //     String? accessToken,
  //     String? refreshToken}) async {
  //   try {
  //     Map body = {
  //       'name': name,
  //       // 'description': 'Assessment \'$name\' result has been generated.',
  //       // 'description': isMcqSheet == true ? "Multiple Choice Sheet" : 'Graded+',
  //       'description': isMcqSheet == true ? "Multiple Choice Sheet" : "Graded+",
  //       'mimeType': 'application/vnd.google-apps.spreadsheet',
  //       'parents': ['$folderId']
  //     };
  //     Map<String, String> headers = {
  //       'Authorization': 'Bearer $accessToken',
  //       'Content-Type': 'application/json; charset=UTF-8'
  //     };

  //     final ResponseModel response = await _dbServices.postApi(
  //         '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files',
  //         //  'https://www.googleapis.com/drive/v3/files',
  //         body: body,
  //         headers: headers,
  //         isGoogleApi: true);

  //     if (response.statusCode != 401 &&
  //         response.statusCode == 200 &&
  //         response.data['statusCode'] != 500) {
  //       String fileId = response.data['body']['id'];
  //       // Globals.googleExcelSheetId = fileId;

  //       return [true, fileId];
  //     } else if ((response.statusCode == 401 ||
  //             response.data['statusCode'] == 500) &&
  //         _totalRetry < 3) {
  //       _totalRetry++;
  //       //To regenerated fresh access token
  //       var result = await _toRefreshAuthenticationToken(refreshToken!);
  //       if (result == true) {
  //         List<UserInformation> _userProfileLocalData =
  //             await UserGoogleProfile.getUserProfile();

  //         final List res = await createSheetOnDrive(
  //           isMcqSheet: isMcqSheet,
  //           name: name!,
  //           folderId: folderId,
  //           accessToken: _userProfileLocalData[0].authorizationToken,
  //           refreshToken: _userProfileLocalData[0].refreshToken,

  //           //  image: file
  //         );
  //         return res;
  //       } else {
  //         return [false, 'ReAuthentication is required'];
  //       }
  //     }
  //     return [false, ''];
  //   } catch (e) {
  //     return [false, e.toString()];
  //   }
  // }
  Future<List> createSheetOnDrive({
    String? name,
    required String description,
    String? folderId,
    required UserInformation userProfile,
    int retry = 3,
  }) async {
    try {
      Map body = {
        'title': name,
        'description': description,
        // 'description': isMcqSheet == true ? "Multiple Choice Sheet" : "Graded+",
        'mimeType': 'application/vnd.google-apps.spreadsheet',
        'parents': [
          {'id': folderId}
        ]
      };
      Map<String, String> headers = {
        'Authorization': 'Bearer ${userProfile.authorizationToken}',
        'Content-Type': 'application/json; charset=UTF-8'
      };

      final ResponseModel response = await _dbServices.postApi(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files',
          //  'https://www.googleapis.com/drive/v3/files',
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return [
          true,
          {
            'fileId': response.data['body']['id'],
            'fileUrl': response.data['body']['alternateLink']
          }
        ];
      } else if (retry > 0) {
        //To regenerated fresh access token
        var result =
            await _toRefreshAuthenticationToken(userProfile.refreshToken ?? '');

        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          userProfile = _userProfileLocalData[0];

          return await createSheetOnDrive(
              description: description,
              name: name!,
              folderId: folderId,
              userProfile: userProfile);
        } else {
          return [false, 'ReAuthentication is required'];
        }
      }
      return [false, response.statusCode];
    } catch (e) {
      print(e);
      return [false, e.toString()];
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
      required List<StudentAssessmentInfo> assessmentData,
      int retry = 3}) async {
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
      if ((assessmentData[1].questionImgUrl?.isNotEmpty ?? false) &&
          (assessmentData[1].questionImgUrl != 'NA')) {
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
                ? (isMcqSheet == true ? 13 : 11)
                : (isMcqSheet == true ? 14 : 12),
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 14 : 12)
                : (isMcqSheet == true ? 15 : 13),
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
                ? (isMcqSheet == true ? 15 : 13)
                : (isMcqSheet == true ? 16 : 14),
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 16 : 14)
                : (isMcqSheet == true ? 17 : 15),
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
                ? (isMcqSheet == true ? 14 : 12)
                : (isMcqSheet == true ? 15 : 13),
            endColumnIndex: assessmentData[1].studentId == null ||
                    assessmentData[1].studentId == '' ||
                    Globals.isPremiumUser == false
                ? (isMcqSheet == true ? 15 : 13)
                : (isMcqSheet == true ? 16 : 14),
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
        if (response.statusCode != 200 && retry > 0) {
          _updateFieldExcelSheet(
              retry: retry - 1,
              assessmentData: assessmentData,
              excelId: excelId,
              isMcqSheet: isMcqSheet,
              token: token);
        }
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
      required bool isSearchPage,
      required String filterType,
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
          '((mimeType = \'application/vnd.google-apps.spreadsheet\' or mimeType = \'application/vnd.google-apps.presentation\' ) and \'$folderId\'+in+parents and title contains \'${searchKey}\')';
      if (searchKey == "" || searchKey == null) {
        switch (filterType) {
          case 'Multiple Choice':
            query =
                '(mimeType=\'application/vnd.google-apps.spreadsheet\' or mimeType=\'application/vnd.google-apps.presentation\') and \'$folderId\' in parents and not fullText contains \'Graded%2B\'';

            // query =
            //     '((mimeType = \'application/vnd.google-apps.spreadsheet\'or mimeType = \'application/vnd.google-apps.presentation\' ) and \'$folderId\'+in+parents and fullText contains \'Multiple Choice Sheet\')';
            break;
          case "Constructed Response":
            query =
                '((mimeType = \'application/vnd.google-apps.spreadsheet\' or mimeType = \'application/vnd.google-apps.presentation\' ) and \'$folderId\' in parents and fullText contains \'Graded%2B\')';
            // query =
            // '((mimeType = \'application/vnd.google-apps.spreadsheet\' or mimeType = \'application/vnd.google-apps.presentation\') and \'$folderId\' in parents and (fullText contains \'Constructed Response sheet\' or fullText contains \'Graded%2B\'))';

            // query =
            //     '(mimeType=\'application/vnd.google-apps.spreadsheet\' or mimeType=\'application/vnd.google-apps.presentation\') and \'$folderId\' in parents and not fullText contains \'Graded+\'';
            break;
          default:
            query = "'$folderId'+in+parents";
        }
      }

      final ResponseModel response = await _dbServices.getApiNew(
          isPagination == true
              ? "$nextPageUrl"
              : (searchKey == "" || searchKey == null) && filterType == 'All'
                  ? "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files?q='$folderId'+in+parents" //List Call
                  : filterType == 'Multiple Choice' &&
                          (searchKey == "" || searchKey == null)
                      ? 'https://www.googleapis.com/drive/v2/files?maxResults=100&orderBy=modifiedDate%20desc&q=(mimeType%3D%27application%2Fvnd.google-apps.spreadsheet%27%20or%20mimeType%3D%27application%2Fvnd.google-apps.presentation%27)%20and%20%271wmJajuIgOriR8l1DEttYooYeqQDK9REr%27%20in%20parents%20and%20not%20fullText%20contains%20%27Graded%2B%27&supportsAllDrives=true&supportsTeamDrives=true'
                      // : "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files?maxResults=100&orderBy=modifiedDate%20desc&q=" +
                      //     //     // https://www.googleapis.com/drive/v2/files?q=" +
                      //     Uri.encodeFull(query), //Search call
                      : "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files?q=" +
                          Uri.encodeFull(query),
          headers: headers,
          isCompleteUrl: true);

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        String updatedNextUrlLink = '';
        try {
          updatedNextUrlLink =
              isPagination == true || (filterType == 'Multiple Choice')
                  ? response.data["nextLink"]
                  : response.data['body']["nextLink"];
        } catch (e) {
          updatedNextUrlLink = '';
        }

        List<HistoryAssessment> _list = isPagination == true ||
                (filterType == 'Multiple Choice')
            ? response.data['items']
                .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
                .toList()
            : response.data['body']['items']
                .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
                .toList();

        List<AssessmentDetails> assessmentList = await getAssessmentList();
        for (int i = 0; i < _list.length; i++) {
          for (int j = 0; j < assessmentList.length; j++) {
            if (_list[i].fileId == assessmentList[j].googlefileId &&
                assessmentList[j].googlefileId != '') {
              _list[i].sessionId = assessmentList[j].sessionId;
              _list[i].isCreatedAsPremium = assessmentList[j].createdAsPremium;
              _list[i].assessmentType = assessmentList[j].assessmentType;
              _list[i].assessmentId = assessmentList[j].assessmentId;
              _list[i].classroomCourseId = assessmentList[j].classroomCourseId;
              _list[i].classroomCourseWorkId =
                  assessmentList[j].classroomCourseWorkId;
            }
          }
        }

        if (filterType == 'Multiple Choice') {
          _list.removeWhere((element) => (element.description == 'Graded+'
              // ||
              // element.description == "Constructed Response sheet"
              ));
        } else if (filterType == 'Constructed Response') {
          _list.removeWhere(
              (element) => element.description == 'Multiple Choice Sheet');
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
              isSearchPage: isSearchPage,
              filterType: filterType,
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

  Future<List> _getShareableLink(
      {required String token,
      required String fileId,
      required String? refreshToken,
      int retry = 3}) async {
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

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return [true, response.data['body']['webViewLink']];
      } else if (retry > 0) {
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          return await _getShareableLink(
              retry: retry - 1,
              token: token,
              fileId: fileId,
              refreshToken: refreshToken);
        }
      }
      return [false, 'ReAuthentication is required'];
    } catch (e) {
      return [false, e.toString()];
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

  Future<String> uploadImgB64AndGetUrl(
      {required String? imgBase64,
      required String? imgExtension,
      required String? section,
      int retry = 3}) async {
    try {
      // print(imgExtension);
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

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return response.data['body']['Location'];
      } else if (retry > 0) {
        return await uploadImgB64AndGetUrl(
            retry: retry - 1,
            imgBase64: imgBase64,
            imgExtension: imgExtension,
            section: section);
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  deleteSlide(
      {required String? presentationId,
      required String? accessToken,
      required String? refreshToken,
      required String? slideObjId,
      int retry = 3}) async {
    Map body = {
      "requests": [
        {
          "deleteObject": {
            "objectId": slideObjId // "p"
          }
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
      } else if (retry > 0) {
        _totalRetry++;

        //To regenerate fresh access token
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          bool result = await deleteSlide(
            retry: retry - 1,
            slideObjId: slideObjId,
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

  Future<List> createSlideOnDrive(
      {String? name,
      String? folderId,
      String? accessToken,
      String? refreshToken,
      required String? excelSheetId,
      required bool isMcqSheet,
      int retry = 3}) async {
    Map body = {
      'name': name,
      'mimeType': 'application/vnd.google-apps.presentation',
      // 'description': isMcqSheet == true
      //     ? "$excelSheetId" + " " + "Multiple Choice Sheet"
      //     : "$excelSheetId" + " " + "Graded+     ",
      'parents': ['$folderId']
    };

    String description =
        isMcqSheet == true ? "Multiple Choice Sheet" : "Graded+";
    body['description'] = (excelSheetId?.isNotEmpty ?? false)
        ? "$excelSheetId $description "
        : description;

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

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        deleteSlide(
            slideObjId:
                "p", //default first slide object ID//Always delete this to change the type of slide
            accessToken: accessToken,
            refreshToken: refreshToken,
            presentationId: response.data['body']['id']);
        return [true, response.data['body']['id']];
      } else if (retry > 0) {
        _totalRetry++;
        //To regernerate fresh access token
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          return await createSlideOnDrive(
              isMcqSheet: isMcqSheet,
              name: name!,
              folderId: folderId,
              accessToken: _userProfileLocalData[0].authorizationToken,
              refreshToken: _userProfileLocalData[0].refreshToken,
              excelSheetId: excelSheetId,
              retry: retry - 1);
        }
      }
      return [false, 'ReAuthentication is required'];
    } catch (e) {
      return [false, e.toString()];
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

      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        return 'Done';
      } else if ((response.statusCode == 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
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
      return response.data['statusCode'].toString();
    } catch (e) {
      return e.toString();
    }
  }

  // Future<String> updateAssessmentImageToSlidesOnDrive(
  //     String? presentationId,
  //     String? accessToken,
  //     String? refreshToken,
  //     List<StudentAssessmentInfo> assessmentData,
  //     LocalDatabase<StudentAssessmentInfo> _studentInfoDb) async {
  //   try {
  //     Map body = {
  //       "requests": prepareStudentAssessmentImageRequestBody(
  //         assessmentData: assessmentData,
  //         studentInfoDb: _studentInfoDb,
  //       )
  //     };

  //     Map<String, String> headers = {
  //       'Authorization': 'Bearer $accessToken',
  //       'Content-Type': 'application/json'
  //     };

  //     final ResponseModel response = await _dbServices.postApi(
  //         '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
  //         body: body,
  //         headers: headers,
  //         isGoogleApi: true);
  //     if (response.statusCode != 401 &&
  //         response.statusCode == 200 &&
  //         response.data['statusCode'] != 500) {
  //       return 'Done';
  //     } else if ((response.statusCode == 401 ||
  //             response.data['statusCode'] == 500) &&
  //         _totalRetry < 3) {
  //       var result = await _toRefreshAuthenticationToken(refreshToken!);
  //       if (result == true) {
  //         List<UserInformation> _userProfileLocalData =
  //             await UserGoogleProfile.getUserProfile();
  //         String result = await updateAssessmentImageToSlidesOnDrive(
  //             presentationId,
  //             _userProfileLocalData[0].authorizationToken,
  //             _userProfileLocalData[0].refreshToken,
  //             assessmentData,
  //             _studentInfoDb);
  //         return result;
  //       } else {
  //         return 'ReAuthentication is required';
  //       }
  //     }
  //     return response.data['statusCode'].toString();
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

  // List<Map> prepareStudentAssessmentImageRequestBody(
  //     {required List<StudentAssessmentInfo> assessmentData,
  //     required LocalDatabase<StudentAssessmentInfo> studentInfoDb}) {
  //   List<String> listOfFields = [
  //     'Student Name',
  //     'Student ID',
  //     'Points Earned',
  //     'Points Possible'
  //   ];

  //   List<Map> body = [];
  //   assessmentData.asMap().forEach((index, element) {
  //     if (!element.isSlideObjUpdated!) {
  //       Map obj = {
  //         "createImage": {
  //           "url": element.assessmentImage,
  //           "elementProperties": {
  //             "pageObjectId": element.slideObjectId,
  //           },
  //           "objectId": DateTime.now().microsecondsSinceEpoch.toString()
  //         }
  //       };
  //       String tableObjectuniqueId =
  //           DateTime.now().microsecondsSinceEpoch.toString();
  //       Map table = {
  //         "createTable": {
  //           "rows": listOfFields.length, //pass no. of names
  //           "columns": 2, //key:value
  //           "objectId": tableObjectuniqueId,
  //           "elementProperties": {
  //             "pageObjectId": element.slideObjectId,
  //             "size": {
  //               "width": {"magnitude": 4000000, "unit": "EMU"},
  //               "height": {"magnitude": 3000000, "unit": "EMU"}
  //             },
  //             "transform": {
  //               "scaleX": 1,
  //               "scaleY": 1,
  //               "translateX": 3480600,
  //               "translateY": 1167820,
  //               "unit": "EMU"
  //             }
  //           },
  //         }
  //       };
  //       body.add(obj);
  //       body.add(table);
  //       listOfFields.asMap().forEach((rowIndex, value) {
  //         for (int columnIndex = 0; columnIndex < 2; columnIndex++) {
  //           body.add(
  //             {
  //               "insertText": {
  //                 "objectId": tableObjectuniqueId,
  //                 "cellLocation": {
  //                   "rowIndex": rowIndex,
  //                   "columnIndex": columnIndex
  //                 },
  //                 "text": columnIndex == 0
  //                     ? listOfFields[rowIndex] //Keys
  //                     : prepareAssignmentTableCellValue(element, rowIndex,
  //                         assessmentData[0].pointPossible) //Values
  //               }
  //             },
  //           );
  //         }
  //       });
  //       element.isSlideObjUpdated = true;
  //       element.slideTableObjId = tableObjectuniqueId;
  //       studentInfoDb.putAt(index, element);
  //     }
  //   });
  //   return body;
  // }

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
                "slideLayoutReference": {"predefinedLayout": "BLANK"}
              }
            }
            //   {
            //   "createSlide": {
            //     "objectId": "Slide1",
            //     "slideLayoutReference": {"predefinedLayout": "TITLE_ONLY"},
            //     "placeholderIdMappings": [
            //       {
            //         "layoutPlaceholder": {"type": "TITLE"},
            //         "objectId": "Title1"
            //       }
            //     ]
            //   }
            // }
          ];
    // print(slideObjects);
    assessmentData.asMap().forEach((index, element) async {
      if (!element.isSlideObjUpdated!) {
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
        // element.isSlideObjUpdated = true;
        await _studentInfoDb.putAt(index, element);
      }
      // else {
      //   element.isSlideObjUpdated = true;
      //   await _studentInfoDb.putAt(index, element);
      // }
    });
    return slideObjects;
  }

//Used to update assessment detail on very slide of the google presentation
  Future<String> _updateAssignmentDetailsOnSlide(
      String? presentationId,
      String? accessToken,
      String? refreshToken,
      String? slideObjectId,
      LocalDatabase<StudentAssessmentInfo> studentAssessmentInfoDB,
      String assignmentName,
      {int retry = 3}) async {
    try {
      var body = {
        "requests": await _getListOfAssignmentDetails(
            assignmentName: assignmentName,
            studentAssessmentInfoDB: studentAssessmentInfoDB)
      };

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };

      final ResponseModel response = await _dbServices.postApi(
          // '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          'https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          body: body,
          headers: headers,
          isGoogleApi: true);
      if (response.statusCode == 200) {
        return 'Done';
      } else if (retry > 0) {
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          String result = await _updateAssignmentDetailsOnSlide(
              presentationId,
              _userProfileLocalData[0].authorizationToken,
              _userProfileLocalData[0].refreshToken,
              slideObjectId,
              studentAssessmentInfoDB,
              assignmentName,
              retry: retry - 1);
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

//Updating first slide of presentation
  Future<List<Map>> _getListOfAssignmentDetails({
    required String? assignmentName,
    required LocalDatabase<StudentAssessmentInfo> studentAssessmentInfoDB,
  }) async {
    List<StudentAssessmentInfo> studentAssessmentInfoData =
        await studentAssessmentInfoDB.getData();
    StudentAssessmentInfo studentAssessmentInfoObj =
        studentAssessmentInfoData[0];

    // check if question image is available or not
    bool? isQuestionImgUrlUpdate =
        studentAssessmentInfoObj.questionImgUrl != null &&
            studentAssessmentInfoObj.questionImgUrl!.isNotEmpty &&
            studentAssessmentInfoObj.questionImgUrl! != "NA";

    // List of title for slide details table
    List<String> listOfFields = [
      'Assignment name',
      'Subject',
      'Teacher',
      'Grade',
      'Class',
      'Date',
      'Rubric',
      'Domain',
      'Learning Standard',
      'Standard Description',
    ];

    // start adding request objects in list
    List<Map> body = [
      //to update the assignment title
      // {
      //   "insertText": {"objectId": "Title1", "text": "$assignmentName"}
      // },

      //prepare blank table on slide
      {
        "createTable": {
          "rows": listOfFields.length, //pass no. of names
          "columns": 2, //key:value
          "objectId": "123456",
          "elementProperties": {
            "pageObjectId": "Slide1",
            "size": {
              "width": {"magnitude": 6000000, "unit": "EMU"},
              "height": {"magnitude": 3500000, "unit": "EMU"}
            },
            "transform": {
              "scaleX": 1,
              "scaleY": 1,
              "translateX": isQuestionImgUrlUpdate ? 3005000 : 1505000,
              "translateY": 250000,
              "unit": "EMU",
            }
          },
        }
      },
    ];

// check if question image is available or not
    if (isQuestionImgUrlUpdate) {
//adding question image on slide request
      body.add({
        "createImage": {
          "url": studentAssessmentInfoObj.questionImgUrl.toString(),
          "elementProperties": {"pageObjectId": "Slide1"},
          "objectId": "123456789"
        }
      });
    }

// To update table cells with title and values
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
                  : prepareTableCellValue(studentAssessmentInfoObj, rowIndex,
                      assignmentName) //Values
            }
          },
        );
        //update the textstyle and fontsize of table cells
        body.add({
          "updateTextStyle": {
            "objectId": "123456",
            "style": {
              "fontSize": {"magnitude": 10, "unit": "PT"},
              "bold": columnIndex == 0
            },
            "fields": "*",
            "cellLocation": {"columnIndex": columnIndex, "rowIndex": rowIndex}
          }
        });
      }
    });

    return body;
  }

  String prepareTableCellValue(StudentAssessmentInfo studentAssessmentInfoObj,
      int index, String? assignmentName) {
    try {
      // detail update on cell in slide table
      Map map = {
        0: assignmentName ?? 'NA',
        1: studentAssessmentInfoObj.subject ?? 'NA',
        2: Globals.teacherEmailId ?? 'NA',
        3: studentAssessmentInfoObj.grade ?? 'NA',
        4: studentAssessmentInfoObj.className ?? "NA",
        5: Utility.convertTimestampToDateFormat(DateTime.now(), "MM/dd/yy")
            .toString(),
        6: studentAssessmentInfoObj.scoringRubric ?? 'NA',
        7:
            //  studentAssessmentInfoObj.learningStandard != null &&
            //         studentAssessmentInfoObj.learningStandard!.length > 30
            //     ? studentAssessmentInfoObj.learningStandard!.substring(0, 29) + ".."
            //     :
            studentAssessmentInfoObj.learningStandard ?? 'NA',
        8: studentAssessmentInfoObj.subLearningStandard ?? 'NA',
        9:
            // studentAssessmentInfoObj.standardDescription != null &&
            //         studentAssessmentInfoObj.standardDescription!.length > 30
            //     ? studentAssessmentInfoObj.standardDescription!.substring(0, 29) +
            //         '..'

            //     :
            studentAssessmentInfoObj.standardDescription ?? 'NA',
      };

      return map[index] ?? 'NA';
    } catch (e) {
      print(e);
      return 'NA';
    }
  }

//Use to update student information in each slide of the presentation
  prepareAssignmentTableCellValue(
      StudentAssessmentInfo studentAssessmentInfoObj,
      int index,
      String? pointPossible) {
    Map map = {
      0: studentAssessmentInfoObj.studentName ?? '',
      1: studentAssessmentInfoObj.studentId ?? '',
      2: studentAssessmentInfoObj.studentGrade ?? '',
      3: pointPossible ?? '',
    };

    return map[index] ?? 'NA';
  }

  Future<String> addAndUpdateStudentAssessmentDetailsToSlide(
      {required String presentationId,
      required String accessToken,
      required String refreshToken,
      required LocalDatabase<StudentAssessmentInfo> studentInfoDb,
      required bool? isScanMore,
      int retry = 3}) async {
    try {
      List<Map> slideRequiredObjectsList =
          await prepareAddAndUpdateSlideRequestBody(
              studentInfoDb: studentInfoDb, isScanMore: isScanMore);
//if user tries to scan same existing assessment sheet, it will not add the that again in the list
      if ((slideRequiredObjectsList?.isEmpty ?? true) &&
          (isScanMore ?? false)) {
        return 'Done';
      }

      Map body = {"requests": slideRequiredObjectsList};

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };

      final ResponseModel response = await _dbServices.postApi(
          //  '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          'https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode == 200) {
        List<StudentAssessmentInfo> assessmentData =
            await studentInfoDb.getData();
        // update the local-db only after slides updated on google drive to manage the next scan more sheets to not repeat in the list
        assessmentData.asMap().forEach((index, element) async {
          element.isSlideObjUpdated = true;
          //updating local database with slideObjectId
          await studentInfoDb.putAt(index, element);
        });
        return 'Done';
      } else if (retry > 0) {
        var result = await _toRefreshAuthenticationToken(refreshToken);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          String result = await addAndUpdateStudentAssessmentDetailsToSlide(
              presentationId: presentationId,
              accessToken: _userProfileLocalData[0].authorizationToken ?? '',
              refreshToken: _userProfileLocalData[0].refreshToken ?? '',
              studentInfoDb: studentInfoDb,
              isScanMore: isScanMore,
              retry: retry - 1);
          return result;
        }
        //  else {
        //   return 'ReAuthentication is required';
        // }
      }
      return 'ReAuthentication is required';
    } catch (e) {
      return e.toString();
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*--------------------------------prepareAddAndUpdateSlideRequestBody---------------------------*/
  /*----------------------------------------------------------------------------------------------*/

  prepareAddAndUpdateSlideRequestBody({
    required LocalDatabase<StudentAssessmentInfo> studentInfoDb,
    required bool? isScanMore,
  }) async {
    List<StudentAssessmentInfo> assessmentData = await studentInfoDb.getData();
    print(assessmentData);
    List<String> listOfFields = [
      'Student Name',
      'Student ID',
      'Points Earned',
      'Points Possible'
    ];

// Preparing first blank slide
    List<Map> slideRequiredObjectsList = (isScanMore ?? true)
        ? []
        : [
            {
              "createSlide": {
                "objectId": "Slide1",
                "slideLayoutReference": {"predefinedLayout": "BLANK"}
              }
            }
          ];
    // print(slideRequiredObjectsList);
    // print(assessmentData);
    try {
      assessmentData.asMap().forEach((index, element) async {
        if (!element.isSlideObjUpdated!) {
          String pageObjectuniqueId =
              DateTime.now().microsecondsSinceEpoch.toString() + "$index";

          String tableObjectuniqueId =
              DateTime.now().microsecondsSinceEpoch.toString() + "$index";
          print(pageObjectuniqueId);
          print(tableObjectuniqueId);
          // Preparing all other blank slide (based on student detail length) type to add assessment images
          Map slideObject = {
            "createSlide": {
              "objectId": pageObjectuniqueId,
              "slideLayoutReference": {"predefinedLayout": "BLANK"}
            }
          };

          //to insert the slide in order for scan more
          if (isScanMore == true && index < assessmentData.length) {
            slideObject["createSlide"]["insertionIndex"] = index + 1;
          }
          slideRequiredObjectsList.add(slideObject);

// Preparing to update assignment sheet images - students
          if (element.assessmentImage?.isNotEmpty ?? false) {
            Map obj = {
              "createImage": {
                "url": element.assessmentImage,
                "elementProperties": {
                  "pageObjectId": pageObjectuniqueId,
                },
                "objectId": DateTime.now().microsecondsSinceEpoch.toString()
              }
            };
            slideRequiredObjectsList.add(obj);
          }
          // print(slideRequiredObjectsList);
          // Preparing table and structure for each student slide
          Map table = {
            "createTable": {
              "rows": listOfFields.length, //pass no. of names
              "columns": 2, //key:value
              "objectId": tableObjectuniqueId,
              "elementProperties": {
                "pageObjectId": pageObjectuniqueId,
                "size": {
                  "width": {"magnitude": 4000000, "unit": "EMU"},
                  "height": {"magnitude": 3000000, "unit": "EMU"}
                },
                "transform": {
                  "scaleX": 1,
                  "scaleY": 1,
                  "translateX": 3480600,
                  "translateY": 1167820,
                  "unit": "EMU"
                }
              },
            }
          };
          slideRequiredObjectsList.add(table);

          // Updating table with student information
          listOfFields.asMap().forEach((rowIndex, value) {
            for (int columnIndex = 0; columnIndex < 2; columnIndex++) {
              slideRequiredObjectsList.add(
                {
                  "insertText": {
                    "objectId": tableObjectuniqueId,
                    "cellLocation": {
                      "rowIndex": rowIndex,
                      "columnIndex": columnIndex
                    },
                    "text": columnIndex == 0
                        ? listOfFields[rowIndex] //Keys
                        : prepareAssignmentTableCellValue(element, rowIndex,
                            assessmentData[0].pointPossible) //Values
                  }
                },
              );
            }
          });

          element.slideObjectId = pageObjectuniqueId;
          // element.isSlideObjUpdated = true;
          element.slideTableObjId = tableObjectuniqueId;
          //updating local database with slideObjectId
          await studentInfoDb.putAt(index, element);
        }
      });
      //  print(assessmentData);
      return slideRequiredObjectsList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*------------------------------------_editSlideFromPresentation--------------------------------*/
  /*-----------------------------------------PART A-----------------------------------------------*/

  Future _editSlideFromPresentation(
      {required StudentAssessmentInfo studentAssessmentInfo,
      required String? presentationId,
      required String? refreshToken,
      required String? accessToken,
      int retry = 3,
      required var oldSlideIndex}) async {
    try {
      Map body = {
        "requests": await prepareEditAndUpdateSlideRequestBody(
            studentAssessmentInfo: studentAssessmentInfo,
            oldSlideIndex: oldSlideIndex)
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
      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        return 'Done';
      } else if (retry > 0) {
        var result = await _toRefreshAuthenticationToken(refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          String result = await _editSlideFromPresentation(
              retry: retry - 1,
              studentAssessmentInfo: studentAssessmentInfo,
              accessToken: _userProfileLocalData[0].authorizationToken,
              presentationId: presentationId,
              refreshToken: _userProfileLocalData[0].refreshToken,
              oldSlideIndex: oldSlideIndex);
          return result;
        } else {
          return 'ReAuthentication is required';
        }
      }
      return response.data['statusCode'].toString();
    } catch (e) {
      return e.toString();
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*------------------------------------_editSlideFromPresentation--------------------------------*/
  /*-----------------------------------------PART B-----------------------------------------------*/

  Future<List> prepareEditAndUpdateSlideRequestBody(
      {required StudentAssessmentInfo studentAssessmentInfo,
      required var oldSlideIndex}) async {
    try {
      //request object
      List<Map> slideObjects = [];

      //check before preparing body
      if (studentAssessmentInfo.slideTableObjId != null &&
          studentAssessmentInfo.slideTableObjId!.isNotEmpty) {
        //index =3 showing number of cell we are updating in the slide table.
        for (int index = 0; index < 3; index++) {
          //delete the existing text from table cell
          Map deleteTextObj = {
            "deleteText": {
              "objectId": studentAssessmentInfo.slideTableObjId,
              "cellLocation": {"columnIndex": 1, "rowIndex": index}
            }
          };

          // now updating new text on table cells
          Map insertTextObj = {
            "insertText": {
              "objectId": studentAssessmentInfo.slideTableObjId,
              "cellLocation": {"columnIndex": 1, "rowIndex": index},
              "text": prepareAssignmentTableCellValue(
                  studentAssessmentInfo, index, '')
            }
          };

          //Adding both delete obj and updating text on request list body
          slideObjects.add(deleteTextObj);
          slideObjects.add(insertTextObj);
        }
      }
      // update slide with new Position or if new position available

// if old slide index has some value it mean name or score is edited by user
      if (oldSlideIndex != null) {
        var newSlideIndex = null;

//get all stduents records
        List<StudentAssessmentInfo> allStudents =
            await OcrUtility.getStudentInfoList(
                isEdit: true, tableName: Strings.studentInfoDbName);

//check the old and new index
        for (int index = 0; index < allStudents.length; index++) {
          if (allStudents[index].studentId == studentAssessmentInfo.studentId) {
            //change slide index only if old and new index is different
            if (index != oldSlideIndex) {
              //update the new slide index
              newSlideIndex = index;
              break;
            }
          }
        }

// update Slides Position in google slides only if new index is found
        if (newSlideIndex != null) {
          if (newSlideIndex > oldSlideIndex) {
            newSlideIndex = newSlideIndex + 2;
          } else {
            newSlideIndex = newSlideIndex + 1;
          }

          Map updateSlideWithNewPostion = {
            "updateSlidesPosition": {
              "insertionIndex": newSlideIndex,
              "slideObjectIds": [studentAssessmentInfo.slideObjectId]
            }
          };
          slideObjects.add(updateSlideWithNewPostion);
        }
      }

      // if ((newSlideIndex + 1) == counts) {
      //   newSlideIndex = newSlideIndex + 2;
      // } else {
      //   newSlideIndex = newSlideIndex + 1;
      // }
      // if (newSlideIndex != null) {
      //   print("slide obj id  ${studentAssessmentInfo.slideObjectId}");
      //   Map updateSlideWithNewPostion = {
      //     "updateSlidesPosition": {
      //       "insertionIndex": newSlideIndex,
      //       "slideObjectIds": [studentAssessmentInfo.slideObjectId]
      //     }
      //   };
      //   slideObjects.add(updateSlideWithNewPostion);
      // }

      return slideObjects;
    } catch (e) {
      print(e);
      return [];
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*----------------------Add Blank Tabs to Spreadsheet and Preparing API Body--------------------*/
  /*------------------------------------------PART A----------------------------------------------*/

  Future<dynamic> addTabsOnSpreadSheet(
      {required Map<String, dynamic> spreadSheetFileObj,
      required UserInformation userProfile,
      required final List<ClassroomCourse> classroomCourseList,
      int retry = 3}) async {
    try {
      String spreadSheetFileId = spreadSheetFileObj['fileId'] ?? '';
      // Prepare body to create blank tabs to the spreadsheet on Drive.
      final List<Map<String, dynamic>> allTabs =
          buildBlankTabsInsideSpreadSheet(
              classroomCourseList: classroomCourseList);

      final body = {
        'requests': allTabs,
      };

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userProfile.authorizationToken}',
      };

      final url =
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://sheets.googleapis.com/v4/spreadsheets/$spreadSheetFileId:batchUpdate';

      final ResponseModel response = await _dbServices.postApi(url,
          headers: headers, body: body, isGoogleApi: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return true;
      } else if (retry > 0) {
        var result =
            await _toRefreshAuthenticationToken(userProfile.refreshToken!);

        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          return await addTabsOnSpreadSheet(
              spreadSheetFileObj: spreadSheetFileObj,
              classroomCourseList: classroomCourseList,
              userProfile: _userProfileLocalData[0],
              retry: retry - 1);
        } else {
          return 'ReAuthentication is required';
        }
      }
      return response.statusCode;
    } catch (e) {
      print(e);
      return e;
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*----------------------Add Blank Tabs to Spreadsheet and Preparing API Body--------------------*/
  /*------------------------------------------PART B----------------------------------------------*/
  List<Map<String, Map<String, dynamic>>> buildBlankTabsInsideSpreadSheet({
    required final List<ClassroomCourse> classroomCourseList,
  }) {
    try {
      List<Map<String, Map<String, dynamic>>> tabs = [
        // Update first default tab title.
        {
          'updateSheetProperties': {
            'properties': {'sheetId': 0, 'title': classroomCourseList[0].name},
            'fields': 'title',
          },
        },
      ];

      /*--------------------------------------------START OF SHEET FORMATTING---------------------------------------------*/

      classroomCourseList.asMap().forEach((index, course) {
        //Managing the center text property start column
        int startColumnIndex =
            (course.name == 'Students' && classroomCourseList.length == 1)
                ? 2
                : 1;

        if (index == 0) {
          //  change heading row text style for first default tab.

          Map<String, Map<String, dynamic>> headingRowTextStyle = {
            "repeatCell": {
              "range": {"sheetId": index, "startRowIndex": 0, "endRowIndex": 1},
              "cell": {
                "userEnteredFormat": {
                  "horizontalAlignment": "CENTER",
                  "textFormat": {"bold": true}
                }
              },
              "fields":
                  "userEnteredFormat(textFormat,borders,backgroundColor,horizontalAlignment)"
            }
          };

          // update the textformat of all cells in sheet
          Map<String, Map<String, dynamic>> allCellsTextFormat = {
            "repeatCell": {
              "range": {
                "sheetId": index,
              },
              "cell": {
                "userEnteredFormat": {
                  "numberFormat": {"type": "TEXT"}
                }
              },
              "fields": "userEnteredFormat(numberFormat)"
            }
          };
          //now update the textstyle of all cells in sheet
          Map<String, Map<String, dynamic>> allCellsTextStyle = {
            "repeatCell": {
              "range": {
                "sheetId": index,
                "startRowIndex": 1,
                "startColumnIndex": startColumnIndex
              },
              "cell": {
                "userEnteredFormat": {"horizontalAlignment": "CENTER"}
              },
              "fields": "userEnteredFormat(horizontalAlignment)"
            }
          };

          /*-------------------------------------------END OF SHEET FORMATTING-----------------------------------------------------*/

          tabs.addAll(
              [headingRowTextStyle, allCellsTextFormat, allCellsTextStyle]);
        } else {
          // Build new tabs inside sheet for all other selected courses.
          Map<String, Map<String, dynamic>> addSheet = {
            'addSheet': {
              'properties': {'title': course.name, 'sheetId': index},
            },
          };
          // change every tab heading row text style.
          Map<String, Map<String, dynamic>> headingRowTextStyle = {
            "repeatCell": {
              "range": {"sheetId": index, "startRowIndex": 0, "endRowIndex": 1},
              "cell": {
                "userEnteredFormat": {
                  "horizontalAlignment": "CENTER",
                  "textFormat": {"bold": true}
                }
              },
              "fields":
                  "userEnteredFormat(textFormat,borders,backgroundColor,horizontalAlignment)"
            }
          };

          // update the text type format of all cells in sheet
          Map<String, Map<String, dynamic>> allCellsTextFormat = {
            "repeatCell": {
              "range": {
                "sheetId": index,
              },
              "cell": {
                "userEnteredFormat": {
                  "numberFormat": {"type": "TEXT"}
                }
              },
              "fields": "userEnteredFormat( numberFormat)"
            }
          };

          //now update the text alignment of all cells starting from column 2(for courses sheet) and 3(for student sheets)
          Map<String, Map<String, dynamic>> allCellsTextStyle = {
            "repeatCell": {
              "range": {
                "sheetId": index,
                "startRowIndex": 1,
                "startColumnIndex": startColumnIndex
              },
              "cell": {
                "userEnteredFormat": {"horizontalAlignment": "CENTER"}
              },
              "fields": "userEnteredFormat(horizontalAlignment)"
            }
          };

          tabs.addAll([
            addSheet,
            headingRowTextStyle,
            allCellsTextFormat,
            allCellsTextStyle
          ]);
        }
      });
      return tabs;
    } catch (e) {
      print(e);
      return [];
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*-------------------Updating Data to Spreadsheet Tabs and Preparing API Body-------------------*/
  /*------------------------------------------PART A----------------------------------------------*/

  Future updateAllTabsDataInsideSpreadSheet(
      {required Map<String, dynamic> spreadSheetFileObj,
      required UserInformation userProfile,
      required final List<ClassroomCourse> classroomCourseworkList,
      int retry = 3}) async {
    try {
      final pbisBloc = PBISPlusBloc();
      String spreadSheetFileId = spreadSheetFileObj['fileId'] ?? '';
      String spreadSheetFileUrl = spreadSheetFileObj['fileUrl'] ?? '';
      // Update data to each tab of the spreadsheet
      final List<Map<String, dynamic>> updatedTabs = updateTabsInSpreadSheet(
          classroomCourseworkList: classroomCourseworkList);

      final Map<String, dynamic> body = {
        "data": updatedTabs,
        "valueInputOption": "USER_ENTERED",
        "includeValuesInResponse": false,
        "responseDateTimeRenderOption": "SERIAL_NUMBER",
        "responseValueRenderOption": "FORMATTED_VALUE"
      };

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${userProfile.authorizationToken}'
      };

      final ResponseModel response = await _dbServices.postApi(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://sheets.googleapis.com/v4/spreadsheets/$spreadSheetFileId/values:batchUpdate',
          headers: headers,
          body: body,
          isGoogleApi: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        //If SpreadSheet all tabs successfully created and updated with data,then add the record with url in the database

        await pbisBloc.createPBISPlusHistoryData(
          type: 'Spreadsheet',
          url: spreadSheetFileUrl,
          teacherEmail: userProfile.userEmail,
          classroomCourseName: 'All',
        );
        return true;
      } else if (retry > 0) {
        var result =
            await _toRefreshAuthenticationToken(userProfile.refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          return await updateAllTabsDataInsideSpreadSheet(
              classroomCourseworkList: classroomCourseworkList,
              spreadSheetFileObj: spreadSheetFileObj,
              userProfile: _userProfileLocalData[0],
              retry: retry - 1);
        } else {
          return 'ReAuthentication is required';
        }
      }
      return response.statusCode;
    } catch (e) {
      print(e);
      return e;
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*-------------------Updating Data to Spreadsheet Tabs and Preparing API Body-------------------*/
  /*------------------------------------------PART B----------------------------------------------*/
  List<Map<String, dynamic>> updateTabsInSpreadSheet({
    required final List<ClassroomCourse> classroomCourseworkList,
  }) {
    try {
      return classroomCourseworkList.map((course) {
        return {
          // 'range': '${course.name}!A1:E${course.students!.length + 1}',
          //Checking the tab is either for Student or for Courses and adding the columns accordingly
          'range':
              '${course.name}!A1:${(course.name == 'Students' && classroomCourseworkList.length == 1) ? 'F' : 'E'}${course.students!.length + 1}',
          'majorDimension': 'ROWS',
          //building row with the student information
          'values': _buildRows(
              students: course.students ?? [],
              //Checking if the tab is building for courses or tabs //returns true or false
              course: (course.name == 'Students' &&
                  classroomCourseworkList.length == 1)),
        };
      }).toList();
    } catch (e) {
      print("errorr ------------------->> $e");
      return [];
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*-------------------Updating Data to Spreadsheet Tabs and Preparing API Body-------------------*/
  /*------------------------------------------PART C----------------------------------------------*/

  List<List<dynamic>> _buildRows(
      {required List<ClassroomStudents> students, required bool course}) {
    try {
      List<String> headingRowName = // always first row for the Headings
          ['Name', 'Engaged', 'Nice Work', 'Helpful', 'Total'];

      if (course == true) {
        headingRowName.insert(1, 'Course');
      }

      return [
        // always first row for the Headings
        headingRowName,

        //stduent information
        ...students.map((student) => [
              student.profile!.name!.fullName,
              if (course == true) student.profile!.courseName,
              student.profile!.engaged,
              student.profile!.niceWork,
              student.profile!.helpful,
              student.profile!.engaged! +
                  student.profile!.niceWork! +
                  student.profile!.helpful!,
            ]),
      ];
    } catch (e) {
      return [];
    }
  }

  List<ClassroomCourse> updateSheetTabTitleForDuplicateNames(
      {required final List<ClassroomCourse> allCourses}) {
    try {
      // Managing the local list to make sure no record skip //Noticed sometime
      List<ClassroomCourse> localAllCourses = [];
      localAllCourses.addAll(allCourses);

      //Storing each course name in key-value pair to update the name of any duplicate course name
      Map<String, int> courseCount = {};
      List<ClassroomCourse> duplicateCourseListWithUpdatedTitle = [];

      for (ClassroomCourse course in localAllCourses) {
        String courseName = course.name ?? '';
        //check if course already present or not
        if (courseCount.containsKey(courseName)) {
          //get old count and update with new value
          int count = courseCount[courseName]! + 1;
          courseCount[courseName] = count; // update on courseCount
          //update the key with latest count
          courseName = '${courseName}_$count';
        } else {
          courseCount[courseName] = 0; // update with default count
        }

        //update the new list with updated news
        duplicateCourseListWithUpdatedTitle.add(ClassroomCourse(
          id: course.id,
          name: courseName, // Use the updated courseName value
          descriptionHeading: course.descriptionHeading,
          ownerId: course.ownerId,
          enrollmentCode: course.enrollmentCode,
          courseState: course.courseState,
          students: course.students,
        ));
      }

      return duplicateCourseListWithUpdatedTitle;
    } catch (e) {
      throw (e);
    }
  }
}
