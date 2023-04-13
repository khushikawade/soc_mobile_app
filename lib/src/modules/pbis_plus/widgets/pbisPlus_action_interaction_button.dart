import 'package:Soc/src/modules/pbis_plus/modal/course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:like_button/like_button.dart';

// ignore: must_be_immutable
class PBISPlusActionInteractionButton extends StatefulWidget {
  final PBISPlusActionInteractionModal iconData;
  ValueNotifier<ClassroomStudents> studentValueNotifier;
  // final Future<bool?> Function(bool)? onTapCallback;

  PBISPlusActionInteractionButton({
    Key? key,
    required this.iconData,
    required this.studentValueNotifier,
    // required this.onTapCallback,
  }) : super(key: key);

  @override
  State<PBISPlusActionInteractionButton> createState() =>
      PBISPlusActionInteractionButtonState();
}

class PBISPlusActionInteractionButtonState
    extends State<PBISPlusActionInteractionButton> {
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

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        _isOffline = connectivity == ConnectivityResult.none;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LikeButton(
              likeCountAnimationType: LikeCountAnimationType.none,
              likeCountPadding: const EdgeInsets.only(left: 5.0),
              animationDuration: Duration(milliseconds: 1000),
              countPostion: CountPostion.right,
              isLiked: null,
              size: 20,
              onTap: _onLikeButtonTapped,
              circleColor: CircleColor(
                start: widget.iconData.color,
                end: widget.iconData.color,
              ),
              bubblesColor: BubblesColor(
                dotPrimaryColor: widget.iconData.color,
                dotSecondaryColor: widget.iconData.color,
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  widget.iconData.iconData,
                  color: widget.iconData.color,
                  size: 20,
                );
              },
              likeCount: _getCounts(),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _showMessage,
              builder: (BuildContext context, bool value, Widget? child) {
                return value
                    ? SizedBox(
                        width: 40,
                        height: 20,
                        child: FittedBox(
                          child: Text(
                            widget.iconData.title,
                            style: Theme.of(context).textTheme.bodyText1!,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 40,
                        height: 20,
                      );
              },
            ),
          ],
        );
      },
      child: _isOffline ? Text('Internet is not working') : SizedBox.shrink(),
    );
  }

  Future<bool> _onLikeButtonTapped(bool isLiked) async {
    if (_isOffline) {
      Utility.currentScreenSnackBar("No Internet Connection", null);
      return isLiked;
    }
    _showMessage.value = true;
    Future.delayed(Duration(seconds: 1), () {
      _showMessage.value = false;
    });
    print(widget.iconData.title);
    if (widget.iconData.title == 'Like') {
      widget.studentValueNotifier.value.profile!.engaged =
          widget.studentValueNotifier.value.profile!.engaged! + 1;
    } else if (widget.iconData.title == 'Thanks') {
      widget.studentValueNotifier.value.profile!.niceWork =
          widget.studentValueNotifier.value.profile!.niceWork! + 1;
    } else {
      widget.studentValueNotifier.value.profile!.helpful =
          widget.studentValueNotifier.value.profile!.helpful! + 1;
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
      'Nice work': widget.studentValueNotifier.value.profile!.niceWork,
      'Helpful': widget.studentValueNotifier.value.profile!.helpful,
    };

    return map[title] ?? 0;
  }
}
