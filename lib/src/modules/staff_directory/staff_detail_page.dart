import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/button_widget.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class AboutSDDetailPage extends StatefulWidget {
  final obj;
  AboutSDDetailPage({
    Key? key,
    required this.obj,
  }) : super(key: key);

  @override
  _AboutSDDetailPageState createState() => _AboutSDDetailPageState();
}

class _AboutSDDetailPageState extends State<AboutSDDetailPage> {
  static const double _kLabelSpacing = 16.0;
  // static const double _kIconSize = 48.0;
  // bool issuccesstate = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  // UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final HomeBloc homebloc = new HomeBloc();
  bool? isErrorState = false;
  static const double _kboxborderwidth = 0.75;
  bool? isloadingstate = false;

  Widget _sdImage() {
    return Container(
        child: CommonImageWidget(
      darkModeIconUrl: widget.obj.darkModeIconC,
      iconUrl: widget.obj!.imageUrlC ??
          Globals.splashImageUrl ??
          Globals.appSetting.appLogoC,
      height: Utility.displayHeight(context) *
          (AppTheme.kDetailPageImageHeightFactor / 100),
      fitMethod: BoxFit.fitHeight,
      isOnTap: true,
    ));
  }

  Widget _buildTitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: TranslationWidget(
        message:
            widget.obj!.designation != 'null' && widget.obj!.designation != null
                ? widget.obj!.designation
                : "",
        toLanguage: Globals.selectedLanguage,
        fromLanguage: "en",
        builder: (translatedMessage) => Text(
          translatedMessage.toString(),
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  Widget _buildNameWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        child: TranslationWidget(
          message: widget.obj!.name ?? "",
          toLanguage: Globals.selectedLanguage,
          fromLanguage: "en",
          builder: (translatedMessage) => Text(
            translatedMessage.toString(),
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ));
  }

  Widget _buildDescriptionWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        // TODO: Replace text with HTML // text: widget.obj!.descriptionC ?? "",
        child: TranslationWidget(
            message: widget.obj!.descriptionC ?? "",
            toLanguage: Globals.selectedLanguage,
            fromLanguage: "en",
            builder: (translatedMessage) => Linkify(
                  onOpen: (link) =>
                      Utility.launchUrlOnExternalBrowser(link.url),
                  options: LinkifyOptions(humanize: false),
                  linkStyle: TextStyle(color: Colors.blue),
                  text: translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                  // )
                )));
  }

  Widget _buildPhoneWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            border: Border.all(
              width: _kboxborderwidth,
              color: AppTheme.kTxtfieldBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
          child: Row(
            children: [
              TranslationWidget(
                message: "Phone :",
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              HorizontalSpacerWidget(_kLabelSpacing / 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: InkWell(
                  onTap: () {
                    Utility.launchUrlOnExternalBrowser(
                        "tel:" + widget.obj!.phoneC);
                  },
                  child: Text(
                    widget.obj!.phoneC ?? "",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                      fontSize: Globals.deviceType == "phone"
                          ? AppTheme.kBodyText1FontSize
                          : AppTheme.kBodyText1FontSize + AppTheme.kSize,
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto Regular',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
              border: Border.all(
                width: _kboxborderwidth,
                color: AppTheme.kTxtfieldBorderColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Globals.selectedLanguage != null &&
                        Globals.selectedLanguage != "English" &&
                        Globals.selectedLanguage != ""
                    ? TranslationWidget(
                        message: "Email :",
                        toLanguage: Globals.selectedLanguage,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      )
                    : Text(
                        "Email : ",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                HorizontalSpacerWidget(_kLabelSpacing / 2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: InkWell(
                    onTap: () {
                      Utility.launchUrlOnExternalBrowser(
                          "mailto:" + widget.obj!.emailC);
                    },
                    child: Text(
                      widget.obj!.emailC ?? '-',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        fontSize: Globals.deviceType == "phone"
                            ? AppTheme.kBodyText1FontSize
                            : AppTheme.kBodyText1FontSize + AppTheme.kSize,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Roboto Regular',
                        height: 1.5,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildItem() {
    return ListView(padding: const EdgeInsets.only(bottom: 35.0), children: [
      SpacerWidget(_kLabelSpacing / 1.5),
      _buildNameWidget(),
      SpacerWidget(_kLabelSpacing),
      _sdImage(),
      SpacerWidget(_kLabelSpacing),
      _buildTitleWidget(),
      SpacerWidget(_kLabelSpacing),
      _buildDescriptionWidget(),
      widget.obj!.phoneC != null && widget.obj!.phoneC != ""
          ? Padding(
              padding: const EdgeInsets.only(top: _kLabelSpacing / 1.25),
              child: _buildPhoneWidget(),
            )
          : Container(),
      widget.obj!.emailC != null && widget.obj!.emailC != ""
          ? Padding(
              padding: const EdgeInsets.only(top: _kLabelSpacing / 1.25),
              child: _buildEmailWidget(),
            )
          : Container(),
      SpacerWidget(_kLabelSpacing),
      ButtonWidget(
        title: widget.obj!.designation ?? "",
        buttonTitle: "Share",
        obj: widget.obj,
        body:
            "${widget.obj!.descriptionC != null && widget.obj!.descriptionC != "" ? widget.obj!.descriptionC.toString() : ""}" +
                "\n" +
                "${widget.obj!.imageUrlC ?? ""}" +
                "\n" +
                "${"Phone : " + widget.obj!.phoneC.toString()}" +
                // "\n" +
                "${"Email : " + widget.obj!.emailC.toString()}",
      ),
      SpacerWidget(_kLabelSpacing / 2),
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      key: refreshKey,
      child: Column(
        children: [
          Expanded(
              child: isloadingstate!
                  ? ShimmerLoading(isLoading: true, child: _buildItem())
                  : _buildItem()),
          Container(
            height: 0,
            width: 0,
            child: BlocListener<HomeBloc, HomeState>(
                bloc: homebloc,
                listener: (context, state) async {
                  if (state is HomeLoading) {
                    isloadingstate = true;
                  }
                  if (state is BottomNavigationBarSuccess) {
                    AppTheme.setDynamicTheme(Globals.appSetting, context);

                    Globals.appSetting = AppSetting.fromJson(state.obj);
                    isloadingstate = false;
                    setState(() {});
                  }
                },
                child: EmptyContainer()),
          ),
          Container(
            height: 0,
            width: 0,
            child: BlocListener<HomeBloc, HomeState>(
              bloc: homebloc,
              listener: (context, state) async {
                if (state is BottomNavigationBarSuccess) {
                  AppTheme.setDynamicTheme(Globals.appSetting, context);

                  Globals.appSetting = AppSetting.fromJson(state.obj);
                  setState(() {});
                }
              },
              child: EmptyContainer(),
            ),
          ),
        ],
      ),
      onRefresh: refreshPage,
    ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    homebloc.add(FetchStandardNavigationBar());
  }
}
