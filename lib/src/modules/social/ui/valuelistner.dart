// import 'package:flutter/material.dart';

// class Notifier1 extends StatefulWidget {
//   // const Notifier1({Key? key, required this.title}) : super(key: key);
//   // final String title;

//   @override
//   _Notifier1State createState() => _Notifier1State();
// }

// class _Notifier1State extends State<Notifier1> {
//   final ValueNotifier<int> _counter = ValueNotifier<int>(0);
//   final Widget goodJob = const Text('Good job!');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("TIITLE")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             ValueListenableBuilder<int>(
//               builder: (BuildContext context, int value, Widget? child) {
//                 // This builder will only get called when the _counter
//                 // is updated.
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Text('$value'),
//                     child!,
//                   ],
//                 );
//               },
//               valueListenable: _counter,
//               // The child parameter is most helpful if the child is
//               // expensive to build and does not depend on the value from
//               // the notifier.
//               child: goodJob,
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.plus_one),
//         onPressed: () => _counter.value += 1,
//       ),
//     );
//   }
// }

// class MyListner extends StatefulWidget {
//   // const Notifier1({Key? key, required this.title}) : super(key: key);
//   // final String title;

//   @override
//   _MyListnerState createState() => _MyListnerState();
// }

// class _MyListnerState extends State<MyListner> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.plus_one),
//         onPressed: () => _counter.value += 1,
//       ),
//     );
//   }
// }
