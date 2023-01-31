import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class InformationPage extends StatefulWidget {
  final bool isBottomSheet;
  final bool ishtml;
  final String appbarTitle;
  final bool? isloadingstate = false;

  @override
  InformationPage({
    Key? key,
    required this.isBottomSheet,
    required this.ishtml,
    required this.appbarTitle,
  }) : super(key: key);
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  static const double _kLabelSpacing = 10.0;
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _bloc = new HomeBloc();
  bool? isErrorState = false;

  bool? isloadingstate = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(FetchStandardNavigationBar());
    Globals.callsnackbar = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _buildContent1() {
    String? htmlData;
    if (Globals.appSetting.appInformationC.toString().contains("src=") ==
        true) {
      String img = Utility.getHTMLImgSrc(Globals.appSetting.appInformationC);
      htmlData =
          Globals.appSetting.appInformationC.toString().replaceAll("$img", " ");
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 20.0),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
          child: Wrap(
            children: [
              Globals.appSetting.appInformationC.toString().contains("src=") &&
                      Globals.appSetting.appInformationC
                              .toString()
                              .split('"')[1] !=
                          ""
                  ? Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                          child: CommonImageWidget(
                              iconUrl: Utility.getHTMLImgSrc(
                                  Globals.appSetting.appInformationC),
                              height: Utility.displayHeight(context) *
                                  (AppTheme.kDetailPageImageHeightFactor /
                                      100))),
                    )
                  : Container(),
              TranslationWidget(
                message: htmlData ?? Globals.appSetting.appInformationC,
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Html(
                  data: translatedMessage.toString(),
                  onLinkTap: (String? url, RenderContext context,
                      Map<String, String> attributes, dom.Element? element) {
                    _launchURL(url);
                  },
                  style: {
                    "table": Style(
                      backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                    ),
                    "tr": Style(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    "th": Style(
                      padding: EdgeInsets.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    "td": Style(
                      padding: EdgeInsets.all(6),
                      alignment: Alignment.topLeft,
                    ),
                    'h5':
                        Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 100.0,
          child: ShareButtonWidget(
            isSettingPage: true,
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: false,
          isShare: false,
          appBarTitle: widget.appbarTitle,
          ishtmlpage: widget.ishtml,
          sharedPopBodyText: Globals.appSetting.appInformationC!
              .replaceAll(exp, '')
              .toString(),
          sharedPopUpHeaderText: "Please checkout this ",
          language: Globals.selectedLanguage,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: Column(
            children: [
              Expanded(
                child: isloadingstate!
                    ? ShimmerLoading(
                        isLoading: true,
                        child: _buildContent1(),
                      )
                    : _buildContent1(),
              ),
              Container(
                height: 0,
                width: 0,
                child: BlocListener<HomeBloc, HomeState>(
                  bloc: _bloc,
                  listener: (context, state) async {
                    if (state is HomeLoading) {
                      isloadingstate = true;
                    }
                    if (state is BottomNavigationBarSuccess) {
                      AppTheme.setDynamicTheme(Globals.appSetting, context);

                      Globals.appSetting = AppSetting.fromJson(state.obj);
                      setState(() {
                        isloadingstate = false;
                      });
                    }
                  },
                  child: Container(),
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
    _bloc.add(FetchStandardNavigationBar());
  }

  _launchURL(obj) async {
    if (obj.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: widget.appbarTitle.toString(),
                    url: obj,
                    isBottomSheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }
}
