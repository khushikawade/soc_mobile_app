import 'dart:async';
import 'package:Soc/src/modules/families/Submodule/staff/modal/models/staff_sublist.dart';
import 'package:Soc/src/modules/families/Submodule/staff/modal/models/stafflist.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  var data;
  StaffBloc() : super(StaffInitial());
  final DbServices _dbServices = DbServices();

  StaffState get initialState => StaffInitial();
  var dataArray;
  @override
  Stream<StaffState> mapEventToState(
    StaffEvent event,
  ) async* {
    if (event is Staffevent) {
      try {
        yield StaffLoading();
        List<Stafflist> list = await getStaffList();

        if (list.length > 0) {
          list.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));
          yield StaffDataSucess(obj: list);
        }
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }

    if (event is StaffsublistEvent) {
      try {
        yield StaffLoading();
        List<Staffsublist> list = await getStaffSubList(event.id);
        if (list.length > 0) {
          list.sort((a, b) => a.sortOrderC.compareTo(b.sortOrderC));
          yield StaffsublistSucess(obj: list);
        }
      } catch (e) {
        yield ErrorLoading(err: e);
      }
    }
  }

  Future<List<Stafflist>> getStaffList() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,Image_URL__c,Id,Name,Description__c, Email__c,Sort_Order__c,Phone__c FROM Staff_Directory_App__c where School_App__c = 'a1T3J000000RHEKUA4'")}");

      if (response.statusCode == 200) {
        dataArray = response.data["records"];
        return response.data["records"]
            .map<Stafflist>((i) => Stafflist.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Staffsublist>> getStaffSubList(id) async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,URL__c,Id,Name, Type__c, PDF_URL__c, RTF_HTML__c,Sort_Order__c FROM Staff_Sub_Menu_App__c where Families_App__c='$id'")}");

      if (response.statusCode == 200) {
        return response.data["records"]
            .map<Staffsublist>((i) => Staffsublist.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
