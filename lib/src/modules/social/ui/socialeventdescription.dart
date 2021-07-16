import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/modules/social/ui/SocialAppUrlLauncher.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  int pageindex = 0;
  String heading1 = '';
  String heading2 = '';
  String heading3 = '';
  int index = 0;
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
    _build();
    index = widget.index;
  }

  Widget _builditem1() {
    return Column(children: [
      _buildItem(),
      Expanded(child: Container()),
      buttomButtonsWidget(),
    ]);
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
              object[index]
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

  _build() {
    String s = object[index].title["__cdata"].toString();
    int dex = s.indexOf("!");
    heading1 = s.substring(0, dex + 1).trim();
    // Third
    int dex2 = s.indexOf("#");
    heading3 = s.substring(dex2).trim();
    date = object[index].pubDate;
    link = object[index].link.toString();
    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(link);

    matches.forEach((match) {
      link2 = link.substring(match.start, match.end);
    });
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
          Utility.convertDate(object[index].pubDate).toString(),
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
              color: Color(0xff171717),
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
                  },
                  icon: Icon(
                    const IconData(0xe80c,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Color(0xffbcc5d4),
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(width: _kPadding / 3),
            IconButton(
              onPressed: () {
                _controller.nextPage(duration: _kDuration, curve: _kCurve);
              },
              icon: (Icon(
                const IconData(0xe815,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kBlackColor,
                size: 20,
              )),
            ),
            SizedBox(width: _kPadding / 3),
          ]),
      body: Column(
        children: <Widget>[
          Flexible(
            child: PageView.builder(
              controller: _controller,
              itemCount: object.length,
              onPageChanged: (indexnum) {
                pageindex = indexnum;
                index = indexnum;
                setState(() {
                  _build();
                });
                print(pageindex);
              },
              itemBuilder: (BuildContext context, int index) {
                return _builditem1();
              },
            ),
          ),
        ],
      ),
      bottomSheet: buttomButtonsWidget(),
      //  Container(
      //   height: MediaQuery.of(context).size.height,
      //   color: Color(0xffF5F5F5),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     mainAxisSize: MainAxisSize.max,
      //     children: [
      //       _buildItem(),
      //       Expanded(child: Container()),
      //       buttomButtonsWidget(),
      //     ],
      //   ),
      // ),
    );
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body =
        heading1.toString() + heading3.toString() + link.toString();

    await Share.share(body,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key ?key, this.title}) : super(key: key);

//   final String? title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// int ?pageViewIndex;

// class _MyHomePageState extends State<MyHomePage> {
//   ActionMenu ?actionMenu;
//   final PageController pageController = PageController();
//   int currentPageIndex = 0;
//   int pageCount = 1;

//   @override
//   void initState() {
//     super.initState();
//     actionMenu = ActionMenu(this.addPageView, this.removePageView);
//   }

//   addPageView() {
//     setState(() {
//       pageCount++;
//     });
//   }

//   removePageView(BuildContext context) {
//     if (pageCount > 1)
//       setState(() {
//         pageCount--;
//       });
//     else
//       Scaffold.of(context).showSnackBar(SnackBar(
//         content: Text("Last page"),
//       ));
//   }

//   navigateToPage(int index) {
//     pageController.animateToPage(
//       index,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.ease,
//     );
//   }

//   getCurrentPage(int page) {
//     pageViewIndex = page;
//   }

//   createPage(int page) {
//     return Container(
//       child: Center(
//         child: Text('Page $page'),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: <Widget>[
//           actionMenu,
//         ],
//       ),
//       body: Container(
//         child: PageView.builder(
//           controller: pageController,
//           onPageChanged: getCurrentPage,
//           // itemCount: pageCount,
//           itemBuilder: (context, position) {
//             if (position == 5) return null;
//             return createPage(position + 1);
//           },
//         ),
//       ),
//     );
//   }
// }

// enum MenuOptions { addPageAtEnd, deletePageCurrent }
// List<Widget> listPageView = List();

// class ActionMenu extends StatelessWidget {
//   final Function addPageView, removePageView;
//   ActionMenu(this.addPageView, this.removePageView);

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<MenuOptions>(
//       onSelected: (MenuOptions value) {
//         switch (value) {
//           case MenuOptions.addPageAtEnd:
//             this.addPageView();
//             break;
//           case MenuOptions.deletePageCurrent:
//             this.removePageView(context);
//             break;
//         }
//       },
//       itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//         PopupMenuItem<MenuOptions>(
//           value: MenuOptions.addPageAtEnd,
//           child: const Text('Add Page at End'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.deletePageCurrent,
//           child: Text('Delete Current Page'),
//         ),
//       ],
//     );
//   }
