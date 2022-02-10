import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/about/bloc/about_bloc.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/home/models/search_list.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/resources/bloc/resources_bloc.dart';
import 'package:Soc/src/modules/schools/bloc/school_bloc.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/local_database/hive_db_services.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:http/http.dart' as http;
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());
  final DbServices _dbServices = DbServices();
  final HiveDbServices _localDbService = HiveDbServices();

  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is FetchBottomNavigationBar) {
      try {
        yield HomeLoading();
        final data = await fetchBottomNavigationBar();
        // Saving data to the Local DataBase
        AppSetting _appSetting = AppSetting.fromJson(data);
        // print(_appSetting);
        //  Globals.homeObject = Globals.appSetting.toJson();
        // Should send the response first then it will sync data to the Local database.
        yield BottomNavigationBarSuccess(obj: data);

        // Saving remote data to the local database.
        LocalDatabase<AppSetting> _appSettingDb =
            LocalDatabase(Strings.schoolObjectName);
        await _appSettingDb.clear();
        await _appSettingDb.addData(_appSetting);
        await _appSettingDb.close();
      } catch (e) {
        print(e);
        // Should not break incase of any issue, it will just return the local data.
        // Fetching the School data from the Local database instead.
        LocalDatabase<AppSetting> _appSettingDb =
            LocalDatabase(Strings.schoolObjectName);
        List<AppSetting>? _appSettings = await _appSettingDb.getData();
        await _appSettingDb.close();
        if (_appSettings.length > 0) {
          Globals.appSetting = _appSettings.last;
          //  Globals.homeObject = Globals.appSetting.toJson();
          yield BottomNavigationBarSuccess(obj: Globals.appSetting.toJson());
        } else {
          // if the School object does not found in the Local database then it will return the received error.
          yield HomeErrorReceived(err: e);
        }
      }
    }
    if (event is GlobalSearchEvent) {
      try {
        yield SearchLoading();
        List<SearchList> list = await getGlobalSearch(event.keyword);
        yield GlobalSearchSuccess(
          obj: list,
        );
      } catch (e) {
        yield HomeErrorReceived(err: e);
      }
    }
  }

  Future fetchBottomNavigationBar() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
        Uri.encodeFull(
            'getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=School_App__c'),
      );

      if (response.statusCode == 200) {
        final data = response.data['body'][0];
        Globals.appSetting = AppSetting.fromJson(data);
        // To take the backup for all the sections.
        _backupAppData();
        if (Globals.appSetting.bannerHeightFactor != null) {
          AppTheme.kBannerHeight = Globals.appSetting.bannerHeightFactor;
          // print(AppTheme.kBannerHeight);
        }
        return data;
      }
    } catch (e) {
      throw (e);
    }
  }

  Future getGlobalSearch(keyword) async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          'searchRecords?schoolId=${Overrides.SCHOOL_ID}&keyword=$keyword');
      if (response.statusCode == 200) {
        return response.data["body"]
            .map<SearchList>((i) => SearchList.fromJson(i))
            .toList();
      }
    } catch (e) {
      throw (e);
    }
  }

  void _backupAppData() {
    try {
      Globals.appSetting.bottomNavigationC!
          .split(";")
          .forEach((String element) {
        element = element.toLowerCase();
        if (element.contains('student')) {
          StudentBloc _studentBloc = StudentBloc();
          _studentBloc.add(StudentPageEvent());
        } else if (element.contains('families')) {
          FamilyBloc _familyBloc = FamilyBloc();
          _familyBloc.add(FamiliesEvent());
        } else if (element.contains('staff')) {
          StaffBloc _staffBloc = StaffBloc();
          _staffBloc.add(StaffPageEvent());
        } else if (element.contains('about')) {
          AboutBloc _aboutBloc = new AboutBloc();
          _aboutBloc.add(AboutStaffDirectoryEvent());
        } else if (element.contains('school')) {
          SchoolDirectoryBloc _schoolBloc = new SchoolDirectoryBloc();
          _schoolBloc.add(SchoolDirectoryListEvent());
        } else if (element.contains('resource')) {
          ResourcesBloc _resourceBloc = ResourcesBloc();
          _resourceBloc.add(ResourcesListEvent());
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
