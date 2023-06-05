import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/google_drive/overrides.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'google _slides_presentation_event.dart';
part 'google _slides_presentation_state.dart';

class GoogleSlidesPresentationBloc
    extends Bloc<GoogleSlidesPresentationEvent, GoogleSlidesPresentationState> {
  GoogleSlidesPresentationBloc() : super(GoogleSlidesPresentationInitial());

  final DbServices _dbServices = DbServices();

  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();

  @override
  Stream<GoogleSlidesPresentationState> mapEventToState(
    GoogleSlidesPresentationEvent event,
  ) async* {
    if (event is StudentPlusGooglePresentationIsAvailable) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        List StduentPresentationiSAvailable = await checkStudentPresentation(
            folderId: event.stduentPlusDriveFolderId,
            userProfile: userProfileLocalData[0],
            studentDetails: event.studentDetails);

        print("returned is StduentPresentationiSAvailable");
        print(StduentPresentationiSAvailable[0]);
        print(StduentPresentationiSAvailable[1]);
        if (StduentPresentationiSAvailable[0] == true &&
            StduentPresentationiSAvailable[1] != '') {
          print("Presentation is already available ");

          yield StudentPlusGooglePresentationIsAvailableSuccess(
              googlePresentationFileId: StduentPresentationiSAvailable[1]);
        } else if (StduentPresentationiSAvailable[0] &&
            StduentPresentationiSAvailable[1] == '') {
          print("Presentation is not available ");

          // List stduentPresentationIsCreated = await createStduentPresentation(
          //     folderId: event.stduentPlusDriveFolderId,
          //     userProfile: userProfileLocalData[0],
          //     studentDetails: event.studentDetails);
          String fileName =
              "${event.studentDetails.firstNameC}_${event.studentDetails.lastNameC}_${event.studentDetails.id}";

          print("calling to create fil in drive");

          List stduentPresentationIsCreated =
              await googleDriveBloc.createSlideOnDrive(
                  name: fileName,
                  folderId: event.stduentPlusDriveFolderId,
                  accessToken: userProfileLocalData[0].authorizationToken,
                  refreshToken: userProfileLocalData[0].refreshToken,
                  excelSheetId: '',
                  isMcqSheet: false);

          if (stduentPresentationIsCreated[0]) {
            yield StudentPlusGooglePresentationIsAvailableSuccess(
                googlePresentationFileId: stduentPresentationIsCreated[1]);
          } else {
            yield GoogleSlidesPresentationErrorState(
                errorMsg: stduentPresentationIsCreated[1].toString());
          }
        }

        if (StduentPresentationiSAvailable[0] == false) {
          yield GoogleSlidesPresentationErrorState(
              errorMsg: StduentPresentationiSAvailable[1].toString());
        }
      } catch (e) {
        print(e);
        yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
      }
    }

    if (event is StudentPlusUpdateNewSldiesOnGooglePresentation) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        List sldiesCounts = await getSlidesCountFromGooglePresentation(
          presentationFileId: event.googlePresentationFileId,
          userProfile: userProfileLocalData[0],
        );
        if (sldiesCounts[0] == true) {
          List newSldiesOnGooglePresentationIsUpdated =
              await updateNewSldiesOnGooglePresentation(
                  presentationId: event.googlePresentationFileId,
                  studentDetails: event.studentDetails,
                  allrecords: event.allrecords,
                  userProfile: userProfileLocalData[0]);
        }
      } catch (e) {
        print(e);
        yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
      }
    }
  }

  Future<List> checkStudentPresentation(
      {required final folderId,
      required final UserInformation? userProfile,
      required final StudentPlusDetailsModel studentDetails,
      int retry = 3}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${userProfile!.authorizationToken}'
      };

      String fileName =
          "${studentDetails.firstNameC}_${studentDetails.lastNameC}_${studentDetails.id}";

      // String query =
      //     'name%3D%22$fileName%22+and+mimeType%3D%22application%2Fvnd.google-apps.presentation%22+and+trashed%3Dfalse';
      String query =
          '((mimeType = \'application/vnd.google-apps.presentation\' ) and \'$folderId\'+in+parents and title contains \'${fileName}\')';

      print("Presentation api called ");

      String api =
          "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files?q=" +
              Uri.encodeFull(query);

      final ResponseModel response = await _dbServices.getApiNew(api,
          //  "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/drives/$folderId/files?q=$query",

          headers: headers,
          isCompleteUrl: true);
      print("api response is recived  ${response.statusCode} ");

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<HistoryAssessment> data = response.data['body']['items']
            .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
            .toList();

        print(data);
        print("returning state");
        return [true, data.isNotEmpty ? data[0].fileId : ''];
      } else if (retry > 0) {
        print("rery inside find file");
        var result = await googleDriveBloc
            .toRefreshAuthenticationToken(userProfile.refreshToken!);

        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          return await checkStudentPresentation(
              folderId: folderId,
              studentDetails: studentDetails,
              userProfile: _userProfileLocalData[0],
              retry: retry - 1);
        } else {
          print("rery  find file ReAuthentication is required");
          return [false, 'ReAuthentication is required'];
        }
      }
      print("rery  find last");
      return [
        false,
        response.statusCode == 200
            ? response.data['statusCode']
            : response.statusCode
      ];
    } catch (e) {
      print("insdei error state ");
      print(e);
      throw (e);
    }
  }

  // Future<List> createStduentPresentation(
  //     {required final folderId,
  //     required final UserInformation? userProfile,
  //     required final StudentPlusDetailsModel studentDetails,
  //     int retry = 3}) async {
  //   try {
  //     String fileName =
  //         "${studentDetails.firstNameC}_${studentDetails.lastNameC}_${studentDetails.id}";

  //     print("calling to create fil in drive");
  //     return await googleDriveBloc.createSlideOnDrive(
  //         name: fileName,
  //         folderId: folderId,
  //         accessToken: userProfile!.authorizationToken,
  //         refreshToken: userProfile.refreshToken,
  //         excelSheetId: '',
  //         isMcqSheet: false);
  //   } catch (e) {
  //     print(e);
  //     throw (e);
  //   }
  // }

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

      print("api response called");
      final ResponseModel response = await _dbServices.getApiNew(api,
          headers: headers, isCompleteUrl: true);

      print("api response is recived  ${response.statusCode} ");

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        var data = response.data['body']['slides'];
        var slideCount = data != null ? data.length : 0;
        return [true, slideCount];
      } else if (retry > 0) {
        var result = await googleDriveBloc
            .toRefreshAuthenticationToken(userProfile.refreshToken!);

        if (result == true) {
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

  Future<List> updateNewSldiesOnGooglePresentation(
      {required String presentationId,
      required final UserInformation? userProfile,
      required final StudentPlusDetailsModel studentDetails,
      required final List<StudentPlusWorkModel> allrecords,
      int retry = 3}) async {
    try {
      List<Map> slideRequiredObjectsList =
          await prepareAddAndUpdateSlideRequestBody(allrecords: allrecords);

      Map body = {"requests": slideRequiredObjectsList};

      Map<String, String> headers = {
        'Authorization': 'Bearer ${userProfile!.authorizationToken}',
        'Content-Type': 'application/json'
      };

      final ResponseModel response = await _dbServices.postApi(
          '${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
          body: body,
          headers: headers,
          isGoogleApi: true);

      if (response.statusCode == 200) {
        return [true, true];
      } else if (retry > 0) {
        var result = googleDriveBloc
            .toRefreshAuthenticationToken(userProfile.refreshToken!);
        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          return await updateNewSldiesOnGooglePresentation(
              presentationId: presentationId,
              studentDetails: studentDetails,
              allrecords: allrecords,
              userProfile: _userProfileLocalData[0],
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

  prepareAddAndUpdateSlideRequestBody(
      {required final List<StudentPlusWorkModel> allrecords}) {
    List<String> listOfFields = [
      'Assignment Name',
      'Assignment Type',
      'Teacher',
      'Assignment Subject',
      'Points Earned',
      'Points Possible'
    ];

    List<Map> slideRequiredObjectsList = [];

    try {
      allrecords
          .asMap()
          .forEach((int index, StudentPlusWorkModel element) async {
        String pageObjectuniqueId =
            DateTime.now().microsecondsSinceEpoch.toString() + "$index";

        String tableObjectuniqueId =
            DateTime.now().microsecondsSinceEpoch.toString() + "$index";

        // Preparing all other blank slide (based on student detail length) type to add assessment images
        Map slideObject = {
          "createSlide": {
            "objectId": pageObjectuniqueId,
            "slideLayoutReference": {"predefinedLayout": "BLANK"}
          }
        };

        slideRequiredObjectsList.add(slideObject);

// Preparing to update assignment sheet images - students
        if (element.assessmentImageC?.isNotEmpty ?? false) {
          Map obj = {
            "createImage": {
              "url": element.assessmentImageC,
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
                "translateX": 3200600,
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
                      : prepareAssignmentTableCellValue(
                          student: element, index: rowIndex) //Values
                }
              },
            );
          }
        });
      });
      //  print(assessmentData);
      return slideRequiredObjectsList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  prepareAssignmentTableCellValue(
      {required StudentPlusWorkModel student, required int index}) {
    Map map = {
      0: student.nameC ?? '',
      1: student.assessmentType ?? '',
      2: student.teacherEmail ?? '',
      3: student.subjectC ?? '',
      4: student.resultC ?? '',
      5: StudentPlusUtility.getMaxPointPossible(rubric: student.rubricC ?? '')
          .toString()
    };

    return map[index] ?? 'NA';
  }
}
