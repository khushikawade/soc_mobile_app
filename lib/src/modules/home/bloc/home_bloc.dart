import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/model/search_list.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());
  final DbServices _dbServices = DbServices();

  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is FetchBottomNavigationBar) {
      try {
        yield HomeLoading();
        final data = await fetchBottomNavigationBar();

        yield BottomNavigationBarSuccess(obj: data);
      } catch (e) {
        yield HomeErrorReceived(err: e);
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
                "Id",
                "Title__c",
                "URL__c",
                "PDF_URL__c",
                "Name",
                "RTF_HTML__c",
                "Type__c",
                "School_App__c"
              ],
              "name": "Families_App__c"
            },
            {
              "name": "Family_Sub_Menu_App__c",
              "fields": [
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
              "fields": [
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
                "Title__c",
                "App_URL__c",
                "App_Icon_URL__c",
                "Deep_Link__c",
                "Id",
                "Name",
                "App_Folder__c",
                "School_App__c"
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
        for (int i = 0; i < list.length; i++) {
          if (list[i].schoolId == Globals.homeObject["Id"]) {
            filteredList.add(list[i]);
          }
        }

        yield GlobalSearchSuccess(
          obj: filteredList,
        );
      } catch (e) {
        yield HomeErrorReceived(err: e);
      }
    }
  }

  Future fetchBottomNavigationBar() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
        Uri.encodeFull('sobjects/School_App__c/${Overrides.SCHOOL_ID}'),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        Globals.appSetting = AppSetting.fromJson(data);
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
}
