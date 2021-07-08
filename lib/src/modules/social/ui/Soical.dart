import 'dart:ui';

import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SocialPage extends StatefulWidget {
  SocialPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  static const double _kLabelSpacing = 16.0;

//Style

  static const _kListTextStyle = TextStyle(
      fontFamily: "Roboto",
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Color(0xff2D3F98));

  static const _kListDateStyle = TextStyle(
      fontFamily: "Roboto Regular",
      fontWeight: FontWeight.bold,
      fontSize: 13,
      color: Color(0xff2D3F98));

  Widget _buildlist(int index) {
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
        vertical: _kLabelSpacing / 2,
      ),
      color: (index % 2 == 0)
          ? Theme.of(context).backgroundColor
          : AppTheme.kListBackgroundColor2,
      child: Row(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.17,
                child: Container(
                    child: ClipRRect(
                        child: Image.network(
                  'https://picsum.photos/250?image=9',
                  fit: BoxFit.fill,
                ))),
              ),
            ],
          ),
          SizedBox(
            width: _kLabelSpacing / 2,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.69,
                        child: Text(
                          "Check out these book suggestions for your summer reading !",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: _kListTextStyle,
                        )),
                  ],
                ),
                SizedBox(height: _kLabelSpacing / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        // width: MediaQuery.of(context).size.width * 0.40,
                        child: Text(
                      "${currentDate}",
                      style: _kListDateStyle,
                    )),
                  ],
                ),
              ]),
        ],
      ),
    );
  }

  Widget makeList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return _buildlist(index);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Container(
          child: Column(
            children: [makeList()],
          ),
        ),
      ]),
    );
  }
}
