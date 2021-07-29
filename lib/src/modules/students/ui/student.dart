import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/modules/students/ui/apps_folder.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentPage extends StatefulWidget {
  var homeObj;
  StudentPage({Key? key, this.homeObj}) : super(key: key);
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  static const double _kLableSpacing = 10.0;

  StudentBloc _bloc = StudentBloc();

  @override
  void initState() {
    super.initState();

    super.initState();
    _bloc.add(StudentPageEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  _launchURL(StudentApp obj, subList) async {
    if (obj.appUrlC == 'app_folder') {
      showDialog(
        context: context,
        builder: (_) => AppsFolderPage(obj: subList, folderName: obj.titleC!),
      );
    } else {
      if (obj.deepLinkC == 'NO') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => InAppUrlLauncer(
                      title: obj.titleC!,
                      url: obj.appUrlC!,
                      isbuttomsheet: true,
                    )));
      } else {
        if (await canLaunch(obj.appUrlC!)) {
          await launch(obj.appUrlC!);
        } else {
          throw 'Could not launch ${obj.appUrlC}';
        }
      }
    }
  }

  Widget _buildGrid(
      int crossaAxisCount, List<StudentApp> list, List<StudentApp> subList) {
    return list.length > 0
        ? GridView.count(
            crossAxisCount: crossaAxisCount,
            crossAxisSpacing: _kLableSpacing,
            mainAxisSpacing: _kLableSpacing,
            children: List.generate(
              list.length,
              (index) {
                return InkWell(
                    onTap: () => _launchURL(list[index], subList),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        list[index].appIconC != null &&
                                list[index].appIconC != ''
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
                        Expanded(
                            child: Text(
                          "${list[index].titleC}",
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ));
              },
            ),
          )
        : Container(child: Text("No apps available here"));
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
                return state.obj != null && state.obj!.length > 0
                    ? _buildGrid(3, state.obj!, state.subFolder!)
                    : Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Text("No data found"),
                      );
              } else if (state is StudentError) {
                return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Text("Unable to load the data"),
                );
              } else {
                return Container();
              }
            }));
  }
}
