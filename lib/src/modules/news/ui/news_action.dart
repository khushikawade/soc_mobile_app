// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
// import 'package:Soc/src/modules/news/model/notification_list.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/material.dart';

// class NewsActionButton extends StatefulWidget {
//   NewsActionButton(
//       {Key? key,
//       required this.newsObj,
//       required this.icons,
//       this.isLoading,
//       required this.iconsName})
//       : super(key: key);

//   final NotificationList newsObj;
//   final List? icons;
//   final List? iconsName;
//   final bool? isLoading;

//   _NewsActionButtonState createState() => _NewsActionButtonState();
// }

// class _NewsActionButtonState extends State<NewsActionButton> {
//   NewsBloc bloc = new NewsBloc();
//   final ValueNotifier<double> like = ValueNotifier<double>(0);
//   final ValueNotifier<double> thanks = ValueNotifier<double>(0);
//   final ValueNotifier<double> helpful = ValueNotifier<double>(0);
//   final ValueNotifier<double> share = ValueNotifier<double>(0);
//   final ValueNotifier<double> totalReactions = ValueNotifier<double>(0);
//   static const double _kLabelSpacing = 16.0;

//   @override
//   void initState() {
//     super.initState();
//     reactionCount(null);

//     totalReactions.value = (double.parse(widget.newsObj.likeCount.toString()) +
//         double.parse(widget.newsObj.thanksCount.toString()) +
//         double.parse(widget.newsObj.helpfulCount.toString()));

// // print(totalReactions.value);
//     // like.value = widget.newsObj.likeCount!;
//     // thanks.value = widget.newsObj.thanksCount!;
//     // helpful.value = widget.newsObj.helpfulCount!;
//     // share.value = widget.newsObj.shareCount!;
//   }

//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         SpacerWidget(5),
//         Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: _kLabelSpacing,
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _reactionIcons(context),
//                   totalReactions.value == 0.0
//                       ? Container(
//                           child: Text("Be the first to react !!"),
//                         )
//                       : Container(),
//                 ],
//               ),
//               Container(
//                 child: Text(
//                   "${share.value == 0.0 ? widget.newsObj.shareCount.toString().split('.')[0] : share.value.toString().split('.')[0]} Shares",
//                 ),
//               )
//             ],
//           ),
//         ),
//         SpacerWidget(5),
//         Container(
//           height: 0.2,
//           color: Colors.grey,
//         ),
//         SpacerWidget(5),
//         mainReactionIcons(false)
//       ],
//     );
//   }

//   Widget mainReactionIcons(bool isCount) {
//     return Container(
//       height: 41,
//       child: ListView.builder(
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemCount: widget.icons!.length,
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
//                   isCount == true
//                       ? Container(
//                           child: index < 3
//                               ? IconButton(
//                                   padding: EdgeInsets.only(
//                                       left: MediaQuery.of(context).size.width *
//                                           0.19),
//                                   constraints: BoxConstraints(),
//                                   onPressed: () {},
//                                   icon: iconListWidget(context, index, false))
//                               : null,
//                         )
//                       : Container(
//                           child: IconButton(
//                               padding: EdgeInsets.only(
//                                   left:
//                                       MediaQuery.of(context).size.width * 0.11),
//                               constraints: BoxConstraints(),
//                               onPressed: () {
//                                 reactionCount(index);
//                                 // increamentValue(index);
//                                 index == 0
//                                     ? like.value = like.value != 0.0
//                                         ? like.value + 1
//                                         : widget.newsObj.likeCount! + 1
//                                     : index == 1
//                                         ? thanks.value = thanks.value != 0.0
//                                             ? thanks.value + 1
//                                             : widget.newsObj.thanksCount! + 1
//                                         : index == 2
//                                             ? helpful.value = helpful.value !=
//                                                     0.0
//                                                 ? helpful.value + 1
//                                                 : widget.newsObj.helpfulCount! +
//                                                     1
//                                             : share.value = share.value != 0.0
//                                                 ? share.value + 1
//                                                 : widget.newsObj.shareCount! +
//                                                     1;

//                                 index == 0
//                                     ? widget.newsObj.likeCount = like.value
//                                     : index == 1
//                                         ? widget.newsObj.thanksCount =
//                                             thanks.value
//                                         : index == 2
//                                             ? widget.newsObj.helpfulCount =
//                                                 helpful.value
//                                             : widget.newsObj.shareCount =
//                                                 share.value;

