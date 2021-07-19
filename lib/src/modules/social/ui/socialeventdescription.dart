import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/modules/social/ui/SocialAppUrlLauncher.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../../../overrides.dart';

// ignore: must_be_immutable
class SocialEventDescription extends StatefulWidget {
  SocialEventDescription({required this.obj, required this.index});
  // List<Item>? obj;
  var obj;
  int index;
  @override
  _SocialEventDescriptionState createState() => _SocialEventDescriptionState();
}

class _SocialEventDescriptionState extends State<SocialEventDescription> {
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  var _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  int? itemcount;
  int pageindex = 0;
  String heading1 = '';
  String heading2 = '';
  String heading3 = '';
  int initailindex = 0;
  int currentindex = 0;
  int firstindex = 0;
  late int lastindex;
  var object;
  var date;
  var link;
  var link2;

  @override
  void initState() {
    super.initState();
    object = widget.obj;
    lastindex = object.length;
    itemcount = lastindex;
    currentindex = int.parse("${widget.index}");
    print("                          CURENT INDEX");
    print(currentindex);

    _build();
  }

  // _maps() {
  //   List<Item> list = [];
  //   for (int i = 0; i < object.length; i++) {
  //     Item customObject = Item(title: [i][obj]['key'], weight: map[i]['key']);
  //     list.add(CustomObject);
  //   }
  // }

  Widget _builditem1() {
    return Column(children: [
      _buildItem(),
      Expanded(child: Container()),
      buttomButtonsWidget(),
    ]);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_controller.hasClients) _controller.jumpToPage(currentindex);
    });

    super.didChangeDependencies();
  }

  Widget _buildItem() {
    return Padding(
      padding: const EdgeInsets.all(_kPadding),
      child: Container(
        child: Column(
          children: [
            _buildnews(),
            SpacerWidget(_kPadding / 2),
            _buildnewTimeStamp(),
            SpacerWidget(_kPadding * 4),
            _buildbuttomsection(),
          ],
        ),
      ),
    );
  }

  Widget _buildbuttomsection() {
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
            Text(
              object[currentindex]
                  .title["__cdata"]
                  .replaceAll(new RegExp(r'[^\w\s]+'), ''),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              "#Solvedconsulting #k12 educatio #edtech #edtechers #appdesign #schoolapp",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildnews() {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width * .90,
            child: heading1.isNotEmpty && heading1.length > 1
                ? Text(
                    heading1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: Theme.of(context).textTheme.headline2,
                  )
                : Text("1")),
        SpacerWidget(_kPadding),
        Container(
            width: MediaQuery.of(context).size.width * .90,
            child: heading3.isNotEmpty && heading3.length > 1
                ? Text(
                    heading3,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: Theme.of(context).textTheme.headline2,
                  )
                : Text("3")),
      ],
    );
  }

  Widget _buildnewTimeStamp() {
    return Row(
      children: [
        Container(
            child: Text(
          Utility.convertDate(object[currentindex].pubDate).toString(),
          style: Theme.of(context).textTheme.subtitle1,
        )),
      ],
    );
  }

  Widget buttomButtonsWidget() {
    return Container(
      padding: EdgeInsets.all(_kPadding / 2),
      color: AppTheme.kBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: _KButtonSize,
            height: _KButtonSize / 2,
            child: ElevatedButton(
              onPressed: () {
                print(link2);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SocialAppUrlLauncher(link: link2)));
              },
              child: Text("More"),
            ),
          ),
          SizedBox(
            width: _kPadding / 2,
          ),
          SizedBox(
            width: _KButtonSize,
            height: _KButtonSize / 2,
            child: ElevatedButton(
              onPressed: () {
                _onShareWithEmptyOrigin(context);
              },
              child: Text("Share"),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          elevation: 0.0,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              const IconData(0xe80d,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: AppTheme.kIconColor1,
              size: 20,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 100.0, height: 50.0, child: BearIconWidget()),
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _controller.previousPage(
                        duration: _kDuration, curve: _kCurve);
                    if (currentindex > -1 && currentindex < object.length) {
                      _controller.previousPage(
                          duration: _kDuration, curve: _kCurve);
                      currentindex = currentindex - 1;
                      print("**************************************");

                      _build();
                    }
                  },
                  icon: Icon(
                    const IconData(0xe80c,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: currentindex == initailindex
                        ? AppTheme.kDecativeIconColor
                        : AppTheme.kBlackColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(width: _kPadding / 3),
            IconButton(
              onPressed: () {
                if (currentindex > -1 && currentindex < object.length) {
                  currentindex = currentindex + 1;
                  print("**************************************");
                  _controller.nextPage(duration: _kDuration, curve: _kCurve);

                  _build();
                }

                _controller.nextPage(duration: _kDuration, curve: _kCurve);
              },
              icon: (Icon(
                const IconData(0xe815,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: currentindex == lastindex
                    ? AppTheme.kDecativeIconColor
                    : AppTheme.kBlackColor,
                size: 20,
              )),
            ),
            SizedBox(width: _kPadding / 3),
          ]),
      body: currentindex != null && currentindex < object.length
          ? Column(
              children: <Widget>[
                Flexible(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: itemcount,
                    onPageChanged: (indexnum) {
                      pageindex = indexnum;
                      // _build();
                      // currentindex = indexnum;
                      // setState(() {
                      //   _build();
                      //   print(currentindex);
                      // });
                      print(pageindex);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return _builditem1();
                    },
                  ),
                ),
              ],
            )
          : Container(),
      bottomSheet: buttomButtonsWidget(),
    );
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body =
        heading1.toString() + heading3.toString() + link.toString();

    await Share.share(body,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  _build() async {
    print("inside build bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
    String s = object[currentindex]
        .title["__cdata"]
        .replaceAll(new RegExp(r'[^\w\s]+'), '');
    //   // .toString()
    //   // .trim();
    // int dex = s.indexOf("!");
    // heading1 = s.substring(0, dex + 1).trim();
    heading1 = s;
    // Third
    // int dex2 = s.indexOf("#");
    // heading3 = s.substring(dex2).trim();
    date = object[currentindex].pubDate;
    link = object[currentindex].link.toString();
    print("*********************link*******************************");
    print(link);
    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(link);
    matches.forEach((match) {
      link2 = link.substring(match.start, match.end);
    });
    print(
        "******************************LINK LINK LINK************************");
    print(link2);
    setState(() {});
  }
}
