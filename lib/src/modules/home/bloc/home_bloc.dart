import 'dart:async';
import 'dart:convert';
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
import 'package:http/http.dart' as http;
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
          Globals.homeObject = Globals.appSetting.toJson();
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
        List<SearchList> filteredList = [];
        List<SearchList> list = await getGlobalSearch({
          "q": event.keyword,
          "sobjects": [
            {
              "fields": [
                "Active_Status__c",
                "Id",
                "Title__c",
                "URL__c",
                "PDF_URL__c",
                "Name",
                "RTF_HTML__c",
                "Type__c",
                "School_App__c",
                "Calendar_Id__c"
              ],
              "name": "Families_App__c"
            },
            {
              "name": "Family_Sub_Menu_App__c",
              "fields": [
                "Active_Status__c",
                "Id",
                "Title__c",
                "URL__c",
                "PDF_URL__c",
                "Name",
                "RTF_HTML__c",
                "Type__c",
                "School_App__c"
              ]
            },
            {
              "name": "Staff_App__c",
              "fields": [
                "Active_Status__c",
                "Id",
                "Title__c",
                "URL__c",
                "PDF_URL__c",
                "Name",
                "RTF_HTML__c",
                "Type__c",
                "School_App__c",
                "Calendar_Id__c"
              ]
            },
            {
              "fields": [
                "Active_Status__c",
                "Id",
                "Title__c",
                "URL__c",
                "PDF_URL__c",
                "Name",
                "RTF_HTML__c",
                "Type__c",
                "School_App__c"
              ],
              "name": "Staff_Sub_Menu_App__c"
            },
            {
              "fields": [
                "Active_Status__c",
                "Title__c",
                "App_URL__c",
                "App_Icon_URL__c",
                "Deep_Link__c",
                "Id",
                "Name",
                "App_Folder__c",
                "School_App__c",
                "Is_Folder__c",
                "Sort_Order__c"
              ],
              "name": "Student_App__c"
            },
            {
              "fields": [
                "Id",
                "Title__c",
                "Active_Status__c",
                "Website_URL__c",
                "Sort_Order__c",
                "RTF_HTML__c",
                "Phone__c",
                "Image_URL__c",
                "Email__c",
                "Type__c",
                "Contact_Office_Location__c",
                "Contact_Address__c",
                "School_App__c"
              ],
              "name": "School_Directory_App__c"
            },
            {
              "fields": [
                "Id",
                "Active_Status__c",
                "Description__c",
                "Email__c",
                "Image_URL__c",
                "Phone__c",
                "School_App__c",
                "Sort_Order__c",
                "Title__c"
              ],
              "name": "Staff_Directory_App__c"
            },
            {
              "fields": [
                "Active_Status__c",
                "App_Icon_URL__c",
                "Sort_Order__c",
                "Title__c",
                "Id",
                "Name",
                "URL__c",
                "Type__c",
                "RTF_HTML__c",
                "PDF_URL__c",
                "School_App__c"
              ],
              "name": "Resources_App__c"
            },
            {
              "fields": [
                "Active_Status__c",
                "App_Icon_URL__c",
                "Sort_Order__c",
                "Title__c",
                "Id",
                "URL__c",
                "School_App__c",
                "PDF_URL__c",
                "RTF_HTML__c",
                "Type__c"
              ],
              "name": "About_App__c"
            }
          ],
          "in": "ALL",
          "overallLimit": 100,
          "defaultLimit": 10
        });
        if (list.length > 0) {
          for (int i = 0; i < list.length; i++) {
            if (list[i].schoolId == Globals.homeObject["Id"]) {
              filteredList.add(list[i]);
            }
            yield GlobalSearchSuccess(
              obj: filteredList,
            );
          }
        } else {
          yield GlobalSearchSuccess(
            obj: list,
          );
        }
      } catch (e) {
        yield HomeErrorReceived(err: e);
      }
    }
  }

  Future fetchBottomNavigationBar() async {
    try {
      // final ResponseModel response = await _dbServices.getapi(
      //   Uri.encodeFull(
      //       'getRecords?schoolId=${Overrides.SCHOOL_ID}&objectName=School_App__c'),
      // );
      final response = await http.get(
        Uri.parse(
            'https://7l6e6qqkb8.execute-api.us-east-2.amazonaws.com/dev/getRecords2?schoolId=${Overrides.SCHOOL_ID}&objectName=School_App__c'),
      );

// https://7l6e6qqkb8.execute-api.us-east-2.amazonaws.com/dev/getRecords2?schoolId=a1f4W000007DQZPQA4&objectName=School_App__c

      if (response.statusCode == 200) {
        final data1 = json.decode(response.body);
        // final data = response.data['body']['Items'][0];
        final data = data1['body'][0];
        Globals.appSetting = AppSetting.fromJson(data);
        // To take the backup for all the sections.
        _backupAppData();
        if (Globals.appSetting.bannerHeightFactor != null) {
          AppTheme.kBannerHeight = Globals.appSetting.bannerHeightFactor;
          print(AppTheme.kBannerHeight);
        }
        return data;
      }
    } catch (e) {
      throw (e);
    }
  }

  Future getGlobalSearch(body) async {
    try {
      final ResponseModel response =
          await _dbServices.postapi('parameterizedSearch', body: body);
      // print(response.data);
      if (response.statusCode == 200) {
        return response.data["searchRecords"]
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
