import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 8.0,
            children: List.generate(choices.length, (index) {
              return Center(
                child: SelectCard(choice: choices[index]),
              );
            })));
  }
}

class Choice {
  const Choice({required this.title, required this.icon});
  final String title;
  final String icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Request', icon: 'assets/images/request_img.png'),
  const Choice(title: 'Graduation', icon: 'assets/images/graduation.png'),
  const Choice(
      title: 'Google Class', icon: 'assets/images/googleclassroom.png'),
  const Choice(title: 'Classdojo', icon: 'assets/images/classdojo.png'),
  const Choice(title: 'PupilPath', icon: 'assets/images/pupilpath.png'),
  const Choice(title: 'Meets', icon: 'assets/images/meet.png'),
  const Choice(title: 'Zoom', icon: 'assets/images/Zoom.png'),
  const Choice(title: 'IXL', icon: 'assets/images/IXL.png'),
  const Choice(title: 'PBS Kids', icon: 'assets/images/PBS_kids_img.png'),
  const Choice(title: 'EDpuzzle', icon: 'assets/images/Edpuzzle.png'),
  const Choice(title: 'PearDeck', icon: 'assets/images/PearDeack.png'),
  const Choice(title: 'NearPod', icon: 'assets/images/nearpod.png'),
];

class SelectCard extends StatelessWidget {
  const SelectCard({required this.choice});
  final Choice choice;
  static const double _kIconSize = 105.0;
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      height: 1.5,
      fontFamily: "Roboto Regular",
      fontSize: 14,
      color: Color(0xff2D3F98),
    );
    return Container(
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Image.asset(
                  choice.icon,
                  fit: BoxFit.cover, // this is the solution for border
                  width: _kIconSize,
                  height: _kIconSize,
                ),
              ),
              Text(choice.title, style: textStyle),
            ]),
      ),
    );
  }
}
