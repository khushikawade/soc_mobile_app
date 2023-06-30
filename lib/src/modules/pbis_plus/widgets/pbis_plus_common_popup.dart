// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behaviour_modal.dart';
import 'package:Soc/src/widgets/circular_custom_button.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PBISPlusDeleteBehaviorPopup extends StatefulWidget {
  final Orientation? orientation;
  final BuildContext? context;
  final String? message;
  final String? title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final PBISPlusGenericBehaviourModal item;
  PBISPlusBloc? pbisPlusClassroomBloc;
  ValueNotifier<List<PBISPlusActionInteractionModalNew>>? containerIcons;
  PBISPlusDeleteBehaviorPopup({
    Key? key,
    required this.orientation,
    required this.context,
    required this.message,
    required this.title,
    required this.titleStyle,
    required this.backgroundColor,
    required this.item,
    required this.containerIcons,
    required this.pbisPlusClassroomBloc,
  }) : super(key: key);

  @override
  State<PBISPlusDeleteBehaviorPopup> createState() =>
      _PBISPlusDeleteBehaviorPopupState();
}

class _PBISPlusDeleteBehaviorPopupState
    extends State<PBISPlusDeleteBehaviorPopup> {
  PBISPlusBloc pbisPlusClassroomBloc = PBISPlusBloc();

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
        child: body());
  }

  Widget body() {
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
                        CustomCircularButton(
                          size: Size(MediaQuery.of(context).size.width * 0.29,
                              MediaQuery.of(context).size.width / 10),
                          text: "Cancel",
                          onClick: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: AppTheme.kButtonColor,
                          isBusy: false,
                          textColor: Color(0xffF7F8F9),
                          buttonRadius: 64,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.height / 40),
                        BlocConsumer(
                            bloc: pbisPlusClassroomBloc,
                            builder: (context, state) {
                              if (state is PBISPlusLoading) {
                                return _buildDeleteButton(true);
                              }
                              return _buildDeleteButton(false);
                            },
                            listener: (context, state) async {
                              if (state is PBISPlusDefaultBehaviourSucess) {
                                Utility.currentScreenSnackBar(
                                    "Successfully Deleted skills", null);
                                Navigator.pop(context, true);
                              } else if (state is PBISPlusSkillsDeleteError) {
                                Utility.currentScreenSnackBar(
                                    "Please try again later. Unable to delete the skills.",
                                    null);
                                Navigator.pop(context, true);
                              }
                            }
                            //_buildEditSkillCards()
                            ),
                      ])),
            ],
          ),
        ),
        Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: _showDeleteIconWidget(widget.item))
      ],
    );
  }

  Widget _buildDeleteButton(bool isBusy) {
    return CustomCircularButton(
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
    pbisPlusClassroomBloc.add(DeletePBISBehavior(item: widget.item));
  }

  Widget _showDeleteIconWidget(PBISPlusGenericBehaviourModal item) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Color(0xffF7F8F9)
                : Color(0xff111C20),
            shape: BoxShape.circle),
        child: CircleAvatar(
            radius: 42.0,
            backgroundColor: Colors.transparent,
            child: item.iconUrlC!.contains('http')
                ? Container(
                    height: 24,
                    width: 24,
                    child: Image.network(
                      item.iconUrlC!,
                      fit: BoxFit.contain,
                    ),
                  )
                : Container(
                    height: 24,
                    width: 24,
                    child: SvgPicture.asset(item.iconUrlC!,
                        fit: BoxFit.contain))));
  }
}
