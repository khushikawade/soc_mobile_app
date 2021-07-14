import 'dart:async';
import 'package:Soc/src/modules/social/modal/models/item.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xml2json/xml2json.dart';
import '../../../overrides.dart' as overrides;
import 'dart:convert';
import 'package:http/http.dart' as http;
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  var data;
  HomeBloc() : super(HomeInitial());
  final DbServices _dbServices = DbServices();
  @override
  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is FetchBottomNavigationBar) {
      try {
        yield HomeLoading();
        await fetchBottomNavigationBar();

        yield BottomNavigationBarSuccess();
      } catch (e) {
        yield HomeErrorReceived(err: e);
      }
    }
  }

  Future fetchBottomNavigationBar() async {
    try {
      // var link = Uri.parse("${overrides.Overrides.socialPagexmlUrl}");

      final ResponseModel response = await _dbServices.getapi(
        Uri.encodeFull(
            'q=SELECT Title__c,App_Icon__c,App_URL__c,Deep_Link__c,Id,Name FROM Student_App__cwhere School_App__c = a1T3J000000RHEKUA4'),
      );
      final data = response.data;
      print(data);
      if (response.statusCode == 200) {
        print("statusCode 200 ***********");
        return true;
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
