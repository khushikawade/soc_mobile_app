import 'dart:convert';
import 'package:Soc/src/modules/pbis_plus/modal/course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pibs_plus_history_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'pbis_plus_event.dart';
part 'pbis_plus_state.dart';

class PBISPlusBloc extends Bloc<PBISPlusEvent, PBISPlusState> {
  PBISPlusBloc() : super(PBISPlusInitial());

  final DbServices _dbServices = DbServices();

  @override
  Stream<PBISPlusState> mapEventToState(
    PBISPlusEvent event,
  ) async* {
    if (event is PBISPlusImportRoster) {
      yield PBISPlusLoading();
      LocalDatabase<ClassroomCourse> _localDb =
          LocalDatabase(PBISPlusOverrides.PBISPlusClassroomDB);
      List<ClassroomCourse>? _localData = await _localDb.getData();

      if (_localData?.isNotEmpty ?? false) {
        yield PBISPlusImportRosterSuccess(
            googleClassroomCourseList: _localData);
      }

//Remove this after API interation-----------------
      await Future.delayed(Duration(seconds: 2));
      final data = await importPBISClassroomRoster(
          'lib/src/modules/pbis_plus/bloc/course_data.json');

//---------------------------------------------------

      List<ClassroomCourse> coursesData = data['body']
          .map<ClassroomCourse>((i) => ClassroomCourse.fromJson(i))
          .toList();

      coursesData.forEach((element) async {
        await _localDb.addData(element);
      });

      // await Future.delayed(Duration(seconds: 2));
      yield PBISPlusImportRosterSuccess(googleClassroomCourseList: coursesData);
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
      // yield PbicPlusLoading();
      // await Future.delayed(Duration(seconds: 2));
      // final data =
      //     await loadData('lib/src/modules/PBISPlus_plus/bloc/history_data.json');

      // List<HistoryModal> historyData = data['body']
      //     .map<HistoryModal>((i) => HistoryModal.fromJson(i))
      //     .toList();

      //yield PBISPlusGetHistoryDataSuccess(historyData: historyData);
    }
  }

  Future importPBISClassroomRoster(String location) async {
    try {
      final String response = await rootBundle.loadString(location);
      // final data = await json.decode(response);
      return json.decode(response);
      // return data['body'].map<Course>((i) => Course.fromJson(i)).toList();
    } catch (e) {
      print(e);
      return '';
    }
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
