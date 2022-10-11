import 'dart:convert';
//import 'package:Soc/src/modules/schedule/modal/calender_modal.dart';
import 'package:Soc/src/modules/schedule/modal/blackOutDate_modal.dart';
import 'package:Soc/src/modules/schedule/modal/model_calender.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../services/Strings.dart';
import '../../../services/db_service_response.model.dart';
import '../../../services/local_database/local_db.dart';
import '../modal/schedule_modal.dart';
part 'calender_event.dart';
part 'calender_state.dart';

class CalenderBloc extends Bloc<CalenderEvent, CalenderState> {
  CalenderBloc() : super(CalenderInitial());
  final DbServices _dbServices = DbServices();
// CalenderModel calenderModel = CalenderModel();
  ModelCalender modelCalender = ModelCalender();
  List<Schedule> studentCalenderDetail = [];
  List<BlackoutDate> studentBlockoutDate = [];
  CalenderState get initialState => CalenderInitial();

  @override
  Stream<CalenderState> mapEventToState(
    CalenderEvent event,
  ) async* {
    if (event is CalenderPageEvent) {
      try {
        String? _scheduleObjectName = "${Strings.scheduleObjectDetails}";
        String? _blackoutDateObjectName =
            "${Strings.blackoutDateObjectDetails}";

        LocalDatabase<Schedule> _scheduleObjectLocalDb =
            LocalDatabase(_scheduleObjectName);

        LocalDatabase<BlackoutDate> _blackoutDateObjectLocalDb =
            LocalDatabase(_blackoutDateObjectName);

        List<Schedule> _scheduleLocalData =
            await _scheduleObjectLocalDb.getData();

        List<BlackoutDate> _blackoutDateLocalData =
            await _blackoutDateObjectLocalDb.getData();

        if (_scheduleLocalData.isEmpty || _blackoutDateLocalData.isEmpty) {
          yield Loading();
        } else {
          yield Loading();
          yield CalenderSucces(
              scheduleObjList: _scheduleLocalData,
              blackoutDateobjList: _blackoutDateLocalData,
              pullToRefresh: event.pullToRefresh);
        }

        Body body = await getStudentDetails(event.email);
        List<Schedule> appList = body.schedules!;

        List<BlackoutDate> blackoutdate = body.blackoutDates!;

        await _scheduleObjectLocalDb.clear();
        appList.forEach((Schedule e) async {
          await _scheduleObjectLocalDb.addData(e);
        });

        await _blackoutDateObjectLocalDb.clear();

        blackoutdate.forEach((BlackoutDate e) async {
          await _blackoutDateObjectLocalDb.addData(e);
        });
        yield Loading();
        if (appList.isNotEmpty) {
          yield CalenderSucces(
              scheduleObjList: appList,
              blackoutDateobjList: blackoutdate,
              pullToRefresh: event.pullToRefresh);
        }
      } catch (e) {
        String? _scheduleObjectName = "${Strings.scheduleObjectDetails}";
        String? _blackoutDateObjectName =
            "${Strings.blackoutDateObjectDetails}";

        LocalDatabase<Schedule> _scheduleObjectLocalDb =
            LocalDatabase(_scheduleObjectName);

        LocalDatabase<BlackoutDate> _blackoutDateObjectLocalDb =
            LocalDatabase(_blackoutDateObjectName);

        List<Schedule> _scheduleLocalData =
            await _scheduleObjectLocalDb.getData();

        List<BlackoutDate> _blackoutDateLocalData =
            await _blackoutDateObjectLocalDb.getData();

        if (_scheduleLocalData.isEmpty || _blackoutDateLocalData.isEmpty) {
          e == 'NO_CONNECTION'
              ? Utility.currentScreenSnackBar("No Internet Connection", null)
              : print(e);
          yield CalenderError(err: e);
        } else {
          yield CalenderSucces(
              scheduleObjList: _scheduleLocalData,
              blackoutDateobjList: _blackoutDateLocalData,
              pullToRefresh: event.pullToRefresh);
        }
      }
    }
  }

