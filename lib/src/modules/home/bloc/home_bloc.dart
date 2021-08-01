import 'dart:async';
import 'dart:convert';
import 'package:Soc/src/modules/home/model/search_list.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  var data;
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
                "Type__c"
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
                "Type__c"
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
                "Type__c"
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
                "Type__c"
              ],
              "name": "Staff_Sub_Menu_App__c"
            },
            {
              "fields": [
                "Title__c",
                "App_Icon__c",
                "App_URL__c",
                "Deep_Link__c",
                "Id",
                "Name",
                "App_Folder__c"
              ],
              "name": "Student_App__c"
            }
          ],
          "in": "ALL",
          "overallLimit": 100,
          "defaultLimit": 10
        });
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
        Uri.encodeFull('sobjects/School_App__c/a1T3J000000RHEKUA4'),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        return data;
      }
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("Please check your Internet Connection.");
      } else {
        throw (e);
      }
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
      if (e.toString().contains("Failed host lookup")) {
        throw ("Please check your Internet Connection.");
      } else {
        throw (e);
      }
    }
  }
}
