import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentPlusFamilyLogIn extends StatefulWidget {
  const StudentPlusFamilyLogIn({Key? key}) : super(key: key);

  @override
  State<StudentPlusFamilyLogIn> createState() => _StudentPlusFamilyLogInState();
}

class _StudentPlusFamilyLogInState extends State<StudentPlusFamilyLogIn> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                IconData(0xe80d,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kButtonColor,
              ),
              onPressed: () {},
            ),
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SpacerWidget(MediaQuery.of(context).size.height * 0.1),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15),
                alignment: Alignment.center,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Utility.textWidget(
                          text: 'Email',
                          context: context,
                          textTheme: Theme.of(context).textTheme.headline1),
                      SpacerWidget(10),
                      Utility.textWidget(
                          textAlign: TextAlign.center,
                          text:
                              'Enter your email below to receive a one-time password.',
                          context: context,
                          textTheme: Theme.of(context).textTheme.headline3)
                    ]),
              ),
              SpacerWidget(MediaQuery.of(context).size.height * 0.1),
              Container(
                height: MediaQuery.of(context).size.width * 0.42,
                // width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/login_lock.png')),
                    color: Colors.black,
                    shape: BoxShape.circle),
              )
            ],
          ),
        ),
      ],
    );
  }
}
