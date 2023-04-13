import 'dart:convert';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/modal/course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pibs_plus_history_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;

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
      try {
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(PBISPlusOverrides.PBISPlusClassroomDB);
        List<ClassroomCourse>? _localData = await _localDb.getData();

        if (_localData.isEmpty) {
          yield PBISPlusLoading();
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
          List<PBISPlusTotalInteractionByTeacherModal>
              pbisTotalInteractionList = await getPBISTotalInteractionByTeacher(
                  teacherEmail: userProfileLocalData[0].userEmail!);

          // Merge Student Interaction with Google Classroom Rosters
          List<ClassroomCourse> classroomStudentProfile =
              await assignStudentTotalInteraction(
                  pbisTotalInteractionList, coursesList);

          await _localDb.clear();
          classroomStudentProfile.forEach((ClassroomCourse e) {
            _localDb.addData(e);
          });

          Utility.updateLogs(
              activityId: '24',
              description: 'Import Roster Successfully From PBIS+',
              operationResult: 'Success');

          yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
          sort(obj: classroomStudentProfile);
          yield PBISPlusImportRosterSuccess(
              googleClassroomCourseList: classroomStudentProfile);
        } else {
          yield PBISErrorState(
            errorMsg: 'ReAuthentication is required',
          );
        }
      } catch (e) {
        print(e);
        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(Strings.googleClassroomCoursesList);

        List<ClassroomCourse>? _localData = await _localDb.getData();
        _localDb.close();

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
    /*---------------------------------GetPBISPlusHistory-------------------------------------------*/
    /*----------------------------------------------------------------------------------------------*/

    if (event is GetPBISPlusHistory) {
      List<UserInformation> userProfileLocalData =
          await UserGoogleProfile.getUserProfile();

      LocalDatabase<PBISPlusHistoryModal> _localDb =
          LocalDatabase(PBISPlusOverrides.PBISPlusHistoryDB);
      List<PBISPlusHistoryModal>? _localData = await _localDb.getData();

      if (_localData?.isNotEmpty ?? false) {
        yield PBISPlusHistorySuccess(pbisHistoryData: _localData);
      } else {
        yield PBISPlusLoading();
      }

      List<PBISPlusHistoryModal> pbisHistoryData = await getPBISPlusHistoryData(
          teacherEmail: userProfileLocalData[0].userEmail!);

      pbisHistoryData.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      await _localDb.clear();
      pbisHistoryData.forEach((element) async {
        await _localDb.addData(element);
      });
      yield PBISPlusLoading();
      yield PBISPlusHistorySuccess(pbisHistoryData: pbisHistoryData);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*---------------------------------Function importPBISClassroomRoster---------------------------*/
  /*----------------------------------------------------------------------------------------------*/

  Future<List> importPBISClassroomRoster(
      {required String? accessToken, required String? refreshToken}) async {
    try {
      print(accessToken);
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
      Utility.updateLogs(
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

  Future<List<PBISPlusTotalInteractionByTeacherModal>>
      getPBISTotalInteractionByTeacher(
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
            .map<PBISPlusTotalInteractionByTeacherModal>(
                (i) => PBISPlusTotalInteractionByTeacherModal.fromJson(i))
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
    List<PBISPlusTotalInteractionByTeacherModal> pbisTotalInteractionList,
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
            if (classroomCourseList[i].students![j].profile!.id ==
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
}
