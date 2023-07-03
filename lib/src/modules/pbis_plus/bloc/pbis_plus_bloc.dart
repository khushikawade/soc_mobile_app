import 'dart:convert';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_add_notes_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_additional_behvaiour_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_default_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_behaviour_modal.dart';
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

        LocalDatabase<PBISPlusGenericBehaviourModal> _pbisPlusSkilllocalsDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenericBehaviourModal>? _pbisPlusSkillsLocalData =
            await _pbisPlusSkilllocalsDB.getData();
        // await _pbisPlusSkilllocalsDB.clear();
        if (_localData.isEmpty) {
          //Managing dummy response for shimmer loading
          var list = await _getShimmerData();
          yield PBISPlusClassRoomShimmerLoading(shimmerCoursesList: list);
        } else {
          sort(obj: _localData);
          await getFilteredStudentList(_localData);
          yield PBISPlusImportRosterSuccess(
              googleClassroomCourseList: _localData);
        }
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

        //API call to refresh with the latest data in the local DB
        List responseList = await importPBISClassroomRoster(
            accessToken: userProfileLocalData[0].authorizationToken,
            refreshToken: userProfileLocalData[0].refreshToken,
            isGradedPlus: event.isGradedPlus);

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
              activityType: event.isGradedPlus == true ? 'GRADED+' : 'PBIS+',
              userType: 'Teacher',
              activityId: '24',
              description: 'Import Roster Successfully From PBIS+',
              operationResult: 'Success');

          yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.
          sort(obj: classroomStudentProfile);
          await getFilteredStudentList(_localData);
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
        await getFilteredStudentList(_localData);
        yield PBISPlusImportRosterSuccess(
            googleClassroomCourseList: _localData);
      }
    }
    if (event is GetPBISPlusAdditionalBehaviour) {
      try {
        print(
            "-----------------event is GetPBISPlusAdditionalBehaviour----------------------------");

        LocalDatabase<PBISPlusGenericBehaviourModal>
            _pbisPlusGenricBehaviourDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenericBehaviourModal>? _pbisPlusGenricBehaviourDataList =
            await _pbisPlusGenricBehaviourDB.getData();

        LocalDatabase<PbisPlusAdditionalBehaviourList>
            _pbisPlusAdditionalBehaviourDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusAdditionalBehviourDB);
        List<PbisPlusAdditionalBehaviourList>?
            _pbisPlusAdditionalBehaviourDataList =
            await _pbisPlusAdditionalBehaviourDB.getData();
        yield PBISPlusLoading();
        var genralDataList;
        if (_pbisPlusAdditionalBehaviourDataList!.isNotEmpty) {
          genralDataList = _pbisPlusAdditionalBehaviourDataList
              .map((item) => PBISPlusGenericBehaviourModal(
                    id: item.id.toString(),
                    activeStatusC: "true",
                    iconUrlC: item.iconUrlC,
                    name: item.name,
                    sortOrderC: item.sortOrderC,
                    counter: 0,
                    behaviourId: "0",
                  ))
              .toList();
          yield PbisPlusAdditionalBehaviourSuccess(
              additionalBehaviourList: genralDataList);
        }

        List<PbisPlusAdditionalBehaviourList> apiData =
            await getPBISPBehaviourListData();

        apiData.removeWhere((item) => item.activeStatusC == 'Hide');
        apiData
            .sort((a, b) => (a.sortOrderC ?? '').compareTo(b.sortOrderC ?? ''));

        if (apiData!.isNotEmpty) {
          genralDataList = apiData
              .map((item) => PBISPlusGenericBehaviourModal(
                    id: item.id.toString(),
                    activeStatusC: "true",
                    iconUrlC: item.iconUrlC,
                    name: item.name,
                    sortOrderC: item.sortOrderC,
                    counter: 0,
                    behaviourId: "0",
                  ))
              .toList();

          apiData.forEach((element) async {
            await _pbisPlusAdditionalBehaviourDB
                .addData(element); // Pass 'element' instead of 'list'
          });
        }
        List<PbisPlusAdditionalBehaviourList> _check =
            await _pbisPlusAdditionalBehaviourDB.getData();

        print(_check);
        if (apiData.isNotEmpty) {
          yield PbisPlusAdditionalBehaviourSuccess(
              additionalBehaviourList: genralDataList);
        } else {
          yield PBISPlusAdditionalBehaviourError(error: "No data Found");
        }
      } catch (e) {
        yield PBISPlusAdditionalBehaviourError(error: e.toString());
      }
    }

    if (event is GetPBISPlusCustomBehaviour) {
      try {
        yield PBISPlusLoading();

        LocalDatabase<PBISPlusGenericBehaviourModal>
            _pbisPlusGenricBehaviourDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenericBehaviourModal>? _pbisPlusGenricBehaviourDataList =
            await _pbisPlusGenricBehaviourDB.getData();

        // LocalDatabase<PBISPlusDefaultAndCustomBehaviourModal>
        //     _pbisPlusdefaultBehaviourDB =
        //     LocalDatabase(PBISPlusOverrides.pbisPlusDefaultBehviourDB);
        // List<PBISPlusDefaultAndCustomBehaviourModal>?
        //     _pbisPlusdefaultBehaviourDataList =
        //     await _pbisPlusdefaultBehaviourDB.getData();

        // await _pbisPlusSkillsDB.clear();

        // List<PBISPlusGenericBehaviourModal> genralDataList = [];
        // var list;

        // if (_pbisPlusdefaultBehaviourDataList != null &&
        //     _pbisPlusdefaultBehaviourDataList.isNotEmpty &&
        //     _pbisPlusdefaultBehaviourDataList.length > 0) {
        //   genralDataList = _pbisPlusdefaultBehaviourDataList[0]
        //       .customList!
        //       .map((item) => PBISPlusGenericBehaviourModal(
        //             id: item.id.toString(),
        //             activeStatusC: "true",
        //             iconUrlC: item.iconUrl,
        //             name: item.name,
        //             sortOrderC: item.sortingOrder,
        //             counter: 0,
        //             behaviourId: "${item.id}",
        //           ))
        //       .toList();
        //   _pbisPlusGenricBehaviourDB.clear();
        //   genralDataList.forEach((element) async {
        //     await _pbisPlusGenricBehaviourDB
        //         .addData(element); // Pass 'element' instead of 'list'
        //   });
        // }

        // if (genralDataList != null && genralDataList.isNotEmpty) {
        //   yield PBISPlusDefaultBehaviourSucess(skillsList: genralDataList);
        // }

        List<PBISPlusGenericBehaviourModal> apiData =
            await getPBISCustomBehaviour();

        // var list = apiData
        //     .map((item) => PBISPlusGenericBehaviourModal(
        //           id: item.id.toString(),
        //           activeStatusC: "true",
        //           iconUrlC: item.iconUrlC,
        //           name: item.name,
        //           sortOrderC: item.sortOrderC,
        //           counter: 0,
        //           behaviourId: "0",
        //         ))
        //     .toList();

        //Adding placeholder
        while (apiData.length < 6) {
          int newItemId = apiData.length + 1;
          PBISPlusGenericBehaviourModal newItem = PBISPlusGenericBehaviourModal(
            id: newItemId.toString(),
            activeStatusC: "Show",
            iconUrlC: "assets/Pbis_plus/add_icon.svg",
            name: 'Add Skill',
            sortOrderC: newItemId.toString(),
            counter: 0,
            behaviourId: "0",
          );

          apiData.add(newItem);
        }
        // if (apiData != null && apiData.isNotEmpty) {
        await _pbisPlusGenricBehaviourDB.clear();

        apiData.forEach((PBISPlusGenericBehaviourModal e) {
          _pbisPlusGenricBehaviourDB.addData(e);
        });
        // }

        yield PBISPlusDefaultBehaviourSucess(skillsList: apiData);
      } catch (e) {
        yield PBISPlusDefaultBehaviourError(error: "No data found");
      }
    }

    if (event is GetPBISPlusStudentList) {
      String plusClassroomDBTableName = PBISPlusOverrides.pbisPlusClassroomDB;
      try {
        List<UserInformation> userProfileLocalData =
            await UserGoogleProfile.getUserProfile();
        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(plusClassroomDBTableName);
        List<ClassroomCourse>? _localData = await _localDb.getData();
        // yield FamilyLoading(); // Should not show loading, instead fetch the data from the Local database and return the list instantly.
        if (_localData.isEmpty) {
          yield PBISPlusLoading();
        } else {
          List<PBISPlusStudentList> list =
              await getFilteredStudentList(_localData);
          yield PBISPlusStudentListSucess(studentList: list);
        }

        List responseList = await importPBISClassroomRoster(
            accessToken: userProfileLocalData[0].authorizationToken,
            refreshToken: userProfileLocalData[0].refreshToken,
            isGradedPlus: false);

        if (responseList[1] == '') {
          List<ClassroomCourse> coursesList = responseList[0];

          // List<PBISPlusTotalInteractionModal> pbisTotalInteractionList = [];
          // //Get PBISTotal interaction only if Section is PBIS+
          // if (event.isGradedPlus == false) {
          //   pbisTotalInteractionList = await getPBISTotalInteractionByTeacher(
          //       teacherEmail: userProfileLocalData[0].userEmail!);
          // }

          // // Merge Student Interaction with Google Classroom Rosters
          // List<ClassroomCourse> classroomStudentProfile =
          //     await assignStudentTotalInteraction(
          //         pbisTotalInteractionList, coursesList);

          await _localDb.clear();

          coursesList.forEach((ClassroomCourse e) {
            _localDb.addData(e);
          });

          yield PBISPlusLoading(); // Just to mimic the state change otherwise UI won't update unless if there's no state change.

          List<PBISPlusStudentList> updatedList =
              await getFilteredStudentList(coursesList);
          yield PBISPlusStudentListSucess(studentList: updatedList);
        } else {
          yield PBISErrorState(
            error: 'ReAuthentication is required',
          );
        }
      } catch (e) {
        LocalDatabase<ClassroomCourse> _localDb =
            LocalDatabase(plusClassroomDBTableName);
        List<ClassroomCourse>? _localData = await _localDb.getData();
        List<PBISPlusStudentList> list =
            await getFilteredStudentList(_localData);
        yield PBISPlusStudentListSucess(studentList: list);
      }
    }

    if (event is GetPBISSkillsUpdateName) {
      try {
        yield PBISPlusLoading();

        LocalDatabase<PBISPlusGenericBehaviourModal> _pbisPlusSkillsDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenericBehaviourModal>? _pbisPlusSkillsData =
            await _pbisPlusSkillsDB.getData();

        if (_pbisPlusSkillsData.isNotEmpty) {
          //Checking index in local database
          final int index = _pbisPlusSkillsData
              .indexWhere((item) => item.id == event.item.id);

          if (index != null) {
            // Update the name of the item
            event.item.name = event.newName;
            // Save the updated data back to the database
            await _pbisPlusSkillsDB.putAt(index, event.item);

            yield PBISPlusDefaultBehaviourSucess(
                skillsList: _pbisPlusSkillsData);
          } else {
            yield PBISPlusSkillsUpdateError();
          }
        }
      } catch (e) {
        yield PBISPlusSkillsUpdateError();
      }
    }

    if (event is UpdatePBISBehavior) {
      try {
        LocalDatabase<PBISPlusGenericBehaviourModal> _pbisPlusSkillsDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        //List also contains placeholders //Add skill placeholder
        List<PBISPlusGenericBehaviourModal>? _pbisPlusSkillsData =
            await _pbisPlusSkillsDB.getData();

        yield PBISPlusLoading();

        if (event.item.id!.isNotEmpty &&
            event.index != null &&
            _pbisPlusSkillsData != null &&
            _pbisPlusSkillsData.isNotEmpty &&
            event.index < _pbisPlusSkillsData.length) {
          //Check if the selected additional icon already exits
          bool itemExists = _pbisPlusSkillsData
              .any((item) => item.iconUrlC == event.item.iconUrlC);

          if (!itemExists) {
            //Check count of total number of existing behavior
            int count = _pbisPlusSkillsData
                .where((item) => item.name != "Add Skill")
                .length;

            // if (count < 6) {
            //Check if updating the behaviour or adding a new behaviour
            if (event.index < count) {
              //Updating existing behaviour
              _pbisPlusSkillsData.removeAt(event.index);
              _pbisPlusSkillsData.insert(event.index, event.item);
            } else {
              //Adding new behaviour //Adding the behavior always to the 1st empty placeholder
              _pbisPlusSkillsData.removeAt(count);
              _pbisPlusSkillsData.insert(count, event.item);
            }
            // } else {
            //   _pbisPlusSkillsData.removeAt(event.index);
            //   _pbisPlusSkillsData.insert(event.index, event.item);
            // }

            //Updating local db with latest chnages
            await _pbisPlusSkillsDB.clear();
            _pbisPlusSkillsData.forEach((element) async {
              await _pbisPlusSkillsDB.addData(element);
            });

            //Return success state
            yield PBISPlusDefaultBehaviourSucess(
                skillsList: _pbisPlusSkillsData);
          } else {
            yield PBISPlusDefaultBehaviourSucess(
                skillsList: _pbisPlusSkillsData);
          }
        } else {
          yield PBISPlusDefaultBehaviourSucess(skillsList: _pbisPlusSkillsData);
        }
        // }
      } catch (e) {
        print(e);
        yield PBISPlusSkillsListUpdateError();
      }
    }

    if (event is DeletePBISBehavior) {
      try {
        yield PBISPlusLoading();

        LocalDatabase<PBISPlusGenericBehaviourModal> _pbisPlusSkillsDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenericBehaviourModal>? _pbisPlusSkillsData =
            await _pbisPlusSkillsDB.getData();

        final int index =
            _pbisPlusSkillsData.indexWhere((item) => item.id == event.item.id);

        // final itemToUpdate = _pbisPlusSkillsData.firstWhere(
        //   (item) => item.id == event.item.id,
        // );
        if (index != null) {
          // Update the name of the item
          _pbisPlusSkillsData.removeAt(index);
          // Shift the remaining items
          // for (int i = index + 1; i < _pbisPlusSkillsData.length; i++) {
          //   _pbisPlusSkillsData[i].sortOrderC =
          //       (int.parse(_pbisPlusSkillsData[i].sortOrderC!) - 1).toString();
          // }

          //Adding placeholder in place of delete item
          PBISPlusGenericBehaviourModal newItem = PBISPlusGenericBehaviourModal(
              id: "5",
              activeStatusC: "Show",
              iconUrlC: "assets/Pbis_plus/add_icon.svg",
              name: 'Add Skill',
              sortOrderC: _pbisPlusSkillsData.length.toString(),
              counter: 0,
              behaviourId: "0");

          // Add the new item at the end of the list
          _pbisPlusSkillsData.add(newItem);

          await _pbisPlusSkillsDB.clear();
          _pbisPlusSkillsData.forEach((element) async {
            await _pbisPlusSkillsDB.addData(element);
            // Pass 'element' instead of 'list'
          });

          yield PBISPlusDefaultBehaviourSucess(skillsList: _pbisPlusSkillsData);
        } else {
          yield PBISPlusSkillsDeleteError();
        }
      } catch (e) {
        yield PBISPlusSkillsDeleteError();
      }
    }
