import 'dart:io';

import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_all_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/circular_custom_button.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class PBISPlusCommonPopup extends StatefulWidget {
  final Orientation? orientation;
  final BuildContext? context;
  final String? message;
  final String? title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final PBISPlusALLBehaviourModal item;
  // PBISPlusBloc? pbisPlusBloc;
  // ValueNotifier<List<PBISPlusActionInteractionModalNew>>? containerIcons;
  PBISPlusCommonPopup({
    Key? key,
    required this.orientation,
    required this.context,
    required this.message,
    required this.title,
    required this.titleStyle,
    required this.backgroundColor,
    required this.item,
    // required this.containerIcons,
    // required this.pbisPlusBloc,
  }) : super(key: key);

  @override
  State<PBISPlusCommonPopup> createState() => _PBISPlusCommonPopupState();
}

class _PBISPlusCommonPopupState extends State<PBISPlusCommonPopup> {
  @override
  void dispose() {
    super.dispose();
  }

  PBISPlusBloc pbisPlusBloc = PBISPlusBloc();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(),
    );
  }

  // bool replaceItems(String title) {
  //   try {
  //     int index = widget.containerIcons!.value
  //         .indexWhere((item) => item.title == title);
  //     if (index != -1) {
  //       widget.containerIcons!.value[index] = PBISPlusActionInteractionModalNew(
  //         imagePath: "assets/Pbis_plus/add_icon.svg",
  //         title: 'Add Skill',
  //         color: Colors.red,
  //       );
  //     }
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Widget contentBox() {
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
              SpacerWidget(MediaQuery.of(context).size.height / 60),
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
                          textColor: Color(0xffF7F8F9),
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
                            pbisPlusBloc.add(
                                PBISPlusDeleteTeacherCustomBehvaiour(
                                    behvaiour: widget.item));
                            Navigator.pop(context, true);
                          },
                          backgroundColor: Color(0xff000000) !=
                                  Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                          isBusy: false,
                          size: Size(MediaQuery.of(context).size.width * 0.29,
                              MediaQuery.of(context).size.width / 10),
                          buttonRadius: 64,
                        ),

                        // BlocConsumer(
                        //     bloc: pbisPlusBloc,
                        //     builder: (context, state) {
                        //       print(state);
                        //       if (state is PBISPlusSkillsDeleteLoading) {
                        //         return _buildDeletebutton(true);
                        //       } else if (state
                        //           is PBISPlusDefaultBehaviourSucess) {
                        //         return _buildDeletebutton(false);
                        //       } else if (state is PBISErrorState)
                        //         return _buildDeletebutton(false);
                        //       return _buildDeletebutton(false);
                        //     },
                        //     listener: (context, state) async {
                        //       if (state is PBISPlusDefaultBehaviourSucess) {
                        //         Utility.currentScreenSnackBar(
                        //             "Successfully Deleted skills", null);
                        //         Navigator.pop(context, true);
                        //         FocusScope.of(context)
                        //             .requestFocus(FocusNode());
                        //       } else if (state is PBISPlusSkillsDeleteError) {
                        //         Utility.currentScreenSnackBar(
                        //             "Please try again later. Unable to delete the skills.",
                        //             null);
                        //         Navigator.pop(context, true);
                        //       }
                        //     }
                        //     //_buildEditSkillCards()
                        //     ),
                      ])),
            ],
          ),
        ),
        Positioned(
            top: 0, left: 16, right: 16, child: _buildIconWidget(widget.item)),
      ],
    );
  }

  Widget _buildDeletebutton(bool isBusy) {
    return CircularCustomButton(
      borderColor: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xff111C20)
          : Color(0xffF7F8F9),
      text: "Delete",
      textColor: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xff111C20)
          : Color(0xffF7F8F9),
      onClick: () async {
        _handleDeleteItem();
      },
      backgroundColor: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xffF7F8F9)
          : Color(0xff111C20),
      isBusy: isBusy,
      size: Size(MediaQuery.of(context).size.width * 0.29,
          MediaQuery.of(context).size.width / 10),
      buttonRadius: 64,
    );
  }

  void _handleDeleteItem() async {
    pbisPlusBloc
        .add(PBISPlusDeleteTeacherCustomBehvaiour(behvaiour: widget.item));
  }

  Widget _buildIcons({required PBISPlusALLBehaviourModal item}) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 30,
          backgroundImage: imageProvider,
          backgroundColor: Colors.transparent),
      imageUrl: item.pBISBehaviorIconURLC!,
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
            radius: 30,
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

  Widget _buildIconWidget(PBISPlusALLBehaviourModal item) {
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
            child: _buildIcons(item: item)));
  }
}
