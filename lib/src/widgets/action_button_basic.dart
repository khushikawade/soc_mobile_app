import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';

class NewsActionBasic extends StatefulWidget {
  NewsActionBasic({
    Key? key,
    required this.obj,
    required this.title,
    required this.imageUrl,
    required this.description,
    this.isLoading,
    required this.page,
    this.imageExtType,
    this.scaffoldKey,
  }) : super(key: key);
  final imageExtType;
  final obj;
  final imageUrl;
  final title;
  final description;
  final bool? isLoading;
  final String page;
  final Key? scaffoldKey;
  _NewsActionBasicState createState() => _NewsActionBasicState();
}

class _NewsActionBasicState extends State<NewsActionBasic> {
  NewsBloc _newsBloc = new NewsBloc();
  SocialBloc _socialbBloc = SocialBloc();
  final ValueNotifier<int> like = ValueNotifier<int>(0);
  final ValueNotifier<int> thanks = ValueNotifier<int>(0);
  final ValueNotifier<int> helpful = ValueNotifier<int>(0);
  final ValueNotifier<int> share = ValueNotifier<int>(0);
  bool _downloadingFile = false;
  int? iconNameIndex;
  bool _isDownloadingFile = false;
  var f = NumberFormat.compact();

  // Widget build(BuildContext context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.045,
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: Globals.icons
  //           .map<Widget>(
  //               (element) => _iconButton(Globals.icons.indexOf(element)))
  //           .toList(),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.07
            : MediaQuery.of(context).size.width * 0.07,
        // width: MediaQuery.of(context).size.width * 0.60,
        // height: MediaQuery.of(context).orientation == Orientation.portrait
        //     ? MediaQuery.of(context).size.height * 0.045
        //     : MediaQuery.of(context).size.width * 0.045,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Globals.icons
              .map<Widget>(
                  (element) => _iconButton(Globals.icons.indexOf(element)))
              .toList(),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    iconNameIndex = -1;
  }

  Widget _iconButton(index) => Container(
        alignment: Alignment.centerLeft,
        padding: Globals.deviceType == "phone"
            ? null
            : EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.04),
        child: Center(
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        height: Globals.deviceType == 'phone' ? 35 : 45,
                        width: Globals.deviceType == 'phone' ? 35 : 45,
                         // color: Colors.grey,
                        child: Center(
                          child: IconButton(
                              padding: EdgeInsets.all(0),
                             // color: index == 3 ?  Theme.of(context).colorScheme.primaryVariant :null,
                              // constraints: BoxConstraints(),
                              onPressed: () {},
                              icon: iconListWidget(
                                
                                  context, index, false, widget.scaffoldKey)),
                        )),
                    widget.isLoading == true
                        ? Container()
                        : Container(
                            //  padding: const EdgeInsets.only(left: 5, top: 1),
                            // padding: const EdgeInsets.only(left: 0, top: 0),
                            child: _actionCount(index),
                          )
                  ],
                ),
              ),
              Expanded(
                  child: iconNameIndex == index
                      ? Container(
                          constraints: BoxConstraints(),
                          // padding: EdgeInsets.all(0),
                          child: TranslationWidget(
                            message: Globals.iconsName[index],
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) => Text(
                              translatedMessage,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(0),
                        ))
            ],
          ),
        ),
      );

  Widget iconListWidget(context, index, bool totalCountIcon, scaffoldKey) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        return Container(
          // color: Colors.yellow,
          child: LikeButton(
            isLiked: null,
            onTap: (onActionButtonTapped) async {
              final bool connected = connectivity != ConnectivityResult.none;

              if (connected) {
                if (index == 3) {
                  await _shareNews();
                }
                return countIncrement(index);
              } else {
                Utility.showSnackBar(scaffoldKey,
                    'Make sure you have a proper Internet connection', context);
              }
            },
            size: 20,
            circleColor: CircleColor(
              start: index == 0
                  ? Colors.red
                  : index == 1
                      ? Colors.blue
                      : index == 2
                          ? Colors.green
                          : Colors.black,
              end: index == 0
                  ? Colors.red
                  : index == 1
                      ? Colors.blue
                      : index == 2
                          ? Colors.green
                          : Colors.black,
            ),
            bubblesColor: BubblesColor(
              dotPrimaryColor: index == 0
                  ? Colors.red
                  : index == 1
                      ? Colors.blue
                      : index == 2
                          ? Colors.green
                          : Colors.black,
              dotSecondaryColor: index == 0
                  ? Colors.red
                  : index == 1
                      ? Colors.blue
                      : index == 2
                          ? Colors.green
                          : Colors.black,
            ),
            likeBuilder: (bool isLiked) {
              return _isDownloadingFile == true &&
                      index ==
                          3 // Id the last button i.e. share button is pressed then it should show loader while the app is downloading the image from the URL.
                  ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primaryVariant,
                      strokeWidth: 1,
                    )
                  : Icon(
                      IconData(Globals.icons[index],

                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      color: index == 0
                          ? Colors.red
                          : index == 1
                              ? Colors.blue
                              : index == 2
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.primaryVariant,
                      size: Globals.deviceType == "phone"
                          ? (index == 0 ? 26 : 21)
                          : (index == 0 ? 30 : 25),
                    );
            },
          ),
        );
      },
      child: Container(),
    );
  }

  Future<bool> onActionButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  Future<bool> countIncrement(index) async {
    bool? isliked = true;
    setState(() {
      iconNameIndex = index;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        iconNameIndex = -1;
      });
    });

    index == 0
        ? like.value =
            like.value != 0 ? like.value + 1 : widget.obj.likeCount! + 1
        : index == 1
            ? thanks.value = thanks.value != 0
                ? thanks.value + 1
                : widget.obj.thanksCount! + 1
            : index == 2
                ? helpful.value = helpful.value != 0
                    ? helpful.value + 1
                    : widget.obj.helpfulCount! + 1
                : share.value = share.value != 0
                    ? share.value + 1
                    : widget.obj.shareCount! + 1;

    index == 0
        ? widget.obj.likeCount = like.value
        : index == 1
            ? widget.obj.thanksCount = thanks.value
            : index == 2
                ? widget.obj.helpfulCount = helpful.value
                : widget.obj.shareCount = share.value;
    if (widget.page == "news") {
      _newsBloc.add(NewsAction(
          notificationId: widget.obj.id,
          notificationTitle: widget.title,
          like: index == 0 ? 1 : 0,
          thanks: index == 1 ? 1 : 0,
          helpful: index == 2 ? 1 : 0,
          shared: index == 3 ? 1 : 0));
    } else if (widget.page == "social") {
      _socialbBloc.add(SocialAction(
          id: widget.obj.guid['\$t'],//widget.obj.id.toString() + widget.obj.guid['\$t'],
          title: widget.title.toString(),
          like: index == 0 ? 1 : 0,
          thanks: index == 1 ? 1 : 0,
          helpful: index == 2 ? 1 : 0,
          shared: index == 3 ? 1 : 0));
    }
    return isliked;
  }

  int _totalRetry = 0; // To maintain total no of retries.

  _shareNews({String? fallBackImageUrl}) async {
    try {
      if (_downloadingFile == true) return;
      setState(() {
        _downloadingFile = true;
      });
      String _title = Utility.convertHtmlTOText(widget.title) ?? "";
      String _description = Utility.convertHtmlTOText(widget.description) ?? "";

      String _imageUrl;
      if (fallBackImageUrl != null) {
        _imageUrl = fallBackImageUrl;
      } else {
        _imageUrl = widget.imageUrl.toString().contains("http") &&
                await Utility.errorImageUrl(widget.imageUrl) != ''
            ? widget.imageUrl
            : '';
      }
      File? _image;

      if (_imageUrl != '') {
        _image = await Utility.createFileFromUrl(
            _imageUrl, widget.page == "social" ? widget.imageExtType : "");
      }

      //  await Utility.createFileFromUrl(_imageUrl);
      setState(() {
        _downloadingFile = false;
      });
      if (_image != null) {
        Share.shareFiles(
          [_image.path],
          subject: '$_title',
          text: '$_description',
        );
      } else {
        Share.share(" $_title $_description");
      }

      _totalRetry = 0;
    } catch (e) {
      print(e);
      setState(() {
        _downloadingFile = false;
      });
      // It should only call the fallback function if there's error with the hosted image and it should not run idefinately. Just 3 retries only.
      if (_totalRetry < 3 && e.toString().contains('403')) {
        // print('Current retry :: $_totalRetry');
        _totalRetry++;
        String _fallBackImageUrl =
            Globals.splashImageUrl != null && Globals.splashImageUrl != ""
                ? Globals.splashImageUrl
                : Globals.appSetting.appLogoC;
        _shareNews(fallBackImageUrl: _fallBackImageUrl);
      } else {
        Utility.showSnackBar(
            widget.scaffoldKey, 'Something went wrong.', context);
      }
    }
  }

  Widget _actionCount(index) {
    return ValueListenableBuilder(
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Text(
          index == 0
              ? (like.value != 0
                  ? f.format(like.value).toString().split('.')[0]
                  : widget.obj.likeCount == 0 || widget.obj.likeCount == null
                      ? ""
                      : f.format(widget.obj.likeCount))
              : index == 1
                  ? (thanks.value != 0
                      ? f.format(thanks.value).toString().split('.')[0]
                      : widget.obj.thanksCount == 0 ||
                              widget.obj.thanksCount == null
                          ? ""
                          : f.format(widget.obj.thanksCount))
                  : index == 2
                      ? (helpful.value != 0
                          ? f.format(helpful.value).toString().split('.')[0]
                          : widget.obj.helpfulCount == 0 ||
                                  widget.obj.helpfulCount == null
                              ? ""
                              : f.format(widget.obj.helpfulCount))
                      : share.value != 0
                          ? f.format(share.value).toString().split('.')[0]
                          : widget.obj.shareCount == 0 ||
                                  widget.obj.shareCount == null
                              ? ""
                              : f.format(widget.obj.shareCount),
          style: Theme.of(context).textTheme.bodyText1!,
        );
      },
      valueListenable: index == 0
          ? like
          : index == 1
              ? thanks
              : index == 2
                  ? helpful
                  : share,
      child: Container(),
    );
  }
}
