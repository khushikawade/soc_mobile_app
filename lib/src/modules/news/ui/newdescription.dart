import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/news/ui/news_image.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';




class Newdescription extends StatefulWidget {
  Newdescription(
      {Key? key,
      required this.obj,
      required this.date,
      required this.isbuttomsheet,
      required this.language})
      : super(key: key);

  final String date;
  final bool isbuttomsheet;
  final String? language;
  final obj;

  _NewdescriptionState createState() => _NewdescriptionState();
}

class _NewdescriptionState extends State<Newdescription> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  static const double _kIconSize = 45.0;
  static const double _kLabelSpacing = 20.0;
  final HomeBloc _homeBloc = new HomeBloc();

  @override
  void initState() {
    super.initState();
    Globals.callsnackbar = true;
  }

  _launchURL(obj) async {
 if(obj.toString().split(":")[0]=='http'){
  String url=obj.toString().replaceAll("http", "https");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InAppUrlLauncer(
                  title: widget.obj.headings["en"].toString(),
                  url:'https://formstack.io/60E4A',// url,
                  isbuttomsheet: true,
                  language: Globals.selectedLanguage,
                )));
        // await canLaunch('https://formstack.io/60E4A') ? await launch('https://formstack.io/60E4A') : throw 'Could not launch ${'https://formstack.io/60E4A'}';
        }
                else{
                  Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InAppUrlLauncer(
                  title: widget.obj.headings["en"].toString(),
                  url: obj,
                  isbuttomsheet: true,
                  language: Globals.selectedLanguage,
                )));
                }
  }

  Widget _buildNewsDescription() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 30.0),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              // height: MediaQuery.of(context).size.width * 0.5,
              child: ClipRRect(
                child: widget.obj.image != null && widget.obj.image != ""
                    ? GestureDetector(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (_) => NewsImagePage(imageURL: widget.obj.image)     
                        );
                      },
                      child: CachedNetworkImage(
                          imageUrl: widget.obj.image,
                          fit: BoxFit.cover,
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
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                    )
                    : Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (_) => NewsImagePage(imageURL: Globals.splashImageUrl!=null && Globals.splashImageUrl!=""?Globals.splashImageUrl:Globals.homeObjet["App_Logo__c"])     
                          );
                       },
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: Globals.splashImageUrl!=null && Globals.splashImageUrl!=""?Globals.splashImageUrl:Globals.homeObjet["App_Logo__c"],
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
                      ),
              ),
            ),
            SpacerWidget(_kLabelSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English" &&
                          Globals.selectedLanguage != ""
                      ? TranslationWidget(
                            message: widget.obj.headings != "" &&
                                    widget.obj.headings != null &&
                                    widget.obj.headings.length > 0
                                ? widget.obj.headings["en"].toString()
                                : widget.obj.contents["en"]
                                        .toString()
                                        .split(" ")[0] +
                                    " " +
                                    widget.obj.contents["en"]
                                        .toString()
                                        .split(" ")[1] +
                                    "...",
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Linkify(
                            onOpen: (link) => _launchURL( link.url),
                            options: LinkifyOptions(humanize: false),
                                text: 
                                translatedMessage.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(fontWeight: FontWeight.w500),
                            
                            
                          ),
                      )
                      : Linkify(
                            onOpen: (link) => _launchURL( link.url),
                            options: LinkifyOptions(humanize: false),
                            linkStyle: TextStyle(color: Colors.blue),
                                text: 
                          widget.obj.headings != "" &&
                                  widget.obj.headings != null &&
                                  widget.obj.headings.length > 0
                              ? widget.obj.headings["en"].toString()
                              : widget.obj.contents["en"]
                                      .toString()
                                      .split(" ")[0] +
                                  " " +
                                  widget.obj.contents["en"]
                                      .toString()
                                      .split(" ")[1] +
                                  "...",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                ),
                // Globals.selectedLanguage != null &&
                //         Globals.selectedLanguage != "English" &&
                //         Globals.selectedLanguage != ""
                //     ? TranslationWidget(
                //         message: widget.date,
                //         toLanguage: Globals.selectedLanguage,
                //         fromLanguage: "en",
                //         builder: (translatedMessage) => Text(
                //           translatedMessage.toString(),
                //           style: Theme.of(context).textTheme.subtitle1!,
                //           textAlign: TextAlign.justify,
                //         ),
                //       )
                //     : Text(
                //         widget.date,
                //         style: Theme.of(context).textTheme.subtitle1!,
                //         textAlign: TextAlign.justify,
                //       ),
              ],
            ),
            Container(
              child: Wrap(
                children: [
                  Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English" &&
                          Globals.selectedLanguage != ""
                      ? TranslationWidget(
                          message: widget.obj.contents["en"].toString(),
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => 
                         Linkify(
                            onOpen: (link) => _launchURL( link.url),
                            options: LinkifyOptions(humanize: false),
                            linkStyle: TextStyle(color: Colors.blue),
                                text: 
                            translatedMessage.toString(),
                            style: Theme.of(context).textTheme.bodyText1!,
                            textAlign: TextAlign.left,
                          ),
                        )
                      : 
                     Linkify(
                            onOpen: (link) => _launchURL( link.url),
                            options: LinkifyOptions(humanize: false),
                            linkStyle: TextStyle(color: Colors.blue),
                                text: 
                          widget.obj.contents["en"].toString(),
                          style: Theme.of(context).textTheme.bodyText1!,
                          textAlign: TextAlign.left,
                        ),
                ],
              ),
            ),
            GestureDetector(
              // onTap: () {
              //   _launchURL(widget.obj.url);
              // },
              child: widget.obj.url != null
                  ? Wrap(
                      children: [
                        Globals.selectedLanguage != null &&
                                Globals.selectedLanguage != "English" &&
                                Globals.selectedLanguage != ""
                            ? TranslationWidget(
                                message: widget.obj.url.toString(),
                                toLanguage: Globals.selectedLanguage,
                                fromLanguage: "en",
                                builder: (translatedMessage) => Linkify(
                            onOpen: (link) => _launchURL( link.url),
                            linkStyle: TextStyle(color: Colors.blue),
                            options: LinkifyOptions(humanize: false),
                                text: 
                                  translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                          decoration: TextDecoration.underline,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryVariant),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                            : 
                            Linkify(
                            onOpen: (link) => _launchURL( link.url),
                            linkStyle: TextStyle(color: Colors.blue),
                                text: 
                                widget.obj.url.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                textAlign: TextAlign.justify,
                              ),
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
        Container(
          height: 0,
          width: 0,
          child: BlocListener<HomeBloc, HomeState>(
            bloc: _homeBloc,
            listener: (context, state) async {
              if (state is BottomNavigationBarSuccess) {
                AppTheme.setDynamicTheme(Globals.appSetting, context);
                Globals.homeObjet = state.obj;
              }
            },
            child: Container(),
          ),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 1.5),
      child: RefreshIndicator(
        key: refreshKey,
        child: _buildNewsDescription(),
        onRefresh: refreshPage,
      ),
    ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
