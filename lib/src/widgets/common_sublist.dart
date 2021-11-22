import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/about/bloc/about_bloc.dart';
import 'package:Soc/src/modules/about/modal/about_sublist.dart';
import 'package:Soc/src/modules/about/modal/aboutstafflist.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/families/modal/family_sublist.dart';
import 'package:Soc/src/modules/resources/bloc/resources_bloc.dart';
import 'package:Soc/src/modules/resources/modal/resources_sublist.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/modules/staff/models/staff_sublist.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubListPage extends StatefulWidget {
  final obj;
  final String? module;
  final bool isbuttomsheet;
  final String appBarTitle;
  final String? language;

  SubListPage(
      {Key? key,
      required this.obj,
      required this.module,
      required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language})
      : super(key: key);
  @override
  _SubListPageState createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage> {
  FocusNode myFocusNode = new FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ResourcesBloc _resourceBloc = ResourcesBloc();
  FamilyBloc _bloc = FamilyBloc();
  StaffBloc _staffBloc = StaffBloc();
  AboutBloc _aboutBloc = AboutBloc();
  List<FamiliesSubList> familyList = [];
  List<StaffSubList> staffList = [];
  List<ResourcesSubList> resourceList = [];
  List<AboutSubList> aboutList = [];

  @override
  void initState() {
    super.initState();
    if (widget.module == "family") {
      _bloc.add(FamiliesSublistEvent(id: widget.obj.id));
    } else if (widget.module == "staff") {
      _staffBloc.add(StaffSubListEvent(id: widget.obj.id));
    } else if (widget.module == "resources") {
      _resourceBloc.add(ResourcesSublistEvent(id: widget.obj.id));
    } else if (widget.module == "about") {
      _aboutBloc.add(AboutSublistEvent(id: widget.obj.id));
    }
  }

  _route(obj, index) {
    if (obj.typeC == "URL") {
      obj.appUrlC != null
          ? _launchURL(obj)
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "RFT_HTML" ||
        obj.typeC == "RTF/HTML" ||
        obj.typeC == "HTML/RTF") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        isbuttomsheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "Embed iFrame") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        isiFrame: true,
                        title: obj.titleC!,
                        url: obj.rtfHTMLC.toString(),
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "PDF") {
      obj.pdfURL != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CommonPdfViewerPage(
                        url: obj.pdfURL,
                        tittle: obj.titleC,
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
    } else {}
  }

  _launchURL(obj) async {
    if (obj.appUrlC.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title:
                        obj.titleC, //?? widget.obj.headings["en"].toString(),
                    url: obj.appUrlC,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  Widget _buildList(list, obj, int index) {
    return obj.status == null || obj.status == 'Show'
        ? GestureDetector(
            onTap: () {
              _route(obj, index);
            },
            child: Container(
                decoration: BoxDecoration(
                  border: (index % 2 == 0)
                      ? Border.all(
                          color: Theme.of(context).colorScheme.secondary)
                      : Border.all(
                          color: Theme.of(context).colorScheme.background),
                  borderRadius: BorderRadius.circular(0.0),
                  color: (index % 2 == 0)
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.background,
                ),
                child: Container(
                  child: ListTile(
                    leading: CustomIconWidget(
                      iconUrl: obj.appIconUrlC ?? Overrides.defaultIconUrl,
                    ),
                    title: TranslationWidget(
                      message: obj.titleC.toString(),
                      fromLanguage: "en",
                      toLanguage: Globals.selectedLanguage,
                      builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  ),
                ))) //ListWidget(index, _buildFormName(index, obj), obj))
        : Container();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(
        isSearch: true,
        isShare: false,
        appBarTitle: widget.appBarTitle,
        sharedpopBodytext: '',
        sharedpopUpheaderText: '',
        language: Globals.selectedLanguage,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          widget.module == "family"
              ? BlocBuilder<FamilyBloc, FamilyState>(
                  bloc: _bloc,
                  builder: (BuildContext contxt, FamilyState state) {
                    if (state is FamilyInitial || state is FamilyLoading) {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator());
                    } else if (state is FamiliesSublistSucess) {
                      return familyList.length > 0
                          ? Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(bottom: 45),
                                itemCount: familyList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildList(
                                      familyList, familyList[index], index
                                      //   _buildFormName(index, resourceList[index]),
                                      //  resourceList[index]
                                      );
                                },
                              ),
                            )
                          : Expanded(
                              child: NoDataFoundErrorWidget(
                                isResultNotFoundMsg: false,
                                isNews: false,
                                isEvents: false,
                              ),
                            );
                    } else {
                      return Container();
                    }
                  })
              : widget.module == 'staff'
                  ? BlocBuilder<StaffBloc, StaffState>(
                      bloc: _staffBloc,
                      builder: (BuildContext contxt, StaffState state) {
                        if (state is StaffInitial || state is StaffLoading) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.75,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator());
                        } else if (state is StaffSubListSucess) {
                          return staffList.length > 0
                              ? Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.only(bottom: 45),
                                    itemCount: staffList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _buildList(
                                          staffList, staffList[index], index
                                          //   _buildFormName(index, resourceList[index]),
                                          //  resourceList[index]
                                          );
                                    },
                                  ),
                                )
                              : NoDataFoundErrorWidget(
                                  isResultNotFoundMsg: false,
                                  isNews: false,
                                  isEvents: false,
                                );
                        } else {
                          return Container();
                        }
                      })
                  : widget.module == "resources"
                      ? BlocBuilder<ResourcesBloc, ResourcesState>(
                          bloc: _resourceBloc,
                          builder: (BuildContext contxt, ResourcesState state) {
                            if (state is ResourcesInitial ||
                                state is ResourcesLoading) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator());
                            } else if (state is ResourcesSubListSucess) {
                              return resourceList.length > 0
                                  ? Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(bottom: 45),
                                        itemCount: resourceList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _buildList(resourceList,
                                              resourceList[index], index
                                              //   _buildFormName(index, resourceList[index]),
                                              //  resourceList[index]
                                              );
                                        },
                                      ),
                                    )
                                  : Expanded(
                                      child: NoDataFoundErrorWidget(
                                        isResultNotFoundMsg: false,
                                        isNews: false,
                                        isEvents: false,
                                      ),
                                    );
                            } else {
                              return Container();
                            }
                          })
                      : widget.module == "about"
                          ? BlocBuilder<AboutBloc, AboutState>(
                              bloc: _aboutBloc,
                              builder: (BuildContext contxt, AboutState state) {
                                if (state is AboutInitial ||
                                    state is AboutLoading) {
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.75,
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator());
                                } else if (state is AboutSublistSucess) {
                                  return aboutList.length > 0
                                      ? Expanded(
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            padding:
                                                EdgeInsets.only(bottom: 45),
                                            itemCount: aboutList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return _buildList(aboutList,
                                                  aboutList[index], index
                                                  //   _buildFormName(index, resourceList[index]),
                                                  //  resourceList[index]
                                                  );
                                            },
                                          ),
                                        )
                                      : Expanded(
                                          child: NoDataFoundErrorWidget(
                                            isResultNotFoundMsg: false,
                                            isNews: false,
                                            isEvents: false,
                                          ),
                                        );
                                } else {
                                  return Container();
                                }
                              })
                          : Expanded(
                              child: NoDataFoundErrorWidget(
                                isResultNotFoundMsg: false,
                                isNews: false,
                                isEvents: false,
                              ),
                            ),
          BlocListener<FamilyBloc, FamilyState>(
              bloc: _bloc,
              listener: (context, state) async {
                if (state is FamiliesSublistSucess) {
                  familyList.clear();
                  for (int i = 0; i < state.obj!.length; i++) {
                    if (state.obj![i].status != "Hide") {
                      familyList.add(state.obj![i]);
                    }
                  }
                }
              },
              child: EmptyContainer()),
          BlocListener<StaffBloc, StaffState>(
              bloc: _staffBloc,
              listener: (context, state) async {
                if (state is StaffSubListSucess) {
                  staffList.clear();
                  for (int i = 0; i < state.obj!.length; i++) {
                    if (state.obj![i].status != "Hide") {
                      staffList.add(state.obj![i]);
                    }
                  }
                }
              },
              child: EmptyContainer()),
          BlocListener<ResourcesBloc, ResourcesState>(
              bloc: _resourceBloc,
              listener: (context, state) async {
                if (state is ResourcesSubListSucess) {
                  resourceList.clear();
                  for (int i = 0; i < state.obj!.length; i++) {
                    if (state.obj![i].status != "Hide") {
                      resourceList.add(state.obj![i]);
                    }
                  }
                }
              },
              child: EmptyContainer()),
          BlocListener<AboutBloc, AboutState>(
              bloc: _aboutBloc,
              listener: (context, state) async {
                if (state is AboutSublistSucess) {
                  resourceList.clear();
                  for (int i = 0; i < state.obj!.length; i++) {
                    if (state.obj![i].status != "Hide") {
                      aboutList.add(state.obj![i]);
                    }
                  }
                }
              },
              child: EmptyContainer()),
        ],
      ),
    );
  }
}