// //------------pbis student list home page-------------------///
//     if (event is GetPBISPlusStudentList) {
//       try {
//         yield PBISPlusLoading();
//         if (event.studentNotesList != null &&
//             event.studentNotesList!.length > 0) {
//           yield PBISPlusStudentListSucess(studentList: event.studentNotesList!);
//         }

//         LocalDatabase<PBISPlusStudentList> _pbisPlusStudentListDB =
//             LocalDatabase(PBISPlusOverrides.pbisPlusStudentListDB);
//         List<PBISPlusStudentList>? _pbisPlusNotesStudentDataList =
//             await _pbisPlusStudentListDB.getData();

//         _pbisPlusNotesStudentDataList = await _pbisPlusStudentListDB.getData();
//         if (_pbisPlusNotesStudentDataList.isNotEmpty) {
//           yield PBISPlusStudentListSucess(
//               studentList: _pbisPlusNotesStudentDataList);
//         } else {
//           yield GetPBISPlusStudentsListNoData(error: "No Student found");
//         }
//       } catch (e) {
//         yield GetPBISPlusStudentsListNoData(error: "No Student found");
//       }
//     }
//---------------pbis student list SEARCH----- ===-----------------
    if (event is PBISPlusNotesSearchStudentList) {
      try {
        print("----------PBISPlusNotesSearchStudentList=================");
        yield PBISPlusLoading();
        if (event.searchKey.isNotEmpty && event.studentNotes.length > 0) {
          final searchedList =
              await searchNotesList(event.studentNotes, event.searchKey);

          if (searchedList.isNotEmpty && searchedList.length > 0) {
            yield PBISPlusStudentSearchSucess(sortedList: searchedList);
          } else {
            yield GetPBISPlusStudentsListNoData(error: "No result found");
          }
        }
      } catch (e) {
        yield GetPBISPlusStudentsListNoData(error: "No data found");
      }
    }

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
            userType: 'Teacher',
            activityId: '38',
            description:
                'User Interaction PBIS+ ${data['body']['Id'].toString()} for student ${event.studentId}',
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
//---------------------------------*GET THE STUDENT NOTES*----------------------------//
    if (event is GetPBISPlusNotes) {
      try {
        LocalDatabase<PBISPlusStudentList> _pbisPlusSNotesStudentListDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusStudentListDB);
        List<PBISPlusStudentList>? _pbisPlusNotesStudentsList =
            await _pbisPlusSNotesStudentListDB.getData();
        yield PBISPlusLoading();

        // Find student data index in local db
        int studentItemindex = _pbisPlusNotesStudentsList.indexWhere(
          (student) => student.studentId == event.studentId,
        );
        // If the notes exits in the local db then return to notes  to UI

        if (studentItemindex != -1 &&
            _pbisPlusNotesStudentsList[studentItemindex].notes != null) {
          yield PBISPlusNotesSucess(
              notesList: _pbisPlusNotesStudentsList[studentItemindex].notes!);
        }

        //TODO Call the Api
        List<PBISStudentNotes>? apidata = await getPBIStudentNotesData(
            student_id: event.studentId,
            school_dbn: event.dbn,
            teacher_id: event.teacherid);

        // //*FEED THE NOTES IN LOCAL DB
        PBISPlusStudentList? studentToUpdate = studentItemindex != -1
            ? _pbisPlusNotesStudentsList[studentItemindex]
            : null;

        if (studentToUpdate != null) {
          // Student found, update the notes
          if (apidata != null && apidata.isNotEmpty) {
            // Assuming want to update the notes with the first API data
            studentToUpdate.notes = apidata;
            _pbisPlusNotesStudentsList.removeAt(studentItemindex);
            _pbisPlusNotesStudentsList.insert(
                studentItemindex, studentToUpdate);
          }
          await _pbisPlusSNotesStudentListDB.clear();
          _pbisPlusNotesStudentsList.forEach((element) async {
            await _pbisPlusSNotesStudentListDB.addData(element);
          });
        }
        yield PBISPlusNotesSucess(notesList: apidata);
        print("------sucess 2-------");
      } catch (e) {
        yield GetPBISPlusStudentAllNotesListError(error: "No Notes Found");
      }
    }

