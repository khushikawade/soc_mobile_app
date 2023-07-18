// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PBISPlusEditSkillsBottomSheet extends StatefulWidget {
  final double? height;
  final PBISPlusCommonBehaviorModal? item;
  BoxConstraints? constraints;
  final int? index = -1;
  final VoidCallback onDelete;
  final void Function(String) onEditCallBack;

  PBISPlusEditSkillsBottomSheet(
      {Key? key,
      this.height = 100,
      required this.item,
      required BoxConstraints constraints,
      required int index,
      required this.onDelete,
      required this.onEditCallBack});
  @override
  State<PBISPlusEditSkillsBottomSheet> createState() =>
      _PBISPlusBottomSheetState();
}

class _PBISPlusBottomSheetState extends State<PBISPlusEditSkillsBottomSheet> {
  late PageController _pageController;
  final _formKey = GlobalKey<FormState>();
  final editNameController = TextEditingController();
  PBISPlusBloc pbisPlusBloc = PBISPlusBloc();
  ValueNotifier<bool> _errorMessage = ValueNotifier<bool>(false);
  int pageValue = 0;

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
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_edit_skill_bottomsheet");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_edit_skill_bottomsheet',
        screenClass: 'PBISPlusEditSkillsBottomSheet');
    /*-------------------------User Activity Track END----------------------------*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: MediaQuery.of(context).viewInsets,
        controller: ModalScrollController.of(context),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Utility.getContrastColor(context),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            height: pageValue == 0
                ? widget.height
                : MediaQuery.of(context).size.height * 0.4,
            //saveAndShareOptions
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
                  _buildEditNameWidget(widget.item)
                ])));
  }

  Widget _buildCloseIcon() {
    return Container(
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              FocusScope.of(context).requestFocus(FocusNode());
            },
            icon: Icon(Icons.clear,
                color: AppTheme.kButtonColor,
                size: Globals.deviceType == "phone" ? 28 : 36)));
  }

  Widget EditAndDeleteIcon(PBISPlusCommonBehaviorModal? dataList) {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          _buildCloseIcon(),
          SpacerWidget(16),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildCard(
                    onTap: () {
                      _pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease);
                    },
                    iconPath: "assets/Pbis_plus/Edit.svg",
                    tittle: "Edit Name"),
                _buildCard(
                    onTap: () {
                      widget.onDelete(); // Call the onDelete callback
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    iconPath: "assets/Pbis_plus/delete.svg",
                    tittle: "Delete")
              ])
        ]));
  }

  Widget _buildCard(
      {void Function()? onTap, String? iconPath, String? tittle}) {
    return GestureDetector(
        onTap: onTap!,
        child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
                color: AppTheme.kButtonColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3))
                ]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(iconPath!),
                  Padding(
                      padding: Globals.deviceType != 'phone'
                          ? const EdgeInsets.only(top: 14, left: 14)
                          : EdgeInsets.zero,
                      child: Utility.textWidget(
                          text: tittle!,
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.black, fontSize: 12)))
                ])));
  }

  Widget _buildEditNameWidget(PBISPlusCommonBehaviorModal? dataList) {
    return Container(
        padding: EdgeInsets.only(left: 16),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context);
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      icon: Icon(Icons.clear,
                          color: AppTheme.kButtonColor,
                          size: Globals.deviceType == "phone" ? 28 : 36))),
              SpacerWidget(10),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Utility.textWidget(
                      context: context,
                      text: "${"Edit " + "${dataList!.behaviorTitleC}"}",
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold))),
              Form(
                  key: _formKey,
                  child: Container(
                    child: TextFieldWidget(
                        counterStyle: TextStyle(
                            color: Color(0xff000000) ==
                                    Theme.of(context).backgroundColor
                                ? Color(0xffFFFFFF)
                                : Color(0xff000000)),
                        maxLength: 13,
                        context: context,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                fontWeight: FontWeight.w600, fontSize: 18),
                        msg: "Field is required",
                        controller: editNameController,
                        onSaved: (String value) {}),
                  )),
              ValueListenableBuilder(
                  valueListenable: _errorMessage,
                  builder: (context, value, _) {
                    return Container(
                        height: 25,
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: _errorMessage.value
                            ? TranslationWidget(
                                message: 'Field is required.',
                                fromLanguage: "en",
                                toLanguage: Globals.selectedLanguage,
                                builder: (translatedMessage) {
                                  return FittedBox(
                                      child: Text(translatedMessage,
                                          style: TextStyle(color: Colors.red)));
                                })
                            : null);
                  }),
              _buildSaveButton(dataList)
            ]));
  }

  Widget _buildSaveButton(PBISPlusCommonBehaviorModal dataList) {
    return Expanded(
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: FloatingActionButton.extended(
              backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
              onPressed: () async {
                if (editNameController.text.isNotEmpty) {
                  _errorMessage.value = false;
                  widget.onEditCallBack(editNameController.text);
                  Navigator.pop(context);
                } else {
                  _errorMessage.value = true;
                }
              },
              label:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Utility.textWidget(
                    text: 'Save',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Theme.of(context).backgroundColor))
              ]))),
    );
  }
}
