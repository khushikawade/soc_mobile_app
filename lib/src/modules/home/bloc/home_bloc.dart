import 'dart:async';
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
        var data = await fetchBottomNavigationBar();

        yield BottomNavigationBarSuccess(obj: data);
      } catch (e) {
        yield HomeErrorReceived(err: e);
      }
    }
    if (event is GlobalSearchEvent) {
      try {
        yield SearchLoading();
        var data = await getGlobalSearch(event.keyword);

        yield GlobalSearchSuccess(obj: data);
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

  Future getGlobalSearch(keyword) async {
    try {
      final ResponseModel response = await _dbServices.getapi(
        Uri.encodeFull('search/?q=$keyword'),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
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
}
