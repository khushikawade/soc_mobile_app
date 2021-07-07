import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:flutter/material.dart';

// class StudentPage extends StatefulWidget {
//   StudentPage({Key? key, this.title}) : super(key: key);
//   final String? title;
//   @override
//   _StudentPageState createState() => _StudentPageState();
// }

// class _StudentPageState extends State<StudentPage> {
//   static const double _kLabelSize = 115.0;

//   // Style
//   static const _ktextStyle = TextStyle(
//     height: 1.5,
//     fontFamily: "Roboto Regular",
//     fontSize: 14,
//     color: Color(0xff2D3F98),
//   );

//   Widget build(BuildContext context) {
//     Widget _buildRow1() {
//       return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//         GestureDetector(
//           onTap: () {}, // handle your image tap here
//           child: Container(
//             width: _kLabelSize,
//             height: _kLabelSize,
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/images/request_img.png',
//                   fit: BoxFit.cover, // this is the solution for border
//                   width: _kLabelSize - 25,
//                   height: _kLabelSize - 25,
//                 ),
//                 Text(
//                   "Request",
//                   style: _ktextStyle,
//                 )
//               ],
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {}, // handle your image tap here
//           child: Container(
//             width: _kLabelSize,
//             height: _kLabelSize,
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/images/graduation.png',
//                   fit: BoxFit.cover,

//                   // this is the solution for border
//                   width: _kLabelSize - 25,
//                   height: _kLabelSize - 25,
//                 ),
//                 Text(
//                   "Graduation",
//                   style: _ktextStyle,
//                 )
//               ],
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {}, // handle your image tap here
//           child: Container(
//             width: _kLabelSize,
//             height: _kLabelSize,
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/images/googleclassroom.png',
//                   fit: BoxFit.cover, // this is the solution for border
//                   width: _kLabelSize - 25,
//                   height: _kLabelSize - 25,
//                 ),
//                 Text(
//                   "Google Class",
//                   style: _ktextStyle,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ]);
//     }

//     Widget _buildList() {
//       return Column(
//         children: [
//           _buildRow1(),
//         ],
//       );
//     }

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             children: [_buildList()],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// // void main() => runApp(StudentPage());

// class StudentPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(body: SafeArea(child: Center(child: StudentPage()))));
//   }
// }

// class StudentPage extends StatefulWidget {
//   GridViewState createState() => GridViewState();
// }

// class GridViewState extends State {
//   num countValue = 2;

//   num aspectWidth = 2;

//   num aspectHeight = 1;

//   List<String> Item =

//  List<String>.generate(
//     10,

//   );

//   ];

//   List<String> gridItem = [
//     'Request',
//     'Graduation',
//     'Google Class',
//   ];

//   List<String> gridImageItem = [
//     'assets/images/request_img.png',
//     'assets/images/graduation.png',
//     'assets/images/googleclassroom.png',
//     // 'Four',
//     // 'Five',
//     // 'Six',
//     // 'Seven',
//     // 'Eight',
//     // 'Nine',
//     // 'Ten',
//     // 'Eleven',
//     // 'Twelve',
//     // 'Thirteen',
//     // 'Fourteen',
//     // 'Fifteen',
//     // 'Sixteen',
//     // 'Seventeen',
//     // 'Eighteen',
//     // 'Nineteen',
//     // 'Twenty'
//   ];

//   changeMode() {
//     if (countValue == 2) {
//       setState(() {
//         countValue = 1;
//         aspectWidth = 3;
//         aspectHeight = 1;
//       });
//     } else {
//       setState(() {
//         countValue = 2;
//         aspectWidth = 2;
//         aspectHeight = 1;
//       });
//     }
//   }

//   getGridViewSelectedItem(BuildContext context, String gridItem) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: new Text(gridItem),
//           actions: <Widget>[
//             FlatButton(
//               child: new Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(children: [
//       Expanded(
//         child: GridView.count(
//           crossAxisCount: 3,
//           childAspectRatio: (aspectWidth / aspectHeight),
//           children: gridImageItem
//               .map((data) => GestureDetector(
//                   onTap: () {
//                     getGridViewSelectedItem(context, data);
//                   },
//                   child: Container(
//                       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                       color: Colors.lightBlueAccent,
//                       child: Column(
//                         children: [
//                           Center(
//                               child: Image.asset(
//                             data,
//                             fit:
//                                 BoxFit.cover, // this is the solution for border
//                             width: 50,
//                             height: 50,
//                           )),
//                         ],
//                       ))))
//               .toList(),
//         ),
//       ),
//       Container(
//           margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//           child: RaisedButton(
//             onPressed: () => changeMode(),
//             child: Text(' Change GridView Mode To ListView '),
//             textColor: Colors.white,
//             color: Colors.red,
//             padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
//           ))
//     ]));
//   }
// }

// import 'package:flutter/material.dart';

// class StudentPage extends StatelessWidget {
//   final List<ListItem> items = List<ListItem>.generate(
//     10,
//     (i) => i % 6 == 0
//         ? HeadingItem('Heading $i')
//         : MessageItem('Sender $i', 'Message body $i'),
//   );

//   @override
//   Widget build(BuildContext context) {
//     final title = 'Mixed List';

//     return Scaffold(
//       body: ListView.builder(
//         // Let the ListView know how many items it needs to build.
//         itemCount: items.length,
//         // Provide a builder function. This is where the magic happens.
//         // Convert each item into a widget based on the type of item it is.
//         itemBuilder: (context, index) {
//           final item = items[index];

//           return ListTile(
//             title: item.buildTitle(context),
//             subtitle: item.buildSubtitle(context),
//           );
//         },
//       ),
//     );
//   }
// }

// /// The base class for the different types of items the list can contain.
// abstract class ListItem {
//   /// The title line to show in a list item.
//   Widget buildTitle(BuildContext context);

//   /// The subtitle line, if any, to show in a list item.
//   Widget buildSubtitle(BuildContext context);
// }

// /// A ListItem that contains data to display a heading.
// class HeadingItem implements ListItem {
//   final String heading;

//   HeadingItem(this.heading);

//   @override
//   Widget buildTitle(BuildContext context) {
//     return Text(
//       heading,
//       style: Theme.of(context).textTheme.headline5,
//     );
//   }

//   @override
//   Widget buildSubtitle(BuildContext context) => SizedBox();
// }

// /// A ListItem that contains data to display a message.
// class MessageItem implements ListItem {
//   final String sender;
//   final String body;

//   MessageItem(this.sender, this.body);

//   @override
//   Widget buildTitle(BuildContext context) => Text(sender);

//   @override
//   Widget buildSubtitle(BuildContext context) => Text(body);
// }

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
  static const double _kIconSize = 115.0;
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
