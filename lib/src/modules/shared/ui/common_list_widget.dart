import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/families/ui/event_with_banners.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/staff_directory/staffdirectory.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/services/parent_profile_details.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/student_plus_family_login.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_ui/student_plus_home.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/modules/shared/ui/common_sublist.dart';
import 'package:Soc/src/widgets/custom_image_widget_small.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../../widgets/no_data_found_error_widget.dart';
import '../../schools_directory/ui/schools_directory.dart';

class CommonListWidget extends StatefulWidget {
  CommonListWidget({
    Key? key,
    required this.data,
    this.bottomPadding,
    required this.sectionName,
    required this.scaffoldKey,
    required this.scrollController,
    this.connected,
  }) : super(key: key);

  final bool? connected;
  final List<SharedList> data;
  final scaffoldKey;
  final String sectionName;
  final double? bottomPadding;
  final ScrollController? scrollController;
  // ;

  @override
  _CommonListWidgetState createState() => _CommonListWidgetState();
}

class _CommonListWidgetState extends State<CommonListWidget> {
  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
  _launchURL(SharedList obj, String queryParameter) async {
    // UNCOMMENT
    if (obj.appUrlC.toString().split(":")[0] == 'http' ||
        obj.deepLinkC == 'YES') {
      await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
    } else {
      // //print(queryParameter=='' ? obj.appUrlC! : obj.appUrlC!+'?'+queryParameter);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC!,
                    url: obj
                        .appUrlC!, //queryParameter=='' ? obj.appUrlC! : obj.appUrlC!+'?'+queryParameter,
                    isBottomSheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  _navigate(SharedList obj, index) async {
    await FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "${widget.sectionName}_${obj.titleC!}");

    if (obj.typeC == "Contact") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ContactPage(
                    obj: Globals.appSetting,
                    isBottomSheet: true,
                    appBarTitle: obj.titleC!,
                    language: Globals.selectedLanguage ?? "English",
                  )));
    } else if (obj.typeC == "URL") {
      obj.appUrlC != null && obj.appUrlC != ""
          ? await _launchURL(obj, '')
          : Utility.showSnackBar(
              widget.scaffoldKey, "No link available", context, null);
    } else if (obj.typeC == "Form") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    isCustom: widget.sectionName == 'Custom' ? true : false,
                    staffDirectoryCategoryId: null,
                    isAbout: true,
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isSubmenu: true,
                    isBottomSheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "Calendar/Events") {
      obj.calendarId != null && obj.calendarId != ""
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => EventPage(
                        isBottomSheet: true,
                        appBarTitle: obj.titleC,
                        language: Globals.selectedLanguage,
                        calendarId: obj.calendarId.toString(),
                      )))
          : Utility.showSnackBar(widget.scaffoldKey,
              "No calendar/events available", context, null);
    } else if (obj.typeC == "RTF_HTML" ||
        obj.typeC == "RFT_HTML" ||
        obj.typeC == "HTML/RTF" ||
        obj.typeC == "RTF/HTML") {
      obj.rtfHTMLC != null
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        isBottomSheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC!,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(
              widget.scaffoldKey, "No data available", context, null);
    } else if (obj.typeC == "Embed iFrame") {
      obj.rtfHTMLC != null
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        isiFrame: true,
                        title: obj.titleC!,
                        url: obj.rtfHTMLC.toString(),
                        isBottomSheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(
              widget.scaffoldKey, "No data available", context, null);
    } else if (obj.typeC == "PDF URL" || obj.typeC == "PDF") {
      obj.pdfURL != null
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CommonPdfViewerPage(
                        isOCRFeature: false,
                        isHomePage: false,
                        url: obj.pdfURL,
                        title: obj.titleC,
                        isBottomSheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(
              widget.scaffoldKey, "No pdf available", context, null);
    } else if (obj.typeC == "Sub-Menu") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SubListPage(
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    module: widget.sectionName,
                    isBottomSheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "Staff_Directory") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    isCustom: false,
                    staffDirectoryCategoryId: obj.id,
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isSubmenu: true,
                    isBottomSheet: true,
                    isAbout: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "School Directory" ||
        obj.typeC == 'Org Directory') {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SchoolDirectoryPage(
                    title: obj.titleC,
                    isSubmenu: obj.typeC == 'Org Directory' ? true : false,
                    obj: obj,
                    isStandardPage: false,
                    isCustomSection: false, //Since its a record here
                  )));
      // } else if (obj.typeC == "OCR") {
      //   if (obj.isSecure == 'true') {
      //     obj.appUrlC != null && obj.appUrlC != ""
      //         ? await _launchURL(obj,Globals.appSetting.appLogoC)
      //         : Utility.showSnackBar(
      //             widget.scaffoldKey, "No authentication URL available", context);
      //   } else {
      //      await Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (BuildContext context) =>
      //                                 OpticalCharacterRecognition()));}
    } else if (obj.typeC == "STUDENT+") {
      familyLogin();
    } else {
      Utility.showSnackBar(
          widget.scaffoldKey, "No data available", context, null);
    }
    // Utility.setLocked();
  }

  Widget _buildLeading(SharedList obj) {
    if (obj.appIconUrlC != null) {
      return CustomIconMode(
        darkModeIconUrl: obj.darkModeIconC,
        iconUrl: obj.appIconUrlC ?? Overrides.defaultIconUrl,
      );
    } else if (obj.appIconC != null) {
      return Icon(
        IconData(
          int.parse('0x${obj.appIconC!}'),
          fontFamily: 'FontAwesomeSolid',
          fontPackage: 'font_awesome_flutter',
        ),
        color: Theme.of(context).colorScheme.primary,
        size: Globals.deviceType == "phone" ? 24 : 32,
      );
    } else {
      return CustomIconMode(
        darkModeIconUrl: obj.darkModeIconC,
        iconUrl: Overrides.defaultIconUrl,
      );
    }
  }

  Widget _buildList(SharedList obj, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.background,
          width: 0.65,
        ),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        onTap: () {
          _navigate(obj, index);
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        // contentPadding:
        //     EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
        leading: _buildLeading(obj),
        title: TranslationWidget(
            message: obj.titleC ?? "No title",
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) {
              return Text(translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText1!);
            }),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: Globals.deviceType == "phone" ? 12 : 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.data.length > 0
        ? Column(children: [
            blocListener(),
            ListView.builder(
                controller: widget.scrollController,
                //  controller: widget.scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    bottom: widget.bottomPadding ?? AppTheme.klistPadding),
                scrollDirection: Axis.vertical,
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(widget.data[index], index);
                })
          ])
        : NoDataFoundErrorWidget(
            isCalendarPageOrientationLandscape: false,
            isResultNotFoundMsg: false,
            isNews: false,
            isEvents: false,
            connected: true);
  }

  familyLogin() async {
    List<UserInformation> _profileData =
        await FamilyUserDetails.getFamilyUserProfile();

    if (_profileData.isEmpty &&
        (_profileData[0].familyToken == null ||
            _profileData[0].familyToken == "")) {
      pushNewScreen(
        context,
        screen: StudentPlusFamilyLogIn(),
        withNavBar: false,
      );
      // } else {
      //   if (_profileData[0].familyToken == null ||
      //       _profileData[0].familyToken == "") {
      //     pushNewScreen(
      //       context,
      //       screen: StudentPlusFamilyLogIn(),
      //       withNavBar: false,
      //     );
    } else {
      _studentPlusBloc.add(GetStudentListFamilyLogin());
    }
    // }
  }

  /* ------------- widget to fetch student Detail and show loader ------------ */

  Widget blocListener() {
    return BlocListener<StudentPlusBloc, StudentPlusState>(
      bloc: _studentPlusBloc,
      listener: (context, state) async {
        if (state is FamilyLoginLoading) {
          Utility.showLoadingDialog(
            context: context,
            isOCR: true,
          );
        } else if (state is StudentPlusSearchSuccess) {
          // PlusUtility.updateLogs(
          //     activityType: 'STUDENT+',
          //     userType: 'Teacher',
          //     activityId: '48',
          //     description: 'Student Search Success',
          //     operationResult: 'Success');
          Navigator.pop(context);
          pushNewScreen(
            context,
            screen: StudentPlusHome(
              sectionType: "Family",
              studentPlusStudentInfo: StudentPlusDetailsModel(
                  studentIdC: state.obj[0].studentIDC,
                  firstNameC: state.obj[0].firstNameC,
                  lastNameC: state.obj[0].lastNameC,
                  classC: state.obj[0].classC),
              index: 0,
              //   index: widget.index,
            ),
            withNavBar: false,
          );
        }
      },
      child: Container(),
    );
  }
}
