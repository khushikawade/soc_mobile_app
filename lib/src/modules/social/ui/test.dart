import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GrtXmldata extends StatelessWidget {
  Xml2Json xml2json = new Xml2Json(); //Make an instance.

  var link = Uri.parse("https://rss.app/feeds/_DawozSyanCYfGaQg.xml");

  void initState() {
    getData();
    print("init call");
    //
  }

  getData() async {
    http.Response response = await http.get(link);
    xml2json.parse(response.body);
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);
    // print(data["rss"]["channel"]["item"][0]["title"]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: InkWell(
            onTap: () {
              getData();
            },
            child: Text("Family Page")),
      )),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
