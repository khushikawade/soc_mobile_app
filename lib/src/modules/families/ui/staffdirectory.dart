import 'dart:ui';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class StaffDirectory extends StatefulWidget {
  final obj;
  bool isbuttomsheet;
  String appBarTitle;
  String? language;
  StaffDirectory(
      {Key? key,
      required this.obj,
      required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language})
      : super(key: key);

  @override
  _StaffDirectoryState createState() => _StaffDirectoryState();
}

class _StaffDirectoryState extends State<StaffDirectory> {
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 45.0;
  final _controller = TextEditingController();
  FamilyBloc _bloc = FamilyBloc();
  UrlLauncherWidget objurl = new UrlLauncherWidget();

  @override
  void initState() {
    super.initState();
    _bloc.add(SDevent());
  }

  Widget _buildHeading(String tittle) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _kLabelSpacing * 1.2),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0,
        ),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: tittle,
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                )
              : Text(
                  tittle,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
        ],
      ),
    );
  }

  Widget contactItem(obj, index) {
    return InkWell(
        onTap: () {},
        child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 1.5),
            padding: EdgeInsets.symmetric(
                horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 1.5),
            decoration: BoxDecoration(
              border: (index % 2 == 0)
                  ? Border.all(
                      color: Theme.of(context).colorScheme.background,
                    )
                  : Border.all(color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(0.0),
              color: (index % 2 == 0)
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.secondary,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  obj.imageUrlC != null && obj.imageUrlC.length > 0
                      ? Center(
                          child: CachedNetworkImage(
                            imageUrl: obj.imageUrlC,
                            fit: BoxFit.fill,
                            width: 60,
                            height: 60,
                            placeholder: (context, url) => Container(
                                alignment: Alignment.center,
                                child: ShimmerLoading(
                                  isLoading: true,
                                  child: Container(
                                    width: _kIconSize * 1.4,
                                    height: _kIconSize * 1.5,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        )
                      : Center(
                          child: Container(
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: Globals.homeObjet["App_Logo__c"],
                              placeholder: (context, url) => Container(
                                  alignment: Alignment.center,
                                  child: ShimmerLoading(
                                    isLoading: true,
                                    child: Container(
                                      width: _kIconSize * 1.4,
                                      height: _kIconSize * 1.5,
                                      color: Colors.white,
                                    ),
                                  )),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        )),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Globals.selectedLanguage != null &&
                              Globals.selectedLanguage != "English"
                          ? TranslationWidget(
                              message: obj.titleC ?? "-",
                              toLanguage: Globals.selectedLanguage,
                              fromLanguage: "en",
                              builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w400)),
                            )
                          : Text(obj.titleC ?? "-",
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400)),
                      SpacerWidget(_kLabelSpacing),
                      Globals.selectedLanguage != null &&
                              Globals.selectedLanguage != "English"
                          ? TranslationWidget(
                              message: obj.descriptionC ?? "-",
                              toLanguage: Globals.selectedLanguage,
                              fromLanguage: "en",
                              builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w400)))
                          : Text(obj.descriptionC ?? "-",
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400)),
                      SpacerWidget(_kLabelSpacing),
                      InkWell(
                        onTap: () {
                          if (obj.emailC != null) {
                            objurl.callurlLaucher(
                                context, 'mailto:"${obj.emailC}"');
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: Globals.deviceType == "phone" ? 14 : 22,
                            ),
                            HorzitalSpacerWidget(_kLabelSpacing / 2),
                            Expanded(
                              child: Text(
                                obj.emailC ?? "-",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SpacerWidget(_kLabelSpacing / 2),
                      InkWell(
                        onTap: () {
                          if (obj.phoneC != null) {
                            objurl.callurlLaucher(context, "tel:" + obj.phoneC);
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_phone,
                              size: Globals.deviceType == "phone" ? 14 : 22,
                            ),
                            HorzitalSpacerWidget(_kLabelSpacing / 2),
                            Expanded(
                              child: Text(
                                obj.phoneC ?? "-",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ))
                ])));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        appBarTitle: widget.appBarTitle,
        isSearch: true,
        sharedpopBodytext: '',
        sharedpopUpheaderText: '',
        isShare: false,
        isCenterIcon: true,
        language: Globals.selectedLanguage,
      ),
      body: SafeArea(
        child: BlocBuilder<FamilyBloc, FamilyState>(
            bloc: _bloc,
            builder: (BuildContext contxt, FamilyState state) {
              if (state is FamilyInitial || state is FamilyLoading) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              } else if (state is SDDataSucess) {
                return Column(
                  children: [
                    _buildHeading("STAFF DIRECTORY"),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: state.obj!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return contactItem(state.obj![index], index);
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is ErrorLoading) {
                return Globals.selectedLanguage != null &&
                        Globals.selectedLanguage != "English"
                    ? Center(
                        child: TranslationWidget(
                            message: "Unable to load the data",
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                )),
                      )
                    : Center(child: Text("Unable to load the data"));
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
