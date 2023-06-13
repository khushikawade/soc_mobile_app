import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_popup.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_common_popup.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import 'hero_dialog_route.dart';

class PBISPlusEditSkillsBottomSheet extends StatefulWidget {
  final double? height;
  PBISPlusActionInteractionModalNew? item;
  PBISPlusEditSkillsBottomSheet({
    Key? key,
    this.height = 100,
    required this.item,
  });
  @override
  State<PBISPlusEditSkillsBottomSheet> createState() =>
      _PBISPlusBottomSheetState();
}

class _PBISPlusBottomSheetState extends State<PBISPlusEditSkillsBottomSheet> {
  late PageController _pageController;
  final _formKey = GlobalKey<FormState>();
  final pointPossibleController = TextEditingController();
  Future<void> initController() async {
    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  initState() {
    initController();
    /*-------------------------User Activity Track START----------------------------*/
    // FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //     "pbis_plus_save_and_share_bottomsheet");
    // FirebaseAnalyticsService.setCurrentScreen(
    //     screenTitle: 'pbis_plus_save_and_share_bottomsheet',
    //     screenClass: 'PBISPlusBottomSheet');
    /*-------------------------User Activity Track END----------------------------*/
    super.initState();
  }

  int pageValue = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      controller: ModalScrollController.of(context),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Color(0xffF7F8F9)
                : Color(0xff111C20),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          height: pageValue == 0
              ? widget.height
              : MediaQuery.of(context).size.height * 0.4, //saveAndShareOptions
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: ((value) {
              pageValue = value;
            }),
            allowImplicitScrolling: false,
            pageSnapping: false,
            controller: _pageController,
            children: [
              EditAndDeleteIcon(widget.item),
              EditName(widget.item?.title)
            ],
          )),
    );
  }

  Widget EditAndDeleteIcon(PBISPlusActionInteractionModalNew? item) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                icon: Icon(
                  Icons.clear,
                  color: AppTheme.kButtonColor,
                  size: Globals.deviceType == "phone" ? 28 : 36,
                ),
              )),
          SpacerWidget(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 136,
                  decoration: BoxDecoration(
                    color: AppTheme.kButtonColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/Pbis_plus/Edit.svg",
                        // height: Globals.deviceType == 'phone' ? 64 : 74,
                        // width: Globals.deviceType == 'phone' ? 64 : 74,
                      ),
                      Padding(
                        padding: Globals.deviceType != 'phone'
                            ? const EdgeInsets.only(top: 14, left: 14)
                            : EdgeInsets.zero,
                        child: Utility.textWidget(
                            text: "Edit Name",
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showPopup(message: "hi", title: "ji");
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 136,
                  decoration: BoxDecoration(
                    color: AppTheme.kButtonColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/Pbis_plus/delete.svg",
                        // height: Globals.deviceType == 'phone' ? 64 : 74,
                        // width: Globals.deviceType == 'phone' ? 64 : 74,
                      ),
                      Padding(
                        padding: Globals.deviceType != 'phone'
                            ? const EdgeInsets.only(top: 14, left: 14)
                            : EdgeInsets.zero,
                        child: Utility.textWidget(
                            text: "Delete",
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  showPopup({required String message, required String? title}) {
    // showDialog(
    //     context: context,
    //     builder: (context) =>
    // OrientationBuilder(builder: (context, orientation) {
    //   return
    Navigator.of(context).pushReplacement(HeroDialogRoute(
        builder: (context) => PBISPlusCommonPopup(
              backgroundColor:
                  Theme.of(context).colorScheme.background == Color(0xff000000)
                      ? Color(0xff162429)
                      : null,
              orientation: MediaQuery.of(context).orientation,
              context: context,
              message: "Are you sure you want to delete this item",
              title: '',
              titleStyle: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontWeight: FontWeight.bold),
            )));
    // );
    // );
  }

  Widget EditName(iconName) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                icon: Icon(
                  Icons.clear,
                  color: AppTheme.kButtonColor,
                  size: Globals.deviceType == "phone" ? 28 : 36,
                ),
              )),
          // ListTile(
          //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
          //   minLeadingWidth: 70,
          //   title:

          Center(
            child: Utility.textWidget(
                context: context,
                text: "${"Edit " + iconName}",
                textTheme: Theme.of(context).textTheme.headline5!),
          ),

          // leading: IconButton(
          //   onPressed: () {
          //     _pageController.animateToPage(pageValue - 1,
          //         duration: const Duration(milliseconds: 400),
          //         curve: Curves.ease);
          //   },
          //   icon: Icon(
          //     IconData(0xe80d,
          //         fontFamily: Overrides.kFontFam,
          //         fontPackage: Overrides.kFontPkg),
          //     color: AppTheme.kButtonColor,
          //   ),
          // ),
          // ),
          // SpacerWidget(15),
          // Utility.textWidget(
          //     context: context,
          //     textAlign: TextAlign.center,
          //     text: 'Please input the name.',
          //     textTheme: Theme.of(context)
          //         .textTheme
          //         .headline5!
          //         .copyWith(fontSize: 18)),

          SpacerWidget(30),
          Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextFieldWidget(
                    hintText: 'Edit Name',
                    msg: "Field is required",
                    keyboardType: TextInputType.number,
                    controller: pointPossibleController,
                    onSaved: (String value) {})),
          ),
          SpacerWidget(20),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: FloatingActionButton.extended(
                backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                onPressed: () async {},
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Utility.textWidget(
                        text: 'Next',
                        context: context,
                        textTheme: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(
                                color: Theme.of(context).backgroundColor)),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
