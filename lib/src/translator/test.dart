import 'package:flutter/material.dart';

class Buttomsearch extends StatefulWidget {
  _ButtomsearchState createState() => _ButtomsearchState();
}

class _ButtomsearchState extends State<Buttomsearch> {
  List<String>? _tempListOfCities;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController textController = new TextEditingController();

  static List<String> _listOfCities = <String>[
    "Tokyo",
    "New York",
    "London",
    "Paris",
    "Madrid",
    "Dubai",
    "Rome",
    "Barcelona",
    "Cologne",
    "Monte Carlo",
    "Puebla",
    "Florence"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("text"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Show bottom sheet"),
              onPressed: () {
                _showModal(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showModal(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Column(children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: TextField(
                                  controller: textController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _tempListOfCities =
                                          _buildSearchList(value);
                                    });
                                  })),
                          IconButton(
                              icon: Icon(Icons.close),
                              color: Color(0xFF1F91E7),
                              onPressed: () {
                                setState(() {
                                  textController.clear();
                                  _tempListOfCities!.clear();
                                });
                              }),
                        ])),
                    Expanded(
                      child: ListView.separated(
                          controller: scrollController,
                          itemCount: (_tempListOfCities != null &&
                                  _tempListOfCities!.length > 0)
                              ? _tempListOfCities!.length
                              : _listOfCities.length,
                          separatorBuilder: (context, int) {
                            return Divider();
                          },
                          itemBuilder: (context, index) {
                            return InkWell(
                                child: (_tempListOfCities != null &&
                                        _tempListOfCities!.length > 0)
                                    ? _showBottomSheetWithSearch(
                                        index, _tempListOfCities!)
                                    : _showBottomSheetWithSearch(
                                        index, _listOfCities),
                                onTap: () {
                                  _scaffoldKey.currentState!.showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text((_tempListOfCities !=
                                                      null &&
                                                  _tempListOfCities!.length > 0)
                                              ? _tempListOfCities![index]
                                              : _listOfCities[index])));

                                  Navigator.of(context).pop();
                                });
                          }),
                    )
                  ]);
                });
          });
        });
  }

  Widget _showBottomSheetWithSearch(int index, List<String> listOfCities) {
    return Text(listOfCities[index],
        style: TextStyle(color: Colors.black, fontSize: 16),
        textAlign: TextAlign.center);
  }

  List<String> _buildSearchList(String userSearchTerm) {
    List<String> _searchList = [""];

    for (int i = 0; i < _listOfCities.length; i++) {
      String name = _listOfCities[i];
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(_listOfCities[i]);
      }
    }
    return _searchList;
  }
}
