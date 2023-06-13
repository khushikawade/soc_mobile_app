import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_list.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_standalone_landing_page.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/circular_custom_button.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';
import 'package:shimmer/shimmer.dart';
import '../../../services/utility.dart';

class PBISPlusCommonPopup extends StatefulWidget {
  final Orientation? orientation;
  final BuildContext? context;
  final String? message;
  final String? title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  PBISPlusCommonPopup({
    Key? key,
    required this.orientation,
    required this.context,
    required this.message,
    required this.title,
    required this.titleStyle,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<PBISPlusCommonPopup> createState() => _PBISPlusCommonPopupState();
}

class _PBISPlusCommonPopupState extends State<PBISPlusCommonPopup> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.26,
          padding: EdgeInsets.only(left: 16, top: 54, right: 16, bottom: 16),
          margin: EdgeInsets.only(top: 54),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.kButtonColor,
                  Color(0xff000000) != Theme.of(context).backgroundColor
                      ? Color(0xffF7F8F9)
                      : Color(0xff111C20),
                ],
                stops: [
                  0.2,
                  0.0,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SpacerWidget(MediaQuery.of(context).size.height / 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Are you sure you want to delete this item?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 16)),
              ),
              SpacerWidget(MediaQuery.of(context).size.height / 40),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircularCustomButton(
                          size: Size(MediaQuery.of(context).size.width * 0.29,
                              MediaQuery.of(context).size.width / 10),
                          text: "Cancel",
                          onClick: () {
                            Navigator.pop(context!);
                          },
                          backgroundColor: AppTheme.kButtonColor,
                          isBusy: false,
                          buttonRadius: 64,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.height / 40),
                        CircularCustomButton(
                          borderColor: Color(0xff000000) !=
                                  Theme.of(context).backgroundColor
                              ? Color(0xff111C20)
                              : Color(0xffF7F8F9),
                          text: "Delete",
                          textColor: Color(0xff000000) !=
                                  Theme.of(context).backgroundColor
                              ? Color(0xff111C20)
                              : Color(0xffF7F8F9),
                          onClick: () {
                            Navigator.pop(context!);
                          },
                          backgroundColor: Color(0xff000000) !=
                                  Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                          isBusy: false,
                          size: Size(MediaQuery.of(context).size.width * 0.29,
                              MediaQuery.of(context).size.width / 10),
                          buttonRadius: 64,
                        )
                      ])),
            ],
          ),
        ),
        Positioned(top: 0, left: 16, right: 16, child: _buildProfileWidget()),
      ],
    );
  }

  Widget _buildProfileWidget() {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xff000000) != Theme.of(context).backgroundColor
              ? Color(0xffF7F8F9)
              : Color(0xff111C20),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 42.0,
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset(
            'assets/Pbis_plus/Helpful.svg',
            // width: 108.0,
            // height: 108.0,
          ),
        ));

    //  CachedNetworkImage(
    //   imageBuilder: (context, imageProvider) => CircleAvatar(
    //     radius: PBISPlusOverrides.profilePictureSize,
    //     backgroundImage: imageProvider,
    //   ),
    //   imageUrl: "https://picsum.photos/250?image=9",
    //   placeholder: (context, url) => Shimmer.fromColors(
    //     baseColor: Colors.grey[300]!,
    //     highlightColor: Colors.grey[100]!,
    //     child: Container(
    //       // padding: EdgeInsets.all(2),
    //       decoration: BoxDecoration(
    //         shape: BoxShape.circle,
    //         border: Border.all(
    //           color: Colors.grey[300]!,
    //           width: 0.5,
    //         ),
    //       ),
    //       child: CircleAvatar(
    //         radius: PBISPlusOverrides.profilePictureSize,
    //         backgroundColor: Colors.transparent,
    //         child: Icon(
    //           Icons.person,
    //           // size: profilePictureSize,
    //           color: Colors.grey[300]!,
    //         ),
    //       ),
    //     ),
    //   ),
    //   errorWidget: (context, url, error) => Icon(Icons.error),
    // ));
  }
}
