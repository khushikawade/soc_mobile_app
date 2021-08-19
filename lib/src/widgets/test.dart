import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  // @override
  // void initState() {
  //   super.initState();
  //   random = Random();
  //   refreshList();
  // }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      new HomePage();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pull to refresh"),
      ),
      body: new DefaultTabController(
        length: 5,
        child: new Column(
          children: <Widget>[
            new Container(
              width: 1200.0,
              child: new Material(
                color: Colors.lightBlue,
                child: new TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      child:
                          new Text("All", style: new TextStyle(fontSize: 20.0)),
                    ),
                    Tab(
                      child: new Text("Moving",
                          style: new TextStyle(fontSize: 20.0)),
                    ),
                    Tab(
                      child: new Text("Idle",
                          style: new TextStyle(fontSize: 20.0)),
                    ),
                    Tab(
                      child: new Text("Parked",
                          style: new TextStyle(fontSize: 20.0)),
                    ),
                    Tab(
                      child: new Text("Inactive",
                          style: new TextStyle(fontSize: 20.0)),
                    ),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: new TabBarView(
                children: [
                  Tab(
                    child: new RefreshIndicator(
                      child: new ListView(
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              new Center(
                                child: new Text("Demo",
                                    style: new TextStyle(fontSize: 20.0)),
                              )
                            ],
                          )
                        ],
                      ),
                      onRefresh: refreshList,
                      key: refreshKey,
                    ),
                  ),
                  Tab(
                    child:
                        new Text("Demo", style: new TextStyle(fontSize: 20.0)),
                  ),
                  Tab(
                    child:
                        new Text("Demo", style: new TextStyle(fontSize: 20.0)),
                  ),
                  Tab(
                    child:
                        new Text("Demo", style: new TextStyle(fontSize: 20.0)),
                  ),
                  Tab(
                    child:
                        new Text("Demo", style: new TextStyle(fontSize: 20.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
