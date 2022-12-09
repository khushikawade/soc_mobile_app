import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/ocr/widgets/Common_popup.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_modal.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/translator/translator_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';
import '../translator/language_list.dart';

class ActionInteractionButtonWidget extends StatefulWidget {
  ActionInteractionButtonWidget({
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
  var obj;
  final imageUrl;
  final title;
  final description;
  final bool? isLoading;
  final String page;
  final Key? scaffoldKey;
  // final Function(Item obj)? onChange;
  @override
  State<ActionInteractionButtonWidget> createState() =>
      _ActionInteractionButtonWidgetState();
}

class _ActionInteractionButtonWidgetState
    extends State<ActionInteractionButtonWidget> {
  @override
  NewsBloc _newsBloc = new NewsBloc();
  SocialBloc _socialBloc = SocialBloc();
  final ValueNotifier<int> like = ValueNotifier<int>(0);
  final ValueNotifier<int> thanks = ValueNotifier<int>(0);
  final ValueNotifier<int> helpful = ValueNotifier<int>(0);
  final ValueNotifier<int> share = ValueNotifier<int>(0);
  final ValueNotifier<int> support = ValueNotifier<int>(0);
  bool _downloadingFile = false;
  int? iconNameIndex;
  bool _isDownloadingFile = false;
  var f = NumberFormat.compact();
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // final _debouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    // print('inside inistate ------------------------------------>');
    like.value = widget.obj.likeCount ?? 0;
    thanks.value = widget.obj.thanksCount ?? 0;
    helpful.value = widget.obj.helpfulCount ?? 0;
    share.value = widget.obj.shareCount ?? 0;
    support.value = widget.obj.supportCount ?? 0;
  }

  @override
  void didUpdateWidget(ActionInteractionButtonWidget oldWidget) {
    // print(
    //     'inside did update method ------------------------------------------');
    super.didUpdateWidget(oldWidget);
    like.value = widget.obj.likeCount ?? 0;
    thanks.value = widget.obj.thanksCount ?? 0;
    helpful.value = widget.obj.helpfulCount ?? 0;
    share.value = widget.obj.shareCount ?? 0;
    support.value = widget.obj.supportCount ?? 0;
  }

  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.07
            : MediaQuery.of(context).size.width * 0.07,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        height: Globals.deviceType == 'phone' ? 35 : 45,
                        width: Globals.deviceType == 'phone' ? 35 : 45,
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {},
                            icon: iconListWidget(
                                context, index, false, widget.scaffoldKey))),
                    widget.isLoading == true
                        ? Container()
                        : Container(
                            // padding: EdgeInsets.only(top:4),
                            child: _actionCount(index),
                          )
                  ],
                ),
              ),
            ),
            Expanded(
                child: iconNameIndex == index
                    ? Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(),
                        child: FutureBuilder(
                            future: _getLocalTranslation(
                                originalText: Globals.iconsName[index],
                                toLanguage: Globals.selectedLanguage!),
                            builder: (context, AsyncSnapshot<String> data) {
                              if (data.hasData) {
                                if (data.data!.isNotEmpty) {
                                  return Text(
                                    data.data!,
                                    style: TextStyle(fontSize: 12),
                                  );
                                } else {
                                  return TranslationWidget(
                                    isUserInteraction: true,
                                    message: Globals.iconsName[index],
                                    fromLanguage: "en",
                                    toLanguage: Globals.selectedLanguage,
                                    builder: (translatedMessage) => Text(
                                      translatedMessage,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  );
                                }
                              }
                              return Container();
                            }),
                      )
                    : Container(
                        padding: EdgeInsets.all(0),
                      ))
          ],
        ),
      );

  Widget iconListWidget(context, index, bool totalCountIcon, scaffoldKey) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        return Container(
          child: LikeButton(
            isLiked: null,
            onTap: (onActionButtonTapped) async {
              if (!connected) {
                Utility.currentScreenSnackBar("No Internet Connection", null);
              } else {
                if (widget.isLoading == true) {
                  Utility.showSnackBar(
                      scaffoldKey, 'Please wait while loading', context, null);
                } else {
                  final toLanguageCode = Translations.supportedLanguagesCodes(
                      Globals.selectedLanguage!);
                  //Save translated text locally
                  await _saveTranslatedTextLocally(
                      originalText: Globals.iconsName[index],
                      toLanguageCode: toLanguageCode,
                      translatedText: TranslationAPI.translate(
                          Globals.iconsName[index], toLanguageCode, true));
                  // _debouncer.run(() async {
                  if (connected) {
                    if (index == 3) {
                      await _shareNews();
                    } else if (index == 4) {
                      supportPopupModal();
                      // popupModal(
                      //     message:
                      //         'You are about to Signout from the google account. This may restricts you to use the app without google SignIn. \n\nContinue Signout?',
                      //     title: 'Signout');
                    }
                    return countIncrement(index, scaffoldKey);
                  } else {
                    Utility.showSnackBar(
                        scaffoldKey,
                        'Make sure you have a proper Internet connection',
                        context,
                        null);
                  }
                  // });
                }
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
                          : index == 3
                              ? Theme.of(context).colorScheme.primaryVariant
                              : Theme.of(context).colorScheme.primaryVariant,
              end: index == 0
                  ? Colors.red
                  : index == 1
                      ? Colors.blue
                      : index == 2
                          ? Colors.green
                          : index == 3
                              ? Theme.of(context).colorScheme.primaryVariant
                              : Theme.of(context).colorScheme.primaryVariant,
            ),
            bubblesColor: BubblesColor(
              dotPrimaryColor: index == 0
                  ? Colors.red
                  : index == 1
                      ? Colors.blue
                      : index == 2
                          ? Colors.green
                          : index == 3
                              ? Theme.of(context).colorScheme.primaryVariant
                              : Theme.of(context).colorScheme.primaryVariant,
              dotSecondaryColor: index == 0
                  ? Colors.red
                  : index == 1
                      ? Colors.blue
                      : index == 2
                          ? Colors.green
                          : index == 3
                              ? Theme.of(context).colorScheme.primaryVariant
                              : Theme.of(context).colorScheme.primaryVariant,
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
                                  : index == 3
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryVariant
                                      : Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                      size: Globals.deviceType == "phone"
                          ? (index == 0 || index == 4 ? 26 : 22)
                          : (index == 0 || index == 4 ? 30 : 25),
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

  Future<bool> countIncrement(index, scaffoldKey) async {
    bool? isliked = true;
    setState(() {
      iconNameIndex = index;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          iconNameIndex = -1;
        });
      }
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
                : index == 3
                    ? share.value = share.value != 0
                        ? share.value + 1
                        : widget.obj.shareCount! + 1
                    : support.value = support.value != 0
                        ? support.value + 1
                        : widget.obj.supportCount! + 1;

    index == 0
        ? widget.obj.likeCount = like.value
        : index == 1
            ? widget.obj.thanksCount = thanks.value
            : index == 2
                ? widget.obj.helpfulCount = helpful.value
                : index == 3
                    ? widget.obj.shareCount = share.value
                    : widget.obj.supportCount = support.value;

    // Item obj = Item();
    // index == 0
    //     ? obj.likeCount = widget.obj.likeCount
    //     : index == 1
    //         ? obj.thanksCount = widget.obj.thanksCount
    //         : index == 2
    //             ? obj.helpfulCount = widget.obj.helpfulCount
    //             : obj.shareCount = widget.obj.shareCount;

    // print(obj.likeCount);
    // obj.likeCount = widget.obj.likeCount;
    // print(obj.likeCount);

    if (widget.page == "news") {
      _newsBloc.add(NewsAction(
          context: context,
          scaffoldKey: scaffoldKey,
          notificationId: widget.obj.id,
          notificationTitle: widget.title,
          like: index == 0 ? 1 : 0,
          thanks: index == 1 ? 1 : 0,
          helpful: index == 2 ? 1 : 0,
          shared: index == 3 ? 1 : 0,
          support: index == 4 ? 1 : 0));
    } else if (widget.page == "social") {
      _socialBloc.add(SocialAction(
          context: context,
          scaffoldKey: scaffoldKey,
          id: widget.obj
              .guid['\$t'], //widget.obj.id.toString() + widget.obj.guid['\$t'],
          title: widget.title.toString(),
          like: index == 0 ? 1 : 0,
          thanks: index == 1 ? 1 : 0,
          helpful: index == 2 ? 1 : 0,
          shared: index == 3 ? 1 : 0,
          support: index == 4 ? 1 : 0));
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
        _totalRetry++;
        String _fallBackImageUrl =
            Globals.splashImageUrl != null && Globals.splashImageUrl != ""
                ? Globals.splashImageUrl
                : Globals.appSetting.appLogoC;
        _shareNews(fallBackImageUrl: _fallBackImageUrl);
      } else {
        Utility.showSnackBar(
            widget.scaffoldKey, 'Something went wrong.', context, null);
      }
    }
  }

  Widget _actionCount(index) {
    return ValueListenableBuilder(
      builder: (BuildContext context, dynamic value, Widget? child) {
        // print('only likes count');
        // print(widget.obj.likeCount);
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
                      : index == 3
                          ? (share.value != 0
                              ? f.format(share.value).toString().split('.')[0]
                              : widget.obj.shareCount == 0 ||
                                      widget.obj.shareCount == null
                                  ? ""
                                  : f.format(widget.obj.shareCount))
                          : support.value != 0
                              ? f.format(support.value).toString().split('.')[0]
                              : widget.obj.supportCount == 0 ||
                                      widget.obj.supportCount == null
                                  ? ""
                                  : f.format(widget.obj.supportCount),
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

//Get the translated text from local database for interaction translation
  Future<String> _getLocalTranslation(
      {required String originalText, required String toLanguage}) async {
    LocalDatabase<TranslationModal> localTranslationDb =
        LocalDatabase('local_Translation');

    List<TranslationModal> list = await localTranslationDb.getData();

    final toLanguageCode = Translations.supportedLanguagesCodes(toLanguage);

    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].originalText == originalText &&
            list[i].toLanguageCode == toLanguageCode) {
          return list[i].translatedText!;
        }
      }
    }

    return '';
  }

//Save translated text locally to bypass the loading of interaction translation
  Future _saveTranslatedTextLocally(
      {required Future<String>? translatedText,
      required String originalText,
      required String toLanguageCode}) async {
    LocalDatabase<TranslationModal> localTranslationDb =
        LocalDatabase('local_Translation');
    List<TranslationModal> list = await localTranslationDb.getData();

    //Convert Future<String> to String
    String? translatedTextNew = await translatedText;

    if (list.isNotEmpty) {
      bool found = list.any((item) =>
          item.originalText == originalText &&
          item.toLanguageCode == toLanguageCode);

      if (found == false) {
        await localTranslationDb.addData(TranslationModal(
            originalText: originalText,
            toLanguageCode: toLanguageCode,
            translatedText: translatedTextNew));
      }
    } else {
      await localTranslationDb.addData(TranslationModal(
          originalText: originalText,
          toLanguageCode: toLanguageCode,
          translatedText: translatedTextNew));
    }
  }

  // popupModal({required String message, required String? title}) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) =>
  //           OrientationBuilder(builder: (context, orientation) {
  //             return CommonPopupWidget(
  //                 isLogout: false,
  //                 orientation: orientation,
  //                 context: context,
  //                 message: message,
  //                 title: title!);
  //           }));
  // }

  supportPopupModal() async {
    await Future.delayed(Duration(milliseconds: 500));
    showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return CommonPopupWidget(
                backgroundColor: Theme.of(context).colorScheme.background ==
                        Color(0xff000000)
                    ? Color(0xff162429)
                    : null,
                isLogout: true,
                orientation: orientation,
                context: context,
                message:
                    'For any query or support, get in touch via email or call',
                title: 'Contact Us',
                actionWidget: supportActionWidget(
                    contactNumber: Globals.appSetting.contactPhoneC,
                    email: Globals.appSetting.contactEmailC),
                clearButton: true,
                titleStyle: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontWeight: FontWeight.bold),
              );
            }));
  }

  List<Widget> supportActionWidget(
      {required String? email, required String? contactNumber}) {
    return [
      // Row(
      //   children: [
      textButtonWidget(
          title: 'Email',
          iconData: Icons.email,
          onPressed: () async {
            RegExp regex = new RegExp(pattern);
            if (email != null && (regex.hasMatch(email))) {
              Utility.launchUrlOnExternalBrowser("mailto:" + email);
            } else {
              Utility.currentScreenSnackBar("Email is not available", null);
            }
          }),
      Container(
        height: 40,
        width: 1,
        color: Colors.grey.withOpacity(0.2),
      ),
      textButtonWidget(
          title: 'Call',
          iconData: Icons.call,
          onPressed: () async {
            if (contactNumber != null && contactNumber.isNotEmpty) {
              Utility.launchUrlOnExternalBrowser("tel:" + contactNumber);
            } else {
              Utility.currentScreenSnackBar("Contact is not available", null);
            }
          }),

// ==========================================================

      // popUpbutton(
      //     'Email', Theme.of(context).scaffoldBackgroundColor, Icons.email,
      //     onPressed: () {
      //   RegExp regex = new RegExp(pattern);
      //   if (email != null && (regex.hasMatch(email))) {
      //     Utility.launchUrlOnExternalBrowser("mailto:" + email);
      //   } else {
      //     Utility.currentScreenSnackBar("Email is not available", null);
      //   }
      // }),
      // popUpbutton('Call', Theme.of(context).scaffoldBackgroundColor, Icons.call,
      //     onPressed: () {
      //   if (contactNumber != null && contactNumber.isNotEmpty) {
      //     Utility.launchUrlOnExternalBrowser("tel:" + contactNumber);
      //   } else {
      //     Utility.currentScreenSnackBar("Contact is not available", null);
      //   }
      // })
    ];
  }

  // Widget popUpbutton(text, color, iconData, {required onPressed}) {
  //   return Row(
  //     children: [
  //       textButtonWidget(title: 'Yes', onPressed: () async {},),
  //       Container(
  //         height: 40,
  //         width: 1,
  //         color: Colors.grey.withOpacity(0.2),
  //       ),
  //       textButtonWidget(title: 'Yes', onPressed: () async {},),
  //       Container(
  //         height: 40,
  //         width: 1,
  //         color: Colors.grey.withOpacity(0.2),
  //       )
  //     ],
  // );
