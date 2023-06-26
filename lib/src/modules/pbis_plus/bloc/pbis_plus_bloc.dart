import 'dart:convert';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_additional_behvaiour_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_default_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_notes_modal.dart';
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

        LocalDatabase<PBISPlusGenricBehaviourModal> _pbisPlusSkilllocalsDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenricBehaviourModal>? _pbisPlusSkillsLocalData =
            await _pbisPlusSkilllocalsDB.getData();
        // await _pbisPlusSkilllocalsDB.clear();
        var list;
        if (_pbisPlusSkillsLocalData.isEmpty) {
          list = PBISPlusSkillsModalLocal.PBISPlusSkillLocalModallist.map(
              (item) => PBISPlusGenricBehaviourModal(
                    id: item.id,
                    activeStatusC: item.activeStatusC,
                    iconUrlC: item.iconUrlC,
                    name: item.name,
                    sortOrderC: item.sortOrderC,
                    counter: item.counter,
                    behaviourId: "0",
                  )).toList();
        }
        // // print(list.runtimeType);

        // if (_pbisPlusSkillsLocalData.isEmpty) {
        //   list.forEach((element) async {
        //     await _pbisPlusSkilllocalsDB
        //         .addData(element); // Pass 'element' instead of 'list'
        //   });
        // }

        final check = await _pbisPlusSkilllocalsDB.getData();
        for (var item in check) {
          for (var data in check) {
            print('----------------------------');
            print('ID: ${data.id}');
            print('Active Status: ${data.activeStatusC}');
            print('Icon URL: ${data.iconUrlC}');
            print('Name: ${data.name}');
            print('Sort Order: ${data.sortOrderC}');
            print('Counter: ${data.counter}');
            print('----------------------------');
          }
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

    if (event is GetPBISPlusAdditionalBehaviour) {
      try {
        print(
            "-----------------event is GetPBISPlusAdditionalBehaviour----------------------------");

        LocalDatabase<PBISPlusGenricBehaviourModal> _pbisPlusGenricBehaviourDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenricBehaviourModal>? _pbisPlusGenricBehaviourDataList =
            await _pbisPlusGenricBehaviourDB.getData();

        LocalDatabase<PbisPlusAdditionalBehaviourList>
            _pbisPlusAdditionalBehaviourDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusAdditionalBehviourDB);
        List<PbisPlusAdditionalBehaviourList>?
            _pbisPlusAdditionalBehaviourDataList =
            await _pbisPlusAdditionalBehaviourDB.getData();
        yield GetPBISPlusAdditionalBehaviourLoading();
        var genralDataList;
        if (_pbisPlusAdditionalBehaviourDataList!.isNotEmpty) {
          genralDataList = _pbisPlusAdditionalBehaviourDataList
              .map((item) => PBISPlusGenricBehaviourModal(
                    id: item.id.toString(),
                    activeStatusC: "true",
                    iconUrlC: item.iconUrlC,
                    name: item.name,
                    sortOrderC: item.sortOrderC,
                    counter: 0,
                    behaviourId: "0",
                  ))
              .toList();
        }
        yield PbisPlusAdditionalBehaviourSuccess(
            additionalbehaviourList: genralDataList);
        List<PbisPlusAdditionalBehaviourList> apiData =
            await getPBISPBehaviourListData();

        apiData.removeWhere((item) => item.activeStatusC == 'Hide');
        apiData
            .sort((a, b) => (a.sortOrderC ?? '').compareTo(b.sortOrderC ?? ''));

        if (apiData!.isNotEmpty) {
          genralDataList = _pbisPlusAdditionalBehaviourDataList
              .map((item) => PBISPlusGenricBehaviourModal(
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

        if (apiData.isNotEmpty) {
          yield PbisPlusAdditionalBehaviourSuccess(
              additionalbehaviourList: genralDataList);
        } else {
          yield PBISPlusAdditionalBehaviourError(error: "No data Found");
        }
      } catch (e) {
        yield PBISPlusAdditionalBehaviourError(error: e.toString());
      }
    }
    if (event is GetPBISPlusDefaultBehaviour) {
      try {
        print(
            "-----------------event is GetPBISPlusBehaviour---------------------------");
        yield PBISPlusDefaultBehaviourLoading();
        LocalDatabase<PBISPlusGenricBehaviourModal> _pbisPlusSkillsDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenricBehaviourModal>? _pbisPlusSkillsData =
            await _pbisPlusSkillsDB.getData();

        LocalDatabase<PBISPlusDefaultAndCustomBehaviourModal>
            _pbisPlusdefaultBehaviourDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusDefaultBehviourDB);
        List<PBISPlusDefaultAndCustomBehaviourModal>?
            _pbisPlusdefaultBehaviourDataList =
            await _pbisPlusdefaultBehaviourDB.getData();

        // await _pbisPlusSkillsDB.clear();
        List<PBISPlusDefaultBehaviourModal> apidata;
        var list;

        if (event.isCustom!) {
          if (_pbisPlusdefaultBehaviourDataList[0].customList!.isNotEmpty) {
            final genralDataList = _pbisPlusdefaultBehaviourDataList[0]
                .customList!
                .map((item) => PBISPlusGenricBehaviourModal(
                      id: item.id.toString(),
                      activeStatusC: "true",
                      iconUrlC: item.iconUrl,
                      name: item.name,
                      sortOrderC: item.sortingOrder,
                      counter: 0,
                      behaviourId: "0",
                    ))
                .toList();
            genralDataList.forEach((element) async {
              await _pbisPlusSkillsDB
                  .addData(element); // Pass 'element' instead of 'list'
            });
          }
        } else {
          if (_pbisPlusdefaultBehaviourDataList[0].defaultList!.isNotEmpty) {
            final genralDataList = _pbisPlusdefaultBehaviourDataList[0]
                .defaultList!
                .map((item) => PBISPlusGenricBehaviourModal(
                      id: item.id.toString(),
                      activeStatusC: "true",
                      iconUrlC: item.iconUrl,
                      name: item.name,
                      sortOrderC: item.sortingOrder,
                      counter: 0,
                      behaviourId: "0",
                    ))
                .toList();
            genralDataList.forEach((element) async {
              await _pbisPlusSkillsDB
                  .addData(element); // Pass 'element' instead of 'list'
            });
          }
        }

        if (_pbisPlusSkillsData.isNotEmpty) {
          yield PBISPlusDefaultBehaviourSucess(skillsList: _pbisPlusSkillsData);
        }

        if (event.isCustom!) {
          apidata = await getPBISCustomBehaviour();
        } else {
          apidata = await getPBISDefaultBehaviour();
        }

        if (apidata.isEmpty) {
          if (event.isCustom!) {
            await _pbisPlusdefaultBehaviourDB.addData(
              PBISPlusDefaultAndCustomBehaviourModal(customList: apidata),
            );
          } else {
            await _pbisPlusdefaultBehaviourDB.addData(
              PBISPlusDefaultAndCustomBehaviourModal(defaultList: apidata),
            );
          }
        }

        list = apidata
            .map((item) => PBISPlusGenricBehaviourModal(
                  id: item.id.toString(),
                  activeStatusC: "true",
                  iconUrlC: item.iconUrl,
                  name: item.name,
                  sortOrderC: item.sortingOrder,
                  counter: 0,
                  behaviourId: "0",
                ))
            .toList();
        while (list.length < 6) {
          int newItemId = list.length + 1;
          PBISPlusGenricBehaviourModal newItem = PBISPlusGenricBehaviourModal(
            id: newItemId.toString(),
            activeStatusC: "Show",
            iconUrlC: "assets/Pbis_plus/add_icon.svg",
            name: 'Add Skill',
            sortOrderC: newItemId.toString(),
            counter: 0,
            behaviourId: "0",
          );
          list.add(newItem);
        }

        if (_pbisPlusSkillsData.isEmpty) {
          list.forEach((element) async {
            await _pbisPlusSkillsDB
                .addData(element); // Pass 'element' instead of 'list'
          });
        }
        _pbisPlusSkillsData = await _pbisPlusSkillsDB.getData();
        final check = await _pbisPlusSkillsDB.getData();

        for (var data in check) {
          print('----------------------------');
          print('ID: ${data.id}');
          print('Active Status: ${data.activeStatusC}');
          print('Icon URL: ${data.iconUrlC}');
          print('Name: ${data.name}');
          print('Sort Order: ${data.sortOrderC}');
          print('Counter: ${data.counter}');
          print('----------------------------');
        }

        if (check.isNotEmpty) {
          yield PBISPlusDefaultBehaviourSucess(skillsList: _pbisPlusSkillsData);
        } else {
          yield PBISPlusDefaultBehaviourError(error: "No data found");
        }
      } catch (e) {
        yield PBISPlusDefaultBehaviourError(error: "No data found");
      }
    }

    if (event is GetPBISSkillsUpdateName) {
      try {
        print(
            "-----------------event is GetPBISSkillsUpdateName---------------------------");
        yield GetPBISSkillsUpdateNameLoading();
        LocalDatabase<PBISPlusGenricBehaviourModal> _pbisPlusSkillsDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenricBehaviourModal>? _pbisPlusSkillsData =
            await _pbisPlusSkillsDB.getData();

        if (event.item.id!.isNotEmpty &&
            event.newName.isNotEmpty &&
            _pbisPlusSkillsData.isNotEmpty) {
          final int index = _pbisPlusSkillsData
              .indexWhere((item) => item.id == event.item.id);
          final itemToUpdate = _pbisPlusSkillsData.firstWhere(
            (item) => item.id == event.item.id,
          );
          if (index != null) {
            // Update the name of the item
            itemToUpdate.name = event.newName;
            // Save the updated data back to the database
            await _pbisPlusSkillsDB.putAt(index, _pbisPlusSkillsData[index]);
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

    if (event is GetPBISSkillsUpdateList) {
      try {
        print(
            "-----------------event is GetPBISSkillsUpdateList---------------------------");
        LocalDatabase<PBISPlusGenricBehaviourModal> _pbisPlusSkillsDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenricBehaviourModal>? _pbisPlusSkillsData =
            await _pbisPlusSkillsDB.getData();
        yield PBISPlusSkillsUpdateLoading(skillsList: _pbisPlusSkillsData);
        if (event.item.id!.isNotEmpty &&
            event.index != null &&
            _pbisPlusSkillsData != null &&
            _pbisPlusSkillsData.isNotEmpty &&
            event.index < _pbisPlusSkillsData.length) {
          //Check the Item already exits
          bool itemExists =
              _pbisPlusSkillsData.any((item) => item.name == event.item.name);

          if (!itemExists) {
            int count = _pbisPlusSkillsData
                .where((item) => item.name != "Add Skill")
                .length;
            if (count < 6) {
              if (event.index < count) {
                _pbisPlusSkillsData.removeAt(event.index);
                _pbisPlusSkillsData.insert(event.index, event.item);
              } else {
                _pbisPlusSkillsData.removeAt(count);
                _pbisPlusSkillsData.insert(count, event.item);
              }
            } else {
              _pbisPlusSkillsData.removeAt(event.index);
              _pbisPlusSkillsData.insert(event.index, event.item);
            }
            await _pbisPlusSkillsDB.clear();
            _pbisPlusSkillsData.forEach((element) async {
              await _pbisPlusSkillsDB.addData(element);
            });
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

    if (event is GetPBISSkillsDeleteItem) {
      try {
        print(
            "-----------------event is GetPBISSkillsDeleteItem---------------------------");
        yield PBISPlusSkillsDeleteLoading();
        LocalDatabase<PBISPlusGenricBehaviourModal> _pbisPlusSkillsDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusBehaviourGenricDB);
        List<PBISPlusGenricBehaviourModal>? _pbisPlusSkillsData =
            await _pbisPlusSkillsDB.getData();
        if (event.item.id!.isNotEmpty && _pbisPlusSkillsData.isNotEmpty) {
          final int index = _pbisPlusSkillsData
              .indexWhere((item) => item.id == event.item.id);
          final itemToUpdate = _pbisPlusSkillsData.firstWhere(
            (item) => item.id == event.item.id,
          );
          if (index != -1) {
            // Update the name of the item
            _pbisPlusSkillsData.removeAt(index);
            // Shift the remaining items
            for (int i = index + 1; i < _pbisPlusSkillsData.length; i++) {
              _pbisPlusSkillsData[i].sortOrderC =
                  (int.parse(_pbisPlusSkillsData[i].sortOrderC!) - 1)
                      .toString();
            }
            PBISPlusGenricBehaviourModal newItem = PBISPlusGenricBehaviourModal(
              id: "5",
              activeStatusC: "Show",
              iconUrlC: "assets/Pbis_plus/add_icon.svg",
              name: 'Add Skill',
              sortOrderC: _pbisPlusSkillsData.length.toString(),
              counter: 0,
              behaviourId: "0",
            );
            // Add the new item at the end of the list
            _pbisPlusSkillsData.add(newItem);

            final check = await _pbisPlusSkillsDB.getData();

            await _pbisPlusSkillsDB.clear();
            _pbisPlusSkillsData.forEach((element) async {
              await _pbisPlusSkillsDB
                  .addData(element); // Pass 'element' instead of 'list'
            });

            yield PBISPlusDefaultBehaviourSucess(
                skillsList: _pbisPlusSkillsData);
          } else {
            yield PBISPlusSkillsDeleteError();
          }
        } else {
          yield PBISPlusSkillsDeleteError();
        }
      } catch (e) {
        yield PBISPlusSkillsDeleteError();
      }
    }

    if (event is GetPBISPlusStudentNotes) {
      try {
        yield PBISPlusStudentNotesShimmer();
        LocalDatabase<PBISPlusStudentNotes> _pbisPlusStudentNotesDB =
            LocalDatabase(PBISPlusOverrides.pbisPlusStudentNotesDB);
        List<PBISPlusStudentNotes>? _pbisPlusStudentNoesDataList =
            await _pbisPlusStudentNotesDB.getData();
        // await _pbisPlusSkillsDB.clear();
        var list;
        if (_pbisPlusStudentNoesDataList.isEmpty) {
          list = PBISPlusStudentNotesLocal.PBISPlusLocalStudentNoteslist.map(
              (item) => PBISPlusStudentNotes(
                    studentName: item.studentName,
                    iconUrlC: item.iconUrlC,
                    date: item.date,
                    notesComments: item.notesComments,
                  )).toList();
        }

        if (_pbisPlusStudentNoesDataList.isEmpty) {
          list.forEach((element) async {
            await _pbisPlusStudentNotesDB
                .addData(element); // Pass 'element' instead of 'list'
          });
        }
        _pbisPlusStudentNoesDataList = await _pbisPlusStudentNotesDB.getData();
        final check = await _pbisPlusStudentNotesDB.getData();
        // for (var item in check) {
        for (var data in check) {
          print('----------------------------');
          print('StudentName: ${data.studentName}');
          print('date: ${data.date}');
          print('Icon URL: ${data.iconUrlC}');
          print('Notes Comments: ${data.notesComments}');
          print('----------------------------');
        }
        // }
        if (check.isNotEmpty) {
          yield PBISPlusStudentNotesSucess(
              studentNotes: _pbisPlusStudentNoesDataList);
        } else {
          yield PBISPlusStudentNotesError(error: "No data found");
        }
      } catch (e) {
        yield PBISPlusStudentNotesError(error: "No data found");
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

  //-----------------------------------GET THE Deafault BEHAVIOUR List----------------------------------------//

  Future<List<PBISPlusDefaultBehaviourModal>> getPBISDefaultBehaviour() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/behaviour/get-behaviour/teacher/0034W00003AwJSfQAN/default',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            // 'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PBISPlusDefaultBehaviourModal> listData = response.data['body']
            .map<PBISPlusDefaultBehaviourModal>(
                (i) => PBISPlusDefaultBehaviourModal.fromJson(i))
            .toList();
        for (var behaviour in listData) {
          print('------getPBISDefaultBehaviour--------------');
          print('Name: ${behaviour.name}');
          print('Behaviour ID: ${behaviour.behaviourId}');
          print('--------------------');
        }
        return listData;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }

  Future<List<PBISPlusDefaultBehaviourModal>> getPBISCustomBehaviour() async {
    try {
      final ResponseModel response = await _dbServices.getApiNew(
          'https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/pbis/behaviour/get-behaviour/teacher/0034W00003AwJSfQAN/custom',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            // 'authorization': 'r?ftDEZ_qdt=VjD#W@S2LM8FZT97Nx'
          },
          isCompleteUrl: true);

      if (response.statusCode == 200 && response.data['statusCode'] == 200) {
        List<PBISPlusDefaultBehaviourModal> listData = response.data['body']
            .map<PBISPlusDefaultBehaviourModal>(
                (i) => PBISPlusDefaultBehaviourModal.fromJson(i))
            .toList();
        for (var behaviour in listData) {
          print('--------getPBISCustomBehaviour------------');
          print('Name: ${behaviour.name}');
          print('Behaviour ID: ${behaviour.behaviourId}');
          // Print additional information as needed
          print('--------------------');
        }
        return listData;
      }
      return [];
    } catch (e) {
      throw (e);
    }
  }
}
