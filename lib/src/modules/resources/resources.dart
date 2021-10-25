import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';

class Resources extends StatefulWidget {
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  static const double _kIconSize = 45.0;
  static const double _kLabelSpacing = 20.0;
  final HomeBloc _homeBloc = new HomeBloc();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildNewsDescription() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 30.0),
      children: [
        
      ]
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 1.5),
      child: RefreshIndicator(
        key: refreshKey,
        child: _buildNewsDescription(),
        onRefresh: refreshPage,
      ),
    ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
