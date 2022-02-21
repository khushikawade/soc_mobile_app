import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/about/bloc/about_bloc.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/home/models/search_list.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/modules/resources/bloc/resources_bloc.dart';
import 'package:Soc/src/modules/schools/bloc/school_bloc.dart';
import 'package:Soc/src/modules/schools/modal/school_directory_list.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
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
          if (Globals.appSetting.bannerHeightFactor != null) {
          AppTheme.kBannerHeight = Globals.appSetting.bannerHeightFactor;
          // print(AppTheme.kBannerHeight);
        }
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
        // yield HomeErrorReceived(err: e);
        List<SearchList> _listGlobal = [];
      try {
        yield SearchLoading();

        // _localData.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        if (event.keyword!.isNotEmpty) {
          _listGlobal.clear();
          List<SearchList> _list1 = await getGlobalSearchList(
              Strings.familiesObjectName, event.keyword);
          _listGlobal.addAll(_list1);
          List<SearchList> _list2 =
              await getGlobalSearchList(Strings.staffObjectName, event.keyword);
          _listGlobal.addAll(_list2);
          List<SearchList> _list3 = await getGlobalSearchList(
              Strings.resourcesObjectName, event.keyword);
          _listGlobal.addAll(_list3);
          List<SearchList> _list4 =
              await getGlobalSearchList(Strings.aboutObjectName, event.keyword);
          _listGlobal.addAll(_list4);
          List<SearchList> _list5 = await getGlobalSearchListStudent(
              Strings.studentsObjectName, event.keyword);
          _listGlobal.addAll(_list5);
          List<SearchList> _list6 = await getGlobalSearchListSchool(
              Strings.schoolDirectoryObjectName, event.keyword);
          _listGlobal.addAll(_list6);
          // List<SearchList> _list7 = await getGlobalSearchList(
          //     Strings.familiesSubListObjectName, event.keyword);
          // _listGlobal.addAll(_list7);
          // List<SearchList> _list8 = await getGlobalSearchList(
          //     Strings.staffSubListObjectName, event.keyword);
          // _listGlobal.addAll(_list8);
          // List<SearchList> _list9 = await getGlobalSearchList(
          //     Strings.aboutSubListObjectName, event.keyword);
          // _listGlobal.addAll(_list9);
          // List<SearchList> _list10 = await getGlobalSearchList(
          //     Strings.resourcesSubListObjectName, event.keyword);
          // _listGlobal.addAll(_list10);
        }

        yield GlobalSearchSuccess(
          obj: _listGlobal,
        );
      } catch (e) {
        yield HomeErrorReceived(err: e);
      }
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

  Future<List<SearchList>> getGlobalSearchList(dataBaseName, keyword) async {
    try {
      LocalDatabase<SharedList> _localDb = LocalDatabase(dataBaseName);

      List<SharedList>? _localData = await _localDb.getData();
      List<SearchList> listSearch = [];
      listSearch.clear();
      for (var i = 0; i < _localData.length; i++) {
        if (_localData[i].titleC!.contains(keyword!)) {
          SearchList _searchList = SearchList();
          _searchList.id = _localData[i].id ?? null;
          _searchList.urlC = _localData[i].appUrlC ?? null;
          _searchList.appIconUrlC = _localData[i].appIconUrlC ?? null;
          _searchList.titleC = _localData[i].titleC ?? null;
          _searchList.typeC = _localData[i].typeC ?? null;
          _searchList.statusC = _localData[i].status ?? null;
          _searchList.sortOrder = _localData[i].sortOrder ?? null;
          _searchList.rtfHTMLC = _localData[i].rtfHTMLC ?? null;
          _searchList.pdfURL = _localData[i].pdfURL ?? null;
          _searchList.name = _localData[i].name ?? null;
          _searchList.calendarId = _localData[i].calendarId ?? null;
          listSearch.insert(listSearch.length, _searchList);
        }
      }
      return listSearch;
    } catch (e) {
      print(e);
      throw Exception('Something went wrong');
    }
  }

  Future<List<SearchList>> getGlobalSearchListSchool(
      dataBaseName, keyword) async {
    SearchList _searchList = SearchList();
    List<SearchList> _listSearch = [];
    try {
      LocalDatabase<SchoolDirectoryList> _localDb = LocalDatabase(dataBaseName);

      List<SchoolDirectoryList>? _localData = await _localDb.getData();
      _listSearch.clear();
      for (var i = 0; i < _localData.length; i++) {
        if (_localData[i].titleC!.contains(keyword!)) {
          _searchList.id = _localData[i].id ?? null;
          _searchList.urlC = _localData[i].urlC ?? null;
          _searchList.appIconUrlC = _localData[i].imageUrlC ?? null;
          _searchList.titleC = _localData[i].titleC ?? null;
          _searchList.address = _localData[i].address ?? null;
          _searchList.phoneC = _localData[i].phoneC ?? null;
          _searchList.rtfHTMLC = _localData[i].rtfHTMLC ?? null;
          _searchList.geoLocation = _localData[i].geoLocation ?? null;
          _searchList.statusC = _localData[i].statusC ?? null;
          _searchList.latitude = _localData[i].latitude ?? null;
          _searchList.longitude = _localData[i].longitude ?? null;
          _searchList.sortOrder = double.parse(_localData[i].sortOrder ?? "0.0");

          _listSearch.insert(0, _searchList);
        }
      }
      return _listSearch;
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

  Future<List<SearchList>> getGlobalSearchListStudent(
      dataBaseName, keyword) async {
    SearchList _searchList = SearchList();
    List<SearchList> _listSearch = [];
    try {
      LocalDatabase<StudentApp> _localDb = LocalDatabase(dataBaseName);

      List<StudentApp>? _localData = await _localDb.getData();
      _listSearch.clear();
      for (var i = 0; i < _localData.length; i++) {
        if (_localData[i].titleC!.contains(keyword!)) {
          _searchList.id = _localData[i].id ?? null;
          _searchList.urlC = _localData[i].appUrlC ?? null;
          _searchList.appIconUrlC = _localData[i].appUrlC ?? null;
          _searchList.titleC = _localData[i].titleC ?? null;
          _searchList.deepLink = _localData[i].deepLinkC ?? null;
          _searchList.statusC = _localData[i].status ?? null;
          _searchList.sortOrder = double.parse(_localData[i].sortOrder ?? "0.0");

          _searchList.name = _localData[i].name ?? null;

          _listSearch.insert(0, _searchList);
        }
      }
      return _listSearch;
    } catch (e) {
      throw Exception('Something went wrong');
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
