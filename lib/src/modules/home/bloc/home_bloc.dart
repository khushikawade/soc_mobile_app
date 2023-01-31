import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/about/bloc/about_bloc.dart';
import 'package:Soc/src/modules/custom/bloc/custom_bloc.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/families/modal/sd_list.dart';
import 'package:Soc/src/modules/home/models/search_list.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/resources/bloc/resources_bloc.dart';
import 'package:Soc/src/modules/schools_directory/bloc/school_bloc.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
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
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom/model/custom_setting.dart';
import '../../schools_directory/modal/school_directory_list.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());
  final DbServices _dbServices = DbServices();
  // final HiveDbServices _localDbService = HiveDbServices();
  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is FetchStandardNavigationBar) {
      try {
        yield HomeLoading();
        final data = await fetchStandardNavigationBar();
        // Saving data to the Local DataBase
        AppSetting _appSetting = AppSetting.fromJson(data);
        Globals.isCustomNavbar = false;

        // fatch custom bottom navbar and update to localdata base
        if (_appSetting.isCustomApp!) {
          List<CustomSetting> data1 = await fetchCustomNavigationBar();
          data1.sort((a, b) => a.sortOrderC!.compareTo(b.sortOrderC!));
          Globals.customSetting = data1;
          Globals.isCustomNavbar = true;
          LocalDatabase<CustomSetting> _customSettingDb =
              LocalDatabase(Strings.customSettingObjectName);
          await _customSettingDb.clear();
          data1.forEach((CustomSetting e) {
            _customSettingDb.addData(e);
          });
        }
        saveDarkModeField(_appSetting);

        // Should send the response first then it will sync data to the Local database.
        yield BottomNavigationBarSuccess(obj: data);

        // Saving remote data to the local database.
        LocalDatabase<AppSetting> _appSettingDb =
            LocalDatabase(Strings.schoolObjectName);
        await _appSettingDb.clear();
        await _appSettingDb.addData(_appSetting);
        await _appSettingDb.close();
      } catch (e) {
        //print(e);
        // Should not break incase of any issue, it will just return the local data.
        // Fetching the School data from the Local database instead.
        LocalDatabase<AppSetting> _appSettingDb =
            LocalDatabase(Strings.schoolObjectName);
        List<AppSetting>? _appSettings = await _appSettingDb.getData();
        await _appSettingDb.close();

        if (_appSettings.length > 0) {
          Globals.appSetting = _appSettings.last;
          if (Globals.appSetting.isCustomApp!) {
            Globals.isCustomNavbar = true;

            LocalDatabase<CustomSetting> _customSettingDb =
                LocalDatabase(Strings.customSettingObjectName);
            List<CustomSetting>? _localData = await _customSettingDb.getData();
            _localData.sort((a, b) => a.sortOrderC!.compareTo(b.sortOrderC!));
            Globals.customSetting = _localData;
            _customSettingDb.close();
          }
          if (Globals.appSetting.bannerHeightFactor != null) {
            AppTheme.kBannerHeight = Globals.appSetting.bannerHeightFactor;
          }
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

        for (var i = 0; i < list.length; i++) {
          if (list[i].appURLC == "app-folder") {
            list.removeAt(i);
          }
        }
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
                Strings.familiesObjectName, event.keyword, 'Families_App__c');
            _listGlobal.addAll(_list1);
            List<SearchList> _list2 = await getGlobalSearchList(
                Strings.staffObjectName,
                event.keyword,
                'Staff_Directory_App__c');
            _listGlobal.addAll(_list2);
            List<SearchList> _list3 = await getGlobalSearchList(
                Strings.resourcesObjectName, event.keyword, 'Resources_App__c');
            _listGlobal.addAll(_list3);
            List<SearchList> _list4 = await getGlobalSearchList(
                Strings.aboutObjectName, event.keyword, 'About_App__c');
            _listGlobal.addAll(_list4);
            List<SearchList> _list5 = await getGlobalSearchListStudent(
                Strings.studentsObjectName, event.keyword, 'Student_App__c');
            _listGlobal.addAll(_list5);
            List<SearchList> _list6 = await getGlobalSearchListSchool(
                Strings.schoolDirectoryObjectName,
                event.keyword,
                'School_Directory_App__c');
            _listGlobal.addAll(_list6);
          }
          //print(_listGlobal.length);
          yield GlobalSearchSuccess(
            obj: _listGlobal,
          );
        } catch (e) {
          yield HomeErrorReceived(err: e);
        }
      }
    }

