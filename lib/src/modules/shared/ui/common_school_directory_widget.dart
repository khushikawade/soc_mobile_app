import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/schools_directory/modal/school_directory_list.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:flutter/material.dart';
import '../../../widgets/no_data_found_error_widget.dart';
import '../../schools_directory/ui/school_details.dart';

class CommonSchoolDirectoryWidget extends StatefulWidget {
  final List<SchoolDirectoryList> data;
  final bool? connected;
  final ScrollController? scrollController;
  CommonSchoolDirectoryWidget({Key? key, required this.data, this.connected, required this.scrollController})
      : super(key: key);
  @override
  _CommonSchoolDirectoryWidgetState createState() =>
      _CommonSchoolDirectoryWidgetState();
}

class _CommonSchoolDirectoryWidgetState
    extends State<CommonSchoolDirectoryWidget> {
  static const double _kIconSize = 48.0;
  static const double _kLabelSpacing = 16.0;
  bool? tapped = true;

  Widget _buildList(SchoolDirectoryList obj, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
        vertical: _kLabelSpacing / 2,
      ),
      color: (index % 2 == 0)
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SchoolDetailPage(obj: obj)));
        },
        child: Row(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: Globals.deviceType == "phone"
                    ? _kIconSize * 1.4
                    : _kIconSize * 2,
                height: Globals.deviceType == "phone"
                    ? _kIconSize * 1.5
                    : _kIconSize * 2,
                child: ClipRRect(
                    child: CommonImageWidget(
                  darkModeIconUrl: obj.darkModeIconC,
                  height: Globals.deviceType == "phone"
                      ? _kIconSize * 1.4
                      : _kIconSize * 2,
                  width: Globals.deviceType == "phone"
                      ? _kIconSize * 1.4
                      : _kIconSize * 2,
                  iconUrl: obj.imageUrlC ??
                      Globals.splashImageUrl ??
                      Globals.appSetting.appLogoC,
                  fitMethod: BoxFit.cover,
                ))),
            SizedBox(
              width: _kLabelSpacing / 2,
            ),
            Expanded(
              child: Container(
                child: _buildnewsHeading(obj),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildnewsHeading(SchoolDirectoryList obj) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? TranslationWidget(
                message: obj.titleC ?? "",
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText2!,
                ),
              )
            : Text(
                obj.titleC ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline4!,
              ));
  }

  @override
  Widget build(BuildContext context) {
    return widget.data.length > 0
        ? ListView.builder(
            controller: widget.scrollController,
            // key: ValueKey(key),
            padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
            scrollDirection: Axis.vertical,
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildList(widget.data[index], index);
            },
          )
        : NoDataFoundErrorWidget(
            isCalendarPageOrientationLandscape: false,
            isResultNotFoundMsg: false,
            isNews: false,
            isEvents: false,
            connected: true,
          );
  }
}
