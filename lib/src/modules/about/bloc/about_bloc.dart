import 'dart:async';
import 'package:Soc/src/modules/about/modal/aboutstafflist.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'about_event.dart';
part 'about_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  // var data;
  AboutBloc() : super(AboutInitial());
  final DbServices _dbServices = DbServices();

  AboutState get initialState => AboutInitial();
  var dataArray;
  @override
  Stream<AboutState> mapEventToState(
    AboutEvent event,
  ) async* {
    if (event is AboutStaffDirectoryEvent) {
      try {
        yield AboutLoading();
        List<AboutStaffDirectoryList> list = await getAboutSDList();
        if (list.length > 0) {
          list.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));
          yield AboutDataSucess(obj: list);
        } else {
          yield AboutDataSucess(obj: list);
        }
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }
  }

  Future<List<AboutStaffDirectoryList>> getAboutSDList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,Image_URL__c,Id,Name__c,Description__c, Email__c,Sort_Order__c,Phone__c,URL__c,Department__c,Active_Status__c FROM Staff_Directory_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
            .map<AboutStaffDirectoryList>(
                (i) => AboutStaffDirectoryList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
