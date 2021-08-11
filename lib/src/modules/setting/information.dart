import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/error_icon_widget.dart';
import 'package:Soc/src/widgets/no_data_icon_widget.dart';
import 'package:Soc/src/widgets/no_internet_icon.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable

class InformationPage extends StatefulWidget {
  String htmlText;

  bool isbuttomsheet;
  bool ishtml;
  String appbarTitle;

  @override
  InformationPage({
    Key? key,
    required this.htmlText,
    required this.isbuttomsheet,
    required this.ishtml,
    required this.appbarTitle,
  }) : super(key: key);
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  static const double _kLabelSpacing = 20.0;
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _bloc = new HomeBloc();

  Widget _buildContent1() {
    String? htmlData;
    if (widget.htmlText.toString().contains("src=") == true) {
      String img = Utility.getHTMLImgSrc(widget.htmlText);
      htmlData = widget.htmlText.toString().replaceAll("$img", " ");
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Wrap(
        children: [
          widget.htmlText.toString().contains("src=") &&
                  widget.htmlText.toString().split('"')[1] != ""
              ? Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: Utility.getHTMLImgSrc(widget.htmlText),
                      placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.width * 0.8,
                              color: Colors.white,
                            ),
                          )),
                      errorWidget: (context, url, error) => Container(),
                    ),
                  ),
                )
              : Container(),
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: htmlData ?? widget.htmlText,
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => Html(
                    data: translatedMessage.toString(),
                  ),
                )
              : Html(
                  data: htmlData ?? widget.htmlText,
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
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: false,
          isShare: false,
          appBarTitle: widget.appbarTitle,
          ishtmlpage: widget.ishtml,
          sharedpopBodytext: widget.htmlText.replaceAll(exp, '').toString(),
          sharedpopUpheaderText: "Please checkout this ",
          language: Globals.selectedLanguage,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: ListView(children: [
            BlocListener<HomeBloc, HomeState>(
              bloc: _bloc,
              listener: (context, state) async {
                if (state is BottomNavigationBarSuccess) {
                  AppTheme.setDynamicTheme(Globals.appSetting, context);
                  Globals.homeObjet = state.obj;
                  setState(() {});
                }
              },
              child: Container(),
            ),
            BlocBuilder<HomeBloc, HomeState>(
                bloc: _bloc,
                builder: (BuildContext contxt, HomeState state) {
                  if (state is HomeErrorReceived) {
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
                        SizedBox(
                          child: NoDataIconWidget(),
                        ),
                        SpacerWidget(12),
                        Globals.selectedLanguage != null &&
                                Globals.selectedLanguage != "English"
                            ? TranslationWidget(
                                message: "No  data found",
                                toLanguage: Globals.selectedLanguage,
                                fromLanguage: "en",
                                builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                ),
                              )
                            : Text("No data found"),
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
            _buildContent1(),
            SizedBox(
              height: 100.0,
              child: ShareButtonWidget(
                language: Globals.selectedLanguage,
              ),
            ),
          ]),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(FetchBottomNavigationBar());
  }
}
