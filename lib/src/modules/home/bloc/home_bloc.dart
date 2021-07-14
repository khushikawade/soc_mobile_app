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
        var data = await fetchBottomNavigationBar();

        yield BottomNavigationBarSuccess(obj: data);
      } catch (e) {
        yield HomeErrorReceived(err: e);
      }
    }
  }

  Future fetchBottomNavigationBar() async {
    try {
      // var link = Uri.parse("${overrides.Overrides.socialPagexmlUrl}");

      final ResponseModel response = await _dbServices.getapi(
        Uri.encodeFull('sobjects/School_App__c/a1T3J000000RHEKUA4'),
      );

      if (response.statusCode == 200) {
        print("statusCode 200 ***********");
        final data = response.data;
        print(data);
        return data;
      } else {
        print("else+++++++++++++");
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
