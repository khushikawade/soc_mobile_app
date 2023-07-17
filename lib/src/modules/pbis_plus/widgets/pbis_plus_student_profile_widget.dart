import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PBISCommonProfileWidget extends StatefulWidget {
  PBISCommonProfileWidget(
      {Key? key,
      required this.profilePictureSize,
      required this.imageUrl,
      this.studentValueNotifier,
      this.countWidget = false,
      this.valueChange,
      this.isLoading,
      this.isFromStudentPlus,
      this.isFromStudentNotes,
      this.studentProfile,
      this.studentname})
      : super(key: key);
  final bool? countWidget;
  final double profilePictureSize;
  final String imageUrl;
  final ValueNotifier<ClassroomStudents>? studentValueNotifier;
  final StudentName? studentname;
  var valueChange;
  final bool? isLoading;
  final String? studentProfile;
  final bool? isFromStudentPlus;
  final bool? isFromStudentNotes;
  @override
  State<PBISCommonProfileWidget> createState() =>
      _PBISCommonProfileWidgetState();
}

class _PBISCommonProfileWidgetState extends State<PBISCommonProfileWidget> {
  //
  @override
  Widget build(BuildContext context) {
    /*----------------------To manage the user profile in case of no profile picture found--------------------------*/
    String firstName;
    //student profile at student notes tabs
    if (widget.isFromStudentNotes != null &&
        widget.isFromStudentNotes == true &&
        widget.studentname!.fullName!.split(' ').length > 0) {
      firstName = widget.studentname!.fullName!
          .split(' ')[0]
          .substring(0, 1)
          .toUpperCase();
    }
    //Student profile at all other places
    else {
      firstName = widget.studentValueNotifier!.value.profile!.name!.fullName!
                  .isNotEmpty &&
              widget.studentValueNotifier!.value.profile!.name!.fullName!
                      .split(' ')
                      .length >
                  0
          ? widget.studentValueNotifier!.value.profile!.name!.fullName!
              .split(' ')[0]
              .substring(0, 1)
              .toUpperCase()
          : '';
    }
    String lastName;

    firstName = widget.studentValueNotifier!.value.profile!.name!.fullName!
                .isNotEmpty &&
            widget.studentValueNotifier!.value.profile!.name!.fullName!
                    .split(' ')
                    .length >
                0
        ? widget.studentValueNotifier!.value.profile!.name!.fullName!
            .split(' ')[0]
            .substring(0, 1)
            .toUpperCase()
        : '';

    lastName = widget.studentValueNotifier!.value.profile!.name!.fullName!
                .isNotEmpty &&
            widget.studentValueNotifier!.value.profile!.name!.fullName!
                    .split(' ')
                    .length >
                1
        ? widget.studentValueNotifier!.value.profile!.name!.fullName!
            .split(' ')[1]
            .substring(0, 1)
            .toUpperCase()
        : '';

    /*-------------------------------------------------END--------------------------------------------------------*/

    return Stack(
      children: [
        Container(
            margin: widget.countWidget == true
                ? EdgeInsets.all(10)
                : EdgeInsets.zero,
            child: widget.isFromStudentPlus == true &&
                    widget.studentProfile != null
                ? studentProfilePicture()
                : (widget.studentValueNotifier!.value.profile!.photoUrl!
                            .contains('default-user') &&
                        !widget.studentValueNotifier!.value.profile!.photoUrl!
                            .contains('default-user=')
                    ? CircleAvatar(
                        radius: widget.profilePictureSize,
                        backgroundColor: Color(0xff000000) ==
                                Theme.of(context).backgroundColor
                            ? Color(0xffF7F8F9)
                            : Color(0xff111C20),
                        child: Text(
                          firstName + lastName,
                          // widget.studentValueNotifier.value.profile!.name!
                          //         .givenName!
                          //         .toUpperCase()
                          //         .substring(0, 1) +
                          //     widget.studentValueNotifier.value.profile!.name!
                          //         .familyName!
                          //         .toUpperCase()
                          //         .substring(0, 1),
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    color: Color(0xff000000) !=
                                            Theme.of(context).backgroundColor
                                        ? Color(0xffF7F8F9)
                                        : Color(0xff111C20),
                                  ),
                        ),
                      )
                    : CachedNetworkImage(
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: widget.profilePictureSize,
                          backgroundImage: imageProvider,
                        ),
                        imageUrl: widget.imageUrl!,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            // padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 0.5,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: widget.profilePictureSize,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.person,
                                // size: profilePictureSize,
                                color: Colors.grey[300]!,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                            radius: widget.profilePictureSize,
                            child: Icon(Icons.error)),
                      ))),
        if (widget.countWidget == true)
          Positioned(
            right: 0,
            top: 32,
            child: Container(
              padding: EdgeInsets.all(5),
              width: PBISPlusOverrides.circleSize,
              height: PBISPlusOverrides.circleSize,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ValueListenableBuilder(
                        valueListenable:
                            widget?.valueChange ?? ValueNotifier(false),
                        builder: (BuildContext context, value, Widget? child) {
                          return ValueListenableBuilder<ClassroomStudents>(
                            valueListenable: widget.studentValueNotifier!,
                            builder: (BuildContext context,
                                ClassroomStudents value, Widget? child) {
                              return
                                  // widget.isLoading == true
                                  //     ? ShimmerLoading(
                                  //         child: Container(
                                  //           height: 10,
                                  //           width: 10,
                                  //           color: Colors.black,
                                  //         ),
                                  //         isLoading: widget.isLoading)
                                  //     :
                                  //TODOPBIS:
                                  Text(
                                      PBISPlusUtility.numberAbbreviationFormat(
                                          // widget
                                          //       .studentValueNotifier
                                          //       .value
                                          //       .profile!
                                          //       .behavior1!
                                          //       .counter! +
                                          //   widget.studentValueNotifier.value.profile!
                                          //       .behavior2!.counter! +
                                          //   widget.studentValueNotifier.value.profile!
                                          //       .behavior3!.counter!
                                          widget.studentValueNotifier!.value
                                                  .profile!.engaged! +
                                              widget.studentValueNotifier!.value
                                                  .profile!.niceWork! +
                                              widget.studentValueNotifier!.value
                                                  .profile!.helpful!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ));
                            },
                          );
                        })),
              ),
            ),
          ),
      ],
    );
  }

  Widget studentProfilePicture() {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: widget.profilePictureSize,
        backgroundImage: imageProvider,
      ),
      imageUrl: widget.studentProfile!,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          // padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 0.5,
            ),
          ),
          child: CircleAvatar(
            radius: widget.profilePictureSize,
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.person,
              // size: profilePictureSize,
              color: Colors.grey[300]!,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
