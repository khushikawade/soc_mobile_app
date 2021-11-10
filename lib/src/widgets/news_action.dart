import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/action_count_list.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

class NewsActionButton extends StatefulWidget {
  NewsActionButton({
    Key? key,
    required this.newsObj,
    required this.icons,
    // required this.countObj,
  }) : super(key: key);

  final NotificationList newsObj;
  // final ActionCountList countObj;
  final List? icons;

  _NewsActionButtonState createState() => _NewsActionButtonState();
}

class _NewsActionButtonState extends State<NewsActionButton> {
  NewsBloc bloc = new NewsBloc();
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.icons!.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              Container(
                child: IconButton(
                    onPressed: () {
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
                          ? (index == 0 ? 30 : 24)
                          : (index == 0 ? 34 : 28),
                    )),
              ),
              Text(
                "129",
                style: Theme.of(context).textTheme.headline4!,
              ),
            ],
          );
        },
      ),
    );
  }
}
