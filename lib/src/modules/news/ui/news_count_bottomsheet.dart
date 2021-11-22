// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class NewsCountSheet extends StatefulWidget {
  

//   final double like;
//   final double thanks;
//   final double helpful;
//   final double share;
//   final List icons;
//   final List iconsName;
//   @override
//   NewsCountSheet({
//     Key? key,
//     required this.like,
//     required this.thanks, 
//     required this.helpful,
//     required this.share,
//     required this.icons,
//     required this.iconsName,
//   }) : super(key: key);
//   @override
//   State<StatefulWidget> createState() => NewsCountSheetState();
// }

// class NewsCountSheetState extends State<NewsCountSheet>
//     with SingleTickerProviderStateMixin {
//   AnimationController? controller;
//   Animation<double>? scaleAnimation;
//   // static const double _kLableSpacing = 10.0;
//   static const double _kIconSize = 45.0;

//   @override
//   void initState() {
//     super.initState();
//     controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 450));
//     scaleAnimation =
//         CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

//     controller!.addListener(() {
//       setState(() {});
//     });
//     controller!.forward();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Material(
//         color: Colors.white,
//         child: ScaleTransition(
//           scale: scaleAnimation!,
//           child: Container(
//             margin: const EdgeInsets.only(
//                 top: 20, left: 20.0, right: 20, bottom: 20),
//             height: MediaQuery.of(context).size.height * 0.1,
//             decoration: ShapeDecoration(
//                 // color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0))),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//               child:InteractiveViewer(panEnabled: true, // Set it to false
//               clipBehavior: Clip.none,
//                 // boundaryMargin: EdgeInsets.all(100),
//                 minScale: 0.5,
//                 maxScale: 5,
//                 child: Container(
//       // height: 50,
//       child: ListView.builder(
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemCount: widget.icons.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     child: IconButton(
//                         padding: EdgeInsets.only(
//                             left: MediaQuery.of(context).size.width * 0.07),
//                         constraints: BoxConstraints(),
//                         onPressed: () {
//                         },
//                         icon: Icon(
//       IconData(widget.icons[index],
//           fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//       color:Colors.black
//         ,
//       // totalCountIcon ? (index==0?Colors.red:index==1?Colors.blue:Colors.green ): (Theme.of(context).colorScheme.primary),
//       //Icons.favorite_outline_outlined,
//       size:  Globals.deviceType == "phone"
//               ? (index == 0 ? 25 : 22)
//               : (index == 0 ? 26 : 20)
          
//     )),
//                   ),
//                   // widget.isLoading == true ? Container() : _likeCount(index)
//                 ],
//               ),
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.only(
//                       left: MediaQuery.of(context).size.width * 0.05
//                   ),
//                   child: Row(
//                     // mainAxisSize: MainAxisSize.min,
//                     // mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                      _likeCount(index),
//                       Container(
//                           padding:
//                              EdgeInsets.only(left: 2) ,
//                           child: Text(widget.iconsName[index])),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _likeCount(index) {
//     return GestureDetector(
//           onTap: () {},
//           child: Text(
//             index == 0
//                 ? "1"
//                 : index == 1
//                     ? "2"
//                     : index == 2
//                         ? "3"
//                         : "4",
//             style: Theme.of(context).textTheme.headline4!,
//           ),
//     );
//   }
// }
