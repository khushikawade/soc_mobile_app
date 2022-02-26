import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonFeedWidget extends StatefulWidget {
  final String title;
  final String description;
  final Widget actionIcon;
  final String url;
  final Widget titleIcon;
  CommonFeedWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.actionIcon,
      required this.url,
      required this.titleIcon})
      : super(key: key);

  @override
  _CommonFeedWidgetState createState() => _CommonFeedWidgetState();
}

class _CommonFeedWidgetState extends State<CommonFeedWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.secondary,
          height: 6,
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Center(child: widget.titleIcon)),
              Container(
                 width: MediaQuery.of(context).size.width * 0.82,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeadline(),
                    SizedBox(
                      height: 5,
                    ),
                    _buildImage(),
                    widget.actionIcon,
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildImage(){
    return widget.url != '' || widget.url == null
                        ? Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: CachedNetworkImage(
                              imageUrl: widget.url,
                              fit: BoxFit.fitWidth,
                              width: MediaQuery.of(context).size.width * 0.85,
                              placeholder: (context, url) => Container(
                                  alignment: Alignment.center,
                                  child: ShimmerLoading(
                                    isLoading: true,
                                    child: Container(
                                      height: MediaQuery.of(context).size.height *
                                          0.4,
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      color: Colors.white,
                                    ),
                                  )),
                              errorWidget: (context, url, error) =>
                                  CachedNetworkImage(
                                    fit: BoxFit.fitWidth,
                                    imageUrl: Globals.splashImageUrl ??
                                        // Globals.homeObject["App_Logo__c"],
                                        Globals.appSetting.appLogoC,
                                    placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        child: ShimmerLoading(
                                          isLoading: true,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            color: Colors.white,
                                          ),
                                        ),),
                                  ),),
                        )
                        : Container();
  }

  Widget _buildHeadline() {
    return widget.title != '' && widget.description != ''
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslationWidget(
                  message: widget.title,
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) {
                    return Text(
                      translatedMessage.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontWeight: FontWeight.w500),
                    );
                  },),
              TranslationWidget(
                  message: widget.description,
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) {
                    return Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.headline2!.copyWith(),
                    );
                  },)
            ],
          )
        : TranslationWidget(
            message: widget.description,
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) {
              return Text(
                translatedMessage.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 16),
              );
            },);
  }
}
