import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentPage extends StatefulWidget {
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  static const double _kLableSpacing = 10.0;

  StudentBloc _bloc = StudentBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(StudentPageEvent());
  }

  _launchURL(StudentApp obj) async {
    if (obj.deepLinkC == 'NO') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC!,
                    url: obj.appUrlC!,
                  )));
    } else {
      if (await canLaunch(obj.appUrlC!)) {
        await launch(obj.appUrlC!);
      } else {
        throw 'Could not launch ${obj.appUrlC}';
      }
    }
  }

  Widget _buildGrid(int crossaAxisCount, List<StudentApp> list) {
    return GridView.count(
      crossAxisCount: crossaAxisCount,
      crossAxisSpacing: _kLableSpacing,
      mainAxisSpacing: _kLableSpacing,
      children: List.generate(
        list.length,
        (index) {
          return InkWell(
              onTap: () => _launchURL(list[index]),
              child: Column(
                children: [
                  list[index].appIconC != null && list[index].appIconC != ''
                      ? SizedBox(
                          height: 100,
                          width: 100,
                          child: CachedNetworkImage(
                            imageUrl: list[index].appIconC ?? '',
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )
                      : Container(),
                  Text("${list[index].titleC}"),
                ],
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<StudentBloc, StudentState>(
            bloc: _bloc,
            builder: (BuildContext contxt, StudentState state) {
              if (state is StudentInitial || state is Loading) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                ));
              } else if (state is StudentDataSucess) {
                return _buildGrid(3, state.obj!);
              } else {
                return Container();
              }
            }));
  }
}
