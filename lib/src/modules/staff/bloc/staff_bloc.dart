import 'dart:async';
import 'package:Soc/src/modules/staff/models/models/staffmodal.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc() : super(StaffInitial());
  final DbServices _dbServices = DbServices();

  StaffState get initialState => StaffInitial();

  @override
  Stream<StaffState> mapEventToState(
    StaffEvent event,
  ) async* {
    if (event is StaffPageEvent) {
      try {
        List<StaffList> appList = [];
        yield Loading();
        List<StaffList> list = await getStaffDetails();
        // if (list != null && list.length > 0) {
        //   for (int i = 0; i < list.length; i++) {
        //     if (list[i].appFolderc == null || list[i].appFolderc == "") {
        //       appList.add(list[i]);
        //     }
        //   }
        // }
        yield StaffDataSucess(
          obj: list,
        );
      } catch (e) {
        yield Errorinloading(err: e);
      }
    }
  }

  Future<List<StaffList>> getStaffDetails() async {
    try {
      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,App_Icon__c,URL__c,Id,Name FROM Staff_App__c where School_App__c = 'a1T3J000000RHEKUA4'")}");
      if (response.statusCode == 200) {
        return response.data["records"]
            .map<StaffList>((i) => StaffList.fromJson(i))
            .toList();
      } else {
        throw ('something_went_wrong');
      }
    } catch (e) {
      throw (e);
    }
  }
}
