import 'dart:ui';
import 'package:Soc/src/Globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class StaffDirectory extends StatefulWidget {
  var obj;
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
  var _controller = TextEditingController();
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
        color: AppTheme.kOnPrimaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.language != null && widget.language != "English"
              ? TranslationWidget(
                  message: tittle,
                  toLanguage: widget.language,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: AppTheme.kFontColor2,
                        ),
                  ),
                )
              : Text(
                  tittle,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: AppTheme.kFontColor2,
                      ),
                ),
        ],
      ),
    );
  }

  Widget _buildSearchbar() {
    return SizedBox(
        height: 50,
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
            color: AppTheme.kFieldbackgroundColor,
            child: TextFormField(
              controller: _controller,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Search School App',
                contentPadding: EdgeInsets.symmetric(
                  vertical: _kLabelSpacing / 2,
                ),
                filled: true,
                fillColor: AppTheme.kBackgroundColor,
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  const IconData(0xe805,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  size: Globals.deviceType == "phone" ? 20 : 28,
                  color: AppTheme.kprefixIconColor,
                ),
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: AppTheme.kIconColor,
                    size: Globals.deviceType == "phone" ? 18 : 24,
                  ),
                ),
              ),
            )));
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
                  ? Border.all(color: AppTheme.ListColor2)
                  : Border.all(color: Theme.of(context).backgroundColor),
              borderRadius: BorderRadius.circular(0.0),
              color: (index % 2 == 0)
                  ? AppTheme.ListColor2
                  : Theme.of(context).backgroundColor,
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
                              placeholder: (context, url) => SizedBox(
                                  height: 5,
                                  width: 5,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                    ),
                                  ))),
                        )
                      : Center(
                          child: Container(
                              child: Image.asset(
                            'assets/images/appicon.png',
                            fit: BoxFit.fill,
                            height: 60,
                            width: 60,
                          )),
                        ),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      widget.language != null && widget.language != "English"
                          ? TranslationWidget(
                              message: obj.titleC ?? "-",
                              toLanguage: widget.language,
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
                      widget.language != null && widget.language != "English"
                          ? TranslationWidget(
                              message: obj.descriptionC ?? "-",
                              toLanguage: widget.language,
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
                          obj.emailC != null
                              ? objurl.callurlLaucher(
                                  context, 'mailto:"${obj.emailC}"')
                              : print("No email found");
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
                          obj.phoneC != null
                              ? objurl.callurlLaucher(
                                  context, "tel:" + obj.phoneC)
                              : print("No telephone number found");
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
          language: widget.language,
        ),
        body: ListView(children: [
          SafeArea(
            child: BlocBuilder<FamilyBloc, FamilyState>(
                bloc: _bloc,
                builder: (BuildContext contxt, FamilyState state) {
                  if (state is FamilyInitial || state is FamilyLoading) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).accentColor,
                        )));
                  } else if (state is SDDataSucess) {
                    return Column(
                      children: [
                        _buildHeading("STAFF DIRECTORY"),
                        Container(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.obj!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return contactItem(state.obj![index], index);
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is ErrorLoading) {
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: widget.language != null &&
                              widget.language != "English"
                          ? TranslationWidget(
                              message: "Unable to load the data",
                              toLanguage: widget.language,
                              fromLanguage: "en",
                              builder: (translatedMessage) => Text(
                                translatedMessage.toString(),
                              ),
                            )
                          : Text("Unable to load the data"),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ]),
        bottomNavigationBar: widget.isbuttomsheet && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }
}
