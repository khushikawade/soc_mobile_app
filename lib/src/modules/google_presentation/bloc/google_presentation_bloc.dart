// ignore_for_file: unnecessary_null_comparison

import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/google_drive/overrides.dart';
import 'package:Soc/src/modules/google_presentation/google_presentation_bloc_method.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'google_presentation_event.dart';
part 'google_presentation_state.dart';

class GoogleSlidesPresentationBloc
    extends Bloc<GoogleSlidesPresentationEvent, GoogleSlidesPresentationState> {
  GoogleSlidesPresentationBloc() : super(GoogleSlidesPresentationInitial());

  final DbServices _dbServices = DbServices();

  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();

  @override
  Stream<GoogleSlidesPresentationState> mapEventToState(
    GoogleSlidesPresentationEvent event,
  ) async* {
    //Used to search the presentation URL if already exist and update the student's local database
    //Create Presentation in case of not exist
    //This will call on pressing sync slide button from Student+ work

    // if (event is SearchStudentPresentationStudentPlus) {
    //   try {
    //     List<UserInformation> userProfileLocalData =
    //         await UserGoogleProfile.getUserProfile();
    //     String? googlePresentationId;

    //     //------------------Search Student Presentation--------------------------------------------
    //     List searchPresentationResult = await searchStudentPresentation(
    //         folderId: event.studentPlusDriveFolderId,
    //         userProfile: userProfileLocalData[0],
    //         studentDetails: event.studentDetails);

    //     if (searchPresentationResult[0] == true) {
    //       //--------------------------Storing presentation search result---------------------------
    //       List<HistoryAssessment> presentationData =
    //           searchPresentationResult[1];
    //       // searchPresentationResult[1] =
    //       googlePresentationId =
    //           presentationData.isNotEmpty ? presentationData[0].fileId : '';
    //     }

    //     //Return Search Success if file found in search
    //     if (searchPresentationResult[0] == true && googlePresentationId != '') {
    //       yield StudentPlusGooglePresentationSearchSuccess(
    //           googlePresentationFileId: googlePresentationId!);
    //     }
    //     //Create presentation to google drive Student+ folder if not already exist
    //     else if (searchPresentationResult[0] && googlePresentationId == '') {
    //       String fileName = (event.studentDetails.firstNameC ?? '') +
    //           "_" +
    //           (event.studentDetails.lastNameC ?? '') +
    //           "_" +
    //           (event.studentDetails.studentIdC ?? '');

    //       List GooglePresentationCreateResponse =
    //           await googleDriveBloc.createPresentationOnDrive(
    //               name: fileName,
    //               folderId: event.studentPlusDriveFolderId,
    //               accessToken: userProfileLocalData[0].authorizationToken,
    //               refreshToken: userProfileLocalData[0].refreshToken,
    //               excelSheetId: '',
    //               isMcqSheet: false);

    //       //Return Google presentation if once presentation created
    //       if (GooglePresentationCreateResponse[0]) {
    //         yield StudentPlusGooglePresentationSearchSuccess(
    //             googlePresentationFileId: GooglePresentationCreateResponse[1]);
    //       }
    //       //Return Error in case of presentation not created
    //       else {
    //         yield GoogleSlidesPresentationErrorState(
    //             errorMsg: GooglePresentationCreateResponse[1].toString());
    //       }
    //     } else if (searchPresentationResult[0] == false) {
    //       yield GoogleSlidesPresentationErrorState(
    //           errorMsg: googlePresentationId.toString());
    //     }
    //   } catch (e) {
    //     print(e);
    //     yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
    //   }
    // }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------StudentPlusCreateAndUpdateNewSlidesToGooglePresentation------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
    // if (event is StudentPlusCreateAndUpdateNewSlidesToGooglePresentation) {
    //   try {
    //     List<UserInformation> userProfileLocalData =
    //         await UserGoogleProfile.getUserProfile();

    //     //Count the number of slide already exist to the Google Presentation
    //     List countGooglePresentationSlide =
    //         await getSlidesCountFromGooglePresentation(
    //       presentationFileId: event.googlePresentationFileId,
    //       userProfile: userProfileLocalData[0],
    //     );

    //     //Compare Google Presentation slide count with the Student work count
    //     if (countGooglePresentationSlide[0] == true &&
    //         countGooglePresentationSlide[1] <= event.allRecords.length) {
    //       List updatedPresentationResponse =
    //           await updateNewSlidesToGooglePresentation(
    //               presentationId: event.googlePresentationFileId,
    //               studentDetails: event.studentDetails,
    //               allRecords: event.allRecords,
    //               numberOfSlidesAlreadyAvailable:
    //                   countGooglePresentationSlide[1],
    //               userProfile: userProfileLocalData[0]);

    //       if (updatedPresentationResponse[0] == true) {
    //         yield StudentPlusCreateAndUpdateSlideSuccess();
    //       } else {
    //         yield GoogleSlidesPresentationErrorState(
    //             errorMsg: countGooglePresentationSlide[1].toString());
    //       }
    //     } else if (countGooglePresentationSlide[0] == true &&
    //         countGooglePresentationSlide[1]! > event.allRecords.length) {
    //       yield StudentPlusCreateAndUpdateSlideSuccess();
    //     } else {
    //       yield GoogleSlidesPresentationErrorState(
    //           errorMsg: countGooglePresentationSlide[1].toString());
    //     }
    //   } catch (e) {
    //     print(e);
    //     yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
    //   }
    // }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------StudentPlusGetGooglePresentation----------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
//Used to get the presentation URL if already exist and update the student's local database
//This is the default event fire on searching the presentation
    // if (event is GetStudentPlusPresentationURL) {
    //   yield GooglePresentationLoading();

    //   try {
    //     List<UserInformation> userProfileLocalData =
    //         await UserGoogleProfile.getUserProfile();

    //     List isStudentPresentationAvailable = await searchStudentPresentation(
    //         folderId: event.studentPlusDriveFolderId,
    //         userProfile: userProfileLocalData[0],
    //         studentDetails: event.studentDetails);

    //     if (isStudentPresentationAvailable[0] == true) {
    //       List<HistoryAssessment> data = isStudentPresentationAvailable[1];
    //       isStudentPresentationAvailable[1] =
    //           data.isNotEmpty ? data[0].webContentLink : '';
    //     }

    //     if (isStudentPresentationAvailable[0] == true) {
    //       //if Presentation is available update the url
    //       if (isStudentPresentationAvailable[1] != '') {
    //         GooglePresentationBlocMethods
    //             .updateStudentLocalDBWithGooglePresentationUrl(
    //                 studentDetails: event.studentDetails,
    //                 studentGooglePresentationUrl:
    //                     isStudentPresentationAvailable[1]);
    //       }

    //       yield GetGooglePresentationURLSuccess(
    //           googlePresentationFileUrl: isStudentPresentationAvailable[1]);
    //     } else {
    //       yield GoogleSlidesPresentationErrorState(
    //           errorMsg: isStudentPresentationAvailable[1].toString());
    //     }
    //   } catch (e) {
    //     yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
    //   }
    // }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------StudentPlusCreate New Slides To Google Presentation------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/

    if (event is StudentPlusCreateGooglePresentationForStudent) {
      try {
        //GET CURRENT GOOGLE USER PROFILE
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        //GET STUDENT PRESENTATION FILE NAME
        String studentGooglePresentationFileName = GooglePresentationBlocMethods
            .createStudentGooglePresentationFileName(
                filterWorkName: event.filterName,
                studentDetails: event.studentDetails,
                studentGooglePresentationFileName: true);

        //CREATE STUDENT PRESENTATION TO DRIVE
        List GooglePresentationCreateResponse =
            await googleDriveBloc.createPresentationOnDrive(
                name: studentGooglePresentationFileName,
                folderId: event.studentPlusDriveFolderId,
                accessToken: userProfileLocalData[0].authorizationToken,
                refreshToken: userProfileLocalData[0].refreshToken,
                excelSheetId: '',
                isMcqSheet: false);

        //Return Google presentation once created
        if (GooglePresentationCreateResponse[0] == true) {
          yield StudentPlusCreateStudentWorkGooglePresentationSuccess(
              googlePresentationFileId: GooglePresentationCreateResponse[1]);
        }
        //Return Error in case of presentation not created
        else {
          yield GoogleSlidesPresentationErrorState(
              errorMsg: GooglePresentationCreateResponse[1].toString());
        }
      } catch (e) {
        print(e);
        yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
      }
    }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------Student Plus Update Slides To GooglePresentation------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/

    // if (event is StudentPlusUpdateGooglePresentationForStudent) {
    //     try {
    //       bool isSaveStudentGooglePresentationWorkOnDataBase = false;

    //       List<UserInformation> userProfileLocalData =
    //           await UserGoogleProfile.getUserProfile();

    //       //Count the number of slide already exist to the Google Presentation
    //       List countGooglePresentationSlide =
    //           await getSlidesCountFromGooglePresentation(
    //         presentationFileId:
    //             event.studentDetails.studentGooglePresentationId ?? '',
    //         userProfile: userProfileLocalData[0],
    //       );

    //       //if the api response return (404) the resource you are trying to access doesn't exist
    //       // so then create one google presentation
    //       if (countGooglePresentationSlide[0] == false &&
    //           countGooglePresentationSlide[1] == 404) {
    //         //GET STUDENT PRESENTAION FILE NAME
    //         String studentGooglePresentationFileName =
    //             GooglePresentationBlocMethods
    //                 .createStudentGooglePresentationFileName(
    //                     event.studentDetails);

    //         //CREATE STUDENT PRESENTAION FILE
    //         List GooglePresentationCreateResponse =
    //             await googleDriveBloc.createPresentationOnDrive(
    //                 name: studentGooglePresentationFileName,
    //                 folderId:
    //                     userProfileLocalData[0].studentPlusGoogleDriveFolderId ??
    //                         '',
    //                 accessToken: userProfileLocalData[0].authorizationToken,
    //                 refreshToken: userProfileLocalData[0].refreshToken,
    //                 excelSheetId: '',
    //                 isMcqSheet: false);

    //         //Return Google presentation if once presentation created
    //         if (GooglePresentationCreateResponse[0] == true) {
    //           event.studentDetails.studentGooglePresentationId =
    //               GooglePresentationCreateResponse[1];
    //           countGooglePresentationSlide[1] = 0;
    //           countGooglePresentationSlide[0] = true;
    //           isSaveStudentGooglePresentationWorkOnDataBase = true;
    //         }
    //       } else {
    //         isSaveStudentGooglePresentationWorkOnDataBase =
    //             countGooglePresentationSlide[1] == 0;
    //       }

    //       //Compare Google Presentation slide count with the Student work count
    //       if (countGooglePresentationSlide[0] == true &&
    //           countGooglePresentationSlide[1] <= event.allRecords.length) {
    //         List updatedPresentationResponse =
    //             await updateNewSlidesToGooglePresentation(
    //                 presentationId:
    //                     event.studentDetails.studentGooglePresentationId ?? '',
    //                 studentDetails: event.studentDetails,
    //                 allRecords: event.allRecords,
    //                 numberOfSlidesAlreadyAvailable:
    //                     countGooglePresentationSlide[1],
    //                 userProfile: userProfileLocalData[0]);

    //         if (updatedPresentationResponse[0] == true) {
    //           yield StudentPlusUpdateStudentWorkGooglePresentationSuccess(
    //               studentDetails: event.studentDetails,
    //               isSaveStudentGooglePresentationWorkOnDataBase:
    //                   isSaveStudentGooglePresentationWorkOnDataBase);
    //         } else {
    //           yield GoogleSlidesPresentationErrorState(
    //               errorMsg: countGooglePresentationSlide[1].toString());
    //         }
    //       }
    //       //---------------------------
    //       else if (countGooglePresentationSlide[0] == true &&
    //           countGooglePresentationSlide[1]! > event.allRecords.length) {
    //         yield StudentPlusUpdateStudentWorkGooglePresentationSuccess(
    //             studentDetails: event.studentDetails,
    //             isSaveStudentGooglePresentationWorkOnDataBase:
    //                 isSaveStudentGooglePresentationWorkOnDataBase);
    //       }
    //       //---------------------------
    //       else {
    //         yield GoogleSlidesPresentationErrorState(
    //             errorMsg: countGooglePresentationSlide[1].toString());
    //       }
    //     } catch (e) {
    //       print(e);
    //       yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
    //     }
    //   }

    if (event is StudentPlusUpdateGooglePresentationForStudent) {
      try {
        bool isSaveStudentGooglePresentationWorkOnDataBase = false;
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        List<dynamic> countGooglePresentationSlideAndTrashStatus =
            await Future.wait([
          // //Count the number of slide already exist to the Google Presentation
          getSlidesCountFromGooglePresentation(
            presentationFileId:
                event.studentDetails.studentGooglePresentationId ?? '',
            userProfile: userProfileLocalData[0],
          ),
          // TO verify the current google presentation is not deleted or not in  trash bin
          checkGooglePresentationInTrashed(
            presentationFileId:
                event.studentDetails.studentGooglePresentationId ?? '',
            userProfile: userProfileLocalData[0],
          )
        ]);

/*--------------------------------------- If Google Presentation  is not Available ------------------------------------------------*/

        //if the api response return (404) the resource you are trying to access doesn't exist
        // so then create one google presentation
        if (( //Checking count API status
                countGooglePresentationSlideAndTrashStatus[0][0] == true &&
                    countGooglePresentationSlideAndTrashStatus[1][1] ==
                        '404') ||
            //Checking trash API status
            (countGooglePresentationSlideAndTrashStatus[1][0] == true &&
                countGooglePresentationSlideAndTrashStatus[1][1] == true)) {
          //if the api response return (404) the resource you are trying to access doesn't e
          yield GoogleSlidesPresentationErrorState(errorMsg: "404");
        }

        /*--------------------------------------- If Google Presentation  is Available ------------------------------------------------*/

        else {
          //Compare Google Presentation slide count with the Student work count
          if (countGooglePresentationSlideAndTrashStatus[0][0] == true &&
              countGooglePresentationSlideAndTrashStatus[0][1] <=
                  event.allRecords.length) {
            List updatedPresentationResponse =
                await updateNewSlidesToGooglePresentation(
                    presentationId:
                        event.studentDetails.studentGooglePresentationId ?? '',
                    studentDetails: event.studentDetails,
                    allRecords: event.allRecords,
                    numberOfSlidesAlreadyAvailable:
                        countGooglePresentationSlideAndTrashStatus[0][1],
                    userProfile: userProfileLocalData[0]);

            if (updatedPresentationResponse[0] == true) {
              //update the Presentation link on studentDetails
              event.studentDetails.studentGooglePresentationUrl =
                  countGooglePresentationSlideAndTrashStatus[1][1];

              yield StudentPlusUpdateStudentWorkGooglePresentationSuccess(
                  studentDetails: event.studentDetails,
                  //isSaveStudentGooglePresentationWorkOnDataBase//Checking if need to save presentation url to database or not //save in case of true
                  isSaveStudentGooglePresentationWorkOnDataBase:
                      countGooglePresentationSlideAndTrashStatus[0][1] == 0);
            } else {
              yield GoogleSlidesPresentationErrorState(
                  errorMsg: countGooglePresentationSlideAndTrashStatus[0][1]
                      .toString());
            }
          }
          //---------------------------
          // If
          else if (countGooglePresentationSlideAndTrashStatus[0][0] == true &&
              countGooglePresentationSlideAndTrashStatus[0][1] >
                  event.allRecords.length) {
            yield StudentPlusUpdateStudentWorkGooglePresentationSuccess(
                studentDetails: event.studentDetails,
                //isSaveStudentGooglePresentationWorkOnDataBase//Checking if need to save presentation url to database or not //save in case of true
                isSaveStudentGooglePresentationWorkOnDataBase:
                    isSaveStudentGooglePresentationWorkOnDataBase);
          }
          //---------------------------
          else {
            yield GoogleSlidesPresentationErrorState(
                errorMsg: countGooglePresentationSlideAndTrashStatus[0][1]
                    .toString());
          }
        }
      } catch (e) {
        print(e);
        yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
      }
    }
  }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------Method searchStudentPresentation----------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
  // Future<List> searchStudentPresentation(
  //     {required final folderId,
  //     required final UserInformation? userProfile,
  //     required final StudentPlusDetailsModel studentDetails,
  //     int retry = 3}) async {
  //   try {
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'authorization': 'Bearer ${userProfile!.authorizationToken}'
  //     };

  //     String fileName = (studentDetails.firstNameC ?? '') +
  //         "_" +
  //         (studentDetails.lastNameC ?? '') +
  //         "_" +
  //         (studentDetails.studentIdC ?? '');
  //     // String query =
  //     //     'name%3D%22$fileName%22+and+mimeType%3D%22application%2Fvnd.google-apps.presentation%22+and+trashed%3Dfalse';
  //     String query =
  //         '((mimeType = \'application/vnd.google-apps.presentation\' ) and \'$folderId\'+in+parents and title contains \'${fileName}\') and trashed = false';

  //     String api =
  //         "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files?q=" +
  //             Uri.encodeFull(query);

  //     //  "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/drives/$folderId/files?q=$query",
  //     final ResponseModel response = await _dbServices.getApiNew(api,
  //         headers: headers, isCompleteUrl: true);

  //     if (response.statusCode == 200 && response.data['statusCode'] == 200) {
  //       List<HistoryAssessment> data = response.data['body']['items']
  //           .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
  //           .toList();

  //       return [true, data];
  //     } else if (retry > 0) {
  //       // var result = await googleDriveBloc
  //       //     .toRefreshAuthenticationToken(userProfile.refreshToken!);

  //       var result = await Authentication.refreshToken();

  //       // if (result == true) {
  //       if (result != null && result != '') {
  //         List<UserInformation> _userProfileLocalData =
  //             await UserGoogleProfile.getUserProfile();

  //         return await searchStudentPresentation(
  //             folderId: folderId,
  //             studentDetails: studentDetails,
  //             userProfile: _userProfileLocalData[0],
  //             retry: retry - 1);
  //       } else {
  //         //  print("rery  find file ReAuthentication is required");
  //         return [false, 'ReAuthentication is required'];
  //       }
  //     }

  //     return [
  //       false,
  //       response.statusCode == 200
  //           ? response.data['statusCode']
  //           : response.statusCode
  //     ];
  //   } catch (e) {
  //     print(e);
  //     throw (e);
  //   }
  // }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------Method getSlidesCountFromGooglePresentation-----------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
  Future<List> getSlidesCountFromGooglePresentation(
      {required final String presentationFileId,
      required final UserInformation? userProfile,
      int retry = 3}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${userProfile!.authorizationToken}'
      };

      String api =
          "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/presentations/$presentationFileId";

      final ResponseModel response = await _dbServices.getApiNew(api,
          headers: headers, isCompleteUrl: true);

      print(
          "getSlidesCountFromGooglePresentation API $response.data['statusCode']");

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        var data = response.data['body']['slides'];

        var slideCount = data != null ? data.length : 0;
        return [true, slideCount];
      } else if (response.statusCode == 200 ||
          (response.data['statusCode'] == 500 &&
              response.data['body']['message'].contains('404'))) {
        //if the api response return (404) the resource you are trying to access doesn't exist
        //Returning true to confirm API returns success but the file we are checking not exist/not found
        return [true, '404'];
      } else if (retry > 0) {
        // var result = await googleDriveBloc
        //     .toRefreshAuthenticationToken(userProfile.refreshToken!);

        var result = await Authentication.refreshToken();

        // if (result == true) {
        if (result != null && result != '') {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          return await getSlidesCountFromGooglePresentation(
              presentationFileId: presentationFileId,
              userProfile: _userProfileLocalData[0],
              retry: retry - 1);
        } else {
          return [false, 'ReAuthentication is required'];
        }
      }

      return [
        false,
        response.statusCode == 200
            ? response.data['statusCode']
            : response.statusCode
      ];
    } catch (e) {
      throw (e);
    }
  }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------Method updateNewSlidesOnGooglePresentation-----------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
  Future<List> updateNewSlidesToGooglePresentation(
      {required String presentationId,
      required final UserInformation? userProfile,
      required final StudentPlusDetailsModel studentDetails,
      required List<StudentPlusWorkModel> allRecords,
      required final int numberOfSlidesAlreadyAvailable,
      int retry = 3}) async {
    try {
      //Preparing Google Presentation Slide Request Body to update slide on existing presentation
      List<Map> slideRequiredObjectsList = await GooglePresentationBlocMethods
          .prepareAddAndUpdateSlideRequestBody(
              allRecords: allRecords,
              numberOfSlidesAlreadyAvailable: numberOfSlidesAlreadyAvailable,
              studentDetails: studentDetails);
      //---------------------------------------------------------------------------------
      Map body = {"requests": slideRequiredObjectsList};
      //---------------------------------------------------------------------------------
      Map<String, String> headers = {
        'Authorization': 'Bearer ${userProfile!.authorizationToken}',
        'Content-Type': 'application/json'
      };
      //---------------------------------------------------------------------------------
      final ResponseModel response = await _dbServices.postApi(
          '${GoogleOverrides.Google_BRIDGE_API_BASE_URL}https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return [true, true];
      } else if (retry > 0) {
        // var result = googleDriveBloc
        //     .toRefreshAuthenticationToken(userProfile.refreshToken!);
        var result = await Authentication.refreshToken();

        // if (result == true) {
        if (result != null && result != '') {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          return await updateNewSlidesToGooglePresentation(
              presentationId: presentationId,
              studentDetails: studentDetails,
              allRecords: allRecords,
              userProfile: _userProfileLocalData[0],
              numberOfSlidesAlreadyAvailable: numberOfSlidesAlreadyAvailable,
              retry: retry - 1);
        } else {
          return [false, 'ReAuthentication is required'];
        }
      }

      return [false, response.statusCode];
    } catch (e) {
      throw (e);
    }
  }

  Future<List> checkGooglePresentationInTrashed(
      {required final String presentationFileId,
      required final UserInformation? userProfile,
      int retry = 3}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${userProfile!.authorizationToken}'
      };

      String api =
          "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v3/files/$presentationFileId?fields=trashed,webViewLink";

      final ResponseModel response = await _dbServices.getApiNew(api,
          headers: headers, isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        var data = response.data['body'];
        bool? isTrashed = data['trashed'];

        return [true, isTrashed == true ? true : data['webViewLink']];
      } else if (response.statusCode == 200 ||
          (response.data['statusCode'] == 500 &&
              response.data['body']['message'].contains('404'))) {
        //if the api response return (404) the resource you are trying to access doesn't exist
        //Returning true to confirm API returns success but the file we are checking not exist/not found
        return [true, '404'];
      } else if (retry > 0) {
        var result = await Authentication.refreshToken();

        if (result != null && result != '') {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();
          return await checkGooglePresentationInTrashed(
              presentationFileId: presentationFileId,
              userProfile: _userProfileLocalData[0],
              retry: retry - 1);
        } else {
          return [false, 'ReAuthentication is required'];
        }
      }
      return [
        false,
        response.statusCode == 200
            ? response.data['statusCode']
            : response.statusCode
      ];
    } catch (e) {
      throw (e);
    }
  }
}
