import 'package:Soc/src/modules/families/ui/family.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/model/search_list.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final _debouncer = Debouncer(milliseconds: 500);
  HomeBloc _searchBloc = new HomeBloc();

  static List<String> mainDataList = ["Flutter", "f", "angular"];

  List<String> newDataList = [''];

  onItemChanged(String value) {
    suggestionlist = true;
    _debouncer.run(() {
      _searchBloc.add(GlobalSearchEvent(keyword: value));
      setState(() {});
    });

    // setState(() {
    //   newDataList = mainDataList
    //       .where((string) => string.toLowerCase().contains(value.toLowerCase()))
    //       .toList();
    // });
  }

  _route(SearchList data) {
    if (data.attributes!.type == "Families_App__c") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => FamilyPage(searchObj: data)));
    } else if (data.attributes!.type == "Staff_App__c") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffPage(searchObj: data)));
    } else if (data.attributes!.type == "Family_Sub_Menu_App__c") {
    } else if (data.attributes!.type == "Staff_Sub_Menu_App__c") {
    } else if (data.attributes!.type == "Student_App__c ") {}

    // setState(() {
    //   _selectedIndex = index;
    // });
  }

  Widget _buildSearchbar() {
    return SizedBox(
        height: 50,
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
            color: AppTheme.kFieldbackgroundColor,
            child: TextFormField(
              // focusNode: myFocusNode,
              controller: _controller,
              cursorColor: Colors.black,
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
  }

  Widget _buildsuggestionlist() {
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: _searchBloc,
        builder: (BuildContext contxt, HomeState state) {
          if (state is GlobalSearchSuccess) {
            return Expanded(
                child: state.obj.map != null && state.obj.length > 0
                    ? Container(
                        margin: EdgeInsets.only(
                            left: _kLabelSpacing / 2,
                            right: _kLabelSpacing / 2,
                            bottom: _kLabelSpacing * 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0)),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(_kLabelSpacing / 2),
                          children: state.obj.map<Widget>((data) {
                            return ListTile(
                                title: Text(
                                  data.id,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                onTap: () {
                                  _route(data);
                                  print(data.id);
                                });
                          }).toList(),
                        ))
                    : Container());
          } else if (state is SearchLoading) {
            return Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                )),
              ),
            );
          } else {
            return Container();
          }
        });
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
            itemCount: 3,
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
      appBar: AppBar(
          elevation: 0.0,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    const IconData(0xe80d,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: AppTheme.kIconColor1,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          title: SizedBox(width: 100.0, height: 60.0, child: BearIconWidget())),
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
