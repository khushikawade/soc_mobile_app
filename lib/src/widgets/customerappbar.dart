// import 'package:flutter/material.dart';

// class CustomAppBar extends PreferredSize {
//   final Widget child;
//   final double height;

//   CustomAppBar({required this.child, this.height = kToolbarHeight});

//   @override
//   Size get preferredSize => Size.fromHeight(height);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(0.0),
//       padding: EdgeInsets.only(
//           top: MediaQuery.of(context).padding.top - 7,
//           left: 0,
//           right: 0,
//           bottom: 0),
//       height: preferredSize.height,
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey,
//             offset: Offset(0.0, 1.0), //(x,y)
//             blurRadius: 10.0,
//           ),
//         ],
//       ),
//       alignment: Alignment.center,
//       child: child,
//     );
//   }
// }
