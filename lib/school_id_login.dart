import 'package:Soc/src/modules/user/ui/startup.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';

class SchoolIDLogin extends StatefulWidget {
  @override
  _SchoolIDLoginState createState() => _SchoolIDLoginState();
}

class _SchoolIDLoginState extends State<SchoolIDLogin> {
  TextEditingController schoolController = TextEditingController();
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
          body: Center(
              child: Column(
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
              ElevatedButton(
                  onPressed: () {
                    if (schoolController.text != "") {
                      Overrides.SCHOOL_ID = schoolController.text;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartupPage()));
                    } else {
                      Utility.showSnackBar(
                          _scaffoldKey, "Please enter school id", context);
                    }
                  },
                  child: Text(
                    "Submit",
                  ))
            ],
          ))),
    );
  }
}