//                                 bloc.add(NewsAction(
//                                     notificationId: widget.newsObj.id,
//                                     schoolId: Overrides.SCHOOL_ID,
//                                     like: index == 0 ? "1" : "",
//                                     thanks: index == 1 ? "1" : "",
//                                     helpful: index == 2 ? "1" : "",
//                                     shared: index == 3 ? "1" : ""));
//                               },
//                               icon: iconListWidget(context, index, false)),
//                         ),
//                   // widget.isLoading == true ? Container() : _likeCount(index)
//                 ],
//               ),
//               isCount == true
//                   ? Expanded(
//                       child: index < 3
//                           ? Container(
//                               padding: EdgeInsets.only(
//                                   left:
//                                       // isCount == true
//                                       //     ?
//                                       MediaQuery.of(context).size.width * 0.15),
//                               // : MediaQuery.of(context).size.width * 0.10),
//                               child: Row(
//                                 // mainAxisSize: MainAxisSize.min,
//                                 // mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   isCount == true
//                                       ? _likeCount(index)
//                                       : Container(),
//                                   Container(
//                                       padding: isCount == true
//                                           ? EdgeInsets.only(left: 2)
//                                           : null,
//                                       child: Text(widget.iconsName![index])),
//                                 ],
//                               ),
//                             )
//                           : Container(),
//                     )
//                   : Expanded(
//                       child: Container(
//                         padding: EdgeInsets.only(
//                             left: isCount == true
//                                 ? MediaQuery.of(context).size.width * 0.07
//                                 : MediaQuery.of(context).size.width * 0.10),
//                         child: Row(
//                           // mainAxisSize: MainAxisSize.min,
//                           // mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             isCount == true ? _likeCount(index) : Container(),
//                             Container(
//                                 padding: isCount == true
//                                     ? EdgeInsets.only(left: 2)
//                                     : null,
//                                 child: Text(widget.iconsName![index])),
//                           ],
//                         ),
//                       ),
//                     )
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _reactionIcons(context) {
//     return Row(
//       children: [
//         Container(
//           height: 30,
//           child: ListView.builder(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemCount: widget.icons!.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return index < 3
//                     ? GestureDetector(
//                         onTap: () {
//                           _openReactionBottomSheet(context, index);
//                           //  showDialog(
//                           //             context: context,
//                           //             builder: (_) =>
//                           // NewsCountSheet(like: like.value, thanks: thanks.value, helpful: helpful.value, share: share.value, icons:widget.icons!, iconsName: widget.iconsName!)
//                           //  );
//                         },
//                         child: Container(
//                             margin: EdgeInsets.only(right: 3),
//                             padding: EdgeInsets.only(left: 1),
//                             alignment: Alignment.center,
//                             width: 20.0,
//                             height: 20.0,
//                             decoration: new BoxDecoration(
//                               color: index == 0
//                                   ? Colors.red.withOpacity(0.8)
//                                   : index == 1
//                                       ? Colors.blue.withOpacity(0.8)
//                                       : Colors.green.withOpacity(0.8),
//                               shape: BoxShape.circle,
//                             ),
//                             child: iconListWidget(context, index, true)),
//                       )
//                     : Container();
//               }),
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 5),
//           child: Text("${totalReactions.value.toString().split('.')[0]}"),
//         )
//       ],
//     );
//   }

//   Widget iconListWidget(context, index, bool totalCountIcon) {
//     return Icon(
//       IconData(widget.icons![index],
//           fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//       color: totalCountIcon
//           ? Colors.black
//           : (Theme.of(context).colorScheme.primary),
//       // totalCountIcon ? (index==0?Colors.red:index==1?Colors.blue:Colors.green ): (Theme.of(context).colorScheme.primary),
//       //Icons.favorite_outline_outlined,
//       size: totalCountIcon
//           ? Globals.deviceType == "phone"
//               ? (index == 0 ? 14 : 12)
//               : (index == 0 ? 26 : 20)
//           : Globals.deviceType == "phone"
//               ? (index == 0 ? 23 : 18)
//               : (index == 0 ? 26 : 20),
//     );
//   }

