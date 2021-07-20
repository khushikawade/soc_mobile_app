import 'dart:async';
import 'package:Soc/src/modules/families/modal/family_list.dart';

import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../overrides.dart' as overrides;
import 'dart:convert';
import 'package:http/http.dart' as http;
part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  var data;
  FamilyBloc() : super(FamilyInitial());
  final DbServices _dbServices = DbServices();

  FamilyState get initialState => FamilyInitial();

  @override
  Stream<FamilyState> mapEventToState(
    FamilyEvent event,
  ) async* {
    if (event is FamiliesEvent) {
      try {
        List<FamiliesList> subList = [];
        yield FamilyLoading();
        List<FamiliesList> list = await getFamilyList();
        // if (list != null && list.length > 0) {
        //   for (int i = 0; i < list.length; i++) {
        //     if (list[i].appFolderc == null || list[i].appFolderc == "") {
        //       appList.add(list[i]);
        //     }
        //   }
        // }
        yield FamiliesDataSucess(obj: list, subFolder: subList);
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }
  }

  Future<List<FamiliesList>> getFamilyList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,App_Icon__c,URL__c,Id,Name, Type__c, PDF_URL__c, RTF_HTML__c FROM Families_App__c where School_App__c = 'a1T3J000000RHEKUA4'")}");

      if (response.statusCode == 200) {
        return response.data["records"]
            .map<FamiliesList>((i) => FamiliesList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
