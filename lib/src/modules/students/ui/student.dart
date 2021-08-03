import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/modules/students/ui/apps_folder.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentPage extends StatefulWidget {
  final homeObj;
  String? language;
  StudentPage({Key? key, this.homeObj, this.language}) : super(key: key);
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
        builder: (_) => AppsFolderPage(
          obj: subList,
          folderName: obj.titleC!,
          language: widget.language,
        ),
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
                      language: widget.language,
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
        ? new OrientationBuilder(builder: (context, orientation) {
            return GridView.count(
              childAspectRatio: orientation == Orientation.portrait ? 1 : 3 / 2,
              crossAxisCount: crossaAxisCount,
              crossAxisSpacing: _kLableSpacing,
              mainAxisSpacing: _kLableSpacing,
              children: List.generate(
                list.length,
                (index) {
                  return InkWell(
                      onTap: () => _launchURL(list[index], subList),
                      child: Column(
                        children: [
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
                              child: widget.language != null &&
                                      widget.language != "English"
                                  ? TranslationWidget(
                                      message: "${list[index].titleC}",
                                      fromLanguage: "en",
                                      toLanguage: widget.language,
                                      builder: (translatedMessage) => Text(
                                        translatedMessage.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Text(
                                      "${list[index].titleC}",
                                      textAlign: TextAlign.center,
                                    )),
                        ],
                      ));
                },
              ),
            );
          })
        : Container(
            child: widget.language != null && widget.language != "English"
                ? TranslationWidget(
                    message: "No apps available here",
                    fromLanguage: "en",
                    toLanguage: widget.language,
                    builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Text("No apps available here"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
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
                        child: widget.language != null &&
                                widget.language != "English"
                            ? TranslationWidget(
                                message: "No data found",
                                fromLanguage: "en",
                                toLanguage: widget.language,
                                builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Text("No data found"),
                      );
              } else if (state is StudentError) {
                return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: widget.language != null && widget.language != "English"
                      ? TranslationWidget(
                          message: "Unable to load the data",
                          fromLanguage: "en",
                          toLanguage: widget.language,
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Text("Unable to load the data"),
                );
              } else {
                return Container();
              }
            }));
  }
}
