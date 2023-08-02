import 'dart:convert';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_additional_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_Behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_behaviour_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
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

//     if (event is PBISPlusImportRoster) {
//       String plusClassroomDBTableName = event.isGradedPlus == true
//           ? OcrOverrides.gradedPlusStandardClassroomDB
//           : PBISPlusOverrides.pbisPlusClassroomDB;
//       try {
//         //Fetch logged in user profile
//         List<UserInformation> userProfileLocalData =
//             await UserGoogleProfile.getUserProfile();

//         LocalDatabase<ClassroomCourse> _localDb =
//             LocalDatabase(plusClassroomDBTableName);

// //Clear Roster local data to manage loading issue
//         SharedPreferences clearRosterCache =
//             await SharedPreferences.getInstance();
//         final clearCacheResult =
//             await clearRosterCache.getBool('delete_local_Roster_cache_1');

//         if (clearCacheResult != true) {
//           await _localDb.clear();

//           await clearRosterCache.setBool('delete_local_Roster_cache_1', true);
//         }

//         //  await _localDb.clear();
//         List<ClassroomCourse>? _localData = await _localDb.getData();

//         if (_localData.isEmpty) {
//           //Managing dummy response for shimmer loading
//           var list = await _getRosterShimmerListData();
//           yield PBISPlusClassRoomShimmerLoading(shimmerCoursesList: list);
//         } else {
//           sort(obj: _localData);
//           yield PBISPlusImportRosterSuccess(
//               googleClassroomCourseList: _localData);
//         }

//         //API call to refresh with the latest data in the local DB
//         List responseList = await importPBISClassroomRoster(
//             accessToken: userProfileLocalData[0].authorizationToken,
//             refreshToken: userProfileLocalData[0].refreshToken,
//             isGradedPlus: event.isGradedPlus);

//         if (responseList[1] == '') {
//           List<ClassroomCourse> coursesList = responseList[0];

//           //Returning Google Classroom Course List from API response if local data is empty
//           //This will used to show shimmer loading on PBIS Score circle // Class Screen
//           // if (_localData.isEmpty) {
//           //   sort(obj: coursesList);
//           //   yield PBISPlusInitialImportRosterSuccess(
//           //       googleClassroomCourseList: responseList[0]);
//           // }

//           // List<PBISPlusTotalBehaviorModal> pbisTotalInteractionList = [];
//           //Get PBISTotal interaction only if Section is PBIS+
//           // if (event.isGradedPlus == false) {
//           //   pbisTotalInteractionList = await getPBISTotalInteractionByTeacher(
//           //       teacherEmail: userProfileLocalData[0].userEmail!);
//           // }
//           // if (event.isGradedPlus == false) {
//           //   pbisTotalInteractionList =
//           //       await getPBISTotalInteractionBySchoolAndTeacher(
//           //           teacherEmail: userProfileLocalData[0].userEmail!,
//           //           schoolId: Overrides.SCHOOL_ID);
//           // }
//           // print(pbisTotalInteractionList);
//           // Merge Student Interaction with Google Classroom Rosters
//           // List<ClassroomCourse> classroomStudentProfile =
//           //     await assignStudentTotalInteraction(
//           //         pbisTotalInteractionList, coursesList);

//           // Merge Student local Interaction with Google Classroom Rosters

//           coursesList =
//               await assignStudentTotalBehaviorWithClassroomCoursesList(
//                   coursesList);

//           await _localDb.clear();

//           coursesList.forEach((ClassroomCourse e) {
//             _localDb.addData(e);
//           });

//           PlusUtility.updateLogs(
//               activityType: event.isGradedPlus == true ? 'GRADED+' : 'PBIS+',
//               userType: 'Teacher',
//               activityId: '24',
//               description: 'Import Roster Successfully From PBIS+',
//               operationResult: 'Success');

//           yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
//           sort(obj: coursesList);
//           // await getFilteredStudentList(_localData);
//           print("api  courses lenght ${coursesList.length}");
//           yield PBISPlusImportRosterSuccess(
//               googleClassroomCourseList: coursesList);
//         } else {
//           yield PBISErrorState(
//             error: 'ReAuthentication is required',
//           );
//         }
//       } catch (e) {
//         print(e);

