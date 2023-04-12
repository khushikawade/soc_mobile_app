import 'dart:convert';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/modal/course_modal.dart';
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
    if (event is PBISPlusImportRoster) {
//       yield PBISPlusLoading();
//       LocalDatabase<ClassroomCourse> _localDb =
//           LocalDatabase(PBISPlusOverrides.PBISPlusClassroomDB);
//       List<ClassroomCourse>? _localData = await _localDb.getData();

//       if (_localData?.isNotEmpty ?? false) {
//         yield PBISPlusImportRosterSuccess(
//             googleClassroomCourseList: _localData);
//       }

// //Remove this after API interation-----------------
//       await Future.delayed(Duration(seconds: 2));
//       final data = await importPBISClassroomRoster(
//           'lib/src/modules/pbis_plus/bloc/course_data.json');

// //---------------------------------------------------

//       List<ClassroomCourse> coursesData = data['body']
//           .map<ClassroomCourse>((i) => ClassroomCourse.fromJson(i))
//           .toList();

//       coursesData.forEach((element) async {
//         await _localDb.addData(element);
//       });

//       // await Future.delayed(Duration(seconds: 2));
//       yield PBISPlusImportRosterSuccess(googleClassroomCourseList: coursesData);

      try {
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(PBISPlusOverrides.PBISPlusClassroomDB);
        List<ClassroomCourse>? _localData = await _localDb.getData();
        //   _localData.sort((a, b) => a..compareTo(b.sortOrder));
        //  ldskvlnk

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
        // print('Course list length : ${coursesList.length}');

        if (responseList[1] == '') {
          List<ClassroomCourse> coursesList = responseList[0];

          await _localDb.clear();
          coursesList.forEach((ClassroomCourse e) {
            _localDb.addData(e);
          });
          Utility.updateLogs(
              activityId: '24',
              description: 'Import Roster Successfully From PBIS+',
              operationResult: 'Success');

          yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
          sort(obj: coursesList);
          yield PBISPlusImportRosterSuccess(
              googleClassroomCourseList: coursesList);
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

    if (event is GetPBISPlusHistory) {
      yield PBISPlusLoading();
      LocalDatabase<PBISPlusHistoryModal> _localDb =
          LocalDatabase(PBISPlusOverrides.PBISPlusHistoryDB);
      List<PBISPlusHistoryModal>? _localData = await _localDb.getData();

      if (_localData?.isNotEmpty ?? false) {
        yield PBISPlusHistorySuccess(pbisHistoryData: _localData);
      }
      List<PBISPlusHistoryModal> pbisHistoryData = await getPBISPlusHistoryData(
          teacherEmail:
              "appdevelopersdp7@gmail.com"); //Use the dynamic teacher email

      pbisHistoryData.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      await _localDb.clear();
      pbisHistoryData.forEach((element) async {
        await _localDb.addData(element);
      });
      yield PBISPlusLoading();
      yield PBISPlusHistorySuccess(pbisHistoryData: pbisHistoryData);
    }
  }

  /*------------------------------------ Function Call Start ---------------------------------------*/

  // Future importPBISClassroomRoster(String location) async {
  //   try {
  //     final String response = await rootBundle.loadString(location);
  //     // final data = await json.decode(response);
  //     // return json.decode(response);
  //     // return data['body'].map<Course>((i) => Course.fromJson(i)).toList();
  //   } catch (e) {
  //     print(e);
  //     return '';
  //   }
  // }

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