//   Widget _likeCount(index) {
//     return ValueListenableBuilder(
//       builder: (BuildContext context, dynamic value, Widget? child) {
//         return GestureDetector(
//           onTap: () {},
//           child: Text(
//             index == 0
//                 ? (like.value != 0.0
//                     ? like.value.toString().split('.')[0]
//                     : widget.newsObj.likeCount.toString().split('.')[0])
//                 : index == 1
//                     ? (thanks.value != 0.0
//                         ? thanks.value.toString().split('.')[0]
//                         : widget.newsObj.thanksCount.toString().split('.')[0])
//                     : index == 2
//                         ? (helpful.value != 0.0
//                             ? helpful.value.toString().split('.')[0]
//                             : widget.newsObj.helpfulCount
//                                 .toString()
//                                 .split('.')[0])
//                         : (share.value != 0.0
//                             ? share.value.toString().split('.')[0]
//                             : widget.newsObj.shareCount
//                                 .toString()
//                                 .split('.')[0]),
//             style: Theme.of(context).textTheme.headline4!,
//           ),
//         );
//       },
//       valueListenable: index == 0
//           ? like
//           : index == 1
//               ? thanks
//               : index == 2
//                   ? helpful
//                   : share,
//       child: Container(),
//     );
//   }

//   _openReactionBottomSheet(context, index) {
//     Future<void> future = showModalBottomSheet<void>(
//         // isScrollControlled: true,
//         shape: RoundedRectangleBorder(
//             borderRadius: new BorderRadius.only(
//                 topLeft: Radius.circular(AppTheme.kBottomSheetModalUpperRadius),
//                 topRight:
//                     Radius.circular(AppTheme.kBottomSheetModalUpperRadius))),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         context: context,
//         isScrollControlled: true,
//         isDismissible: true,
//         enableDrag: true,
//         builder: (context) {
//           {
//             return StatefulBuilder(builder: (BuildContext context,
//                 StateSetter setState /*You can rename this!*/) {
//               return new OrientationBuilder(builder: (context, orientation) {
//                 //   orientation == Orientation.landscape
//                 //       ? SystemChrome.setEnabledSystemUIOverlays(
//                 //           [SystemUiOverlay.bottom])
//                 //       : SystemChrome.setEnabledSystemUIOverlays(
//                 //           SystemUiOverlay.values);
//                 return SafeArea(
//                     child: Container(
//                   height: orientation == Orientation.landscape
//                       ? MediaQuery.of(context).size.width * 0.965
//                       : MediaQuery.of(context).size.height * 0.16,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisSize: MainAxisSize.max,
//                         // crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.only(left: 20),
//                             child: Text(
//                               "All Reactions",
//                               textAlign: TextAlign.center,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline6!
//                                   .copyWith(
//                                     fontSize: AppTheme.kBottomSheetTitleSize,
//                                   ),
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               FocusScope.of(context).requestFocus(FocusNode());
//                             },
//                             icon: Icon(
//                               Icons.clear,
//                               size: Globals.deviceType == "phone" ? 28 : 36,
//                             ),
//                           ),
//                         ],
//                       ),
//                       mainReactionIcons(true)
//                     ],
//                   ),
//                 ));
//               });
//             });
//           }
//         });
//   }

//   void reactionCount(index) {
//     setState(() {
//       if (index != 3) {
//         totalReactions.value++;
//       }
//     });
//   }

//   // void increamentValue(index) {
//   //   index == 0
//   //       ? like.value =
//   //           like.value != 0.0 ? like.value + 1 : widget.newsObj.likeCount! + 1
//   //       : index == 1
//   //           ? thanks.value = thanks.value != 0.0
//   //               ? thanks.value + 1
//   //               : widget.newsObj.thanksCount! + 1
//   //           : index == 2
//   //               ? helpful.value = helpful.value != 0.0
//   //                   ? helpful.value + 1
//   //                   : widget.newsObj.helpfulCount! + 1
//   //               : share.value = share.value != 0.0
//   //                   ? share.value + 1
//   //                   : widget.newsObj.shareCount! + 1;

//   //   index == 0
//   //       ? widget.newsObj.likeCount = like.value
//   //       : index == 1
//   //           ? widget.newsObj.thanksCount = thanks.value
//   //           : index == 2
//   //               ? widget.newsObj.helpfulCount = helpful.value
//   //               : widget.newsObj.shareCount = share.value;
//   // }
// }
