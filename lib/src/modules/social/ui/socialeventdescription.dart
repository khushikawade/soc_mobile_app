import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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

  void htmlparser() {
    List<String> data = [];

    data.add(object.description["__cdata"]
        .getElementsByClassName("time")[0]
        .innerHtml);

    var temp = object.description["__cdata"].getElementsByClassName("temp")[0];
    data.add(temp.innerHtml.substring(0, temp.innerHtml.indexOf("<span>")));
    data.add(temp
        .getElementsByTagName("small")[0]
        .innerHtml
        .replaceAll(RegExp("[(|)|℃]"), ""));

    var rows = object.description["__cdata"]
        .getElementsByTagName("table")[0]
        .getElementsByTagName("td");

    rows.map((e) => e.innerHtml).forEach((element) {
      if (element != "-") {
        data.add(element);
      }
    });
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
            SpacerWidget(_kPadding * 5),
            _buildbuttomsection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildbuttomsection(BuildContext context) {
    return Column(
      children: [
        HorzitalSpacerWidget(_kPadding / 2),
        object.description["__cdata"] != null &&
                object.description["__cdata"]
                    .toString()
                    .contains("<img src=") &&
                object.description["__cdata"].toString().split('"')[1] != ""
            ? Html(
                data: "<img" +
                    "${object.description["__cdata"].toString().split("<img")[1].split(">")[0]}" +
                    ">")
            : Container(
                alignment: Alignment.center,
                child: Image(image: AssetImage("assets/images/appicon.png")),
              ),
        Html(
          data:
              "${object.description["__cdata"].toString().replaceAll(new RegExp(r'[\\n]+'), '')}",
        )
      ],
    );
  }

  Widget _buildnews(BuildContext context) {
    return Wrap(children: [
      object != null && object.title["__cdata"].length > 1
          ? Container(
              alignment: Alignment.centerLeft,
              child: Text(
                object.title["__cdata"]
                    .toString()
                    .replaceAll(new RegExp(r'[\\]+'), '\n')
                    .replaceAll("n.", ".")
                    .replaceAll("\nn", "\n"),
                textAlign: TextAlign.left,
              ),
            )
          : Text("No headline found"),
      SpacerWidget(_kPadding),
    ]);
  }

  Widget _buildnewTimeStamp(BuildContext context) {
    return Row(
      children: [
        Container(
            child: object != null && object.pubDate.length > 1
                ? Text(
                    Utility.convertDate(object.pubDate).toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                : Text("No timestamp found")),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Container(child: _buildItem(context))),
    );
  }
}