//----------------------------------------ADD THE NEW  NOTES---------------------------------------- //
    if (event is AddPBISPlusStudentNotes) {
      try {
        yield PBISPlusLoading();

        //TODO SEND THE LOCAL DB DATA
        PbisPlusAddNotes? apidata = await addPBIStudentNotes(
          studentId: event.studentId,
          studentName: event.studentName,
          studentEmail: event.studentEmail,
          teacherId: event.teacherId,
          schoolId: event.schoolId,
          dBNc: event.schoolDbn,
          notes: event.notes,
        );
        if (apidata != null) {
          yield PBISPlusAddNotesSucess(note: apidata);
        } else {
          yield PBISPlusAddNotesError(
              error: "Note was not added  Please try again later.");
        }
      } catch (e) {
        yield PBISPlusAddNotesError(
            error: "Note was not  added  Please try again later.");
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
      print(
          "------------teacherEmail ------===========-${teacherEmail}==============----------------");
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
              //TODOPBIS:
              // classroomCourse.students![j].profile!.behaviour1!.counter =
              //     pbisTotalInteractionList[k].engaged;
              // classroomCourse.students![j].profile!.behaviour2!.counter =
              //     pbisTotalInteractionList[k].niceWork;
              // classroomCourse.students![j].profile!.behaviour3!.counter =
              //     pbisTotalInteractionList[k].helpful;
              classroomCourse.students![j].profile!.engaged =
                  pbisTotalInteractionList[k].engaged;
              classroomCourse.students![j].profile!.niceWork =
                  pbisTotalInteractionList[k].niceWork;
              classroomCourse.students![j].profile!.helpful =
                  pbisTotalInteractionList[k].helpful;
              interactionCountsFound = true;
              // print(classroomCourse.students![j].profile!.studentInteraction);
              break;
            }
          }
        }

        //Adding 0 interaction where no interaction added yet
        if (!interactionCountsFound) {
          // If no interaction counts were found, set all counts to 0
          for (int j = 0; j < classroomCourseList[i].students!.length; j++) {
            //TODOPBIS::
            // classroomCourse.students![j].profile!.behaviour1?.counter = 0;
            // classroomCourse.students![j].profile!.behaviour2?.counter = 0;
            // classroomCourse.students![j].profile!.behaviour3?.counter = 0;
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
      //if user reset Course //All Courses & Students||Select Students
      if (type == PBISPlusOverrides.kresetOptionOnetitle ||
          type == PBISPlusOverrides.kresetOptionTwotitle) {
        // Create a comma-separated string of Courses for a list of selected classroom courses "('','','')"
        String classroomCourseIds =
            selectedCourses.map((course) => course.id).join("','");
        body.addAll({"Classroom_Course_Id": "('$classroomCourseIds')"});
      }
      //Select Courses
      else if (type == PBISPlusOverrides.kresetOptionThreetitle) {
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

  //------------FILTER THE STUDENT LIST FROM THE ROASTER DATA SAVE TO LOCAL DB------For NotesPage----///
  Future<List<PBISPlusStudentList>> getFilteredStudentList(
      List<ClassroomCourse> allClassroomCourses) async {
    try {
      final uniqueStudents = <ClassroomStudents>[];
      for (final course in allClassroomCourses) {
        for (final student in course?.students ?? []) {
          final isStudentUnique =
              !uniqueStudents.any((s) => s.profile?.id == student.profile?.id);
          if (isStudentUnique) {
            student.profile!.courseName = course.name;
            uniqueStudents.add(student);
          }
        }
      }

      uniqueStudents.sort((a, b) {
        return a.profile!.name!.fullName!
            .toLowerCase()
            .compareTo(b.profile!.name!.fullName!.toLowerCase());
      });

      // uniqueStudents.forEach((student) {
      //   print('ID: ${student.profile!.id}');
      //   print('Name: ${student.profile!.name!.fullName}');
      //   print('Email: ${student.profile!.emailAddress}');
      //   print('Photo URL: ${student.profile!.photoUrl}');
      //   // Access and print other properties as needed
      //   print('---');
      // });

      LocalDatabase<PBISPlusStudentList> _pbisPlusStudentListDB =
          LocalDatabase(PBISPlusOverrides.pbisPlusStudentListDB);
      List<PBISPlusStudentList>? _pbisPlusStudentNotesDataList =
          await _pbisPlusStudentListDB.getData();
      List<PBISPlusStudentList> list = [];

      // ---------------------------OLD LIST MAP ----------------------------------
      // list = uniqueStudents
      //     .map((item) => PBISPlusStudentList(
      //         email: item.profile!.emailAddress!,
      //         names: StudentName(
      //             familyName: item.profile!.name!.familyName!,
      //             fullName: item.profile!.name!.fullName!,
      //             givenName: item.profile!.name!.givenName!),
      //         iconUrlC: item.profile?.photoUrl!,
      //         studentId: item.profile?.id,
      //         notes: null))
      //     .toList();

      // await _pbisPlusStudentListDB.clear();
      // list.forEach((element) async {
      //   await _pbisPlusStudentListDB
      //       .addData(element); // Pass 'element' instead of 'list'
      // });

      //--------------------------------NEW WAY TO MAP THE DATA IT SAVED THE PERVIOULSY NOTES  THE STUDENTS ------------- /
      // Fetch the list from the first API
      if (_pbisPlusStudentNotesDataList.isNotEmpty) {
        list = uniqueStudents.map((item) {
          // Check if the student already exists in the local database
          PBISPlusStudentList existingStudent = _pbisPlusStudentNotesDataList
              .firstWhere((e) => e.studentId == item.profile?.id);
          List<PBISStudentNotes>? notes =
              existingStudent != null ? existingStudent.notes : null;
          // Create a new PBISPlusStudentList object with the updated details
          return PBISPlusStudentList(
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
            .map((item) => PBISPlusStudentList(
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

      print(
          "----------unique sudent ==================================================================================================  saved on db -------------------- ");
      var dataList = await _pbisPlusStudentListDB.getData();
      dataList.forEach((student) {
        print('ID: ${student.studentId}');
        print('Name: ${student.names?.fullName!}');
        print('Email: ${student.email}');
        print('Photo URL: ${student.iconUrlC}');
        print("----NOTES: ${student.notes}");
        // Access and print other properties as needed
        print('---');
      });

      return list;
      // return newList;
    } catch (e) {
      print('INSIDE EXPECTION IN THE STUDENT LIST  $e');
      throw (e);
    }
  }

//-----------------------------------GET THE  ADDITIONAL BEHAVIOUR List----------------------------------------//

  Future getPBISPBehaviourListData() async {
    try {
      print("--------------INSIDE --getPBISPBehaviourListData---");
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/PBIS_Custom_Icon__c',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            // 'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);
      print("--------------response------ -${response.statusCode}--");
      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PbisPlusAdditionalBehaviourList> resp = response.data['body']
            .map<PbisPlusAdditionalBehaviourList>(
                (i) => PbisPlusAdditionalBehaviourList.fromJson(i))
            .toList();

        print(resp.length);
        print(resp);
        return resp;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

//-----------------------------------GET THE  ADDITIONAL BEHAVIOUR List----------------------------------------//

  Future getPBISPlusBehaviourAdditionalBehaviourList() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          '${Overrides.API_BASE_URL2}production/getRecords/PBIS_Custom_Icon__c',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            // 'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PbisPlusAdditionalBehaviourList> resp = response.data['body']
            .map<PbisPlusAdditionalBehaviourList>(
                (i) => PbisPlusAdditionalBehaviourList.fromJson(i))
            .toList();

        print(resp.length);
        print(resp);
        return resp;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

//-----------------------------------GET THE Deafault BEHAVIOUR List----------------------------------------//

  // Future<List<PBISPlusDefaultBehaviourModal>> getPBISDefaultBehaviour() async {
  //   try {
  //     final ResponseModel response = await _dbServices.getApiNew(
  //         'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/behaviour/get-behaviour/teacher/0034W00003AwJSfQAN/default',
  //         headers: {
  //           'Content-Type': 'application/json;charset=UTF-8',
  //           // 'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
  //         },
  //         isCompleteUrl: true);

  //     if (response.statusCode == 200 && response.data['statusCode'] == 200) {
  //       List<PBISPlusDefaultBehaviourModal> listData = response.data['body']
  //           .map<PBISPlusDefaultBehaviourModal>(
  //               (i) => PBISPlusDefaultBehaviourModal.fromJson(i))
  //           .toList();
  //       // for (var behaviour in listData) {
  //       //   print('------getPBISDefaultBehaviour--------------');
  //       //   print('Name: ${behaviour.name}');
  //       //   print('Behaviour ID: ${behaviour.behaviourId}');
  //       //   print('--------------------');
  //       // }
  //       return listData;
  //     }
  //     return [];
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  Future<List<PBISPlusGenericBehaviourModal>> getPBISCustomBehaviour() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/behaviour/get-custom-behaviour/teacher/0034W00003AwJSfQAN',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            // 'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PBISPlusGenericBehaviourModal> listData = response.data['body']
            .map<PBISPlusGenericBehaviourModal>(
                (i) => PBISPlusGenericBehaviourModal.fromJson(i))
            .toList();
        // for (var behaviour in listData) {
        //   print('--------getPBISCustomBehaviour------------');
        //   print('Name: ${behaviour.name}');
        //   print('Behaviour ID: ${behaviour.behaviourId}');
        //   // Print additional information as needed
        //   print('--------------------');
        // }
        return listData;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

  //============-----------------------------------------GET STUDENT ALL NOTES -----------------//
  Future<List<PBISStudentNotes>> getPBIStudentNotesData(
      {String? teacher_id, String? student_id, String? school_dbn}) async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/notes/get-notes/teacher/$teacher_id/student/$student_id?dbn=$school_dbn',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            // 'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
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

  Future addPBIStudentNotes({
    String? studentId,
    String? studentName,
    String? studentEmail,
    String? teacherId,
    String? schoolId,
    String? dBNc,
    String? notes,
  }) async {
    try {
      Map<String, String>? body = {};
      body['student_id'] = studentId!;
      body['student_name'] = studentName!;
      body['student_email'] = studentEmail!;
      body['teacher_id'] = teacherId!;
      body['school_id'] = schoolId!;
      body['DBN__c'] = dBNc!;
      body['notes'] = notes!;

      final ResponseModel response = await _dbServices.postApi(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/notes/add-notes',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          body: body,
          isGoogleApi: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        final data = response.data as Map<String, dynamic>;
        final listData = PbisPlusAddNotes.fromJson(data['body']);
        return listData;
      }
      return null;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  List<PBISPlusStudentList> searchNotesList(
      List<PBISPlusStudentList> notesList, String keyword) {
    List<PBISPlusStudentList> searchResults = [];

    for (var note in notesList) {
      if (note.names != null && note.names!.fullName != null) {
        if (note.names!.fullName!
            .toLowerCase()
            .contains(keyword.toLowerCase())) {
          searchResults.add(note);
        }
      }
    }

    return searchResults;
  }
}
