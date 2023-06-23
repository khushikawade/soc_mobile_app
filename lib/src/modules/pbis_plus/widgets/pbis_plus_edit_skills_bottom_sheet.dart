import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_common_popup.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'hero_dialog_route.dart';

class PBISPlusEditSkillsBottomSheet extends StatefulWidget {
  final double? height;
  PBISPlusActionInteractionModalNew? item;
  ValueNotifier<List<PBISPlusActionInteractionModalNew>>? containerIcons;
  PBISPlusEditSkillsBottomSheet(
      {Key? key,
      this.height = 100,
      required this.item,
      required this.containerIcons});
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
              _buildEditNameWidget(widget.item?.title)
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

  Widget EditAndDeleteIcon(PBISPlusActionInteractionModalNew? item) {
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
                        item: item);
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
      PBISPlusActionInteractionModalNew? item}) {
    Navigator.of(context).pushReplacement(HeroDialogRoute(
        builder: (context) => PBISPlusCommonPopup(
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
  }

  Widget _buildEditNameWidget(iconName) {
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
                text: "${"Edit " + iconName}",
                textTheme: Theme.of(context).textTheme.headline5!),
          ),
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
