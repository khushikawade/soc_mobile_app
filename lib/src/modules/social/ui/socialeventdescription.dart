import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:html/dom.dart' as dom;
// import 'package:html/parser.dart' show parse;

// ignore: must_be_immutable
class SocialDescription extends StatelessWidget {
  var object;
  SocialDescription({required this.object});
  static const double _kPadding = 16.0;

  RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  int objectindex = 0;
  int? itemcount;
  int pageindex = 0;
  String heading1 = '';
  String heading2 = '';
  String heading3 = '';
  int initailindex = 0;
  int currentindex = 0;
  int firstindex = 0;
  late int lastindex;

  var date;
  var link;
  var link2;
  int pageviewItem = 0;
  int indexpostion = 0;

  void increasIndexValue() {
    this.currentindex++;
  }

  Widget _buildItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_kPadding),
      child: Container(
        child: Column(
          children: [
            _buildnews(context),
            SpacerWidget(_kPadding / 2),
            _buildnewTimeStamp(context),
            SpacerWidget(_kPadding * 4),
            _buildbuttomsection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildbuttomsection(BuildContext context) {
    print(object.description["__cdata"].toString().split('"')[1]);
    return Column(
      children: [
        Row(children: [
          Container(
            width: MediaQuery.of(context).size.width * .92,
            height: 5,
            decoration: BoxDecoration(
                border: Border.all(width: 0.50, color: Colors.black)),
          ),
        ]),
        HorzitalSpacerWidget(_kPadding / 2),
        Column(
          children: [
            object.description["__cdata"] != null &&
                    object.description["__cdata"].toString().split('"')[1] != ""
                ? CachedNetworkImage(
                    imageUrl:
                        object.description["__cdata"].toString().split('"')[1],
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: AppTheme.kAccentColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                : Container(),
            Html(
              data:
                  "${object.description["__cdata"].toString().replaceAll(new RegExp(r'[\\n]+'), '')}",
            ),
          ],
        )
      ],
    );
  }

  Widget _buildnews(BuildContext context) {
    return Wrap(children: [
      object != null && object.title["__cdata"].length > 1
          ? Html(
              data: object.title["__cdata"]
                  .toString()
                  .replaceAll(new RegExp(r'[\\n]+'), '\n'))
          : Text("1"),
      SpacerWidget(_kPadding),
    ]);
  }

  Widget _buildnewTimeStamp(BuildContext context) {
    return Row(
      children: [
        Container(
            child: object != null
                ? Text(
                    Utility.convertDate(object.pubDate).toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                : Text("date")),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Container(child: _buildItem(context))),
    );
  }
}
