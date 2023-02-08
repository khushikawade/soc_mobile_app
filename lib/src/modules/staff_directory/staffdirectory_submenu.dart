// ignore_for_file: unnecessary_null_comparison

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/modal/sd_list.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:flutter/material.dart';
import '../../widgets/empty_container_widget.dart';

class StaffDirectoryFolderSubMenu extends StatefulWidget {
  StaffDirectoryFolderSubMenu(
      {Key? key,
      required this.groupName,
      required this.list,
      required this.isAbout})
      : super(key: key);
  final String? groupName;
  final List<SDlist>? list;
  final bool? isAbout;
  @override
  State<StaffDirectoryFolderSubMenu> createState() =>
      _StaffDirectoryFolderSubMenuState();
}

class _StaffDirectoryFolderSubMenuState
    extends State<StaffDirectoryFolderSubMenu> {
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 45.0;
  static const double _kButtonMinSize = 45.0;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        'staff_directory_folder_list');
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'staff_directory_folder_list',
        screenClass: 'StaffDirectoryFolderSubMenu');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isSearch: false,
        isShare: false,
        appBarTitle: widget.groupName!,
        sharedPopBodyText: '',
        sharedPopUpHeaderText: '',
        language: Globals.selectedLanguage,
        marginLeft: 30,
      ),
      body: widget.list!.length == null || widget.list!.length == 0
          ? Center(
              child: NoDataFoundErrorWidget(
                isResultNotFoundMsg: false,
                isNews: false,
                isEvents: false,
                connected: true,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.list!.length,
              itemBuilder: (BuildContext context, int index) {
                return listItem(widget.list, widget.list![index], index);
              },
            ),
    );
  }

  Widget listItem(list, obj, index) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SliderWidget(
                      obj: list,
                      currentIndex: index,
                      isSocialPage: false,
                      isAboutSDPage: widget.isAbout, // true,
                      isNewsPage: false,
                      // iseventpage: false,
                      date: "",
                      isBottomSheet: true,
                      language: Globals.selectedLanguage,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
        padding: EdgeInsets.symmetric(
            horizontal: _kLabelSpacing / 2, vertical: _kLabelSpacing / 1.5),
        decoration: BoxDecoration(
          border: (index % 2 == 0)
              ? Border.all(
                  color: Theme.of(context).colorScheme.background,
                )
              : Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(0.0),
          color: (index % 2 == 0)
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              spreadRadius: 0,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  HorizontalSpacerWidget(_kLabelSpacing / 1.5),
                  CommonImageWidget(
                      darkModeIconUrl: obj.darkModeIconC,
                      height: Globals.deviceType == "phone"
                          ? _kIconSize * 1.4
                          : _kIconSize * 2,
                      width: Globals.deviceType == "phone"
                          ? _kIconSize * 1.4
                          : _kIconSize * 2,
                      fitMethod: BoxFit.cover,
                      iconUrl: obj.imageUrlC ??
                          Globals.splashImageUrl ??
                          Globals.appSetting.appLogoC),
                  HorizontalSpacerWidget(_kLabelSpacing),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TranslationWidget(
                          message: obj.name ?? "-",
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                              translatedMessage.toString(),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headline2!),
                        ),
                        obj.designation != null && obj.designation != ""
                            ? TranslationWidget(
                                message: obj.designation,
                                toLanguage: Globals.selectedLanguage,
                                fromLanguage: "en",
                                builder: (translatedMessage) => Text(
                                    translatedMessage.toString(),
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.headline2!),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  obj.phoneC != null && obj.phoneC != ""
                      ? Container(
                          height: _kButtonMinSize,
                          width: _kButtonMinSize,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(8),
                            ),
                            onPressed: () {
                              Utility.launchUrlOnExternalBrowser(
                                  "tel:" + obj.phoneC);
                            },
                            child: Icon(
                              Icons.local_phone_outlined,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        )
                      : EmptyContainer(),
                  HorizontalSpacerWidget(_kLabelSpacing / 2),
                  obj.emailC != null && obj.emailC != ""
                      ? Container(
                          height: _kButtonMinSize,
                          width: _kButtonMinSize,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(6),
                              ),
                              onPressed: () {
                                Utility.launchUrlOnExternalBrowser(
                                    "mailto:" + obj.emailC);
                              },
                              child: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context).colorScheme.background,
                              )),
                        )
                      : EmptyContainer()
                ]),
          ],
        ),
      ),
    );
  }
}
