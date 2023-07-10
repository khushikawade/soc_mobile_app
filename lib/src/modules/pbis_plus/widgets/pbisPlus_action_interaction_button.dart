import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:like_button/like_button.dart';
import 'package:audioplayers/audioplayers.dart';

// ignore: must_be_immutable
class PBISPlusActionInteractionButton extends StatefulWidget {
  final PBISPlusCommonBehaviorModal iconData;
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
  AudioPlayer? soundEffectPlayer;

  bool _isOffline = false;

  final ValueNotifier<bool> _showMessage = ValueNotifier<bool>(false);
  final ValueNotifier<int> participation = ValueNotifier<int>(0);
  final ValueNotifier<int> collaboration = ValueNotifier<int>(0);
  final ValueNotifier<int> listening = ValueNotifier<int>(0);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
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
                      start: AppTheme.kButtonColor,
                      end: AppTheme.kButtonColor,
                    ),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: AppTheme.kButtonColor,
                      dotSecondaryColor: AppTheme.kButtonColor,
                    ),
                    likeBuilder: (bool isLiked) {
                      return CachedNetworkImage(
                        imageUrl: widget.iconData.pBISBehaviorIconURLC!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => ShimmerLoading(
                          isLoading: true,
                          child: Container(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: widget.isFromStudentPlus == true ? 15 : 15,
                      bottom: widget.isFromStudentPlus == true ? 0 : 5,
                    ),
                    child: ValueListenableBuilder(
                        valueListenable: onTapDetect,
                        builder: (BuildContext context, dynamic value,
                            Widget? child) {
                          return Container(
                              height: 24,
                              width: 24,
                              alignment: Alignment.center,
                              // padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.isShowCircle!
                                    ? Colors.grey[300]
                                    : Colors.transparent,
                              ),
                              child: widget.isLoading == true
                                  ? Utility.textWidget(
                                      text: '0',
                                      textAlign: TextAlign.center,
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
              Center(
                child: Padding(
                  padding: Globals.deviceType != 'phone'
                      ? const EdgeInsets.all(0.0)
                      : EdgeInsets.zero,
                  child: Utility.textWidget(
                      textAlign: TextAlign.center,
                      text: widget.iconData.behaviorTitleC!,
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
      child: _isOffline
          ? Utility.textWidget(
              text: 'Make sure you have proper internet connection',
              context: context)
          : SizedBox.shrink(),
    );
  }

  Future<bool> _onLikeButtonTapped(bool isLiked) async {
    Utility.playSound(Strings.soundPath[0]);
    Utility.doVibration();

    if (_isOffline) {
      Utility.currentScreenSnackBar("No Internet Connection", null);
      return isLiked;
    }

    /*-------------------------User Activity Track START----------------------------*/
    //Postgres event track for interaction added to bloc success

    // FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //     'pbis plus user interaction'.toLowerCase().replaceAll(" ", "_"));
    /*-------------------------User Activity Track END----------------------------*/

    _showMessage.value = true;
    Future.delayed(Duration(seconds: 1), () {
      _showMessage.value = false;
    });

    interactionBloc.add(PbisPlusAddPBISInteraction(
        context: context,
        scaffoldKey: widget.scaffoldKey,
        studentId: widget.studentValueNotifier.value.profile!.id,
        studentEmail: widget.studentValueNotifier.value.profile!.emailAddress,
        classroomCourseId: widget.classroomCourseId,
        behaviour: widget.iconData));

    return true;
  }

  // Future<bool> _onLikeButtonTapped(bool isLiked) async {
  //   Utility.playSound(Strings.soundPath[0]);

  //   if (_isOffline) {
  //     Utility.currentScreenSnackBar("No Internet Connection", null);
  //     return isLiked;
  //   }

  //   /*-------------------------User Activity Track START----------------------------*/
  //   //Postgres event track for interaction added to bloc success

  //   FirebaseAnalyticsService.addCustomAnalyticsEvent(
  //       'pbis plus user interaction'.toLowerCase().replaceAll(" ", "_"));
  //   /*-------------------------User Activity Track END----------------------------*/

  //   _showMessage.value = true;
  //   Future.delayed(Duration(seconds: 1), () {
  //     _showMessage.value = false;
  //   });

  //   if (widget.iconData.title == 'Engaged') {
  //     // TODOPBIS:
  //     //   widget.studentValueNotifier.value.profile!.behavior1?.counter =
  //     //       widget.isFromStudentPlus == true
  //     //           ? widget.studentValueNotifier.value.profile!.engaged
  //     //           : widget.studentValueNotifier.value.profile!.engaged! + 1;
  //     // } else if (widget.iconData.title == 'Nice Work') {
  //     //   widget.studentValueNotifier.value.profile!.niceWork =
  //     //       widget.isFromStudentPlus == true
  //     //           ? widget.studentValueNotifier.value.profile!.niceWork
  //     //           : widget.studentValueNotifier.value.profile!.niceWork! + 1;
  //     // } else {
  //     //   widget.studentValueNotifier.value.profile!.helpful =
  //     //       widget.isFromStudentPlus == true
  //     //           ? widget.studentValueNotifier.value.profile!.helpful
  //     //           : widget.studentValueNotifier.value.profile!.helpful! + 1;
  //   }

  //   onTapDetect.value =
  //       !onTapDetect.value; //Update interaction text count in card

  //   widget.onValueUpdate(
  //       widget.studentValueNotifier); //return updated count to other screens

  //   if (widget.isFromStudentPlus != true) {
  //     interactionBloc.add(AddPBISInteraction(
  //         context: context,
  //         scaffoldKey: widget.scaffoldKey,
  //         studentId: widget.studentValueNotifier.value.profile!.id,
  //         studentEmail: widget.studentValueNotifier.value.profile!.emailAddress,
  //         classroomCourseId: widget.classroomCourseId,
  //         engaged: widget.iconData.title == 'Engaged' ? 1 : 0,
  //         niceWork: widget.iconData.title == 'Nice Work' ? 1 : 0,
  //         helpful: widget.iconData.title == 'Helpful' ? 1 : 0));
  //   }

  //   return !isLiked;
  // }

  _getCounts() {
    String title = widget.iconData.behaviorTitleC!;
    var map = {
      //TODOPBIS:
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
          ? EdgeInsets.zero
          // const EdgeInsets.only(top: 10, left: 10)//old by Nikhar
          : EdgeInsets.zero,
      child: Utility.textWidget(
          text: viewCount.toString(),
          context: context,
          textAlign: TextAlign.center,
          textTheme: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Color(0xff000000) == Theme.of(context).backgroundColor
                  ? Color(0xff111C20)
                  : Color(0xff111C20),
              fontSize: 12)),
    );
  }
}