// ===================================================
  // Expanded(
  //   child: Padding(
  //     padding: EdgeInsets.all(10.0),
  //     child: ElevatedButton(
  //       onPressed: onPressed,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             iconData,
  //             // size: size,
  //             color: Theme.of(context).colorScheme.background ==
  //                     Color(0xff000000)
  //                 ? Colors.white
  //                 : Colors.black,
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           TranslationWidget(
  //               message: text ?? '',
  //               fromLanguage: "en",
  //               toLanguage: Globals.selectedLanguage,
  //               builder: (translatedMessage) {
  //                 return Text(translatedMessage.toString(),
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .headline2!
  //                         .copyWith(fontWeight: FontWeight.bold));
  //               }),
  //         ],
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         primary: color ?? Colors.transparent,
  //         shape: RoundedRectangleBorder(
  //           side: BorderSide(
  //               width: 0.10, color: Theme.of(context).colorScheme.background),
  //           borderRadius: BorderRadius.circular(40.0),
  //         ),
  //       ),
  //     ),
  //   ),
  // );
  // }

  Widget textButtonWidget(
      {required String title,
      required IconData iconData,
      required void Function()? onPressed}) {
    return TextButton(
      child: Row(
        children: [
          Icon(
            iconData,
          ),
          SizedBox(
            width: 10,
          ),
          TranslationWidget(
              message: title,
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) {
                return Text(translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        // color:,
                        ));
              }),
        ],
      ),
      onPressed: onPressed,

      //  () async {
      //   if (widget.isAccessDenied == true) {
      //     //To pop 2 times to navigate back to the home screen in case of camera access denied
      //     int count = 0;
      //     Navigator.of(context).popUntil((_) {
      //       if (Platform.isAndroid) {
      //         return count++ >= 3;
      //       } else {
      //         return count++ >= 2;
      //       }
      //     });

      //     //To open the app setting for permission access
      //     OpenAppsSettings.openAppsSettings(
      //         settingsCode: SettingsCode.APP_SETTINGS);
      //   } else if (widget.isLogout == true) {
      //
      //   } else {
      //     //Globals.iscameraPopup = false;
      //     Navigator.pop(context, false);
      //   }
      // },
    );
  }
  // Widget buildTitle(title) {
  //   return Row(
  //     children: [
  //       TranslationWidget(
  //           message: title,
  //           fromLanguage: "en",
  //           toLanguage: Globals.selectedLanguage,
  //           builder: (translatedMessage) {
  //             return Text(translatedMessage.toString(),
  //                 textAlign: TextAlign.center,
  //                 style: Theme.of(context).textTheme.headline1!.copyWith());
  //           }),
  //       Icon(
  //         Icons.clear,
  //         size: Globals.deviceType == "phone" ? 28 : 36,
  //       ),
  //     ],
  //   );
  // }
}
