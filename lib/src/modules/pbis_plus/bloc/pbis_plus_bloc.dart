import 'dart:convert';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pibs_plus_history_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pbis_plus_event.dart';
part 'pbis_plus_state.dart';

class PBISPlusBloc extends Bloc<PBISPlusEvent, PBISPlusState> {
  PBISPlusBloc() : super(PBISPlusInitial());

  final DbServices _dbServices = DbServices();

  int _totalRetry = 0;
  GoogleClassroomBloc googleClassroomBloc = GoogleClassroomBloc();

  @override
  Stream<PBISPlusState> mapEventToState(
    PBISPlusEvent event,
  ) async* {
    /*----------------------------------------------------------------------------------------------*/
    /*------------------------------------PBISPlusImportRoster--------------------------------------*/
    /*----------------------------------------------------------------------------------------------*/

    if (event is PBISPlusImportRoster) {
      String plusClassroomDBTableName = event.isGradedPlus == true
          ? OcrOverrides.gradedPlusStandardClassroomDB
          : PBISPlusOverrides.pbisPlusClassroomDB;
      try {
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        // LocalDatabase<ClassroomCourse> _localDb =
        //     LocalDatabase(PBISPlusOverrides.pbisPlusClassroomDB);

        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(plusClassroomDBTableName);
        List<ClassroomCourse>? _localData = await _localDb.getData();

        //Clear Roster local data to manage loading issue
        SharedPreferences clearRosterCache =
            await SharedPreferences.getInstance();
        final clearCacheResult =
            await clearRosterCache.getBool('delete_local_Roster_cache');

        if (clearCacheResult != true) {
          await _localDb.close();
          _localData.clear();
          await clearRosterCache.setBool('delete_local_Roster_cache', true);
        }

        if (_localData.isEmpty) {
          //Managing dummy response for shimmer loading
          var list = await _getShimmerData();
          yield PBISPlusClassRoomShimmerLoading(shimmerCoursesList: list);
        } else {
          sort(obj: _localData);
          yield PBISPlusImportRosterSuccess(
              googleClassroomCourseList: _localData);
        }

        //API call to refresh with the latest data in the local DB
        List responseList = await importPBISClassroomRoster(
            accessToken: userProfileLocalData[0].authorizationToken,
            refreshToken: userProfileLocalData[0].refreshToken);

        if (responseList[1] == '') {
          List<ClassroomCourse> coursesList = responseList[0];

          //Returning Google Classroom Course List from API response if local data is empty
          //This will used to show shimmer loading on PBIS Score circle // Class Screen
          if (_localData.isEmpty) {
            sort(obj: coursesList);
            yield PBISPlusInitialImportRosterSuccess(
                googleClassroomCourseList: responseList[0]);
          }

          List<PBISPlusTotalInteractionModal> pbisTotalInteractionList = [];
          //Get PBISTotal interaction only if Section is PBIS+
          if (event.isGradedPlus == false) {
            pbisTotalInteractionList = await getPBISTotalInteractionByTeacher(
                teacherEmail: userProfileLocalData[0].userEmail!);
          }

          // Merge Student Interaction with Google Classroom Rosters
          List<ClassroomCourse> classroomStudentProfile =
              await assignStudentTotalInteraction(
                  pbisTotalInteractionList, coursesList);

          await _localDb.clear();

          classroomStudentProfile.forEach((ClassroomCourse e) {
            _localDb.addData(e);
          });

          PlusUtility.updateLogs(
              activityType: 'PBIS+',
              activityId: '24',
              description: 'Import Roster Successfully From PBIS+',
              operationResult: 'Success');

          yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
          sort(obj: classroomStudentProfile);
          yield PBISPlusImportRosterSuccess(
              googleClassroomCourseList: classroomStudentProfile);
        } else {
          yield PBISErrorState(
            error: 'ReAuthentication is required',
          );
        }
      } catch (e) {
        print(e);

        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(plusClassroomDBTableName);
        List<ClassroomCourse>? _localData = await _localDb.getData();
        sort(obj: _localData);
        // _localDb.close();

        yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
        // sort(obj: _localData);
        yield PBISPlusImportRosterSuccess(
            googleClassroomCourseList: _localData);
      }
    }

    /*----------------------------------------------------------------------------------------------*/
    /*------------------------------GetPBISTotalInteractionsByTeacher-------------------------------*/
    /*-----No need ot use this event as this is already manage together with Import Roster event----*/
    /*----------------------------------------------------------------------------------------------*/

    // if (event is GetPBISTotalInteractionsByTeacher) {
    //   List<UserInformation> userProfileLocalData =
    //       await UserGoogleProfile.getUserProfile();

    //   LocalDatabase<PBISPlusTotalInteractionByTeacherModal> _localDb =
    //       LocalDatabase(PBISPlusOverrides.PBISPlusTotalInteractionByTeacherDB);
    //   List<PBISPlusTotalInteractionByTeacherModal>? _localData =
    //       await _localDb.getData();

    //   if (_localData?.isNotEmpty ?? false) {
    //     yield PBISPlusTotalInteractionByTeacherSuccess(
    //         pbisTotalInteractionList: _localData);
    //   } else {
    //     yield PBISPlusLoading();
    //   }

    //   List<PBISPlusTotalInteractionByTeacherModal> pbisTotalInteractionList =
    //       await getPBISTotalInteractionByTeacher(
    //           teacherEmail: userProfileLocalData[0].userEmail!);

    //   await _localDb.clear();
    //   pbisTotalInteractionList.forEach((element) async {
    //     await _localDb.addData(element);
    //   });

    //   yield PBISPlusLoading();
    //   yield PBISPlusTotalInteractionByTeacherSuccess(
    //       pbisTotalInteractionList: pbisTotalInteractionList);
    // }

    /*----------------------------------------------------------------------------------------------*/
    /*------------------------------GetPBISTotalInteractionsByTeacher-------------------------------*/
    /*----------------------------------------------------------------------------------------------*/

    if (event is AddPBISInteraction) {
      try {
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        String? _objectName = "${PBISPlusOverrides.pbisStudentInteractionDB}";
        LocalDatabase<ClassroomCourse> _localDb = LocalDatabase(_objectName);
        List<ClassroomCourse> _localData = await _localDb.getData();

        yield PBISPlusLoading();
        if (_localData.isNotEmpty) {
          for (int i = 0; i < _localData.length; i++) {
            for (int j = 0; j < _localData[i].students!.length; j++) {
              if (_localData[i].students![j].profile!.id == event.studentId) {
                ClassroomCourse obj = _localData[i];
                // print(_localData[i].likeCount);
                _localDb.putAt(i, obj);
              }
            }
          }
        }

        var data = await addPBISInteraction({
          "Student_Id": event.studentId!,
          "Student_Email": event.studentEmail,
          "Classroom_Course_Id": "${event.classroomCourseId}",
          "Engaged": "${event.engaged}",
          "Nice_Work": "${event.niceWork}",
          "Helpful": "${event.helpful}",
          "School_Id": Overrides.SCHOOL_ID,
          "DBN": Globals.schoolDbnC,
          "Teacher_Email": userProfileLocalData[0].userEmail,
          "Teacher_Name":
              userProfileLocalData[0].userName!.replaceAll('%20', ' '),
          "Status": "active"
        });

        /*-------------------------User Activity Track START----------------------------*/
        PlusUtility.updateLogs(
            activityType: 'PBIS+',
            activityId: '38',
            description:
                'User Interaction PBIS+ for student ${event.studentId}',
            operationResult: 'Success');
        /*-------------------------User Activity Track END----------------------------*/

        yield AddPBISInteractionSuccess(
          obj: data,
        );
      } catch (e) {
        if (e.toString().contains('NO_CONNECTION')) {
          Utility.showSnackBar(
              event.scaffoldKey,
              'Make sure you have a proper Internet connection',
              event.context,
              null);
        } else {
          Utility.showSnackBar(
              event.scaffoldKey, 'Something went wrong', event.context, null);
        }
        yield PBISErrorState(error: e);
      }
    }

    /*----------------------------------------------------------------------------------------------*/
    /*---------------------------------GetPBISPlusHistory-------------------------------------------*/
    /*----------------------------------------------------------------------------------------------*/

    if (event is GetPBISPlusHistory) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        LocalDatabase<PBISPlusHistoryModal> _localDb =
            LocalDatabase(PBISPlusOverrides.PBISPlusHistoryDB);

        List<PBISPlusHistoryModal>? _localData = await _localDb.getData();

        if (_localData.isNotEmpty) {
          List<PBISPlusHistoryModal> localClassRoomData = [];
          List<PBISPlusHistoryModal> localSheetData = [];
          _localData.asMap().forEach((index, element) {
            if (_localData[index].type == 'Classroom') {
              localClassRoomData.add(_localData[index]);
            } else if (_localData[index].type == 'Sheet' ||
                _localData[index].type == 'Spreadsheet') {
              localSheetData.add(_localData[index]);
            }
          });
          yield PBISPlusHistorySuccess(
              pbisHistoryList: _localData,
              pbisClassroomHistoryList: localClassRoomData,
              pbisSheetHistoryList: localSheetData);
        } else {
          yield PBISPlusLoading();
        }

        List<PBISPlusHistoryModal> pbisHistoryList =
            await getPBISPlusHistoryData(
                teacherEmail: userProfileLocalData[0].userEmail!);

        pbisHistoryList.sort((a, b) => b.id!.compareTo(a
            .id!)); //Sorting on the basis of id as its serial in type and date is creating confusion

        await _localDb.clear();
        pbisHistoryList.forEach((element) async {
          await _localDb.addData(element);
        });

        //---------------------------getting api data and make two list & add the value-------------//
        List<PBISPlusHistoryModal> classRoomData = [];
        List<PBISPlusHistoryModal> sheetData = [];
        pbisHistoryList.asMap().forEach((index, element) {
          if (pbisHistoryList[index].type == 'Classroom') {
            classRoomData.add(pbisHistoryList[index]);
          } else if (pbisHistoryList[index].type == 'Sheet' ||
              pbisHistoryList[index].type == 'Spreadsheet') {
            sheetData.add(pbisHistoryList[index]);
          }
        });

        yield PBISPlusLoading();

        yield PBISPlusHistorySuccess(
            pbisHistoryList: pbisHistoryList,
            pbisClassroomHistoryList: classRoomData,
            pbisSheetHistoryList: sheetData);
      } catch (e) {
        LocalDatabase<PBISPlusHistoryModal> _localDb =
            LocalDatabase(PBISPlusOverrides.PBISPlusHistoryDB);
        List<PBISPlusHistoryModal>? _localData = await _localDb.getData();

        List<PBISPlusHistoryModal> localClassRoomData = [];
        List<PBISPlusHistoryModal> localSheetData = [];
        _localData.asMap().forEach((index, element) {
          if (_localData[index].type == 'Classroom') {
            localClassRoomData.add(_localData[index]);
          } else if (_localData[index].type == 'Sheet' ||
              _localData[index].type == 'Spreadsheet') {
            localSheetData.add(_localData[index]);
          }
        });
        yield PBISPlusHistorySuccess(
            pbisHistoryList: _localData,
            pbisClassroomHistoryList: localClassRoomData,
            pbisSheetHistoryList: localSheetData);
      }
    }

    /*----------------------------------------------------------------------------------------------*/
    /*---------------------------------GetPBISPlusHistory-------------------------------------------*/
    /*----------------------------------------------------------------------------------------------*/

    if (event is AddPBISHistory) {
      List<UserInformation> userProfileLocalData =
          await UserGoogleProfile.getUserProfile();

      var result = await createPBISPlusHistoryData(
          type: event.type!,
          url: event.url,
          // studentEmail: event.studentEmail,
          teacherEmail: userProfileLocalData[0].userEmail,
          classroomCourseName: event.classroomCourseName);

      yield PBISPlusLoading();
      yield AddPBISHistorySuccess();
    }
    /* -------------------------------------------------------------------------- */
    /*                    Event to get student details by email                   */
    /* -------------------------------------------------------------------------- */
    if (event is GetPBISPlusStudentDashboardLogs) {
      String sectionTableName = event.isStudentPlus == true
          ? "${PBISPlusOverrides.PBISPlusStudentDetail}_${event.studentId}"
          : "${PBISPlusOverrides.PBISPlusStudentDetail}_${event.classroomCourseId}_${event.studentId}";
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        LocalDatabase<PBISPlusTotalInteractionModal> _localDb =
            LocalDatabase(sectionTableName);
        List<PBISPlusTotalInteractionModal>? _localData =
            await _localDb.getData();

        if (_localData.isNotEmpty) {
          yield PBISPlusStudentDashboardLogSuccess(
              pbisStudentInteractionList: _localData);
        } else {
          yield PBISPlusLoading();
        }

        List<PBISPlusTotalInteractionModal> pbisStudentDetails =
            await getPBISPlusStudentDashboardLogs(
                studentId: event.studentId,
                teacherEmail: userProfileLocalData[0].userEmail!,
                classroomCourseId: event.classroomCourseId,
                isStudentPlus: event.isStudentPlus);

        //   pbisHistoryData.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        await _localDb.clear();
        pbisStudentDetails
            .forEach((PBISPlusTotalInteractionModal element) async {
          await _localDb.addData(element);
        });
        yield PBISPlusLoading();
        yield PBISPlusStudentDashboardLogSuccess(
            pbisStudentInteractionList: pbisStudentDetails);
      } catch (e) {
        LocalDatabase<PBISPlusTotalInteractionModal> _localDb =
            LocalDatabase(sectionTableName);
        List<PBISPlusTotalInteractionModal>? _localData =
            await _localDb.getData();
        yield PBISPlusStudentDashboardLogSuccess(
            pbisStudentInteractionList: _localData);
      }
    }
    if (event is PBISPlusResetInteractions) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        //REMOVE THE 'ALL' OBJECT FROM LIST IF EXISTS
        if (event.selectedRecords.length > 0 &&
            event.selectedRecords[0].name == 'All') {
          event.selectedRecords.removeAt(0);
        }

        var result = await resetPBISPlusInteractionInteractions(
          type: event.type,
          selectedCourses: event.selectedRecords,
          userProfile: userProfileLocalData[0],
        );
        if (result == true) {
          yield PBISPlusResetSuccess();
        } else {
          yield PBISErrorState(error: result);
        }
      } catch (e) {
        yield PBISErrorState(error: e.toString());
      }
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*---------------------------------Function importPBISClassroomRoster---------------------------*/
  /*----------------------------------------------------------------------------------------------*/

  Future<List> importPBISClassroomRoster(
      {required String? accessToken, required String? refreshToken}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/importRoster/$accessToken',
          isCompleteUrl: true);

      if (response.statusCode != 401 &&
          response.data['body'] != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        List<ClassroomCourse> data = response.data['body']
            .map<ClassroomCourse>((i) => ClassroomCourse.fromJson(i))
            .toList();

        return [data, ''];
      } else if ((response.statusCode == 401 ||
              // response.data['body'][" status"] != 401 ||
              response.data['statusCode'] == 500) &&
          _totalRetry < 3) {
        var result = await googleClassroomBloc
            .toRefreshAuthenticationToken(refreshToken!);

        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          List responseList = await importPBISClassroomRoster(
              accessToken: _userProfileLocalData[0].authorizationToken,
              refreshToken: _userProfileLocalData[0].refreshToken);
          return responseList;
        } else {
          List<ClassroomCourse> data = [];
          return [data, 'ReAuthentication is required'];
        }
      } else {
        List<ClassroomCourse> data = [];
        return [data, 'ReAuthentication is required'];
      }
    } catch (e) {
      PlusUtility.updateLogs(
          activityType: 'PBIS+',
          activityId: '24',
          description: 'Import Roster failure From PBIS+',
          operationResult: 'failure');

      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*-----------------------------Function to sort student profile alphabetically------------------*/
  /*----------------------------------------------------------------------------------------------*/

  sort({required List<ClassroomCourse> obj}) {
    obj.sort((a, b) => a.name!.compareTo(b.name!));
    try {
      for (int i = 0; i < obj.length; i++) {
        if (obj[i].students!.length > 0) {
          obj[i].students!.sort((a, b) => a.profile!.name!.givenName!
              .toString()
              .toUpperCase()
              .compareTo(b.profile!.name!.givenName!.toString().toUpperCase()));
        }
      }
    } catch (e) {}
  }

  /*----------------------------------------------------------------------------------------------*/
  /*------------------------------Function getPBISTotalInteractionByTeacher-----------------------*/
  /*----------------------------------------------------------------------------------------------*/

  Future addPBISInteraction(body) async {
    try {
      final ResponseModel response = await _dbServices.postApi(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/interactions',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          body: body,
          isGoogleApi: true);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*------------------------------Function getPBISTotalInteractionByTeacher-----------------------*/
  /*----------------------------------------------------------------------------------------------*/

  Future<List<PBISPlusTotalInteractionModal>> getPBISTotalInteractionByTeacher(
      {required String teacherEmail, int retry = 3}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/interactions/teacher/$teacherEmail',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return response.data['body']
            .map<PBISPlusTotalInteractionModal>(
                (i) => PBISPlusTotalInteractionModal.fromJson(i))
            .toList();
      } else if (retry > 0) {
        return getPBISTotalInteractionByTeacher(
            teacherEmail: teacherEmail, retry: retry - 1);
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*-----------------Function to assign the student interaction with classroom--------------------*/
  /*----------------------------------------------------------------------------------------------*/

  List<ClassroomCourse> assignStudentTotalInteraction(
    List<PBISPlusTotalInteractionModal> pbisTotalInteractionList,
    List<ClassroomCourse> classroomCourseList,
  ) {
    List<ClassroomCourse> classroomStudentProfile = [];

    // classroomStudentProfile.clear();
    if (pbisTotalInteractionList.length == 0) {
      //Add 0 interaction counts to all the post in case of no interaction found
      classroomStudentProfile.addAll(classroomCourseList);
    } else {
      for (int i = 0; i < classroomCourseList.length; i++) {
        ClassroomCourse classroomCourse = ClassroomCourse();
        classroomCourse
          ..id = classroomCourseList[i].id
          ..name = classroomCourseList[i].name
          ..enrollmentCode = classroomCourseList[i].enrollmentCode
          ..descriptionHeading = classroomCourseList[i].descriptionHeading
          ..ownerId = classroomCourseList[i].ownerId
          ..courseState = classroomCourseList[i].courseState
          ..students = classroomCourseList[i].students;

        bool interactionCountsFound = false;

        for (int j = 0; j < classroomCourseList[i].students!.length; j++) {
          for (int k = 0; k < pbisTotalInteractionList.length; k++) {
            if (classroomCourseList[i].id ==
                    pbisTotalInteractionList[k].classroomCourseId &&
                classroomCourseList[i].students![j].profile!.id ==
                    pbisTotalInteractionList[k].studentId) {
              classroomCourse.students![j].profile!.engaged =
                  pbisTotalInteractionList[k].engaged;
              classroomCourse.students![j].profile!.niceWork =
                  pbisTotalInteractionList[k].niceWork;
              classroomCourse.students![j].profile!.helpful =
                  pbisTotalInteractionList[k].helpful;
              interactionCountsFound = true;

              break;
            }
          }
        }

        //Adding 0 interaction where no interaction added yet
        if (!interactionCountsFound) {
          // If no interaction counts were found, set all counts to 0
          for (int j = 0; j < classroomCourseList[i].students!.length; j++) {
            classroomCourse.students![j].profile!.engaged = 0;
            classroomCourse.students![j].profile!.niceWork = 0;
            classroomCourse.students![j].profile!.helpful = 0;
          }
        }

        classroomStudentProfile.add(classroomCourse);
      }
    }
    return classroomStudentProfile;
  }

  /*----------------------------------------------------------------------------------------------*/
  /*---------------------------------Function getPBISPlusHistoryData------------------------------*/
  /*----------------------------------------------------------------------------------------------*/

  Future<List<PBISPlusHistoryModal>> getPBISPlusStudentPreviousData(
      {required String teacherEmail,
      required String studentId,
      int retry = 3}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/interactions/student/$studentId?teacher_email=$teacherEmail',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);
      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return response.data['body']
            .map<PBISPlusHistoryModal>((i) => PBISPlusHistoryModal.fromJson(i))
            .toList();
      } else if (retry > 0) {
        return getPBISPlusHistoryData(
            teacherEmail: teacherEmail, retry: retry - 1);
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*---------------------------------Function getPBISPlusHistoryData------------------------------*/
  /*----------------------------------------------------------------------------------------------*/

  Future<List<PBISPlusHistoryModal>> getPBISPlusHistoryData(
      {required String teacherEmail, int retry = 3}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/history/teacher/$teacherEmail',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);
      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PBISPlusHistoryModal> historyList = response.data['body']
            .map<PBISPlusHistoryModal>((i) => PBISPlusHistoryModal.fromJson(i))
            .toList();
        return historyList;
      } else if (retry > 0) {
        return getPBISPlusHistoryData(
            teacherEmail: teacherEmail, retry: retry - 1);
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*---------------------------------Function createPBISPlusHistoryData------------------------------*/
  /*----------------------------------------------------------------------------------------------*/

  Future<bool> createPBISPlusHistoryData(
      {required String type,
      required String? url,
      // required String? studentEmail,
      required String? teacherEmail,
      required String? classroomCourseName,
      int retry = 3}) async {
    try {
      // print('createPBISPlusHistoryData');

      var currentDate =
          Utility.convertTimestampToDateFormat(DateTime.now(), "MM/dd/yy");

      var headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
      };

      var body = {
        "Type": type,
        "URL": url,
        "Teacher_Email": teacherEmail,
        // "Student_Email": studentEmail,
        "School_Id": Globals.appSetting.schoolNameC,
        "Title": 'PBIS_${Globals.appSetting.contactNameC}_$currentDate',
        "Classroom_Course": classroomCourseName
      };

      final ResponseModel response = await _dbServices.postApi(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/history',
          headers: headers,
          body: body,
          isGoogleApi: true);

      // print('createPBISPlusHistoryData :$response');
      if (response.statusCode == 200 && response.data['statusCode'] != 500) {
        return true;
      } else if (retry > 0) {
        return createPBISPlusHistoryData(
            type: type,
            url: url,
            // studentEmail: studentEmail,
            teacherEmail: teacherEmail,
            classroomCourseName: classroomCourseName);
      }
      return true;
    } catch (e) {
      throw (e);
    }
  }
  /* -------------------------------------------------------------------------- */
  /* -------Function to get student previous date log details from email ------ */
  /* -------------------------------------------------------------------------- */

  Future<List<PBISPlusTotalInteractionModal>> getPBISPlusStudentDashboardLogs({
    required String studentId, //Id/Email
    required String teacherEmail,
    int retry = 3,
    required String classroomCourseId,
    required bool? isStudentPlus,
  }) async {
    try {
      String url = isStudentPlus == true
          ? '${PBISPlusOverrides.pbisBaseUrl}pbis/interactions/student/$studentId?teacher_email=$teacherEmail'
          : '${PBISPlusOverrides.pbisBaseUrl}pbis/interactions/$classroomCourseId/student/$studentId?teacher_email=$teacherEmail';
      final ResponseModel response = await _dbServices.getApiNew(url,
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return response.data['body']
            .map<PBISPlusTotalInteractionModal>(
                (i) => PBISPlusTotalInteractionModal.fromJson(i))
            .toList();
      } else if (retry > 0) {
        return getPBISPlusStudentDashboardLogs(
            studentId: studentId,
            teacherEmail: teacherEmail,
            retry: retry - 1,
            classroomCourseId: classroomCourseId,
            isStudentPlus: isStudentPlus);
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

  /* -------------------------------------------------------------------------- */
  /* -------------Function to reset PBIS Score for selected choice------------- */
  /* -------------------------------------------------------------------------- */

  Future resetPBISPlusInteractionInteractions(
      {required String? type,
      required List<ClassroomCourse> selectedCourses,
      required UserInformation? userProfile,
      int retry = 3}) async {
    try {
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      Map<String, dynamic> body = {
        "Reset_Date": currentDate,
        "Teacher_Email": userProfile!.userEmail ?? '',
      };
      //if user reset Course
      if (type == "All Courses & Students" || type == "Courses") {
        // Create a comma-separated string of Courses for a list of selected classroom courses "('','','')"
        String classroomCourseIds =
            selectedCourses.map((course) => course.id).join("','");
        body.addAll({"Classroom_Course_Id": "('$classroomCourseIds')"});
      } else if //if user reset student
          (type == "Students") {
        // Create a comma-separated string of student IDs for a list of selected classroom courses "('','','')"
        String studentIds = selectedCourses
            .expand((course) => course.students ?? [])
            .map((student) => student.profile?.id)
            .where((id) => id != null && id.isNotEmpty)
            .toSet() // Convert to Set to remove duplicates
            .map((id) => "$id")
            .join(
                "', '"); // Surround the string with double quotes and  (parentheses)

        body.addAll({"Student_Id": "('$studentIds')"});
      }
      print(body);
      final ResponseModel response = await _dbServices.postApi(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/interactions/reset',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          body: body,
          isGoogleApi: true);

      if (response.statusCode == 200) {
        return true;
      } else if (retry > 0) {
        return await resetPBISPlusInteractionInteractions(
            selectedCourses: selectedCourses,
            type: type,
            userProfile: userProfile,
            retry: retry - 1);
      }
      return response.statusCode;
    } catch (e) {
      return e.toString();
    }
  }

  /* -------------------------------------------------------------------------- */
  /* --------Function to manage the shimmer loading for classroom courses------ */
  /* -------------------------------------------------------------------------- */

  Future<List<ClassroomCourse>> _getShimmerData() async {
    try {
      final String response = await rootBundle.loadString(
          'lib/src/modules/pbis_plus/pbis_plus_asset/pbis_plus_classroom_loading_data.json'
          // 'assets/pbis_plus_asset/pbis_plus_classroom_loading_data.json'
          );

      final data = await json.decode(response);

      return data
          .map<ClassroomCourse>((i) => ClassroomCourse.fromJson(i))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
