// import 'package:Soc/src/modules/PBISPlus_plus/modal/course_modal.dart';
// import 'package:Soc/src/modules/PBISPlus_plus/widgets/inherited_widget.dart';
// import 'package:flutter/widgets.dart';

// class StateWidget extends StatefulWidget {
//   List<Course> data;
//   Widget child;

//   StateWidget({
//     Key? key,
//     required this.data,
//     required this.child,
//   }) : super(
//           key: key,
//         );

//   @override
//   _StateWidgetState createState() => _StateWidgetState();
// }

// class _StateWidgetState extends State<StateWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return MyInheritedWidget(child: widget.child, data: widget.data);
//   }
// }

// class MyInheritedWidget extends InheritedWidget {
//   const MyInheritedWidget({
//     Key? key,
//     required this.data,
//     required Widget child,
//   }) : super(key: key, child: child);

//   final List<Course> data;

//   static MyInheritedWidget? of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
//   }

//   @override
//   bool updateShouldNotify(MyInheritedWidget oldWidget) {
//     return oldWidget.data != data;
//   }
// }
