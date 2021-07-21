// import 'package:flutter/material.dart';

// class SearchBarPage extends StatefulWidget {
//   @override
//   _SearchBarPageState createState() => _SearchBarPageState();
// }

// class _SearchBarPageState extends State<SearchBarPage> {
//   // TODO: Add search history here

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // TODO: Add the FloatingSearchBar here
//       body: SearchResultsListView(
//         searchTerm: '',
//       ),
//     );
//   }
// }

// class SearchResultsListView extends StatelessWidget {
//   final String? searchTerm;

//   const SearchResultsListView({
//     Key? key,
//     @required this.searchTerm,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (searchTerm == null) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.search,
//               size: 64,
//             ),
//             Text(
//               'Start searching',
//               style: Theme.of(context).textTheme.headline5,
//             )
//           ],
//         ),
//       );
//     }

//     return ListView(
//       children: List.generate(
//         50,
//         (index) => ListTile(
//           title: Text('$searchTerm search result'),
//           subtitle: Text(index.toString()),
//         ),
//       ),
//     );
//   }
// }

import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex = 0;
  bool suggestionlist = false;
  static const double _kLabelSpacing = 20.0;
  var _controller = TextEditingController();
  final backColor = AppTheme.kactivebackColor;
  final sebarcolor = AppTheme.kFieldbackgroundColor;
  FocusNode myFocusNode = new FocusNode();
  // Color c = const Color.fromRGBO(142, 142, 147, 0.12);

  static List<String> mainDataList = [
    "Flutter",
  ];

  List<String> newDataList = List.from(mainDataList);

  onItemChanged(String value) {
    suggestionlist = true;
    setState(() {
      newDataList = mainDataList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildSearchbar() {
    return SizedBox(
        height: 50,
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
            color: AppTheme.kFieldbackgroundColor,
            child: TextFormField(
              focusNode: myFocusNode,
              controller: _controller,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Search',
                contentPadding: EdgeInsets.symmetric(
                  vertical: _kLabelSpacing / 2,
                ),
                filled: true,
                fillColor: AppTheme.kBackgroundColor,
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  const IconData(0xe805,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: AppTheme.kprefixIconColor,
                ),
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      suggestionlist = false;
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: AppTheme.kIconColor,
                    size: 18,
                  ),
                ),
              ),
              onChanged: onItemChanged,
            )));

    //   Container(
    //     padding: EdgeInsets.symmetric(
    //         vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 3),
    //     color: AppTheme.kFieldbackgroundColor,
    //     child: TextFormField(
    //       controller: _controller,
    //       focusNode: myFocusNode,
    //       textAlign: TextAlign.start,
    //       style: TextStyle(color: Colors.black),
    //       decoration: InputDecoration(
    //         contentPadding: EdgeInsets.symmetric(
    //           vertical: _kLabelSpacing,
    //         ),
    //         prefixIcon: Icon(
    //           const IconData(0xe805,
    //               fontFamily: Overrides.kFontFam,
    //               fontPackage: Overrides.kFontPkg),
    //           color: AppTheme.kprefixIconColor,
    //           size: 18,
    //         ),
    //         suffix: IconButton(
    //           onPressed: () {
    //             setState(() {
    //               _controller.clear();
    //               suggestionlist = false;
    //             });
    //           },
    //           icon: Icon(
    //             Icons.clear,
    //             color: AppTheme.kIconColor,
    //             size: 18,
    //           ),
    //         ),
    //         filled: true,
    //         fillColor: AppTheme.kBackgroundColor,
    //         enabledBorder: OutlineInputBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //           borderSide: const BorderSide(),
    //         ),
    //         border: OutlineInputBorder(
    //           borderRadius: const BorderRadius.all(
    //             const Radius.circular(10.0),
    //           ),
    //         ),
    //         hintText: 'Search',
    //         hintStyle: TextStyle(
    //           color: AppTheme.kBlackColor,
    //         ),
    //       ),
    //       onChanged: onItemChanged,
    //     ),
    //   ),
    // );
  }

  Widget _buildsuggestionlist() {
    return Expanded(
      child: Container(
          child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(_kLabelSpacing / 2),
        children: newDataList.map((data) {
          return ListTile(
              title: Text(
                data,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                print(data);
              });
        }).toList(),
      )),
    );
  }

  Widget _buildHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        HorzitalSpacerWidget(_kLabelSpacing / 2),
        Text(
          "Search",
          style: Theme.of(context).appBarTheme.titleTextStyle,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildrecentItem() {
    return new Expanded(
        child: new ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                  height: 50,
                  child: ListTile(
                    title: Text(
                      '${mainDataList[index]}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    selected: true,
                    onTap: () {},
                  ));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isnewsDescription: false,
        isnewsSearchPage: true,
      ),
      body: Container(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          _buildHeading(),
          SpacerWidget(_kLabelSpacing / 2),
          _buildSearchbar(),
          suggestionlist ? _buildsuggestionlist() : SizedBox(height: 0),
          suggestionlist == false ? _buildrecentItem() : SizedBox(height: 0),
        ]),
      ),
    );
  }
}