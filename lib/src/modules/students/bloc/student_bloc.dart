import 'dart:async';
import 'package:Soc/src/modules/social/modal/models/item.dart';
import 'package:Soc/src/modules/students/studentmodal.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xml2json/xml2json.dart';
import '../../../overrides.dart' as overrides;
import 'dart:convert';
import 'package:http/http.dart' as http;
part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  var data;
  StudentBloc() : super(StudentInitial());
  final DbServices _dbServices = DbServices();

  @override
  StudentState get initialState => StudentInitial();

  @override
  Stream<StudentState> mapEventToState(
    StudentEvent event,
  ) async* {
    if (event is StudentPageEvent) {
      try {
        print("student page event");
        yield Loading();
        List<Item> list = await getStudentDetails();
        yield DataGettedSuccessfully(obj: list);
      } catch (e) {
        yield Errorinloading(err: e);
      }
    }
  }

  Future getStudentDetails() async {
    try {
      // var link = Uri.parse("${overrides.Overrides.socialPagexmlUrl}");

      final ResponseModel response = await _dbServices.getapi(
          "query/?q=${Uri.encodeComponent("SELECT Title__c,App_Icon__c,App_URL__c,Deep_Link__c,Id,Name FROM Student_App__c where School_App__c = 'a1T3J000000RHEKUA4'")}"

          //"Title__c,App_Icon__c,App_URL__c,Deep_Link__c,Id,Name FROM Student_App__c where School_App__c = 'a1T3J000000RHEKUA4'")}",
          );
      final data = response.data;

      print(data);

      final data1 = data["records"];

      if (response.statusCode == 200) {
        print("statusCode 200 ***********");
        return data1.map((i) {
          return StudentItem(
            title: i,
          );
        }).toList();
      } else {
        print("else+++++++++++++");
      }
    } catch (e) {
      print(e);

      print(e.toString().contains("Failed host lookup"));
      if (e.toString().contains("Failed host lookup")) {
        print(e);
        print("inside if");
        throw ("Please check your Internet Connection.");
      } else {
        throw (e);
      }
    }
  }
}
