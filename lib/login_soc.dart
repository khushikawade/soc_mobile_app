import 'package:Soc/src/startup.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

class SchoolIDLogin extends StatefulWidget {
  @override
  _SchoolIDLoginState createState() => _SchoolIDLoginState();
}

class _SchoolIDLoginState extends State<SchoolIDLogin> {
  TextEditingController schoolController = TextEditingController();
  TextEditingController pushAppIdController = TextEditingController();
  TextEditingController restKeyController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              title: Text('School Login',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Colors.white))),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: schoolController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'School Id',
                    ),
                    style: Theme.of(context).textTheme.headline2!,
                    onSaved: (e) {},
                  )),
              // Container(
              // margin: EdgeInsets.all(20),
              // child: TextFormField(
              //   controller: pushAppIdController,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Push App ID',
              //   ),
              //   style: Theme.of(context).textTheme.headline2!,
              //   onSaved: (e) {},
              // )),
              // Container(
              // margin: EdgeInsets.all(20),
              // child: TextFormField(
              //   controller: restKeyController,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Onesignal Rest Key',
              //   ),
              //   style: Theme.of(context).textTheme.headline2!,
              //   onSaved: (e) {},
              // )),
              ElevatedButton(
                  onPressed: () {
                    if (schoolController.text != "") {
                      Overrides.SCHOOL_ID = schoolController.text;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartupPage()));
                    }
                    // if (pushAppIdController.text != "") {
                    //   Overrides.PUSH_APP_ID = pushAppIdController.text;
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => StartupPage()));
                    // }
                    // if (restKeyController.text != "") {
                    //   Overrides.REST_API_KEY = restKeyController.text;
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => StartupPage()));
                    // } else {
                    //   Utility.showSnackBar(
                    //       _scaffoldKey, "All fields are required", context);
                    // }
                  },
                  child: Text(
                    "Submit",
                  ))
            ],
          )),
    );
  }
}