  Future<Body> getStudentDetails(email) async {
    try {
      final ResponseModel response = await _dbServices.getapiNew(
        //schoolId=${Overrides.SCHOOL_ID}&objectName=//scott.walker@solvedconsulting.com//$value//
        "https://ny67869sad.execute-api.us-east-2.amazonaws.com/production/getSchedule?email=$email",
        //matias.brocato@solvedconsulting.com",
        isCompleteUrl: true,
      );
      if (response.statusCode == 200) {
        modelCalender = modelCalenderFromJson(json.encode(response.data));

        return modelCalender.body!;
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Color getDayColor(Schedule schedule, String _currentDay) {
    switch (_currentDay) {
      case 'Monday':
        return Utility.getColorFromHex(schedule.monHexCodeC!);
      case 'Tuesday':
        return Utility.getColorFromHex(schedule.tuesHexCodeC!);
      case 'Wednesday':
        return Utility.getColorFromHex(schedule.wedHexCodeC!);
      case 'Thursday':
        return Utility.getColorFromHex(schedule.thursHexCodeC!);
      case 'Friday':
        return Utility.getColorFromHex(schedule.friHexCodeC!);
      case 'Saturday':
        return Colors.transparent;
      case 'Sunday':
        return Colors.transparent;
      default:
        return Colors.transparent;
    }
  }

  String getPeriod(Schedule schedule, String _currentDay) {
    switch (_currentDay) {
      case 'Monday':
        return 'P${schedule.monPeriodC!}-';
      case 'Tuesday':
        return 'P${schedule.tuesPeriodC!}-';
      case 'Wednesday':
        return 'P${schedule.wedPeriodC!}-';
      case 'Thursday':
        return 'P${schedule.thursPeriodC!}-';
      case 'Friday':
        return 'P${schedule.friPeriodC!}-';
      case 'Saturday':
        return '';
      case 'Sunday':
        return '';
      default:
        return '';
    }
  }

  getSubject(Schedule schedule, String _currentDay) {
    switch (_currentDay) {
      case 'Monday':
        return schedule.mondaySubjectC ?? '';
      case 'Tuesday':
        return schedule.tuesdaySubjectC ?? '';
      case 'Wednesday':
        return schedule.wednesdaySubjectC ?? '';
      case 'Thursday':
        return schedule.thursdaySubjectC ?? '';
      case 'Friday':
        return schedule.fridaySubjectC ?? '';
      case 'Saturday':
        return '';
      case 'Sunday':
        return '';
      default:
        return '';
    }
  }

  getShortSubj(Schedule schedule, DateTime date) {
    String _currentDay = DateFormat('EEEE').format(date);
    switch (_currentDay) {
      case 'Monday':
        return schedule.monSubjAbbrC ?? '';
      case 'Tuesday':
        return schedule.tuesSubjAbbrC ?? '';
      case 'Wednesday':
        return schedule.wedSubjAbbrC ?? '';
      case 'Thursday':
        return schedule.thursSubjAbbrC ?? '';
      case 'Friday':
        return schedule.friSubjAbbrC ?? '';
      case 'Saturday':
        return '';
      case 'Sunday':
        return '';
      default:
        return '';
    }
  }

  getRoom(Schedule schedule, DateTime date) {
    String _currentDay = DateFormat('EEEE').format(date);
    switch (_currentDay) {
      case 'Monday':
        return schedule.monRoomC ?? '';
      case 'Tuesday':
        return schedule.tuesRoomC ?? '';
      case 'Wednesday':
        return schedule.wedRoomC ?? '';
      case 'Thursday':
        return schedule.thursRoomC ?? '';
      case 'Friday':
        return schedule.friRoomC ?? '';
      case 'Saturday':
        return '';
      case 'Sunday':
        return '';
      default:
        return '';
    }
  }

  getTeacher(Schedule schedule, String _currentDay) {
    switch (_currentDay) {
      case 'Monday':
        return schedule.monTeacherC ?? '';
      case 'Tuesday':
        return schedule.tuesTeacherC ?? '';
      case 'Wednesday':
        return schedule.wedTeacherC ?? '';
      case 'Thursday':
        return schedule.thursTeacherC ?? '';
      case 'Friday':
        return schedule.friTeacherC ?? '';
      case 'Saturday':
        return '';
      case 'Sunday':
        return '';
      default:
        return '';
    }
  }

  // getTitle(BlackoutDate title, DateTime date) {
  //   String _currentDay = DateFormat('EEEE').format(date);
  //   switch (_currentDay) {
  //     case 'Monday':
  //       return title.titleC ?? '';
  //     case 'Tuesday':
  //       return title.titleC ?? '';
  //     case 'Wednesday':
  //       return title.titleC ?? '';
  //     case 'Thursday':
  //       return title.titleC ?? '';
  //     case 'Friday':
  //       return title.titleC ?? '';
  //     case 'Saturday':
  //       return '';
  //     case 'Sunday':
  //       return '';
  //     default:
  //       return '';
  //   }
  // }

  getabrasion(Schedule scheduleList, String day) {
    String periodNumber;
    var map = {
      'Monday': scheduleList.monSubjAbbrC ?? '',
      'Tuesday': scheduleList.tuesSubjAbbrC ?? '',
      'Wednesday': scheduleList.wedSubjAbbrC ?? '',
      'Thursday': scheduleList.thursSubjAbbrC ?? '',
      'Friday': scheduleList.friSubjAbbrC ?? '',
    };
    periodNumber = map[day] ?? '';

    return periodNumber;
  }

  getDaysPeriodsNumber(Schedule scheduleList, String day) {
    String periodNumber;
    var map = {
      'Monday': scheduleList.monPeriodC ?? '',
      'Tuesday': scheduleList.tuesPeriodC ?? '',
      'Wednesday': scheduleList.wedPeriodC ?? '',
      'Thursday': scheduleList.thursPeriodC ?? '',
      'Friday': scheduleList.friPeriodC ?? '',
    };
    periodNumber = map[day] ?? '';
    return periodNumber;
  }
}
