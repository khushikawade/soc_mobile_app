import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/modules/students/ui/apps_folder.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/error_icon_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:Soc/src/widgets/no_internet_icon.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentPage extends StatefulWidget {
  final homeObj;

  StudentPage({Key? key, this.homeObj}) : super(key: key);
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  static const double _kLableSpacing = 10.0;
  int? gridLength;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();

  StudentBloc _bloc = StudentBloc();

  @override
  void initState() {
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
                      language: Globals.selectedLanguage,
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

  Widget _buildGrid(List<StudentApp> list, List<StudentApp> subList) {
    return list.length > 0
        ? new OrientationBuilder(builder: (context, orientation) {
            return GridView.count(
              childAspectRatio: orientation == Orientation.portrait ? 1 : 3 / 2,
              crossAxisCount: orientation == Orientation.portrait &&
                      Globals.deviceType == "phone"
                  ? 3
                  : (orientation == Orientation.landscape &&
                          Globals.deviceType == "phone")
                      ? 4
                      : orientation == Orientation.portrait &&
                              Globals.deviceType != "phone"
                          ? 4
                          : orientation == Orientation.landscape &&
                                  Globals.deviceType != "phone"
                              ? 5
                              : 3,
              crossAxisSpacing: _kLableSpacing * 1.2,
              mainAxisSpacing: _kLableSpacing * 1.2,
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
                                    placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        child: ShimmerLoading(
                                          isLoading: true,
                                          child: Container(
                                            color: Colors.white,
                                          ),
                                        )),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                )
                              : Container(),
                          Expanded(
                              child: Globals.selectedLanguage != null &&
                                      Globals.selectedLanguage != "English"
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: _kLableSpacing / 2),
                                      child: TranslationWidget(
                                        message: "${list[index].titleC}",
                                        fromLanguage: "en",
                                        toLanguage: Globals.selectedLanguage,
                                        builder: (translatedMessage) => Text(
                                          translatedMessage.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: _kLableSpacing / 2),
                                      child: Text(
                                        "${list[index].titleC}",
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                        ],
                      ));
                },
              ),
            );
          })
        : Center(
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: "No apps available here",
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Center(child: Text("No apps available here")),
          );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(StudentPageEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          refresh: (v) {
            setState(() {});
          },
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<StudentBloc, StudentState>(
                    bloc: _bloc,
                    builder: (BuildContext contxt, StudentState state) {
                      if (state is StudentInitial || state is Loading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is StudentDataSucess) {
                        return state.obj != null && state.obj!.length > 0
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    bottom: _kLableSpacing / 2),
                                child: _buildGrid(state.obj!, state.subFolder!),
                              )
                            : Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Globals.selectedLanguage != null &&
                                        Globals.selectedLanguage != "English"
                                    ? TranslationWidget(
                                        message: "No data found",
                                        fromLanguage: "en",
                                        toLanguage: Globals.selectedLanguage,
                                        builder: (translatedMessage) => Text(
                                          translatedMessage.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Center(child: Text("No data found")),
                              );
                      } else if (state is StudentError) {
                        if (state.err == "NO_CONNECTION") {
                          return ListView(shrinkWrap: true, children: [
                            SizedBox(
                              child: NoInternetIconWidget(),
                            ),
                            SpacerWidget(12),
                            Globals.selectedLanguage != null &&
                                    Globals.selectedLanguage != "English"
                                ? TranslationWidget(
                                    message: "No internet connection",
                                    toLanguage: Globals.selectedLanguage,
                                    fromLanguage: "en",
                                    builder: (translatedMessage) => Text(
                                      translatedMessage.toString(),
                                    ),
                                  )
                                : Text("No internet connection"),
                          ]);
                        } else if (state.err == "Something went wrong") {
                          return ListView(shrinkWrap: true, children: [
                            ErrorMessageWidget(
                              imgURL: 'assets/images/no_data_icon.png',
                              msg: "No data found",
                            ),
                            // SpacerWidget(12),
                            // Globals.selectedLanguage != null &&
                            //         Globals.selectedLanguage != "English"
                            //     ? TranslationWidget(
                            //         message: "No  data found",
                            //         toLanguage: Globals.selectedLanguage,
                            //         fromLanguage: "en",
                            //         builder: (translatedMessage) => Text(
                            //           translatedMessage.toString(),
                            //         ),
                            //       )
                            //     : Text("No data found"),
                          ]);
                        } else {
                          return ListView(shrinkWrap: true, children: [
                            SizedBox(child: ErrorIconWidget()),
                            Globals.selectedLanguage != null &&
                                    Globals.selectedLanguage != "English"
                                ? TranslationWidget(
                                    message: "Error",
                                    toLanguage: Globals.selectedLanguage,
                                    fromLanguage: "en",
                                    builder: (translatedMessage) => Text(
                                      translatedMessage.toString(),
                                    ),
                                  )
                                : Text("Error"),
                          ]);
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
              BlocListener<HomeBloc, HomeState>(
                bloc: _homeBloc,
                listener: (context, state) async {
                  if (state is BottomNavigationBarSuccess) {
                    AppTheme.setDynamicTheme(Globals.appSetting, context);
                    Globals.homeObjet = state.obj;
                    setState(() {});
                  } else if (state is HomeErrorReceived) {
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(child: Text("Unable to load the data")),
                    );
                  }
                },
                child: Container(
                  height: 0,
                  width: 0,
                ),
              ),
            ],
          ),
          onRefresh: refreshPage,
        ));
  }
}