//ReferenceGlobalSearchREvent

    if (event is GetRecordByID) {
      bool result = false;
      try {
        //ge
        List<dynamic> _localDb =
            await getRecentSearchListData(Strings.hiveReferenceLogName);

        for (int i = 0; i < _localDb.length; i++) {
          if (event.recordId == _localDb[i].id) {
            result = true;
            //print("return from local db ============>");
            if (event.isFromRecent == false) {
              yield EmptyState();
            }
            if (event.isFromRecent != true) {
              yield RecordDetailSuccess(
                  isRecentRecod: true,
                  recordObject: _localDb[i],
                  objectName: event.objectName,
                  objectType: event.recordType);
            }

            break;
          }
        }

        if (!result) {
          yield RefrenceSearchLoading();
        }

        //print('calling api ===================>');
        dynamic recordObject = await getrecordByID_API(
            event.recordId, event.objectName, event.recordType!);

        List<dynamic> idReferenceList = [];
        for (int i = 0; i < _localDb.length; i++) {
          idReferenceList.add(_localDb[i].id);
          if (_localDb[i].id.toString() == recordObject.id.toString()) {
            // recordDetailList[i] = recordObject;
            //print('updating local db =============>');
            await HiveDbServices()
                .updateListData(Strings.hiveReferenceLogName, i, recordObject);
          }
        }

        if (!idReferenceList.contains(recordObject.id)) {
          deleteRecentSearchItem(Strings.hiveReferenceLogName);
          //print('adding in local db===============>');
          addRecordDetailtoLocalDb(recordObject);
        }
        if (!result && event.isFromRecent != true) {
          //print('returning new state====================>');
          yield RecordDetailSuccess(
              isRecentRecod: false,
              recordObject: recordObject,
              objectName: event.objectName,
              objectType: event.recordType);
        }
      } catch (e) {
        if (event.recordId!.isNotEmpty &&
            event.objectName!.isNotEmpty &&
            event.recordType!.isNotEmpty) {
          //       }
          dynamic recordObject;
          if (event.objectName == "Families_App__c") {
            getRecordByID_localDatabase(
                Strings.familiesObjectName, event.recordId);
          } else if (event.objectName == 'Staff_Directory_App__c') {
            getRecordByID_localDatabase(
                Strings.staffObjectName, event.recordId);
          } else if (event.objectName == 'Resources_App__c') {
            getRecordByID_localDatabase(
                Strings.resourcesObjectName, event.recordId);
          } else if (event.objectName == 'About_App__c') {
            getRecordByID_localDatabase(
                Strings.aboutObjectName, event.recordId);
          } else if (event.objectName == 'Student_App__c') {
            getRecordByID_localDatabase(
                Strings.studentsObjectName, event.recordId);
          } else if (event.objectName == 'School_Directory_App__c') {
            getRecordByID_localDatabase(
                Strings.schoolDirectoryObjectName, event.recordId);
          }
          //print('inside catch ===============>');
          if (!result) {
            //print('retrunig from catch ');
            yield RecordDetailSuccess(
                isRecentRecod: false,
                recordObject: recordObject,
                objectName: event.objectName,
                objectType: event.recordType);
          }
        }

        // yield HomeErrorReceived(err: e);
      }
    }
  }

  Future fetchCustomNavigationBar() async {
    try {
      final ResponseModel response = await _dbServices.getApi(
        Uri.encodeFull(
            'getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=Custom_App_Section__c'),
      );

      if (response.statusCode == 200) {
        List<CustomSetting> _list = response.data['body']
            .map<CustomSetting>((i) => CustomSetting.fromJson(i))
            .toList();

        _list.removeWhere((CustomSetting element) => element.status == 'Hide');
        _list.sort((a, b) => a.sortOrderC!.compareTo(b.sortOrderC!));
        if (_list.length > 6) {
          _list.removeRange(6, _list.length);
        }
        Globals.customSetting = _list;
        // To take the backup for all the sections.
        _backupAppData();
        return _list;
      }
    } catch (e) {
      throw (e);
    }
  }

  Future fetchStandardNavigationBar() async {
    try {
      final ResponseModel response = await _dbServices.getApi(
        Uri.encodeFull(
            'getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=School_App__c'),
      );

      if (response.statusCode == 200) {
        final data = response.data['body'][0];
        Globals.appSetting = AppSetting.fromJson(data);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            Strings.SplashUrl, data["Splash_Screen__c"] ?? data["App_Logo__c"]);

        _backupAppData();
        if (Globals.appSetting.bannerHeightFactor != null) {
          AppTheme.kBannerHeight = Globals.appSetting.bannerHeightFactor;
        }
        return data;
      }
    } catch (e) {
      throw (e);
    }
  }

//TODO : Improve the logic via model
  Future<List<SearchList>> getGlobalSearchList(
      dataBaseName, keyword, objectName) async {
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
          _searchList.objectName = objectName;
          listSearch.insert(listSearch.length, _searchList);
        }
      }
      return listSearch;
    } catch (e) {
      //print(e);
      throw Exception('Something went wrong');
    }
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> getRecordByID_localDatabase(dataBaseName, id) async {
    try {
      LocalDatabase<dynamic> _localDb = LocalDatabase(dataBaseName);

      List<dynamic>? _localData = await _localDb.getData();
      dynamic object;
      // listSearch.clear();
      for (var i = 0; i < _localData.length; i++) {
        if (_localData[i].id = id) {
          object = _localData[i];
        }
      }
      return object;
    } catch (e) {
      //print(e);
      throw Exception('Something went wrong');
    }
  }