//         LocalDatabase<ClassroomCourse> _localDb =
//             LocalDatabase(plusClassroomDBTableName);
//         List<ClassroomCourse>? _localData = await _localDb.getData();
//         sort(obj: _localData);
//         // _localDb.close();
//         yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
//         // sort(obj: _localData);
//         // await getFilteredStudentList(_localData);
//         yield PBISPlusImportRosterSuccess(
//             googleClassroomCourseList: _localData);
//       }
//     }

    if (event is PBISPlusImportRoster) {
      String plusClassroomDBTableName = event.isGradedPlus == true
          ? OcrOverrides.gradedPlusStandardClassroomDB
          : PBISPlusOverrides.pbisPlusClassroomDB;
      try {
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(plusClassroomDBTableName);
        // await _localDb.clear();
        List<ClassroomCourse>? _localData = await _localDb.getData();

        if (_localData.isEmpty) {
          //Managing dummy response for shimmer loading
          var list = await _getRosterShimmerListData();
          yield PBISPlusClassRoomShimmerLoading(shimmerCoursesList: list);
        } else {
          sort(obj: _localData);
          yield PBISPlusImportRosterSuccess(
              googleClassroomCourseList: _localData);
        }
        //Clear Roster local data to manage loading issue
        SharedPreferences clearRosterCache =
            await SharedPreferences.getInstance();
        final clearCacheResult =
            await clearRosterCache.getBool('delete_local_Roster_cache_1');

        if (clearCacheResult != true) {
          await _localDb.close();
          _localData.clear();
          await clearRosterCache.setBool('delete_local_Roster_cache_1', true);
        }

        //API call to refresh with the latest data in the local DB
        List responseList = await importPBISClassroomRoster(
            accessToken: userProfileLocalData[0].authorizationToken,
            refreshToken: userProfileLocalData[0].refreshToken,
            isGradedPlus: event.isGradedPlus);

        if (responseList[1] == '') {
          List<ClassroomCourse> coursesList = responseList[0];
          List pbisTotalDefaultAndCustomBehaviourInteractionList = [];

          //Returning Google Classroom Course List from API response if local data is empty
          //This will used to show shimmer loading on PBIS Score circle // Class Screen
          if (_localData.isEmpty) {
            sort(obj: coursesList);
            yield PBISPlusInitialImportRosterSuccess(
                googleClassroomCourseList: coursesList);
          }

          //Get PBISTotal interaction only if Section is PBIS+
          if (event.isGradedPlus == false) {
            pbisTotalDefaultAndCustomBehaviourInteractionList =
                await Future.wait([
              pBISPlusGetStudentBehaviorBySection(
                  section: 'default',
                  teacherEmail: userProfileLocalData[0].userEmail!,
                  schoolId: Overrides.SCHOOL_ID),
              pBISPlusGetStudentBehaviorBySection(
                  section: 'custom',
                  teacherEmail: userProfileLocalData[0].userEmail!,
                  schoolId: Overrides.SCHOOL_ID)
            ]);
          }

          // Merge Student Interaction with Google Classroom Rosters
          List<ClassroomCourse> classroomStudentProfile =
              await assignStudentTotalInteraction(
                  classroomCourseList: coursesList,
                  pbisTotalDefaultAndCustomBehaviourInteractionList:
                      pbisTotalDefaultAndCustomBehaviourInteractionList);

          await _localDb.clear();
          classroomStudentProfile.forEach((ClassroomCourse e) {
            _localDb.addData(e);
          });

          PlusUtility.updateLogs(
              activityType: event.isGradedPlus == true ? 'GRADED+' : 'PBIS+',
              userType: 'Teacher',
              activityId: '24',
              description: 'Import Roster Successfully From PBIS+',
              operationResult: 'Success');

          yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
          sort(obj: classroomStudentProfile);
          // await getFilteredStudentList(_localData);
          yield PBISPlusImportRosterSuccess(
              googleClassroomCourseList: classroomStudentProfile);
        } else {
          yield PBISErrorState(error: 'ReAuthentication is required');
        }
      } catch (e) {
        print(e);

        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(plusClassroomDBTableName);
        List<ClassroomCourse>? _localData = await _localDb.getData();
        sort(obj: _localData);

        yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.

        yield PBISPlusImportRosterSuccess(
            googleClassroomCourseList: _localData);
      }
    }

    if (event is PBISPlusGetAdditionalBehavior) {
      LocalDatabase<PBISPlusCommonBehaviorModal> _localDb = LocalDatabase(
          PBISPlusOverrides.PbisPlusAdditionalBehaviorLocalDbTable);

      List<PBISPlusCommonBehaviorModal>? _localData = await _localDb.getData();

      try {
        if (_localData.isEmpty) {
          yield PBISPlusBehaviorLoading(
              demoBehaviorData: PBISPlusCommonBehaviorModal.demoBehaviorData);
        } else {
          yield PBISPlusAdditionalBehaviorSuccess(
              additionalBehaviorList: _localData);
        }

        List<PBISPlusCommonBehaviorModal> list =
            await getPBISAdditionalBehavior();

        // Sort the list based on the "order" key
        list = sortByOrder(list);
        await _localDb.clear();
        list.forEach((PBISPlusCommonBehaviorModal e) async {
          await _localDb.addData(e);
        });

        yield PBISPlusLoading();
        yield PBISPlusAdditionalBehaviorSuccess(additionalBehaviorList: list);
      } catch (e) {
        yield PBISErrorState(error: e.toString());
      }
    }

    /* -------------------------------------------------------------------------- */
    /* ------------------PBISPlusDeleteTeacherCustomBehavior-------------------- */
    /* -------------------------------------------------------------------------- */
    if (event is PBISPlusDeleteTeacherCustomBehavior) {
      LocalDatabase<PBISPlusCommonBehaviorModal> _localDb = LocalDatabase(
          PBISPlusOverrides.PbisPlusTeacherCustomBehaviorLocalDbTable);
      List<PBISPlusCommonBehaviorModal>? _localData = await _localDb.getData();

      try {
        var itemIndex;
        //remove the deleted item from db
        for (int i = 0; i < _localData.length; i++) {
          if (_localData[i].id == event.behavior.id) {
            itemIndex = i;
            _localData.removeAt(i);
            break;
          }
        }

        //clean localDB AND
        await _localDb.clear();

        //update the new sorting index every item in localDB
        _localData.asMap().forEach((index, element) async {
          element.pBISBehaviorSortOrderC = (index + 1).toString();
          await _localDb.addData(element);
        });

        yield PBISPlusLoading();
        yield PBISPlusGetTeacherCustomBehaviorSuccess(
            teacherCustomBehaviorList: _localData);

        var result = await deleteTeacherCustomBehavior(
            behavior: event.behavior,
            teacherId: await OcrUtility.getTeacherId() ?? '');

        if (result == true && _localData.isNotEmpty) {
          // Updating the changes to server after UI update to perform in background//no need to wait for APi response.

          await sortTheBehaviourInDB(
              allBehavior: _localData,
              teacherId: await OcrUtility.getTeacherId() ?? '');
        } else if (result != true &&
            _localData.isNotEmpty &&
            itemIndex != null) {
          //api delete api caught error
          //insert the deleted item from localDB
          _localData.insert(itemIndex, event.behavior);

          //clean localDB AND
          await _localDb.clear();
          //update the previous sorting index every item in localDB
          _localData.asMap().forEach((index, element) async {
            element.pBISBehaviorSortOrderC = (index + 1).toString();
            await _localDb.addData(element);
          });

          yield PBISPlusLoading();
          yield PBISPlusGetTeacherCustomBehaviorSuccess(
              teacherCustomBehaviorList: _localData, caughtError: result[1]);
        }
      } catch (e) {
        yield PBISPlusLoading();
        yield PBISPlusGetTeacherCustomBehaviorSuccess(
            caughtError: e.toString(), teacherCustomBehaviorList: _localData);
      }
    }

