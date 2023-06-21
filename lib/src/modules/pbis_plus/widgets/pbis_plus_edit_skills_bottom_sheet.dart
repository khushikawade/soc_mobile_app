import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_popup.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_skill_list_modal.dart';
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
  PBISPlusSkills? item;
  ValueNotifier<List<PBISPlusActionInteractionModalNew>>? containerIcons;
  BoxConstraints? constraints;
  int? index = -1;
  PBISPlusBloc? pbisPlusClassroomBloc;
  PBISPlusEditSkillsBottomSheet(
      {Key? key,
      this.height = 100,
      required this.item,
      this.containerIcons,
      required BoxConstraints constraints,
      required pbisPlusClassroomBloc,
      required int index});
  @override
  State<PBISPlusEditSkillsBottomSheet> createState() =>
      _PBISPlusBottomSheetState();
}

class _PBISPlusBottomSheetState extends State<PBISPlusEditSkillsBottomSheet> {
  late PageController _pageController;
  final _formKey = GlobalKey<FormState>();
  final editNameController = TextEditingController();
  PBISPlusBloc pbisPlusClassroomBloc = PBISPlusBloc();

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
            color: Utility.getContrastColor(context),
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
              _buildEditNameWidget(widget.item)
            ],
          )),
    );
  }

  Widget _buildCloseIcon() {
    return Container(
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
        ));
  }

  Widget EditAndDeleteIcon(PBISPlusSkills? dataList) {
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
                    showPopup(
                        message: "Are you sure you want to delete this item",
                        title: "",
                        item: dataList);
                  },
                  iconPath: "assets/Pbis_plus/delete.svg",
                  tittle: "Delete"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard(
      {void Function()? onTap, String? iconPath, String? tittle}) {
    return GestureDetector(
      onTap: onTap!,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height:
            // widget.constraints!.maxHeight <= 115
            //     ?
            MediaQuery.of(context).size.width / 3
        // : MediaQuery.of(context).size.width / 4,
        ,
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
              iconPath!,
              // height: Globals.deviceType == 'phone' ? 64 : 74,
              // width: Globals.deviceType == 'phone' ? 64 : 74,
            ),
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
                      .copyWith(color: Colors.black, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  showPopup(
      {required String message,
      required String? title,
      PBISPlusSkills? item,
      PBISPlusBloc? pbisPlusClassroomBloc}) async {
    final res = await Navigator.of(context).push(HeroDialogRoute(
        builder: (context) => PBISPlusCommonPopup(
              pbisPlusClassroomBloc: pbisPlusClassroomBloc,
              item: item!,
              containerIcons: widget.containerIcons,
              backgroundColor:
                  Theme.of(context).colorScheme.background == Color(0xff000000)
                      ? Color(0xff162429)
                      : null,
              orientation: MediaQuery.of(context).orientation,
              context: context,
              message: message,
              title: '',
              titleStyle: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontWeight: FontWeight.bold),
            )));
    if (res) {
      Navigator.pop(context);
    }
  }

  Widget _buildNextbutton(PBISPlusSkills dataList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: FloatingActionButton.extended(
          backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
          onPressed: () async {
            print(editNameController.text);
            if (editNameController.text.isNotEmpty) {
              pbisPlusClassroomBloc.add(GetPBISSkillsUpdateName(
                  item: dataList, newName: editNameController.text));
            }
          },
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Utility.textWidget(
                  text: 'Update',
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Theme.of(context).backgroundColor)),
            ],
          )),
    );
  }

  Widget _buildEditNameWidget(PBISPlusSkills? dataList) {
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
          Center(
            child: Utility.textWidget(
                context: context,
                text: "${"Edit " + "${dataList!.name}"}",
                textTheme: Theme.of(context).textTheme.headline5!),
          ),
          SpacerWidget(MediaQuery.of(context).size.width * 0.1),
          Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextFieldWidget(
                    hintText: 'Edit Name',
                    msg: "Field is required",
                    keyboardType: TextInputType.text,
                    controller: editNameController,
                    onSaved: (String value) {})),
          ),
          SpacerWidget(MediaQuery.of(context).size.width * 0.1),
          BlocConsumer(
              bloc: pbisPlusClassroomBloc,
              builder: (context, state) {
                print(state);
                if (state is PBISPlusSkillsUpdateLoading) {
                  return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: AppTheme.kButtonColor,
                      ));
                } else if (state is PBISPlusSkillsSucess) {
                  if (state.skillsList.isNotEmpty ?? false) {
                    return _buildNextbutton(dataList);
                  } else {
                    return _buildNextbutton(dataList);
                  }
                } else if (state is PBISErrorState)
                  return _buildNextbutton(dataList);
                return _buildNextbutton(dataList);
              },
              listener: (context, state) async {
                if (state is PBISPlusSkillsSucess) {
                  Utility.currentScreenSnackBar(
                      "Successfully updated skills name", null);
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else if (state is PBISErrorState) {
                  Utility.currentScreenSnackBar(
                      "Please try again later. Unable to update the skills name.",
                      null);
                }
              }
              //_buildEditSkillCards()
              ),
        ],
      ),
    );
  }
}
