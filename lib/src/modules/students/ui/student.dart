import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/modules/students/models/models/records.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../studentmodal.dart';

// ignore: must_be_immutable

class StudentPage extends StatefulWidget {
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  static const double _kLableSpacing = 10.0;

  StudentBloc _bloc = StudentBloc();
  List<Records>? obj;

  @override
  void initState() {
    super.initState();
    _bloc.add(StudentPageEvent());
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildGrid(int crossaAxisCount, int itemlen, object) {
    return GridView.count(
      crossAxisCount: crossaAxisCount,
      crossAxisSpacing: _kLableSpacing,
      mainAxisSpacing: _kLableSpacing,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: List.generate(
        itemlen,
        (index) {
          return InkWell(
              onTap: () => _launchURL(object[index].appUrlC),
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: object[index].appIconC,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Text("${obj![index].titleC}"),
                ],
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        Container(),
        BlocListener<StudentBloc, StudentState>(
          bloc: _bloc,
          listener: (context, state) async {
            if (state is StudentDataSucess) {
              obj = state.obj;
              setState(() {});
            }
          },
          child: Container(
            height: 0,
          ),
        ),
        obj != null ? _buildGrid(3, obj!.length, obj) : Text(""),
      ]),
    ));
  }
}
