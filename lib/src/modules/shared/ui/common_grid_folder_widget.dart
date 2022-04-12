import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/custom_image_widget_small.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import '../../../widgets/no_data_found_error_widget.dart';
import '../../about/bloc/about_bloc.dart';
import '../../custom/bloc/custom_bloc.dart';
import '../../families/bloc/family_bloc.dart';
import '../../resources/bloc/resources_bloc.dart';
import '../../staff/bloc/staff_bloc.dart';
import '../models/shared_list.dart';

// ignore: must_be_immutable
class CommonGridFolder extends StatefulWidget {
  SharedList obj;
  // final String folderName;
  final String? sectionName;
  @override
  CommonGridFolder(
      {Key? key,
      required this.obj,
      // required this.folderName,
      this.sectionName})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => CommonGridFolderState();
}

class CommonGridFolderState extends State<CommonGridFolder>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  static const double _kLableSpacing = 10.0;
  // List subList = [];

  FamilyBloc _familyBloc = FamilyBloc();
  StaffBloc _staffBloc = StaffBloc();
  AboutBloc _aboutBloc = AboutBloc();
  CustomBloc _customBloc = CustomBloc();
  ResourcesBloc _resourceBloc = ResourcesBloc();
  // bool? isLoading=true;
  @override
  void initState() {
    super.initState();
    if (widget.sectionName == "family") {
      _familyBloc.add(FamiliesSublistEvent(id: widget.obj.id));
    } else if (widget.sectionName == "staff") {
      _staffBloc.add(StaffSubListEvent(id: widget.obj.id));
    } else if (widget.sectionName == "resources") {
      _resourceBloc.add(ResourcesSublistEvent(id: widget.obj.id));
    } else if (widget.sectionName == "about") {
      _aboutBloc.add(AboutSublistEvent(id: widget.obj.id));
    } else if (widget.sectionName == "Custom") {
      _customBloc.add(CustomSublistEvent(id: widget.obj.id));
    }
// subList.addAll(widget.obj);
    // for (int i = 0; i < widget.obj.length; i++) {
    //   if (widget.obj[i].appFolderc != null &&
    //       widget.obj[i].appFolderc == widget.folderName) {
    //     subList.add(widget.obj[i]);
    //   }
    // }

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _launchURL(obj) async {
    if (obj.deepLinkC == 'NO') {
      if (obj.appUrlC!.toString().split(":")[0] == 'http') {
        await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => InAppUrlLauncer(
                      title: obj.titleC!,
                      url: obj.appUrlC!,
                      isbuttomsheet: true,
                      language: Globals.selectedLanguage,
                    )));
      }
    } else {
      await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        // elevation: 99,
        // shadowColor: Colors.red,
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            margin: const EdgeInsets.only(
                top: 20, left: 20.0, right: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                // backgroundColor: Colors.white,
                body:
                    //    isLoading==true?Container(
                    // alignment: Alignment.center,
                    // child: CircularProgressIndicator(
                    //   color: Theme.of(context).colorScheme.primaryVariant,
                    // )):
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20.0, right: 20, bottom: 20),
                        child:
                            // subList.length > 0
                            //     ?
                            ListView(
                          shrinkWrap: true,
                          children: [
                            widget.sectionName == 'Custom'
                                ? BlocBuilder<CustomBloc, CustomState>(
                                    bloc: _customBloc,
                                    builder: (BuildContext contxt,
                                        CustomState state) {
                                      if (state is CustomInitial ||
                                          state is CustomLoading) {
                                        return Container(
                                            margin: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.18),
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant,
                                            ));
                                      } else if (state
                                          is CustomSublistSuccess) {
                                        return state.obj != null &&
                                                state.obj!.length > 0
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: buildGrid(state.obj))
                                            :
                                            // ListView(children: [
                                            NoDataFoundErrorWidget(
                                                isResultNotFoundMsg: false,
                                                isNews: false,
                                                isEvents: false,
                                                // connected: connected,
                                              );
                                        // ]);
                                      }
                                      return Container();
                                    })
                                : widget.sectionName == 'family'
                                    ? BlocBuilder<FamilyBloc, FamilyState>(
                                        bloc: _familyBloc,
                                        builder: (BuildContext contxt,
                                            FamilyState state) {
                                          if (state is CustomInitial ||
                                              state is CustomLoading) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant,
                                            ));
                                          } else if (state
                                              is FamiliesSublistSucess) {
                                            return state.obj != null &&
                                                    state.obj!.length > 0
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: buildGrid(state.obj))
                                                :
                                                // ListView(children: [
                                                NoDataFoundErrorWidget(
                                                    isResultNotFoundMsg: false,
                                                    isNews: false,
                                                    isEvents: false,
                                                    // connected: connected,
                                                  );
                                            // ]);
                                          }
                                          return Container();
                                        })
                                    : widget.sectionName == 'staff'
                                        ? BlocBuilder<StaffBloc, StaffState>(
                                            bloc: _staffBloc,
                                            builder: (BuildContext contxt,
                                                StaffState state) {
                                              if (state is CustomInitial ||
                                                  state is CustomLoading) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryVariant,
                                                ));
                                              } else if (state
                                                  is StaffSubListSucess) {
                                                return state.obj != null &&
                                                        state.obj!.length > 0
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        child: buildGrid(
                                                            state.obj))
                                                    :
                                                    // ListView(children: [
                                                    NoDataFoundErrorWidget(
                                                        isResultNotFoundMsg:
                                                            false,
                                                        isNews: false,
                                                        isEvents: false,
                                                        // connected: connected,
                                                      );
                                                // ]);
                                              }
                                              return Container();
                                            })
                                        : widget.sectionName == 'resources'
                                            ? BlocBuilder<ResourcesBloc,
                                                    ResourcesState>(
                                                bloc: _resourceBloc,
                                                builder: (BuildContext contxt,
                                                    ResourcesState state) {
                                                  if (state
                                                          is ResourcesInitial ||
                                                      state
                                                          is ResourcesLoading) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primaryVariant,
                                                    ));
                                                  } else if (state
                                                      is ResourcesSubListSucess) {
                                                    return state.obj != null &&
                                                            state.obj!.length >
                                                                0
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: buildGrid(
                                                                state.obj))
                                                        :
                                                        // ListView(children: [
                                                        NoDataFoundErrorWidget(
                                                            isResultNotFoundMsg:
                                                                false,
                                                            isNews: false,
                                                            isEvents: false,
                                                            // connected: connected,
                                                          );
                                                    // ]);
                                                  }
                                                  return Container();
                                                })
                                            : widget.sectionName == 'about'
                                                ? BlocBuilder<AboutBloc,
                                                        AboutState>(
                                                    bloc: _aboutBloc,
                                                    builder:
                                                        (BuildContext contxt,
                                                            AboutState state) {
                                                      if (state
                                                              is CustomInitial ||
                                                          state
                                                              is AboutLoading) {
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .primaryVariant,
                                                        ));
                                                      } else if (state
                                                          is AboutSublistSucess) {
                                                        return state.obj !=
                                                                    null &&
                                                                state.obj!
                                                                        .length >
                                                                    0
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                child: buildGrid(
                                                                    state.obj))
                                                            :
                                                            // ListView(children: [
                                                            NoDataFoundErrorWidget(
                                                                isResultNotFoundMsg:
                                                                    false,
                                                                isNews: false,
                                                                isEvents: false,
                                                                // connected: connected,
                                                              );
                                                        // ]);
                                                      }
                                                      return Container();
                                                    })
                                                : Expanded(
                                                    child:
                                                        NoDataFoundErrorWidget(
                                                      isResultNotFoundMsg:
                                                          false,
                                                      isNews: false,
                                                      isEvents: false,
                                                    ),
                                                  ),
                          ],
                        )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildGrid(subList) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: MediaQuery.of(context).orientation ==
                  Orientation.portrait &&
              Globals.deviceType == "phone"
          ? 3
          : (MediaQuery.of(context).orientation == Orientation.landscape &&
                  Globals.deviceType == "phone")
              ? 4
              : MediaQuery.of(context).orientation == Orientation.portrait &&
                      Globals.deviceType != "phone"
                  ? 4
                  : MediaQuery.of(context).orientation ==
                              Orientation.landscape &&
                          Globals.deviceType != "phone"
                      ? 5
                      : 3,
      crossAxisSpacing: _kLableSpacing,
      mainAxisSpacing: _kLableSpacing,
      children: List.generate(
        subList.length,
        (index) {
          return subList[index].status == null ||
                  subList[index].status == 'Show'
              ? InkWell(
                  onTap: () => _launchURL(subList[index]),
                  child: Column(
                    children: [
                      // subList[index].appIconC != null &&
                      //         subList[index].appIconC != ''
                      //  ?
                      Container(
                          height: 65,
                          width: 65,
                          child: CustomIconMode(
                              darkModeIconUrl: subList[index].darkModeIconC,
                              iconUrl: subList[index].appIconC ??
                                  Overrides.defaultIconUrl)),
                      // : Container(),
                      Container(
                          child: TranslationWidget(
                        message: subList[index] != null
                            ? "${subList[index].titleC}"
                            : '',
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) => Container(
                          child: MediaQuery.of(context).orientation ==
                                      Orientation.portrait &&
                                  translatedMessage.toString().length > 11
                              ? Expanded(
                                  child: Marquee(
                                    text: translatedMessage.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            fontSize:
                                                Globals.deviceType == "phone"
                                                    ? 16
                                                    : 24),
                                    scrollAxis: Axis.horizontal,
                                    velocity: 30.0,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    blankSpace: 50,
                                    pauseAfterRound: Duration(seconds: 5),
                                    showFadingOnlyWhenScrolling: true,
                                    startPadding: 10.0,
                                    accelerationDuration: Duration(seconds: 1),
                                    accelerationCurve: Curves.linear,
                                    decelerationDuration:
                                        Duration(milliseconds: 500),
                                    decelerationCurve: Curves.easeOut,
                                  ),
                                )
                              : MediaQuery.of(context).orientation ==
                                          Orientation.landscape &&
                                      translatedMessage.toString().length > 18
                                  ? Expanded(
                                      child: Marquee(
                                      text: translatedMessage.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize:
                                                  Globals.deviceType == "phone"
                                                      ? 16
                                                      : 24),
                                      scrollAxis: Axis.horizontal,
                                      velocity: 30.0,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      blankSpace:
                                          50, //MediaQuery.of(context).size.width
                                      // velocity: 100.0,
                                      pauseAfterRound: Duration(seconds: 5),
                                      showFadingOnlyWhenScrolling: true,
                                      startPadding: 10.0,
                                      accelerationDuration:
                                          Duration(seconds: 1),
                                      accelerationCurve: Curves.linear,
                                      decelerationDuration:
                                          Duration(milliseconds: 500),
                                      decelerationCurve: Curves.easeOut,
                                    ))
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(translatedMessage.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  fontSize:
                                                      Globals.deviceType ==
                                                              "phone"
                                                          ? 16
                                                          : 24)),
                                    ),
                        ),
                      )),
                    ],
                  ))
              : Container();
        },
      ),
    );
  }
}
