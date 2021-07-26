import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

// ignore: must_be_immutable
class SocialDescription extends StatelessWidget {
  var object;

  SocialDescription({required this.object});

  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  var _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
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
    print(data);
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
        Column(
          children: [
            // object.description["__cdata"]
            //     .querySelectorAll('div')
            //     .forEach((value) {
            //   debugPrint(value.outerHtml);
            // }),

            Html(
              data: "${object.description["__cdata"]}",
            ),
            // InkWell(
            //   onTap: () {
            //     var document = parse(object.description["__cdata"]);
            //     dom.Element? link = document.querySelector('div');
            //     String? imageLink = link != null ? link.attributes[''] : '';

            //     print(imageLink);
            //   },
            //   child: Text(
            //     "#Solvedconsulting #k12 education #edtech #edtechers #appdesign #schoolapp",
            //     style: Theme.of(context).textTheme.subtitle1,
            //   ),
            // ),
          ],
        )
      ],
    );
  }

  Widget _buildnews(BuildContext context) {
    return Column(
      children: [
        Wrap(children: [
          object != null && object.title["__cdata"].length > 1
              ? Text(
                  object.title["__cdata"]
                      .replaceAll(new RegExp(r'[^\w\s]+'), ''),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline2,
                )
              : Text("1"),
          SpacerWidget(_kPadding),
          // Container(
          //     width: MediaQuery.of(context).size.width * .90,
          //     child: Text(
          //       "heading3",
          //       overflow: TextOverflow.ellipsis,
          //       maxLines: 5,
          //       style: Theme.of(context).textTheme.headline2,
          //     )),
        ]),
      ],
    );
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
