import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';

class NewsActionBasic extends StatefulWidget {
  NewsActionBasic(
      {Key? key,
      required this.obj,
      // required this.icons,
      this.isLoading,
      required this.page,
      // required this.iconsName
      })
      : super(key: key);

  final obj;
  // final List? icons;
  // final List? iconsName;
  final bool? isLoading;
  final String page;

  _NewsActionBasicState createState() => _NewsActionBasicState();
}

class _NewsActionBasicState extends State<NewsActionBasic> {
  NewsBloc _newsBloc = new NewsBloc();
  SocialBloc _socialbBloc = SocialBloc();
  final ValueNotifier<int> like = ValueNotifier<int>(0);
  final ValueNotifier<int> thanks = ValueNotifier<int>(0);
  final ValueNotifier<int> helpful = ValueNotifier<int>(0);
  final ValueNotifier<int> share = ValueNotifier<int>(0);
  // final ValueNotifier<double> like = ValueNotifier<double>(0);
  // final ValueNotifier<double> thanks = ValueNotifier<double>(0);
  // final ValueNotifier<double> helpful = ValueNotifier<double>(0);
  // final ValueNotifier<double> share = ValueNotifier<double>(0);
  int? iconNameIndex;
  bool _isDownloadingFile = false;
  var f = NumberFormat.compact();

