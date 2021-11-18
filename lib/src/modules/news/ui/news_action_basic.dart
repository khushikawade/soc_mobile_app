import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class NewsActionBasic extends StatefulWidget {
  NewsActionBasic(
      {Key? key,
      required this.newsObj,
      required this.icons,
      this.isLoading,
      required this.iconsName})
      : super(key: key);

  final NotificationList newsObj;
  final List? icons;
  final List? iconsName;
  final bool? isLoading;

  _NewsActionBasicState createState() => _NewsActionBasicState();
}

class _NewsActionBasicState extends State<NewsActionBasic> {
  NewsBloc bloc = new NewsBloc();
  final ValueNotifier<double> like = ValueNotifier<double>(0);
  final ValueNotifier<double> thanks = ValueNotifier<double>(0);
  final ValueNotifier<double> helpful = ValueNotifier<double>(0);
  final ValueNotifier<double> share = ValueNotifier<double>(0);
  int? iconnameindex;

  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.045,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.icons!.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
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
                      widget.isLoading == true ? Container() : _likeCount(index)
                    ],
                  ),
                ),
                Expanded(
                    child: iconnameindex == index
                        ? Container(
                            padding: EdgeInsets.all(0),
                            child: Text(
                              widget.iconsName![index],
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(0),
                          ))
              ],
            ),
          );
        },
      ),
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
            iconnameindex = -1;
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
      iconnameindex = index;
    });

    startTimer();
    index == 0
        ? like.value =
            like.value != 0.0 ? like.value + 1 : widget.newsObj.likeCount! + 1
        : index == 1
            ? thanks.value = thanks.value != 0.0
                ? thanks.value + 1
                : widget.newsObj.thanksCount! + 1
            : index == 2
                ? helpful.value = helpful.value != 0.0
                    ? helpful.value + 1
                    : widget.newsObj.helpfulCount! + 1
                : share.value = share.value != 0.0
                    ? share.value + 1
                    : widget.newsObj.shareCount! + 1;

    index == 0
        ? widget.newsObj.likeCount = like.value
        : index == 1
            ? widget.newsObj.thanksCount = thanks.value
            : index == 2
                ? widget.newsObj.helpfulCount = helpful.value
                : widget.newsObj.shareCount = share.value;

    bloc.add(NewsAction(
        notificationId: widget.newsObj.id,
        schoolId: Overrides.SCHOOL_ID,
        like: index == 0 ? "1" : "",
        thanks: index == 1 ? "1" : "",
        helpful: index == 2 ? "1" : "",
        shared: index == 3 ? "1" : ""));
    return isliked;
  }

  Widget iconListWidget(context, index, bool totalCountIcon) {
    return LikeButton(
      isLiked: null,
      onTap: (onLikeButtonTapped) {
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
        return Icon(
          IconData(widget.icons![index],
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
          color: index == 0
              ? Colors.red
              : index == 1
                  ? Colors.blue
                  : index == 2
                      ? Colors.green
                      : Colors.black,
          size: Globals.deviceType == "phone"
              ? (index == 0 ? 23 : 18)
              : (index == 0 ? 26 : 20),
        );
      },
    );
  }

  Widget _likeCount(index) {
    return ValueListenableBuilder(
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Text(
          index == 0
              ? (like.value != 0.0
                  ? like.value.toString().split('.')[0]
                  : widget.newsObj.likeCount == 0.0
                      ? ""
                      : widget.newsObj.likeCount.toString().split('.')[0])
              : index == 1
                  ? (thanks.value != 0.0
                      ? thanks.value.toString().split('.')[0]
                      : widget.newsObj.thanksCount == 0.0
                          ? ""
                          : widget.newsObj.thanksCount.toString().split('.')[0])
                  : index == 2
                      ? (helpful.value != 0.0
                          ? helpful.value.toString().split('.')[0]
                          : widget.newsObj.helpfulCount == 0.0
                              ? ""
                              : widget.newsObj.helpfulCount
                                  .toString()
                                  .split('.')[0])
                      : share.value != 0.0
                          ? share.value.toString().split('.')[0]
                          : widget.newsObj.shareCount == 0.0
                              ? ""
                              : widget.newsObj.shareCount
                                  .toString()
                                  .split('.')[0],
          style: Theme.of(context).textTheme.headline4!,
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