//---------------pbis student list SEARCH-------------------------------
    if (event is PBISPlusNotesSearchStudent) {
      try {
        yield PBISPlusLoading();
        if (event.searchKey.isNotEmpty) {
          final searchedList =
              await searchStudentList(event.studentNotes, event.searchKey);

          if (searchedList != null && searchedList.isNotEmpty) {
            yield PBISPlusStudentSearchSucess(sortedList: searchedList);
          } else {
            yield PBISErrorState(error: "No Student Found");
          }
        }
      } catch (e) {
        yield PBISErrorState(error: "No data found");
      }
    }

    /*----------------------------------------------------------------------------------------------*/
    /*------------------------------GetPBISTotalInteractionsByTeacher-------------------------------*/
    /*----------------------------------------------------------------------------------------------*/
    //:::::::::::::::::::::::::::::::::::::::::OLD way to add interaction::::::::::::::::::::::::::::::::::::::::::
    // if (event is AddPBISInteraction) {
    //   try {
    //     //Fetch logged in user profile
    //     List<UserInformation> userProfileLocalData =
    //         await UserGoogleProfile.getUserProfile();

    //     String? _objectName = "${PBISPlusOverrides.pbisStudentInteractionDB}";
    //     LocalDatabase<ClassroomCourse> _localDb = LocalDatabase(_objectName);
    //     List<ClassroomCourse> _localData = await _localDb.getData();

    //     yield PBISPlusLoading();
    //     if (_localData.isNotEmpty) {
    //       for (int i = 0; i < _localData.length; i++) {
    //         for (int j = 0; j < _localData[i].students!.length; j++) {
    //           if (_localData[i].students![j].profile!.id == event.studentId) {
    //             ClassroomCourse obj = _localData[i];
    //             // print(_localData[i].likeCount);
    //             _localDb.putAt(i, obj);
    //           }
    //         }
    //       }
    //     }

    //     var data = await addPBISInteraction({
    //       "Student_Id": event.studentId!,
    //       "Student_Email": event.studentEmail,
    //       "Classroom_Course_Id": "${event.classroomCourseId}",
    //       "Engaged": "${event.engaged}",
    //       "Nice_Work": "${event.niceWork}",
    //       "Helpful": "${event.helpful}",
    //       "School_Id": Overrides.SCHOOL_ID,
    //       "DBN": Globals.schoolDbnC,
    //       "Teacher_Email": userProfileLocalData[0].userEmail,
    //       "Teacher_Name":
    //           userProfileLocalData[0].userName!.replaceAll('%20', ' '),
    //       "Status": "active"
    //     });

    //     /*-------------------------User Activity Track START----------------------------*/
    //     PlusUtility.updateLogs(
    //         activityType: 'PBIS+',
    //         userType: 'Teacher',
    //         activityId: '38',
    //         description:
    //             'User Interaction PBIS+ ${data['body']['Id'].toString()} for student ${event.studentId}',
    //         operationResult: 'Success');
    //     /*-------------------------User Activity Track END----------------------------*/

    //     yield AddPBISInteractionSuccess(
    //       obj: data,
    //     );
    //   } catch (e) {
    //     if (e.toString().contains('NO_CONNECTION')) {
    //       Utility.showSnackBar(
    //           event.scaffoldKey,
    //           'Make sure you have a proper Internet connection',
    //           event.context,
    //           null);
    //     } else {
    //       Utility.showSnackBar(
    //           event.scaffoldKey, 'Something went wrong', event.context, null);
    //     }
    //     yield PBISErrorState(error: e);
    //   }
    // }

    if (event is PbisPlusAddPBISInteraction) {
      try {
        //Fetch logged in user profile
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        // LocalDatabase<ClassroomCourse> _localDb = LocalDatabase(_objectName);
        // List<ClassroomCourse> _localData = await _localDb.getData();

        // yield PBISPlusLoading();
        // if (_localData.isNotEmpty) {
        //   for (int i = 0; i < _localData.length; i++) {
        //     for (int j = 0; j < _localData[i].students!.length; j++) {
        //       if (_localData[i].students![j].profile!.id == event.studentId) {
        //         ClassroomCourse obj = _localData[i];

        //         _localDb.putAt(i, obj);
        //       }
        //     }
        //   }
        // }
        Map body = {
          "Student_Id": event.studentId!,
          "Student_Email": event.studentEmail,
          "Classroom_Course_Id": "${event.classroomCourseId}",
          "School_Id": Overrides.SCHOOL_ID,
          "DBN": Globals.schoolDbnC,
          "Teacher_Email": userProfileLocalData[0].userEmail,
          "Teacher_Name":
              userProfileLocalData[0].userName!.replaceAll('%20', ' '),
          "Status": "active",
          "Behaviour_Id": event.behaviour?.id.toString() ?? '',
          "Behaviour_Score": 1.toString()
        };

        var data = await addPBISInteraction(body: body);

        /*-------------------------User Activity Track START----------------------------*/
        PlusUtility.updateLogs(
            activityType: 'PBIS+',
            userType: 'Teacher',
            activityId: '38',
            description:
                '${event.isCustomBehavior == true ? 'Custom' : 'Default'} User Interaction PBIS+ ${data['body']['Id'].toString()} for student ${event.studentId}',
            operationResult: 'Success');
        /*-------------------------User Activity Track END----------------------------*/

        yield AddPBISInteractionSuccess(obj: data);
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
    // /* -------------------------------------------------------------------------- */
    // /*                    Event to get student details by email                   */
    // /* -------------------------------------------------------------------------- */

    if (event is PBISPlusResetInteractions) {
      try {
        //Save the event records in separate list to make sure not to change on runtime.
        List<ClassroomCourse> LocalSelectedRecords =
            List<ClassroomCourse>.from(event.selectedRecords);

        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        //REMOVE THE 'ALL' OBJECT FROM LIST IF EXISTS
        if (LocalSelectedRecords.length > 0 &&
            LocalSelectedRecords[0].name == 'All') {
          LocalSelectedRecords.removeAt(0);
        }

        var result = await resetPBISPlusInteractionInteractions(
          type: event.type,
          selectedCourses: LocalSelectedRecords,
          userProfile: userProfileLocalData[0],
        );
        if (result == true) {
          yield PBISPlusResetSuccess();
        } else {
          yield PBISErrorState(error: result);
        }
      } catch (e) {
        print(e);
        yield PBISErrorState(error: e.toString());
      }
    }

    if (event is PBISPlusGetDefaultSchoolBehavior) {
      LocalDatabase<PBISPlusCommonBehaviorModal> _localDb =
          LocalDatabase(PBISPlusOverrides.PbisPlusDefaultBehaviorLocalDbTable);

      List<PBISPlusCommonBehaviorModal>? _localData = await _localDb.getData();
      try {
        if (_localData.isEmpty) {
          yield PBISPlusBehaviorLoading(
              demoBehaviorData: PBISPlusCommonBehaviorModal.demoBehaviorData);
        } else {
          yield PBISPlusGetDefaultSchoolBehaviorSuccess(
              defaultSchoolBehaviorList: _localData);
        }

        List<PBISPlusCommonBehaviorModal> list =
            await getDefaultSchoolBehavior();

        await _localDb.clear();

        list.forEach((PBISPlusCommonBehaviorModal e) {
          _localDb.addData(e);
        });
        PBISPlusLoading();
        yield PBISPlusGetDefaultSchoolBehaviorSuccess(
            defaultSchoolBehaviorList: _localData);
      } catch (e) {
        yield PBISPlusLoading();
        yield PBISPlusGetDefaultSchoolBehaviorSuccess(
            caughtError: e.toString(), defaultSchoolBehaviorList: _localData);
      }
    }

    if (event is PBISPlusGetTeacherCustomBehavior) {
      LocalDatabase<PBISPlusCommonBehaviorModal> _localDb = LocalDatabase(
          PBISPlusOverrides.PbisPlusTeacherCustomBehaviorLocalDbTable);
      List<PBISPlusCommonBehaviorModal>? _localData = await _localDb.getData();

      try {
        if (_localData.isEmpty) {
          yield PBISPlusBehaviorLoading(
              demoBehaviorData: PBISPlusCommonBehaviorModal.demoBehaviorData);
        } else {
          yield PBISPlusGetTeacherCustomBehaviorSuccess(
              teacherCustomBehaviorList: _localData);
        }

        List<PBISPlusCommonBehaviorModal> list = await getTeacherCustomBehavior(
            teacherId: await OcrUtility.getTeacherId() ?? '');

        // Sort the list based on the "order" key
        list = await sortByOrder(list);

        await _localDb.clear();
        list.forEach((PBISPlusCommonBehaviorModal e) async {
          await _localDb.addData(e);
        });

        yield PBISPlusLoading();
        yield PBISPlusGetTeacherCustomBehaviorSuccess(
            teacherCustomBehaviorList: list);
      } catch (e) {
        yield PBISPlusLoading();
        yield PBISPlusGetTeacherCustomBehaviorSuccess(
            teacherCustomBehaviorList: _localData, caughtError: e.toString());
      }
    }

    // if (event is PBISPlusAddTeacherCustomBehavior) {
    //   LocalDatabase<PBISPlusCommonBehaviorModal> _localDb = LocalDatabase(
    //       PBISPlusOverrides.PbisPlusTeacherCustomBehaviorLocalDbTable);
    //   List<PBISPlusCommonBehaviorModal>? _localData = await _localDb.getData();

    //   try {
    //     //index null means added a new icon otherwise replce the index item
    //     bool isAddedNewIcon = event.index == null;

    //     //Adding new behavior
    //     if (isAddedNewIcon) {
    //       print("printing add new skill with ${event.behavior.behaviorTitleC}");
    //       print(
    //           "printing add new skill with ${event.behavior.pBISBehaviorSortOrderC}");
    //       String sortOrderC = (_localData.length + 1).toString();
    //       event.behavior.pBISBehaviorSortOrderC = sortOrderC;
    //       await _localDb.addData(event.behavior);
    //     }
    //     //Updating existing behavior
    //     else {
    //       print("printing replce  skill with ${event.behavior.behaviorTitleC}");
    //       print(
    //           "printing replce  skill with ${event.behavior.pBISBehaviorSortOrderC}");
    //       String sortOrderC = (event.index! + 1).toString();
    //       event.behavior.pBISBehaviorSortOrderC = sortOrderC;
    //       await _localDb.putAt(event.index!, event.behavior);
    //     }

    //     List result = await addTeacherCustomBehavior(
    //         behavior: event.behavior,
    //         schoolId: Overrides.SCHOOL_ID ?? "",
    //         teacherId: await OcrUtility.getTeacherId() ?? "",
    //         isAddedNewIcon: isAddedNewIcon);

    //     //Fetching updated value
    //     _localData.clear();
    //     _localData = await _localDb.getData();

    //     if (result[0] == true && isAddedNewIcon == true) {
    //       if (_localData.isNotEmpty) {
    //         int updateIndex = _localData.length - 1;
    //         _localData[updateIndex].id = result[1];
    //         await _localDb.putAt(updateIndex, _localData[updateIndex]);
    //       }
    //     }

    //     yield PBISPlusLoading();
    //     yield PBISPlusGetTeacherCustomBehaviorSuccess(
    //         teacherCustomBehaviorList: _localData);
    //   } catch (e) {
    //     print(e);
    //   }
    // }

    if (event is PBISPlusAddAndUpdateTeacherCustomBehavior) {
      LocalDatabase<PBISPlusCommonBehaviorModal> _localDb = LocalDatabase(
          PBISPlusOverrides.PbisPlusTeacherCustomBehaviorLocalDbTable);
      List<PBISPlusCommonBehaviorModal>? _localData = await _localDb.getData();

      try {
        //index null means added a new icon otherwise replce the index item
        bool isAddedNewIcon = event.index == null;

        //Adding new behavior SortOrder
        if (isAddedNewIcon) {
          String sortOrderC = (_localData.length + 1).toString();
          event.behavior.pBISBehaviorSortOrderC = sortOrderC;
          // await _localDb.addData(event.behavior);
        }

        List result = await addTeacherCustomBehavior(
            behavior: event.behavior,
            schoolId: Overrides.SCHOOL_ID ?? "",
            teacherId: await OcrUtility.getTeacherId() ?? "",
            isAddedNewIcon: isAddedNewIcon);

        if (result[0] == true) {
          //Adding new behavior
          if (isAddedNewIcon == true) {
            //Updating existing behavior SortOrder
            event.behavior.id = result[1];
            _localData.add(event.behavior);
            await _localDb.addData(event.behavior);
          }
          //Updating existing behaviour //icon//name
          else if (event.index != null) {
            //Updating existing behavior
            _localData[event.index!] = event.behavior;
            await _localDb.putAt(event.index!, event.behavior);
          }
        }

        yield PBISPlusLoading();
        yield PBISPlusGetTeacherCustomBehaviorSuccess(
            caughtError: result[0] == false ? result[1] : null,
            teacherCustomBehaviorList: _localData);
      } catch (e) {
        yield PBISPlusLoading();
        yield PBISPlusGetTeacherCustomBehaviorSuccess(
            caughtError: e.toString(), teacherCustomBehaviorList: _localData);
      }
    }
//------------------------------GET STUDENT LIST NOTES-----------------------
    if (event is GetPBISPlusStudentList) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        //Fetching list of student from local db stored
        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(PBISPlusOverrides.pbisPlusClassroomDB);
        List<ClassroomCourse>? _localData = await _localDb.getData();

        //Returning the list locally first
        if (_localData.isEmpty) {
          yield PBISPlusLoading();
        } else {
          List<PBISPlusNotesUniqueStudentList> list =
              await getUniqueStudentListForNotesScreen(_localData);
          yield PBISPlusStudentListSucess(studentList: list);
        }

        List responseList = await importPBISClassroomRoster(
            accessToken: userProfileLocalData[0].authorizationToken,
            refreshToken: userProfileLocalData[0].refreshToken,
            isGradedPlus: false);

        if (responseList[1] == '') {
          List<ClassroomCourse> coursesList = responseList[0];
          await _localDb.clear();
          coursesList.forEach((ClassroomCourse e) {
            _localDb.addData(e);
          });

          // Just to mimic the state change otherwise UI won't update unless if there's no state change.
          yield PBISPlusLoading();

          List<PBISPlusNotesUniqueStudentList> updatedList =
              await getUniqueStudentListForNotesScreen(coursesList);
          yield PBISPlusStudentListSucess(studentList: updatedList);
        } else {
          yield PBISErrorState(
            error: 'ReAuthentication is required',
          );
        }
      } catch (e) {
        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(PBISPlusOverrides.pbisPlusClassroomDB);
        List<ClassroomCourse>? _localData = await _localDb.getData();

        List<PBISPlusNotesUniqueStudentList> list =
            await getUniqueStudentListForNotesScreen(_localData);
        yield PBISPlusStudentListSucess(studentList: list);
      }
    }

