import 'dart:async';
import 'package:Soc/src/modules/about/modal/about_sublist.dart';
import 'package:Soc/src/modules/about/modal/about_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
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
        List<AboutList> list = await getAboutSDList();
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
    if (event is AboutSublistEvent) {
      try {
        yield AboutLoading();
        List<AboutSubList> list = await getAboutSubList(event.id);
        if (list.length > 0) {
          list.sort((a, b) => a.sortOredr.compareTo(b.sortOredr));

          yield AboutSublistSucess(obj: list);
        } else {
          yield AboutSublistSucess(obj: list);
        }
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }
  }

  Future<List<AboutList>> getAboutSDList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,Type__c,Id,Name,Sort_Order__c,URL__c,RTF_HTML__c,PDF_URL__c,App_Icon_URL__c,Active_Status__c FROM About_App__c where School_App__c = '${Overrides.SCHOOL_ID}'")}");
      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
            .map<AboutList>((i) => AboutList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<AboutSubList>> getAboutSubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,URL__c,Id,Name, Type__c, PDF_URL__c, RTF_HTML__c,Sort_Order__c,App_Icon_URL__c,Active_Status__c FROM About_Sub_Menu_App__c where About_App__c='$id'")}");

      if (response.statusCode == 200) {
        return response.data["records"]
            .map<AboutSubList>((i) => AboutSubList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