//TODO : Improve the logic via model
  Future<List<SearchList>> getGlobalSearchListSchool(
      dataBaseName, keyword, objectName) async {
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
          _searchList.objectName = objectName;
          _searchList.sortOrder =
              double.parse(_localData[i].sortOrder ?? "0.0");

          _listSearch.insert(0, _searchList);
        }
      }
      return _listSearch;
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

//TODO : Improve the logic via model
  Future<List<SearchList>> getGlobalSearchListStudent(
      dataBaseName, keyword, objectName) async {
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
          _searchList.objectName = objectName;
          _searchList.sortOrder =
              double.parse(_localData[i].sortOrder ?? "0.0");

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
      final ResponseModel response = await _dbServices.getApi(
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
        } else if (element.contains('social')) {
          SocialBloc _socialBloc = SocialBloc();
          _socialBloc.add(SocialPageEvent(action: 'initial'));
        } else if (element.contains('news')) {
          NewsBloc _newsBloc = NewsBloc();
          _newsBloc.add(FetchNotificationList());
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
          _schoolBloc.add(SchoolDirectoryListEvent(isSubMenu: false));
        } else if (element.contains('resource')) {
          ResourcesBloc _resourceBloc = ResourcesBloc();
          _resourceBloc.add(ResourcesListEvent());
        }
      });

      if (Globals.customSetting != null) {
        for (var i = 0; i < Globals.customSetting!.length; i++) {
          CustomBloc _customBloc = CustomBloc();
          _customBloc.add(CustomEvents(id: Globals.customSetting![i].id));
        }
      }

      NewsBloc _newsBloc = NewsBloc();
      _newsBloc.add(FetchActionCountList(isDetailPage: false));
      SocialBloc _socialBloc = SocialBloc();
      // _socialBloc.add(FetchSocialActionCount(isDetailPage: false));
      _socialBloc.add(SocialPageEvent(action: 'initial'));
    } catch (e) {
      //print(e);
    }
  }

  saveDarkModeField(AppSetting _appSetting) {
    if (_appSetting.disableDarkMode == true) {
      HiveDbServices _hivedb = HiveDbServices();
      _hivedb.addSingleData('disableDarkMode', 'darkMode', true);
    } else {
      HiveDbServices _hivedb = HiveDbServices();
      _hivedb.addSingleData('disableDarkMode', 'darkMode', false);
    }
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> getrecordByID_API(
      String? recordId, String? objectName, String recordType) async {
    try {
      final ResponseModel response =
          await _dbServices.getApi('getRecord/$objectName/$recordId');
      if (response.statusCode == 200) {
        dynamic data;
        if (objectName == "Staff_Directory_App__c") {
          return data = SDlist.fromJson(response.data['body']);
        } else if (objectName == "About_App__c" ||
            objectName == "Families_App__c" ||
            objectName == "Resources_App__c" ||
            objectName == "Staff_App__c" ||
            objectName == "Custom_App_Menu__c") {
          return data = SharedList.fromJson(response.data['body']);
        } else if (objectName == "School_Directory_App__c") {
          return data = SchoolDirectoryList.fromJson(response.data['body']);
        } else if (objectName == "Student_App__c") {
          return data = StudentApp.fromJson(response.data['body']);
        }
      }
    } catch (e) {
      throw (e);
    }
  }

  getRecentSearchListData(String localDatalogName) async {
    List listItem = await HiveDbServices().getListData(localDatalogName);
    return listItem;
  }

  // cleanList() async {
  //   await HiveDbServices().clearAll(Strings.hiveReferenceLogName);
  // }

  // void updateRecordList(List<dynamic> log) async {
  //   LocalDatabase<dynamic> _localDb =
  //       LocalDatabase(Strings.hiveReferenceLogName);
  //   // List<dynamic> _localData = await _localDb.getData();
  //   try {
  //     _localDb.clear();
  //     log.forEach((dynamic e) {
  //       //print("local database");
  //       _localDb.addData(e);
  //     });
  //   } catch (e) {
  //     //print(e);
  //     //print("inside catch");
  //   }

  //   //_localDb.close();

  //   // bool isSuccess =
  //   //     await HiveDbServices().addData(log, Strings.hiveReferenceLogName);
  // }

  void deleteRecentSearchItem(String localDatalogName) async {
    int itemCount = await HiveDbServices().getListLength(localDatalogName);
    if (itemCount > 5) {
      await HiveDbServices().deleteData(localDatalogName, 0);
    }
  }

  void addRecordDetailtoLocalDb(dynamic log) async {
    await HiveDbServices().addData(log, Strings.hiveReferenceLogName);
  }
}
