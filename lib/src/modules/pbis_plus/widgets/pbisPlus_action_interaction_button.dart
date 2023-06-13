import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class PBISPlusActionInteractionButton extends StatefulWidget {
  final PBISPlusActionInteractionModalNew iconData;
  ValueNotifier<ClassroomStudents> studentValueNotifier;
  final bool?
      isFromStudentPlus; // to check it is from pbis plus or student plus
  final bool? isLoading; // to maintain loading when user came from student plus
  final Key? scaffoldKey;
  final String? classroomCourseId;
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;
  final bool? isShowCircle;
  final double? size;
  // final Size
  // final Future<bool?> Function(bool)? onTapCallback;

  PBISPlusActionInteractionButton({
    Key? key,
    this.isLoading,
    this.isFromStudentPlus,
    required this.iconData,
    required this.studentValueNotifier,
    required this.scaffoldKey,
    required this.classroomCourseId,
    required this.onValueUpdate,
    required this.isShowCircle,
    required this.size,
    // required this.onTapCallback,
  }) : super(key: key);

  @override
  State<PBISPlusActionInteractionButton> createState() =>
      PBISPlusActionInteractionButtonState();
}

class PBISPlusActionInteractionButtonState
    extends State<PBISPlusActionInteractionButton> {
  PBISPlusBloc interactionBloc = new PBISPlusBloc();
  final ValueNotifier<bool> onTapDetect = ValueNotifier<bool>(false);
  // void updateState(bool isLiked) {
  //   if (_isOffline) {
  //     Utility.currentScreenSnackBar("No Internet Connection", null);
  //   }
  //   _showMessage.value = true;
  //   Future.delayed(Duration(seconds: 1), () {
  //     _showMessage.value = false;
  //   });

  //   /// send your request here
  //   // final bool success = await sendRequest();

  //   /// if failed, you can do nothing
  //   // return success? !isLiked:isLiked;
  // }

  bool _isOffline = false;

  final ValueNotifier<bool> _showMessage = ValueNotifier<bool>(false);

  final ValueNotifier<int> participation = ValueNotifier<int>(0);
  final ValueNotifier<int> collaboration = ValueNotifier<int>(0);
  final ValueNotifier<int> listening = ValueNotifier<int>(0);
  void update() {}

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        _isOffline = connectivity == ConnectivityResult.none;
        return InkWell(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LikeButton(
                      padding: EdgeInsets.only(
                          top: widget.isFromStudentPlus == true ? 15 : 20,
                          bottom: widget.isFromStudentPlus == true ? 0 : 14,
                          left: 15,
                          right: 5),
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      likeCountAnimationType: LikeCountAnimationType.none,
                      likeCountPadding: const EdgeInsets.only(left: 0.0),
                      animationDuration: Duration(
                          milliseconds:
                              widget.isFromStudentPlus == true ? 0 : 1000),
                      countPostion: CountPostion.right,
                      isLiked: null,
                      size: widget.size!,
                      onTap: widget.isLoading == true
                          ?
                          // Interaction should not be tappable in STUDENT+ module
                          (bool isLiked) async {
                              return false;
                            }
                          : _onLikeButtonTapped,
                      circleColor: CircleColor(
                        start: widget.iconData.color,
                        end: widget.iconData.color,
                      ),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: widget.iconData.color,
                        dotSecondaryColor: widget.iconData.color,
                      ),
                      likeBuilder: (bool isLiked) {
                        return SvgPicture.asset(
                          widget.iconData.imagePath,
                          height: widget.size,
                          width: widget.size,
                          // height: Globals.deviceType == 'phone' ? 64 : 74,
                          // width: Globals.deviceType == 'phone' ? 64 : 74,
                        );

                        // Icon(widget.iconData.iconData,
                        //     color: widget.iconData.color,
                        //     size: Globals.deviceType == 'phone' ? 64 : 74);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        // top: widget.isFromStudentPlus == true ? 15 : 0,
                        // bottom: widget.isFromStudentPlus == true ? 0 : 5,
                        top: widget.isFromStudentPlus == true ? 15 : 15,
                        bottom: widget.isFromStudentPlus == true ? 0 : 5,
                      ),
                      child: ValueListenableBuilder(
                          valueListenable: onTapDetect,
                          builder: (BuildContext context, dynamic value,
                              Widget? child) {
                            return Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.isShowCircle!
                                      ? Colors.grey[300]
                                      : Colors.transparent,
                                ),
                                child: widget.isLoading == true
                                    ? Utility.textWidget(
                                        text: '0',
                                        context: context,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18))
                                    : _getCounts());
                          }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: Globals.deviceType != 'phone'
                    ? const EdgeInsets.all(0.0)
                    : EdgeInsets.zero,
                child: Utility.textWidget(
                    text: widget.iconData.title,
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );

        // InkWell(
        //   onTap: () {},
        //   child: Column(
        //     // mainAxisSize: MainAxisSize.min,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Container(
        //         alignment: Alignment.center,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             LikeButton(
        //               padding: EdgeInsets.only(
        //                   top: widget.isFromStudentPlus == true ? 15 : 20,
        //                   bottom: widget.isFromStudentPlus == true ? 0 : 5,
        //                   left: 15,
        //                   right: 5),
        //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               likeCountAnimationType: LikeCountAnimationType.none,
        //               likeCountPadding: const EdgeInsets.only(left: 5.0),
        //               animationDuration: Duration(
        //                   milliseconds:
        //                       widget.isFromStudentPlus == true ? 0 : 1000),
        //               countPostion: CountPostion.right,
        //               isLiked: null,

        //               size: 20,
        //               onTap: widget.isLoading == true
        //                   ?
        //                   // Interaction should not be tappable in STUDENT+ module
        //                   (bool isLiked) async {
        //                       return false;
        //                     }
        //                   : _onLikeButtonTapped,
        //               circleColor: CircleColor(
        //                 start: widget.iconData.color,
        //                 end: widget.iconData.color,
        //               ),
        //               bubblesColor: BubblesColor(
        //                 dotPrimaryColor: widget.iconData.color,
        //                 dotSecondaryColor: widget.iconData.color,
        //               ),
        //               likeBuilder: (bool isLiked) {
        //                 return Icon(widget.iconData.iconData,
        //                     color: widget.iconData.color,
        //                     size: Globals.deviceType == 'phone' ? 20 : 30
        //                     // 20
        //                     // widget.iconData.iconSize,
        //                     );
        //               },

        //               // likeCount: _getCounts(),
        //             ),
        //             Padding(
        //               padding: EdgeInsets.only(
        //                 top: widget.isFromStudentPlus == true ? 15 : 20,
        //                 bottom: widget.isFromStudentPlus == true ? 0 : 5,
        //               ),
        //               child: ValueListenableBuilder(
        //                   valueListenable: onTapDetect,
        //                   builder: (BuildContext context, dynamic value,
        //                       Widget? child) {
        //                     // print('only likes count');
        //                     // print(widget.obj.likeCount);
        //                     return widget.isLoading == true
        //                         ? Utility.textWidget(
        //                             text: '0',
        //                             context: context,
        //                             textTheme: Theme.of(context)
        //                                 .textTheme
        //                                 .bodyText1!
        //                                 .copyWith(fontSize: 12))
        //                         : _getCounts();
        //                   }),
        //             )
        //           ],
        //         ),
        //       ),

        //       Padding(
        //         padding: Globals.deviceType != 'phone'
        //             ? const EdgeInsets.all(16.0)
        //             : EdgeInsets.zero,
        //         child: Utility.textWidget(
        //             text: widget.iconData.title,
        //             context: context,
        //             textTheme: Theme.of(context)
        //                 .textTheme
        //                 .bodyText1!
        //                 .copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
        //       ),
        //       // ValueListenableBuilder<bool>(
        //       //   valueListenable: _showMessage,
        //       //   builder: (BuildContext context, bool value, Widget? child) {
        //       //     return value
        //       //         ? SizedBox(
        //       //             width: 40,
        //       //             height: 20,
        //       //             child: FittedBox(
        //       //               child: Text(
        //       //                 widget.iconData.title,
        //       //                 style: Theme.of(context).textTheme.bodyText1!,
        //       //               ),
        //       //             ),
        //       //           )
        //       //         : SizedBox(
        //       //             width: 40,
        //       //             height: 20,
        //       //           );
        //       //   },
        //       // ),
        //     ],
        //   ),
        // );
      },
      child: _isOffline
          ? Utility.textWidget(
              text: 'Make sure you have proper internet connection',
              context: context)
          : SizedBox.shrink(),
    );
  }

  Future<bool> _onLikeButtonTapped(bool isLiked) async {
    if (_isOffline) {
      Utility.currentScreenSnackBar("No Internet Connection", null);
      return isLiked;
    }

    /*-------------------------User Activity Track START----------------------------*/
    Utility.updateLogs(
        activityType: 'PBIS+',
        activityId: '38',
        description: 'User Interaction PBIS+',
        operationResult: 'Success');

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        'pbis plus user interaction'.toLowerCase().replaceAll(" ", "_"));
    /*-------------------------User Activity Track END----------------------------*/

    _showMessage.value = true;
    Future.delayed(Duration(seconds: 1), () {
      _showMessage.value = false;
    });

    if (widget.iconData.title == 'Engaged') {
      widget.studentValueNotifier.value.profile!.engaged =
          widget.isFromStudentPlus == true
              ? widget.studentValueNotifier.value.profile!.engaged
              : widget.studentValueNotifier.value.profile!.engaged! + 1;
    } else if (widget.iconData.title == 'Nice Work') {
      widget.studentValueNotifier.value.profile!.niceWork =
          widget.isFromStudentPlus == true
              ? widget.studentValueNotifier.value.profile!.niceWork
              : widget.studentValueNotifier.value.profile!.niceWork! + 1;
    } else {
      widget.studentValueNotifier.value.profile!.helpful =
          widget.isFromStudentPlus == true
              ? widget.studentValueNotifier.value.profile!.helpful
              : widget.studentValueNotifier.value.profile!.helpful! + 1;
    }

    onTapDetect.value =
        !onTapDetect.value; //Update interaction text count in card

    widget.onValueUpdate(
        widget.studentValueNotifier); //return updated count to other screens

    if (widget.isFromStudentPlus != true) {
      interactionBloc.add(AddPBISInteraction(
          context: context,
          scaffoldKey: widget.scaffoldKey,
          studentId: widget.studentValueNotifier.value.profile!.id,
          studentEmail: widget.studentValueNotifier.value.profile!.emailAddress,
          classroomCourseId: widget.classroomCourseId,
          engaged: widget.iconData.title == 'Engaged' ? 1 : 0,
          niceWork: widget.iconData.title == 'Nice Work' ? 1 : 0,
          helpful: widget.iconData.title == 'Helpful' ? 1 : 0));
    }

    /// send your request here
    // final bool success = await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
    // setState(() {prin});
    return !isLiked;
  }

  _getCounts() {
    String title = widget.iconData.title;
    var map = {
      'Engaged': widget.studentValueNotifier.value.profile!.engaged,
      'Nice Work': widget.studentValueNotifier.value.profile!.niceWork,
      'Helpful': widget.studentValueNotifier.value.profile!.helpful,
      'Participation': ++participation.value,
      'Collaboration': ++collaboration.value,
      'Listening': ++listening.value,
      // widget.studentValueNotifier.value.profile!.niceWork,
      // 'Helpful': widget.studentValueNotifier.value.profile!.helpful,
    };

    int viewCount = map[title] ?? 0;
    // return viewCount;
    return Padding(
      padding: Globals.deviceType != 'phone'
          ? const EdgeInsets.only(top: 10, left: 10)
          : EdgeInsets.zero,
      child: Utility.textWidget(
          text: viewCount.toString(),
          context: context,
          textTheme:
              Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12)),
    );
  }
}
