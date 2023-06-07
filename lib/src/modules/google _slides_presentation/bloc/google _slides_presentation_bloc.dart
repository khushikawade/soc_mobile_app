import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/google_drive/overrides.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
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

        print("check Presentation is available or not");
        List stduentPresentationiSAvailable = await checkStudentPresentation(
            folderId: event.stduentPlusDriveFolderId,
            userProfile: userProfileLocalData[0],
            studentDetails: event.studentDetails);

        if (stduentPresentationiSAvailable[0] == true) {
          List<HistoryAssessment> data = stduentPresentationiSAvailable[1];
          stduentPresentationiSAvailable[1] =
              data.isNotEmpty ? data[0].fileId : '';
        }

        if (stduentPresentationiSAvailable[0] == true &&
            stduentPresentationiSAvailable[1] != '') {
          print("Presentation is already available ");

          yield StudentPlusGooglePresentationIsAvailableSuccess(
              googlePresentationFileId: stduentPresentationiSAvailable[1]);
        } else if (stduentPresentationiSAvailable[0] &&
            stduentPresentationiSAvailable[1] == '') {
          print("Presentation is not available ");

          String fileName =
              "${event.studentDetails.firstNameC}_${event.studentDetails.lastNameC}_${event.studentDetails.studentIdC}";

          print("create Presentation");

          List stduentPresentationIsCreated =
              await googleDriveBloc.createSlideOnDrive(
                  name: fileName,
                  folderId: event.stduentPlusDriveFolderId,
                  accessToken: userProfileLocalData[0].authorizationToken,
                  refreshToken: userProfileLocalData[0].refreshToken,
                  excelSheetId: '',
                  isMcqSheet: false);

          if (stduentPresentationIsCreated[0]) {
            print(" Presentation crated successfully");
            yield StudentPlusGooglePresentationIsAvailableSuccess(
                googlePresentationFileId: stduentPresentationIsCreated[1]);
          } else {
            print(" Presentation crate FAIL");
            yield GoogleSlidesPresentationErrorState(
                errorMsg: stduentPresentationIsCreated[1].toString());
          }
        }

        if (stduentPresentationiSAvailable[0] == false) {
          print("check Presentation is  available or not  FAIL");
          yield GoogleSlidesPresentationErrorState(
              errorMsg: stduentPresentationiSAvailable[1].toString());
        }
      } catch (e) {
        print(e);
        print("FAIL INSDIE StudentPlusGooglePresentationIsAvailable");
        yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
      }
    }

    if (event is StudentPlusUpdateNewSldiesOnGooglePresentation) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        print("Get counts from Presentation");
        List numberOfSlidesIsAlreayavailable =
            await getSlidesCountFromGooglePresentation(
          presentationFileId: event.googlePresentationFileId,
          userProfile: userProfileLocalData[0],
        );
        print("number of records available ${event.allrecords.length} ");

        if (numberOfSlidesIsAlreayavailable[0] == true &&
            numberOfSlidesIsAlreayavailable[1] <= event.allrecords.length) {
          print(
              "Get counts from Presentation successfully ${numberOfSlidesIsAlreayavailable[1]}");

          print("Now update the Presentation with new sldies");
          List newSldiesOnGooglePresentationIsUpdated =
              await updateNewSldiesOnGooglePresentation(
                  presentationId: event.googlePresentationFileId,
                  studentDetails: event.studentDetails,
                  allrecords: event.allrecords,
                  numberOfSlidesIsAlreayavailable:
                      numberOfSlidesIsAlreayavailable[1],
                  userProfile: userProfileLocalData[0]);

          if (newSldiesOnGooglePresentationIsUpdated[0] == true) {
            print("updated the Presentation with new sldies successfully");
            yield StudentPlusUpdateNewSldiesOnGooglePresentationSuccess();
          } else {
            print("updated the Presentation with new sldies FAIL");
            yield GoogleSlidesPresentationErrorState(
                errorMsg: numberOfSlidesIsAlreayavailable[1].toString());
          }
        } else if (numberOfSlidesIsAlreayavailable[1]! >
            event.allrecords.length) {
          print(
              "Presentation is Alreay updated to all slides not need to update");
          yield StudentPlusUpdateNewSldiesOnGooglePresentationSuccess();
        } else {
          print("Get counts from Presentation FAIL");
          yield GoogleSlidesPresentationErrorState(
              errorMsg: numberOfSlidesIsAlreayavailable[1].toString());
        }
      } catch (e) {
        print(e);
        yield GoogleSlidesPresentationErrorState(errorMsg: e.toString());
      }
    }

    if (event is StudentPlusGetGooglePresentation) {
      yield StudentPlusGooglePresentationLoading();

      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        print("check Presentation is available or not");

        List stduentPresentationiSAvailable = await checkStudentPresentation(
            folderId: event.stduentPlusDriveFolderId,
            userProfile: userProfileLocalData[0],
            studentDetails: event.studentDetails);

        if (stduentPresentationiSAvailable[0] == true) {
          List<HistoryAssessment> data = stduentPresentationiSAvailable[1];
          stduentPresentationiSAvailable[1] =
              data.isNotEmpty ? data[0].webContentLink : '';
        }
        print("GooglePresentation ${stduentPresentationiSAvailable[1]}");
        if (stduentPresentationiSAvailable[0] == true) {
          //if Presentation is available update the url
          if (stduentPresentationiSAvailable[1] != '') {
            updateTheStudentWithgooglePresentationUrl(
                studentDetails: event.studentDetails,
                studentGooglePresentationUrl:
                    stduentPresentationiSAvailable[1]);
          }

          print("Presentation url get successfully  ");

          yield StudentPlusGetGooglePresentationSuccess(
              googlePresentationFileUrl: stduentPresentationiSAvailable[1]);
        } else {
          print("Presentation url get FAIL  ");
          yield GoogleSlidesPresentationErrorState(
              errorMsg: stduentPresentationiSAvailable[1].toString());
        }
      } catch (e) {
        print("Presentation url get FAIL  ");
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
          "${studentDetails.firstNameC}_${studentDetails.lastNameC}_${studentDetails.studentIdC}";

      // String query =
      //     'name%3D%22$fileName%22+and+mimeType%3D%22application%2Fvnd.google-apps.presentation%22+and+trashed%3Dfalse';
      String query =
          '((mimeType = \'application/vnd.google-apps.presentation\' ) and \'$folderId\'+in+parents and title contains \'${fileName}\') and trashed = false';

      print("Presentation api called ");

      String api =
          "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://www.googleapis.com/drive/v2/files?q=" +
              Uri.encodeFull(query);

      final ResponseModel response = await _dbServices.getApiNew(api,
          //  "${GoogleOverrides.Google_API_BRIDGE_BASE_URL}https://slides.googleapis.com/v1/drives/$folderId/files?q=$query",

          headers: headers,
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<HistoryAssessment> data = response.data['body']['items']
            .map<HistoryAssessment>((i) => HistoryAssessment.fromJson(i))
            .toList();

        // return [true, data.isNotEmpty ? data[0].fileId : ''];
        return [true, data];
      } else if (retry > 0) {
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
          //  print("rery  find file ReAuthentication is required");
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

      final ResponseModel response = await _dbServices.getApiNew(api,
          headers: headers, isCompleteUrl: true);

      if (response.statusCode == 200) {
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
      required List<StudentPlusWorkModel> allrecords,
      required final int numberOfSlidesIsAlreayavailable,
      int retry = 3}) async {
    try {
      List<Map> slideRequiredObjectsList =
          await prepareAddAndUpdateSlideRequestBody(
              allrecords: allrecords,
              numberOfSlidesIsAlreayavailable: numberOfSlidesIsAlreayavailable,
              studentDetails: studentDetails);

      Map body = {"requests": slideRequiredObjectsList};

      Map<String, String> headers = {
        'Authorization': 'Bearer ${userProfile!.authorizationToken}',
        'Content-Type': 'application/json'
      };

      final ResponseModel response = await _dbServices.postApi(
          'https://slides.googleapis.com/v1/presentations/$presentationId:batchUpdate',
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
              numberOfSlidesIsAlreayavailable: numberOfSlidesIsAlreayavailable,
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

  prepareAddAndUpdateSlideRequestBody({
    required List<StudentPlusWorkModel> allrecords,
    required final int numberOfSlidesIsAlreayavailable,
    required final StudentPlusDetailsModel studentDetails,
  }) {
    print("${allrecords.length}  before -------------");
    try {
      List<String> listOfFieldsForFirstSlide = [
        'Name',
        'ID',
        'Phone',
        'Email',
        'Grade',
        'Class',
        'Attend %',
        'Gender',
        'Age',
        'DOB',
      ];

      List<String> listOfFieldsForEverySlide = [
        'Assignment Name',
        'Assignment Type',
        'Teacher',
        'Assignment Subject',
        'Date',
        'Points Earned',
        'Points Possible'
      ];

      List<Map> slideRequiredObjectsList = [];

      if (numberOfSlidesIsAlreayavailable == 0) {
        //prepare blank slide
        Map blankSlide = {
          "createSlide": {
            "objectId": "Slide1",
            "slideLayoutReference": {"predefinedLayout": "BLANK"}
          }
        };

        //prepare blank table on slide
        Map blanktable = {
          "createTable": {
            "rows": listOfFieldsForFirstSlide.length, //pass no. of names
            "columns": 2, //key:value
            "objectId": "123456",
            "elementProperties": {
              "pageObjectId": "Slide1",
              "size": {
                "width": {"magnitude": 5000000, "unit": "EMU"},
                "height": {"magnitude": 3500000, "unit": "EMU"}
              },
              "transform": {
                "scaleX": 1,
                "scaleY": 1,
                "translateX": 2005000,
                "translateY": 850000,
                "unit": "EMU",
              }
            },
          }
        };

        slideRequiredObjectsList.add(blankSlide);
        slideRequiredObjectsList.add(blanktable);

// To update table cells with title and values
        listOfFieldsForFirstSlide.asMap().forEach((rowIndex, value) {
          for (int columnIndex = 0; columnIndex < 2; columnIndex++) {
            slideRequiredObjectsList.add(
              {
                "insertText": {
                  "objectId": "123456",
                  "cellLocation": {
                    "rowIndex": rowIndex,
                    "columnIndex": columnIndex
                  },
                  "text": columnIndex == 0
                      ? listOfFieldsForFirstSlide[rowIndex] //Keys
                      : prepareTableCellValueForFirstSlide(
                          studentDetails: studentDetails,
                          index: rowIndex,
                        ) //Values
                }
              },
            );
            //update the textstyle and fontsize of table cells
            slideRequiredObjectsList.add({
              "updateTextStyle": {
                "objectId": "123456",
                "style": {
                  "fontSize": {"magnitude": 10, "unit": "PT"},
                  "bold": columnIndex == 0
                },
                "fields": "*",
                "cellLocation": {
                  "columnIndex": columnIndex,
                  "rowIndex": rowIndex
                }
              }
            });
          }
        });
      } else {
        print("REMOVING ITEAM FORM LIST--------");

        allrecords.removeRange(0, numberOfSlidesIsAlreayavailable - 1);
        print("${allrecords.length}  after -------------");
      }

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
            "rows": listOfFieldsForEverySlide.length, //pass no. of names
            "columns": 2, //key:value
            "objectId": tableObjectuniqueId,
            "elementProperties": {
              "pageObjectId": pageObjectuniqueId,
              "size": {
                "width": {"magnitude": 6000000, "unit": "EMU"},
                "height": {"magnitude": 3000000, "unit": "EMU"}
              },
              "transform": {
                "scaleX": 1,
                "scaleY": 1,
                "translateX": 3005000,
                "translateY": 1050000,
                "unit": "EMU"
              }
            },
          }
        };
        slideRequiredObjectsList.add(table);

        // Updating table with student information
        listOfFieldsForEverySlide.asMap().forEach((rowIndex, value) {
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
                      ? listOfFieldsForEverySlide[rowIndex] //Keys
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
      4: student.dateC,
      5: student.resultC ?? '',
      6: StudentPlusUtility.getMaxPointPossible(rubric: student.rubricC ?? '')
          .toString()
    };

    return map[index] != null && map[index] != '' ? map[index] : '-';
  }

  prepareTableCellValueForFirstSlide(
      {required final StudentPlusDetailsModel studentDetails,
      required int index}) {
    Map map = {
      0: "${studentDetails.firstNameC} ${studentDetails.lastNameC}" ?? '-',
      1: studentDetails.id ?? '-',
      2: studentDetails.parentPhoneC ?? '-',
      3: studentDetails.emailC ?? '-',
      4: studentDetails.gradeC ?? '-',
      5: studentDetails.classC ?? '-',
      6: studentDetails.currentAttendance ?? '-',
      7: studentDetails.genderFullC ?? '-',
      8: studentDetails.age ?? '-',
      // 9: studentDetails.dobC ?? '-'
      9: studentDetails.dobC != null && studentDetails.dobC!.isNotEmpty
          ? DateFormat("MM/dd/yyyy")
              .format(DateTime.parse(studentDetails.dobC ?? '-'))
          : '-'
    };

    return map[index] != null && map[index] != '' ? map[index] : '-';
  }

  void updateTheStudentWithgooglePresentationUrl(
      {required StudentPlusDetailsModel studentDetails,
      required final String studentGooglePresentationUrl}) async {
    try {
      print("now update the local db with url");
      //this will get the all students saved in local db
      LocalDatabase<StudentPlusDetailsModel> _localDb = LocalDatabase(
          "${StudentPlusOverrides.studentPlusDetails}_${studentDetails.id}");

      List<StudentPlusDetailsModel> studentsLocalData =
          await _localDb.getData();
      //it will find the student by id and update the updated object wwith googlePresentationUrl

      for (int index = 0; index < studentsLocalData.length; index++) {
        if (studentsLocalData[index].studentIdC == studentDetails.studentIdC) {
          StudentPlusDetailsModel student = studentsLocalData[index];

          student.googlePresentationUrl = studentGooglePresentationUrl;

          await _localDb.putAt(index, student);
          break;
        }
      }
    } catch (e) {
      throw (e);
    }
  }
}