  Widget _iconButton(index) => Container(
        alignment: Alignment.centerLeft,
        // width: MediaQuery.of(context).size.width * 0.25,
        padding: Globals.deviceType == "phone"
            ? null
            : EdgeInsets.only(
                // left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04),
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () {},
                      icon: iconListWidget(context, index, false)),
                  widget.isLoading == true
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 5, top: 1),
                          child: _likeCount(index),
                        )
                ],
              ),
            ),
            Expanded(
                child: iconNameIndex == index
                    ? Container(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          Globals.iconsName[index],
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(0),
                      ))
          ],
        ),
      );

  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.045,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: Globals.icons
            .map<Widget>(
                (element) => _iconButton(Globals.icons.indexOf(element)))
            .toList(),
      ),
      // child: ListView.builder(
      //   shrinkWrap: true,
      //   scrollDirection: Axis.horizontal,
      //   itemCount: widget.icons!.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return Container(
      //       width: MediaQuery.of(context).size.width * 0.25,
      //       padding: EdgeInsets.only(
      //           left: MediaQuery.of(context).size.width * 0.05,
      //           right: MediaQuery.of(context).size.width * 0.04),
      //       child: Column(
      //         children: [
      //           Center(
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               mainAxisSize: MainAxisSize.max,
      //               children: [
      //                 IconButton(
      //                     padding: EdgeInsets.all(0),
      //                     constraints: BoxConstraints(),
      //                     onPressed: () {},
      //                     icon: iconListWidget(context, index, false)),
      //                 widget.isLoading == true ? Container() : _likeCount(index)
      //               ],
      //             ),
      //           ),
      //           Expanded(
      //               child: iconnameindex == index
      //                   ? Container(
      //                       padding: EdgeInsets.all(0),
      //                       child: Text(
      //                         widget.iconsName![index],
      //                         style: TextStyle(fontSize: 12),
      //                       ),
      //                     )
      //                   : Container(
      //                       padding: EdgeInsets.all(0),
      //                     ))
      //         ],
      //       ),
      //     );
      //   },
      // ),
    );
  }

  int _start = 2;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            iconNameIndex = -1;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  Future<bool> countIncrement(index) async {
    bool? isliked = true;

    setState(() {
      iconNameIndex = index;
    });

    startTimer();

    index == 0
        ? like.value =
            like.value != 0.0 ? like.value + 1 : widget.obj.likeCount! + 1
        : index == 1
            ? thanks.value = thanks.value != 0.0
                ? thanks.value + 1
                : widget.obj.thanksCount! + 1
            : index == 2
                ? helpful.value = helpful.value != 0.0
                    ? helpful.value + 1
                    : widget.obj.helpfulCount! + 1
                : share.value = share.value != 0.0
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
          like: index == 0 ? 1 : 0,
          thanks: index == 1 ? 1 : 0,
          helpful: index == 2 ? 1 : 0,
          shared: index == 3 ? 1 : 0));
    } else if (widget.page == "social") {
      _socialbBloc.add(SocialAction(
          id: widget.obj.id.toString()+widget.obj.guid['\$t'],
          like: index == 0 ? 1 : 0,
          thanks: index == 1 ? 1 : 0,
          helpful: index == 2 ? 1 : 0,
          shared: index == 3 ? 1 : 0));
    }

    return isliked;
  }

  _shareNews() async {
    try {
      setState(() {
        _isDownloadingFile = true;
      });
      String _title = widget.obj.headings["en"] ?? "";
      String _description = widget.obj.contents["en"] ?? "";
      String _imageUrl = widget.obj.image != null
          ? widget.obj.image
          : Globals.splashImageUrl != null && Globals.splashImageUrl != ""
              ? Globals.splashImageUrl
              : Globals.homeObject["App_Logo__c"];
      File _image = await Utility.createFileFromUrl(_imageUrl);
      setState(() {
        _isDownloadingFile = false;
      });
      print(
          "${widget.obj.headings["en"]},${widget.obj.contents["en"]}");
      print("${[_image.path]},$_title,$_description");
      Share.shareFiles(
        [_image.path],
        subject: '$_title',
        text: '$_description',
      );
    } catch (e) {
      setState(() {
        _isDownloadingFile = false;
      });
    }
  }

  Widget iconListWidget(context, index, bool totalCountIcon) {
    return LikeButton(
      isLiked: null,
      onTap: (onLikeButtonTapped) async {
        if (index == 3) {
          await _shareNews();
        }
        return countIncrement(index);
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
                    : Colors.black, // Color(0xff33b5e5),
        dotSecondaryColor: index == 0
            ? Colors.red
            : index == 1
                ? Colors.blue
                : index == 2
                    ? Colors.green
                    : Colors.black, //Color(0xff0099cc),
      ),
      likeBuilder: (bool isLiked) {
        return _isDownloadingFile == true &&
                index ==
                    3 // Id the last button i.e. share button is pressed then it should show loader while the app is downloading the image from the URL.
            ? CircularProgressIndicator(
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
                            : Colors.black,
                size: Globals.deviceType == "phone"
                    ? (index == 0 ? 26 : 21)
                    : (index == 0 ? 30 : 25),
              );
      },
    );
  }

  Widget _likeCount(index) {
    return ValueListenableBuilder(
      builder: (BuildContext context, dynamic value, Widget? child) {
        return //Text("");
            Text(
          index == 0
              ? (like.value != 0.0
                  ? f.format(like.value).toString().split('.')[0]
                  : widget.obj.likeCount == 0.0
                      ? ""
                      : f
                          .format(widget.obj.likeCount)
                          .toString()
                          .split('.')[0])
              : index == 1
                  ? (thanks.value != 0.0
                      ? f.format(thanks.value).toString().split('.')[0]
                      : widget.obj.thanksCount == 0.0
                          ? ""
                          : f
                              .format(widget.obj.thanksCount)
                              .toString()
                              .split('.')[0])
                  : index == 2
                      ? (helpful.value != 0.0
                          ? f.format(helpful.value).toString().split('.')[0]
                          : widget.obj.helpfulCount == 0.0
                              ? ""
                              : f
                                  .format(widget.obj.helpfulCount)
                                  .toString()
                                  .split('.')[0])
                      : share.value != 0.0
                          ? f.format(share.value).toString().split('.')[0]
                          : widget.obj.shareCount == 0.0
                              ? ""
                              : f
                                  .format(widget.obj.shareCount)
                                  .toString()
                                  .split('.')[0],
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
