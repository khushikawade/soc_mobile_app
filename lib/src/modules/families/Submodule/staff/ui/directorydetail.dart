import 'package:Soc/src/widgets/app_bar.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectoryDetailPage extends StatefulWidget {
  DirectoryDetailPage({
    Key? key,
  }) : super(key: key);
  // final String? title;
  @override
  _DirectoryDetailPageState createState() => _DirectoryDetailPageState();
}

class _DirectoryDetailPageState extends State<DirectoryDetailPage> {
  static const double _kLabelSpacing = 16.0;
  Widget _buildIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Container(
              child: Image.asset(
            'assets/images/address.png',
            fit: BoxFit.fill,
            height: 160,
            width: MediaQuery.of(context).size.width * 1,
          )),
        )
      ],
    );
  }

  Widget _buildItemList(String text, IconData icon, String tileCase) {
    return GestureDetector(
      onTap: () {
        switch (tileCase) {
          case "PHONE":
            _launch("tel:" + "1234");
            break;
          case "email":
            _launch("mailto: email@com?");
            break;
          default:
            break;
        }
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 3),
          child: new Column(children: <Widget>[
            ListTile(
              title: new Text(
                text,
                style: new TextStyle(
                  color: Colors.blueGrey[400],
                  fontSize: 20.0,
                ),
              ),
              leading: new Icon(
                icon,
                color: Colors.blue[400],
              ),
            ),
            new Container(
              height: 0.3,
              color: Colors.blueGrey[900],
            ),
          ])),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
          isnewsDescription: false,
          isnewsSearchPage: false,
          title: "Contact Detail"),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(),
          _buildItemList("name", Icons.ac_unit_outlined, "1"),
          _buildItemList("12345", Icons.local_phone, "PHONE"),
          _buildItemList("email", Icons.email, "email"),
          _buildItemList("title", Icons.ac_unit, "1"),
          _buildItemList("description", Icons.ac_unit, "1")
        ],
      )),
    );
  }

  void _launch(String launchThis) async {
    try {
      String url = launchThis;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print("Unable to launch $launchThis");
//        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
