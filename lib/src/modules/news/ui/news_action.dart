import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

class NewsActionButton extends StatefulWidget {
  NewsActionButton(
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

  _NewsActionButtonState createState() => _NewsActionButtonState();
}

class _NewsActionButtonState extends State<NewsActionButton> {
  NewsBloc bloc = new NewsBloc();
  final ValueNotifier<double> like = ValueNotifier<double>(0);
  final ValueNotifier<double> thanks = ValueNotifier<double>(0);
  final ValueNotifier<double> helpful = ValueNotifier<double>(0);

  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.icons!.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: IconButton(
                        padding: EdgeInsets.all(0),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          index == 0
                              ? like.value = like.value != 0.0
                                  ? like.value + 1
                                  : widget.newsObj.likeCount! + 1
                              : index == 1
                                  ? thanks.value = thanks.value != 0.0
                                      ? thanks.value + 1
                                      : widget.newsObj.thanksCount! + 1
                                  : helpful.value = helpful.value != 0.0
                                      ? helpful.value + 1
                                      : widget.newsObj.helpfulCount! + 1;

                          index == 0
                              ? widget.newsObj.likeCount = like.value
                              : index == 1
                                  ? widget.newsObj.thanksCount = thanks.value
                                  : widget.newsObj.helpfulCount = helpful.value;

                          bloc.add(NewsAction(
                              notificationId: widget.newsObj.id,
                              schoolId: Overrides.SCHOOL_ID,
                              like: index == 0 ? "1" : "",
                              thanks: index == 1 ? "1" : "",
                              helpful: index == 2 ? "1" : ""));
                        },
                        icon: Icon(
                          IconData(widget.icons![index],
                              fontFamily: Overrides.kFontFam,
                              fontPackage: Overrides.kFontPkg),
                          color: Colors.black,
                          //Icons.favorite_outline_outlined,
                          size: Globals.deviceType == "phone"
                              ? (index == 0
                                  ? 23
                                  : index == 2
                                      ? 19
                                      : 18)
                              : (index == 0 ? 26 : 20),
                        )),
                  ),
                  widget.isLoading == true ? Container() : _likeCount(index)
                ],
              ),
              Expanded(
                child: Container( padding: EdgeInsets.all(0),child: Text(widget.iconsName![index] + "${index==3?" ":" | "}") ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _likeCount(index) {
    return ValueListenableBuilder(
      builder: (BuildContext context, dynamic value, Widget? child) {
        return GestureDetector(
          onTap: () {},
          child: Text(
            index == 0
                ? (like.value != 0.0
                    ? like.value.toString().split('.')[0]
                    : widget.newsObj.likeCount.toString().split('.')[0])
                : index == 1
                    ? (thanks.value != 0.0
                        ? thanks.value.toString().split('.')[0]
                        : widget.newsObj.thanksCount.toString().split('.')[0])
                    : (helpful.value != 0.0
                        ? helpful.value.toString().split('.')[0]
                        : widget.newsObj.helpfulCount.toString().split('.')[0]),
            style: Theme.of(context).textTheme.headline4!,
          ),
        );
      },
      valueListenable: index == 0
          ? like
          : index == 1
              ? thanks
              : helpful,
      child: Container(),
    );
  }
}