//---------------------------------*GET THE STUDENT NOTES*----------------------------//
    if (event is GetPBISPlusNotes) {
      try {
        LocalDatabase<PBISPlusNotesUniqueStudentList>
            _pbisPlusSNotesStudentListDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusStudentListDB);

        List<PBISPlusNotesUniqueStudentList>? _pbisPlusNotesStudentsList =
            await _pbisPlusSNotesStudentListDB.getData();

        // Find student data index in local db
        int studentItemIndex = _pbisPlusNotesStudentsList.indexWhere(
          (student) => student.studentId == event.studentId,
        );

        // If the notes exits in the local db then return to notes  to UI
        if (_pbisPlusNotesStudentsList.isEmpty ||
            _pbisPlusNotesStudentsList[studentItemIndex].notes == null ||
            _pbisPlusNotesStudentsList[studentItemIndex].notes!.isEmpty) {
          yield PBISPlusLoading();
        } else {
          yield PBISPlusNotesSucess(
              notesList: _pbisPlusNotesStudentsList[studentItemIndex].notes!);
        }

        //Calling the API
        List<PBISStudentNotes>? studentNotesList =
            await getPBIStudentNotesData(student_id: event.studentId);

        if (studentItemIndex >= 0
            // &&
            // studentNotesList != null && studentNotesList.isNotEmpty
            ) {
          // Assuming want to update the notes with the first API data
          _pbisPlusNotesStudentsList[studentItemIndex].notes = studentNotesList;

          //Updating the notes data in local db
          await _pbisPlusSNotesStudentListDB.clear();
          _pbisPlusNotesStudentsList.forEach((element) async {
            await _pbisPlusSNotesStudentListDB.addData(element);
          });
        }
        yield PBISPlusLoading();
        yield PBISPlusNotesSucess(notesList: studentNotesList);
      } catch (e) {
        yield PBISErrorState(error: "No Notes Found");
      }
    }

    //----------------------------------------ADD THE NEW  NOTES---------------------------------------- //
    if (event is AddPBISPlusStudentNotes) {
      try {
        yield PBISPlusLoading();

        bool apiData = await addPBIStudentNotes(
            studentId: event.studentId,
            studentName: event.studentName,
            studentEmail: event.studentEmail,
            schoolId: event.schoolId,
            notes: event.notes);

        if (apiData == true) {
          yield PBISPlusAddNotesSucess();
        } else {
          yield PBISErrorState(
              error: "Failed to add the note. Please try again later.");
        }
      } catch (e) {
        yield PBISErrorState(
            error: "Failed to add the note. Please try again later.");
      }
    }

    // if (event is PBISPlusGetStudentBehaviorByCourse) {
    //   String courseLocalDbTable =
    //       '${event.classroomCourse.id}_${event.classroomCourse.name}';
    //   LocalDatabase<PBISPlusTotalBehaviorModal> _localDb =
    //       LocalDatabase(courseLocalDbTable);
    //   List<PBISPlusTotalBehaviorModal>? _localData = await _localDb.getData();
    //   try {
    //     if (_localData.isEmpty) {
    //       print("EMPTYYYYYYYYYYYYYYY  $courseLocalDbTable");
    //       yield PBISPlusLoading();
    //     } else {
    //       print("NOT EMPTYYYYYYYYYYYYYYY  $courseLocalDbTable");
    //       ClassroomCourse classroomStudentProfile =
    //           await assignStudentTotalBehavior(
    //               event.classroomCourse, _localData);
    //       yield PBISPlusLoading();
    //       yield PBISPlusGetStudentBehaviorByCourseSuccess(
    //           classroomCourse: classroomStudentProfile);
    //     }

    //     List<PBISPlusTotalBehaviorModal> pbisTotalBehaviorList =
    //         await pBISPlusGetStudentBehaviorBySection(
    //       section: 'default',
    //       teacherEmail: event.teacherEmail ?? '',
    //       schoolId: Overrides.SCHOOL_ID,
    //     );

    //     if (pbisTotalBehaviorList.isNotEmpty) {
    //       await _localDb.clear();
    //       pbisTotalBehaviorList.forEach((element) async {
    //         await _localDb.addData(element);
    //       });
    //     }

    //     ClassroomCourse classroomStudentProfile =
    //         await assignStudentTotalBehavior(
    //             event.classroomCourse, pbisTotalBehaviorList);
    //     yield PBISPlusLoading();
    //     yield PBISPlusGetStudentBehaviorByCourseSuccess(
    //         classroomCourse: classroomStudentProfile);
    //   } catch (e) {
    //     print(e);
    //     if (_localData.isEmpty) {
    //       yield PBISPlusGetStudentBehaviorByCourseSuccess(
    //           classroomCourse: event.classroomCourse);
    //     }
    //   }
    // }
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

        LocalDatabase<PBISPlusStudentDashboardTotalBehaviourModal> _localDb =
            LocalDatabase(sectionTableName);

        List<PBISPlusStudentDashboardTotalBehaviourModal>? _localData =
            await _localDb.getData();

        if (_localData.isNotEmpty) {
          yield PBISPlusStudentDashboardLogSuccess(
              pbisStudentInteractionList: _localData,
              isLoading: _localData.length >= 20);
        } else {
          yield PBISPlusLoading();
        }

        List<PBISPlusStudentDashboardTotalBehaviourModal> pbisStudentDetails =
            await getPBISPlusStudentDashboardLogs(
                studentId: event.studentId,
                teacherEmail: userProfileLocalData[0].userEmail!,
                classroomCourseId: event.classroomCourseId,
                isStudentPlus: event.isStudentPlus,
                limit: PBISPlusOverrides.studentDashbordRowsPerPage,
                offset: 0);

        await _localDb.clear();
        pbisStudentDetails.forEach(
            (PBISPlusStudentDashboardTotalBehaviourModal element) async {
          await _localDb.addData(element);
        });

        yield PBISPlusLoading();
        yield PBISPlusStudentDashboardLogSuccess(
            pbisStudentInteractionList: pbisStudentDetails,
            isLoading: pbisStudentDetails.length >= 20);
      } catch (e) {
        LocalDatabase<PBISPlusStudentDashboardTotalBehaviourModal> _localDb =
            LocalDatabase(sectionTableName);
        List<PBISPlusStudentDashboardTotalBehaviourModal>? _localData =
            await _localDb.getData();
        yield PBISPlusStudentDashboardLogSuccess(
            pbisStudentInteractionList: _localData,
            isLoading: _localData.length >= 20);
      }
    }

    //Managing pagination with separate event to save only first batch in local db and all other data will be fetched each time
    if (event is PBISPlusGetMoreStudentDashboardLogs) {
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();

        List<PBISPlusStudentDashboardTotalBehaviourModal> pbisStudentDetails =
            await getPBISPlusStudentDashboardLogs(
                studentId: event.studentId,
                teacherEmail: userProfileLocalData[0].userEmail!,
                classroomCourseId: event.classroomCourseId,
                isStudentPlus: event.isStudentPlus,
                limit: PBISPlusOverrides.studentDashbordRowsPerPage,
                offset: event.pbisStudentInteractionList.length);

        event.pbisStudentInteractionList.addAll(pbisStudentDetails);
        yield PBISPlusLoading();

        yield PBISPlusStudentDashboardLogSuccess(
            pbisStudentInteractionList: event.pbisStudentInteractionList,
            isLoading: pbisStudentDetails.length >= 20);
      } catch (e) {
        yield PBISPlusLoading();

        yield PBISPlusStudentDashboardLogSuccess(
            pbisStudentInteractionList: event.pbisStudentInteractionList,
            isLoading: event.pbisStudentInteractionList.length >= 20);
        print(e);
      }
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*---------------------------------Function importPBISClassroomRoster---------------------------*/
  /*----------------------------------------------------------------------------------------------*/

  Future<List> importPBISClassroomRoster(
      {required String? accessToken,
      required String? refreshToken,
      required bool? isGradedPlus}) async {
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
        var result = await Authentication.refreshAuthenticationToken(
            refreshToken: refreshToken ?? '');

        if (result == true) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          List responseList = await importPBISClassroomRoster(
              accessToken: _userProfileLocalData[0].authorizationToken,
              refreshToken: _userProfileLocalData[0].refreshToken,
              isGradedPlus: isGradedPlus);
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
          activityType: isGradedPlus == true ? 'GRADED+' : 'PBIS+',
          userType: 'Teacher',
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

  // Future addPBISInteraction(body) async {
  //   try {
  //     final ResponseModel response = await _dbServices.postApi(
  //         'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/interactions',
  //         headers: {
  //           'Content-Type': 'application/json;charset=UTF-8',
  //           'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
  //         },
  //         body: body,
  //         isGoogleApi: true);
  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else {
  //       throw ('something_went_wrong');
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  Future addPBISInteraction({required Map body, int retry = 3}) async {
    print(body);
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
      } else if (retry > 0) {
        return addPBISInteraction(body: body, retry: retry - 1);
      }
    } catch (e) {
      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*------------------------------Function getPBISTotalInteractionByTeacher-----------------------*/
  /*----------------------------------------------------------------------------------------------*/

  // Future<List<PBISPlusTotalInteractionModal>> getPBISTotalInteractionByTeacher(
  //     {required String teacherEmail, int retry = 3}) async {
  //   try {
  //     print(
  //         "------------teacherEmail ------===========-${teacherEmail}==============----------------");
  //     final ResponseModel response = await _dbServices.getApiNew(
  //         'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/interactions/teacher/$teacherEmail',
  //         headers: {
  //           'Content-Type': 'application/json;charset=UTF-8',
  //           'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
  //         },
  //         isCompleteUrl: true);

  //     if (response.statusCode == 200 && response.data['statusCode'] == 200) {
  //       return response.data['body']
  //           .map<PBISPlusTotalInteractionModal>(
  //               (i) => PBISPlusTotalInteractionModal.fromJson(i))
  //           .toList();
  //     } else if (retry > 0) {
  //       return getPBISTotalInteractionByTeacher(
  //           teacherEmail: teacherEmail, retry: retry - 1);
  //     }
  //     return [];
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  /*----------------------------------------------------------------------------------------------*/
  /*-----------------Function to assign the student interaction with classroom--------------------*/
  /*----------------------------------------------------------------------------------------------*/

  // List<ClassroomCourse> assignStudentTotalInteraction({
  //   required List<PBISPlusTotalBehaviorModal> pbisTotalBehaviorList,
  //   required List<ClassroomCourse> classroomCourseList,
  // }) {
  //   List<ClassroomCourse> classroomStudentProfile = [];

  //   // classroomStudentProfile.clear();
  //   if (pbisTotalBehaviorList.length == 0) {
  //     //Add 0 interaction counts to all the post in case of no interaction found
  //     classroomStudentProfile.addAll(classroomCourseList);
  //   } else {
  //     for (int i = 0; i < classroomCourseList.length; i++) {
  //       ClassroomCourse classroomCourse = ClassroomCourse();
  //       classroomCourse
  //         ..id = classroomCourseList[i].id
  //         ..name = classroomCourseList[i].name
  //         ..enrollmentCode = classroomCourseList[i].enrollmentCode
  //         ..descriptionHeading = classroomCourseList[i].descriptionHeading
  //         ..ownerId = classroomCourseList[i].ownerId
  //         ..courseState = classroomCourseList[i].courseState
  //         ..students = classroomCourseList[i].students;

  //       bool interactionCountsFound = false;

  //       for (int j = 0; j < classroomCourseList[i].students!.length; j++) {
  //         for (int k = 0; k < pbisTotalBehaviorList.length; k++) {

  //           if (classroomCourseList[i].id ==
  //                   pbisTotalBehaviorList[k].classroomCourseId &&
  //               classroomCourseList[i].students![j].profile!.id ==
  //                   pbisTotalBehaviorList[k].studentId) {
  //             //TODOPBIS:
  //             // classroomCourse.students![j].profile!.behavior1!.counter =
  //             //     pbisTotalInteractionList[k].engaged;
  //             // classroomCourse.students![j].profile!.behavior2!.counter =
  //             //     pbisTotalInteractionList[k].niceWork;
  //             // classroomCourse.students![j].profile!.behavior3!.counter =
  //             //     pbisTotalInteractionList[k].helpful;
  //             // classroomCourse.students![j].profile!.engaged =
  //             //     pbisTotalInteractionList[k].engaged;
  //             // classroomCourse.students![j].profile!.niceWork =
  //             //     pbisTotalInteractionList[k].niceWork;
  //             // classroomCourse.students![j].profile!.helpful =
  //             //     pbisTotalInteractionList[k].helpful;
  //             classroomCourse.students![j].profile!.behaviorList =
  //                 pbisTotalBehaviorList[k].behaviorList;
  //             interactionCountsFound = true;
  //             // print(classroomCourse.students![j].profile!.studentInteraction);
  //             break;
  //           }
  //         }
  //       }

  //       //Adding 0 interaction where no interaction added yet
  //       if (!interactionCountsFound) {
  //         // If no interaction counts were found, set all counts to 0
  //         for (int j = 0; j < classroomCourseList[i].students!.length; j++) {
  //           //TODOPBIS::
  //           // classroomCourse.students![j].profile!.behavior1?.counter = 0;
  //           // classroomCourse.students![j].profile!.behavior2?.counter = 0;
  //           // classroomCourse.students![j].profile!.behavior3?.counter = 0;
  //           // classroomCourse.students![j].profile!.engaged = 0;
  //           // classroomCourse.students![j].profile!.niceWork = 0;
  //           // classroomCourse.students![j].profile!.helpful = 0;
  //         }
  //       }

  //       classroomStudentProfile.add(classroomCourse);
  //     }
  //   }
  //   return classroomStudentProfile;
  // }

//-----------------------------------------------------------------------------------------------
//Updating student interaction to Roster list
  List<ClassroomCourse> assignStudentTotalInteraction({
    required List? pbisTotalDefaultAndCustomBehaviourInteractionList,
    required List<ClassroomCourse> classroomCourseList,
  }) {
    List<ClassroomCourse> classroomStudentProfile = [];

    if (pbisTotalDefaultAndCustomBehaviourInteractionList == null ||
        pbisTotalDefaultAndCustomBehaviourInteractionList.isEmpty) {
      // Add 0 interaction counts to all the students in the classroomCourseList
      classroomStudentProfile.addAll(classroomCourseList);
    } else {
      for (int i = 0; i < classroomCourseList.length; i++) {
        ClassroomCourse classroomCourse = classroomCourseList[i];

        for (int j = 0; j < classroomCourse.students!.length; j++) {
          // Define defaultBehviour and customBehviour lists directly inside the loop
          List<PBISPlusTotalBehaviorModal> defaultBehviour =
              pbisTotalDefaultAndCustomBehaviourInteractionList[0];
          List<PBISPlusTotalBehaviorModal> customBehviour =
              pbisTotalDefaultAndCustomBehaviourInteractionList[1];

          for (int d = 0; d < defaultBehviour.length; d++) {
            if (classroomCourse.id == defaultBehviour[d].classroomCourseId &&
                classroomCourse.students![j].profile!.emailAddress ==
                    defaultBehviour[d].studentEmail) {
              classroomCourse.students![j].profile!.behaviorList!
                  .addAll(defaultBehviour[d].behaviorList!);

              break;
            }
          }

          for (int c = 0; c < customBehviour.length; c++) {
            if (classroomCourse.id == customBehviour[c].classroomCourseId &&
                classroomCourse.students![j].profile!.emailAddress ==
                    customBehviour[c].studentEmail) {
              classroomCourse.students![j].profile!.behaviorList!
                  .addAll(customBehviour[c].behaviorList!);

              break;
            }
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
  /*--------------------------------Function createPBISPlusHistoryData----------------------------*/
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

  Future<List<PBISPlusStudentDashboardTotalBehaviourModal>>
      getPBISPlusStudentDashboardLogs(
          {required String studentId, //Id/Email
          required String teacherEmail,
          int retry = 3,
          required String classroomCourseId,
          required bool? isStudentPlus,
          required int offset,
          required int limit}) async {
    try {
      String url = isStudentPlus == true
          ? '${PBISPlusOverrides.pbisBaseUrl}pbis/interactions/v2/student/$studentId?teacher_email=$teacherEmail&school_Id=${Globals.appSetting.id}&offset=$offset&limit=$limit'
          : '${PBISPlusOverrides.pbisBaseUrl}pbis/interactions/v2/student/$studentId?teacher_email=$teacherEmail&school_Id=${Globals.appSetting.id}&classroom_course_id=$classroomCourseId&offset=$offset&limit=$limit';
      print(url);
      final ResponseModel response = await _dbServices.getApiNew(url,
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return response.data['body']
            .map<PBISPlusStudentDashboardTotalBehaviourModal>(
                (i) => PBISPlusStudentDashboardTotalBehaviourModal.fromJson(i))
            .toList();
      } else if (retry > 0) {
        return getPBISPlusStudentDashboardLogs(
            studentId: studentId,
            teacherEmail: teacherEmail,
            retry: retry - 1,
            classroomCourseId: classroomCourseId,
            isStudentPlus: isStudentPlus,
            limit: limit,
            offset: offset);
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
      //if user reset Course //All Courses & Students||Select Students
      if (type == PBISPlusOverrides.kresetOptionOnetitle ||
          type == PBISPlusOverrides.kresetOptionThreetitle) {
        // Create a comma-separated string of Courses for a list of selected classroom courses "('','','')"
        String classroomCourseIds =
            selectedCourses.map((course) => course.id).join("','");
        body.addAll({"Classroom_Course_Id": "('$classroomCourseIds')"});
      }
      //Select Courses
      else if (type == PBISPlusOverrides.kresetOptionTwotitle) {
        // Create a comma-separated string of student IDs for a list of selected classroom courses "('','','')"
        String studentIds = selectedCourses
            .expand((course) => course.students ?? [])
            .map((student) => student.profile?.id)
            .where((id) => id != null && id.isNotEmpty)
            .toSet() // Convert to Set to remove duplicates
            .map((id) => "$id")
            .join("', '");
        // Surround the string with double quotes and  (parentheses)

        body.addAll({"Student_Id": "('$studentIds')"});
      }
      // Select Students by Course
      else if (type == PBISPlusOverrides.kresetOptionFourtitle) {
        List<Map<String, dynamic>> courseIdsAndStudentIds = [];
        for (ClassroomCourse course in selectedCourses) {
          // Create a map to store Classroom_Course_Id and Student_Id
          Map<String, dynamic> classroomCourse = {
            "Classroom_Course_Id": course.id,
            "Student_Id": <String>[],
          };
          // Create a list to store student IDs //For every course index
          List<String> studentIds = [];
          // Iterate over each ClassroomStudents in course.students (handling null case with ?? [])
          for (ClassroomStudents student in course.students ?? []) {
            // Check if student.profile and student.profile.id are not null
            if (student.profile?.id != null &&
                student.profile!.id!.isNotEmpty) {
              // Add student ID to the list only if id was not null and empty
              studentIds.add(student.profile!.id!);
            } else if (student.profile?.emailAddress != null &&
                student.profile!.emailAddress!.isNotEmpty) {
              //  Add student email to the list only if id was null or empty
              studentIds.add(student.profile!.emailAddress!);
            }
          }
          // Assign the list of student IDs to the "Student_Id" key in the classroomCourse map
          classroomCourse["Student_Id"] = studentIds;
          // Add the classroomCourse map to the list of courseIdsAndStudentIds

          courseIdsAndStudentIds.add(classroomCourse);
        }
// Add the courseIdsAndStudentIds to the "Student_Details" key in the api body
        body.addAll({"Student_Details": courseIdsAndStudentIds});
      }

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
      throw (e);
    }
  }

  /* -------------------------------------------------------------------------- */
  /* --------Function to manage the shimmer loading for classroom courses------ */
  /* -------------------------------------------------------------------------- */

  Future<List<ClassroomCourse>> _getRosterShimmerListData() async {
    try {
      final String response = await rootBundle.loadString(
          'lib/src/modules/pbis_plus/pbis_plus_asset/pbis_plus_classroom_shimmer_loading_data.json');

      final data = await json.decode(response);

      return data
          .map<ClassroomCourse>((i) => ClassroomCourse.fromJson(i))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  //------------FILTER THE STUDENT LIST FROM THE ROASTER DATA SAVE TO LOCAL DB------For NotesPage----///

  Future getUniqueStudentListForNotesScreen(
      List<ClassroomCourse> allClassroomCourses) async {
    try {
      List<ClassroomStudents> uniqueStudents = <ClassroomStudents>[];
      List<PBISPlusNotesUniqueStudentList> list = [];

      LocalDatabase<PBISPlusNotesUniqueStudentList> _pbisPlusStudentListDB =
          LocalDatabase(PBISPlusOverrides.pbisPlusStudentListDB);

      //DELTE THE STUDENT LIST
      SharedPreferences clearNewsCache = await SharedPreferences.getInstance();
      final clearCacheResult =
          clearNewsCache.getBool('delete_local_all_notes_Student');

      if (clearCacheResult != true) {
        print('Inside clear state');
        await _pbisPlusStudentListDB.clear();
        await clearNewsCache.setBool('delete_local_all_notes_Student', true);
      }

      List<PBISPlusNotesUniqueStudentList>? _pbisPlusStudentDataList =
          await _pbisPlusStudentListDB.getData();

      //Creating the unique student list
      for (final ClassroomCourse course in allClassroomCourses) {
        for (final ClassroomStudents student in course?.students ?? []) {
          if (student.profile != null &&
              !uniqueStudents
                  .any((s) => s.profile?.id == student.profile?.id)) {
            student.profile!.courseName = course.name;
            uniqueStudents.add(student);
          }
        }
      }
      //Sorting the unique student list in alphabetically order
      uniqueStudents.sort((a, b) => a.profile!.name!.fullName!
          .toLowerCase()
          .compareTo(b.profile!.name!.fullName!.toLowerCase()));

      //--------------------------------NEW WAY TO MAP THE DATA IT SAVED THE PERVIOULSY NOTES  THE STUDENTS ------------- /
      if (_pbisPlusStudentDataList.isNotEmpty) {
        list = uniqueStudents.map((item) {
          // Check if the student already exists in the local database
          PBISPlusNotesUniqueStudentList existingStudent =
              PBISPlusNotesUniqueStudentList();
          List<PBISStudentNotes>? notes;

          try {
            existingStudent = _pbisPlusStudentDataList.firstWhere(
                (e) => e.studentId == item.profile?.id,
                orElse: () => PBISPlusNotesUniqueStudentList());
            notes = existingStudent.notes ?? null;
          } catch (e) {
            notes = null;
          }

          return PBISPlusNotesUniqueStudentList(
            email: item.profile!.emailAddress!,
            names: StudentName(
              familyName: item.profile!.name!.familyName!,
              fullName: item.profile!.name!.fullName!,
              givenName: item.profile!.name!.givenName!,
            ),
            iconUrlC: item.profile?.photoUrl!,
            studentId: item.profile?.id,
            notes: notes, // Assign the existing notes or null
          );
        }).toList();
      } else {
        list = uniqueStudents
            .map((item) => PBISPlusNotesUniqueStudentList(
                email: item.profile!.emailAddress!,
                names: StudentName(
                    familyName: item.profile!.name!.familyName!,
                    fullName: item.profile!.name!.fullName!,
                    givenName: item.profile!.name!.givenName!),
                iconUrlC: item.profile?.photoUrl!,
                studentId: item.profile?.id,
                notes: null))
            .toList();
      }

      await _pbisPlusStudentListDB.clear();
      list.forEach((element) async {
        await _pbisPlusStudentListDB.addData(element);
      });

      return list;
    } catch (e) {
      print('INSIDE EXPECTION IN THE STUDENT LIST  $e');
      throw (e);
    }
  }

  Future<List<ClassroomStudents>> getUniqueStudentList(
      List<ClassroomCourse> allClassroomCourses) async {
    List<ClassroomStudents> uniqueStudents = [];

    try {
      for (final ClassroomCourse course in allClassroomCourses) {
        for (ClassroomStudents student in course.students ?? []) {
          final isStudentUnique =
              !uniqueStudents.any((s) => s.profile?.id == student.profile?.id);

          if (isStudentUnique) {
            student.profile!.courseName = course.name;
            uniqueStudents.add(student);
          }
        }
      }
    } catch (e) {
      print("An exception occurred in getUniqueStudentList :$e");
    }

    return uniqueStudents;
  }

//-----------------------------------GET THE  ADDITIONAL BEHAVIOUR List----------------------------------------//

  Future<List<PBISPlusCommonBehaviorModal>> getPBISAdditionalBehavior() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/PBIS_Custom_Icon__c',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PBISPlusCommonBehaviorModal> resp = response.data['body']
            .map<PBISPlusCommonBehaviorModal>((i) =>
                PBISPlusCommonBehaviorModal.fromJsonForAdditionalBehavior(i))
            .toList();

        return resp;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

/*----------------------------------------------------------------------------------------------*/
/*------------------------Function getPBISPlusBehaviorAdditionalBehaviorList--------------------*/
/*----------------------------------------------------------------------------------------------*/

  Future getPBISPlusBehaviorAdditionalBehaviorList() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          '${Overrides.API_BASE_URL2}production/getRecords/PBIS_Custom_Icon__c',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PbisPlusAdditionalBehaviorList> resp = response.data['body']
            .map<PbisPlusAdditionalBehaviorList>(
                (i) => PbisPlusAdditionalBehaviorList.fromJson(i))
            .toList();

        return resp;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

/*----------------------------------------------------------------------------------------------*/
/*---------------------------------Function GetDefaultSchoolBehavior----------------------------*/
/*----------------------------------------------------------------------------------------------*/

  Future<List<PBISPlusCommonBehaviorModal>> getDefaultSchoolBehavior() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/filterRecords/PBIS_School_Behavior__c/"Mobile_App__c" = \'${Overrides.SCHOOL_ID}\'',
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        List<PBISPlusCommonBehaviorModal> _list = response.data['body']
            .map<PBISPlusCommonBehaviorModal>(
                (i) => PBISPlusCommonBehaviorModal.fromJson(i))
            .toList();

        return _list;
      }

      return [];
    } catch (e) {
      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*--------------------------------Function getTeacherCustomBehavior-----------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  Future<List<PBISPlusCommonBehaviorModal>> getTeacherCustomBehavior(
      {required String teacherId}) async {
    print("teacherId $teacherId");
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/behaviour/get-custom-behaviour/teacher/${teacherId}',
          isCompleteUrl: true);
      if (response.statusCode == 200) {
        List<PBISPlusCommonBehaviorModal> _list = response.data['body']
            .map<PBISPlusCommonBehaviorModal>((i) =>
                PBISPlusCommonBehaviorModal.fromJsonForTeacherCustomBehavior(i))
            .toList();

        return _list;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*------------------------------Function deleteTeacherCustomBehavior----------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  Future<dynamic> deleteTeacherCustomBehavior(
      {required PBISPlusCommonBehaviorModal behavior,
      required String teacherId,
      int retry = 3}) async {
    try {
      final url =
          "https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/behaviour/delete-behaviour/teacher/$teacherId/behaviour/${behavior.id}";

      final ResponseModel response = await _dbServices.deleteApi(
        url,
      );

      if (response.statusCode == 200) {
        return true;
      } else if (retry > 0) {
        return deleteTeacherCustomBehavior(
            behavior: behavior, teacherId: teacherId, retry: retry - 1);
      }
      return response.statusCode.toString();
    } catch (e) {
      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*-------------------------------Function addTeacherCustomBehavior------------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  Future<List> addTeacherCustomBehavior(
      {required PBISPlusCommonBehaviorModal behavior,
      required String teacherId,
      required String schoolId,
      required bool isAddedNewIcon,
      int retry = 3}) async {
    try {
      Map body = {
        "behaviour_name": behavior.behaviorTitleC.toString(),
        "behaviour_score": "1",
        "is_default_behaviour": "false",
        "icon_url": behavior.pBISBehaviorIconURLC.toString(),
        "teacher_id": teacherId.toString(),
        "school_id": schoolId.toString(),
        "sorting_order": behavior.pBISBehaviorSortOrderC.toString()
      };

      //Add behavior id to request body in case of behavior update
      if (isAddedNewIcon == false) {
        body.addAll({"behaviour_id": behavior.id});
      }

      final headers = {
        "Content-Type": "application/json;charset=UTF-8",
        "Authorization": "r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx"
      };
      // print(body);
      final url =
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/behaviour/add-behaviour';

      final ResponseModel response = await _dbServices.postApi(url,
          headers: headers, body: body, isGoogleApi: true);

      if (response.statusCode == 200) {
        String behavior_id = response.data['body']['Id'].toString();
        return [true, behavior_id];
      } else if (retry > 0) {
        return addTeacherCustomBehavior(
            behavior: behavior,
            teacherId: teacherId,
            schoolId: schoolId,
            isAddedNewIcon: isAddedNewIcon,
            retry: retry - 1);
      }
      return [false, response.statusCode.toString()];
    } catch (e) {
      throw (e);
    }
  }

  /*----------------------------------------------------------------------------------------------*/
  /*-------------------------------------Function sortByOrder-------------------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  List<PBISPlusCommonBehaviorModal> sortByOrder(
      List<PBISPlusCommonBehaviorModal> allBehaviors) {
    allBehaviors.sort((a, b) {
      int orderA = int.parse(
          a.pBISBehaviorSortOrderC != '' ? a.pBISBehaviorSortOrderC! : '1');
      int orderB = int.parse(
          b.pBISBehaviorSortOrderC != '' ? b.pBISBehaviorSortOrderC! : '1');

      return orderA.compareTo(orderB);
      // For descending order: return orderB.compareTo(orderA);
    });
    return allBehaviors;
  }

  /*----------------------------------------------------------------------------------------------*/
  /*-----------------------------------Function sortTheBehaviourInDB------------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  Future sortTheBehaviourInDB(
      {List<PBISPlusCommonBehaviorModal>? allBehavior,
      required String teacherId,
      int retry = 3}) async {
    try {
      List<Map> body = [];

      //Creating list of behavior to sort all together
      allBehavior!.forEach((element) {
        Map obj = {
          "Behaviour_Id": element.id,
          "Sorting_Order": element.pBISBehaviorSortOrderC,
          "Teacher_Id": teacherId
        };
        body.add(obj);
      });

      final ResponseModel response = await _dbServices.postApi(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/behaviour/sort-behaviour',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          body: body,
          isGoogleApi: true);
      if (response.statusCode == 200) {
        return true;
      } else if (retry > 0) {
        return sortTheBehaviourInDB(
            teacherId: teacherId, allBehavior: allBehavior, retry: retry - 1);
      }
      return response.statusCode;
    } catch (e) {
      throw (e);
    }
  }

  //============-----------------------------------------GET STUDENT ALL NOTES -----------------//
  Future<List<PBISStudentNotes>> getPBIStudentNotesData(
      {String? student_id}) async {
    try {
      final teacherId = await await OcrUtility.getTeacherId();

      final ResponseModel response = await _dbServices.getApiNew(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/notes/get-notes/teacher/$teacherId/student/$student_id?dbn=${Globals.schoolDbnC}',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PBISStudentNotes> listData = response.data['body']
            .map<PBISStudentNotes>((i) => PBISStudentNotes.fromJson(i))
            .toList();

        return listData;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

  //---------------------------------ADD THE STUDENT NOTES---------------------------------

  Future<bool> addPBIStudentNotes(
      {String? studentId,
      String? studentName,
      String? studentEmail,
      String? schoolId,
      String? notes}) async {
    try {
      Map<String, String>? body = {};
      body['student_id'] = studentId!;
      body['student_name'] = studentName!;
      body['student_email'] = studentEmail!;
      body['teacher_id'] = await OcrUtility.getTeacherId();
      body['school_id'] = schoolId!;
      body['DBN__c'] = Globals.schoolDbnC!;
      body['notes'] = notes!;

      final ResponseModel response = await _dbServices.postApi(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/notes/add-notes',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          body: body,
          isGoogleApi: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  // Future<List<PBISPlusTotalBehaviorModal>>
  //     getPBISTotalInteractionBySchoolAndTeacher (
  //         {required String teacherEmail,
  //         required String schoolId,
  //         int retry = 3}) async {
  //   try {

  //     final ResponseModel response = await _dbServices.getApiNew(
  //         'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/interactions/v2/teacher/$teacherEmail?schoolId=$schoolId',
  //         headers: {
  //           'Content-Type': 'application/json;charset=UTF-8',
  //           'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
  //         },
  //         isCompleteUrl: true);

  //     if (response.statusCode == 200 && response.data['statusCode'] == 200) {
  //       return response.data['body']
  //           .map<PBISPlusTotalBehaviorModal>(
  //               (i) => PBISPlusTotalBehaviorModal.fromJson(i))
  //           .toList();
  //     } else if (retry > 0) {
  //       return getPBISTotalInteractionBySchoolAndTeacher(
  //           teacherEmail: teacherEmail, retry: retry - 1, schoolId: schoolId);
  //     }
  //     return [];
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  Future<List<PBISPlusTotalBehaviorModal>> pBISPlusGetStudentBehaviorBySection(
      {required String teacherEmail,
      required String schoolId,
      required String section,
      int retry = 3}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          // 'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/interactions/v2/teacher/$teacherEmail?schoolId=$schoolId&classroomId=$classroomCourseId',

          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/interactions/v2/$section?teacher_email=$teacherEmail&schoolId=$schoolId',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PBISPlusTotalBehaviorModal> interactionList = response.data['body']
            .map<PBISPlusTotalBehaviorModal>(
                (i) => PBISPlusTotalBehaviorModal.fromJson(i))
            .toList();

        return interactionList;
      } else if (retry > 0) {
        return pBISPlusGetStudentBehaviorBySection(
            teacherEmail: teacherEmail,
            retry: retry - 1,
            schoolId: schoolId,
            section: section);
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

/*----------------------------------------------------------------------------------------------*/
/*---------------------------------------Function searchNotesList-------------------------------*/
/*----------------------------------------------------------------------------------------------*/
  List<PBISPlusNotesUniqueStudentList> searchStudentList(
      List<PBISPlusNotesUniqueStudentList> notesList, String keyword) {
    return notesList
        .where((note) =>
            note.names != null &&
            note.names!.fullName != null &&
            note.names!.fullName!.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}
