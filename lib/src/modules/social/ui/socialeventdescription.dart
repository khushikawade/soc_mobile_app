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

  void htmlparser() {
    List<String> data = [];

    data.add(object.description["__cdata"]
        .getElementsByClassName("time")[0]
        .innerHtml);

    //declaring variable for temp since we will be using it multiple places
    var temp = object.description["__cdata"].getElementsByClassName("temp")[0];
    data.add(temp.innerHtml.substring(0, temp.innerHtml.indexOf("<span>")));
    data.add(temp
        .getElementsByTagName("small")[0]
        .innerHtml
        .replaceAll(RegExp("[(|)|℃]"), ""));

    //We can also do document.getElementsByTagName("td") but I am just being more specific here.
    var rows = object.description["__cdata"]
        .getElementsByTagName("table")[0]
        .getElementsByTagName("td");

    //Map elememt to its innerHtml,  because we gonna need it.
    //Iterate over all the table-data and store it in the data list
    rows.map((e) => e.innerHtml).forEach((element) {
      if (element != "-") {
        data.add(element);
      }
    });

    //print the data to console.
    // print(data);
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
            // SpacerWidget(_kPadding * 4),
            SpacerWidget(_kPadding / 2),
            _buildDivider(context),
            _buildbuttomsection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _kPadding / 3),
      width: MediaQuery.of(context).size.width * 1,
      height: 1,
      decoration:
          BoxDecoration(border: Border.all(width: 0.50, color: Colors.black)),
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

            // CachedNetworkImage(
            //     imageUrl:
            //         object.description["__cdata"].toString().split('"')[1],
            //     placeholder: (context, url) => Container(
            //       alignment: Alignment.center,
            //       child: CircularProgressIndicator(
            //         strokeWidth: 2,
            //         backgroundColor: AppTheme.kAccentColor,
            //       ),
            //     ),
            //     errorWidget: (context, url, error) => Icon(Icons.error),
            //   )

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
            ) //Html(data: data)
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
