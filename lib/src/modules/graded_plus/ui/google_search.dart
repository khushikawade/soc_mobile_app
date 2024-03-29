import 'package:Soc/src/modules/graded_plus/ui/google_file_search.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';

class GoogleSearchWidget extends StatefulWidget {
  const GoogleSearchWidget(
      {Key? key, required this.selectedFilterValue, this.titleIconData})
      : super(key: key);
  final String selectedFilterValue;
  final IconData? titleIconData;
  @override
  State<GoogleSearchWidget> createState() => _GoogleSearchState();
}

class _GoogleSearchState extends State<GoogleSearchWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

//Separating appbar and body to stop the profile reload on keyboard appearing
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
                commonLogoPath:
                    Color(0xff000000) == Theme.of(context).backgroundColor
                        ? "assets/images/graded+_light.png"
                        : "assets/images/graded+_dark.png",
                refresh: (v) {
                  setState(() {});
                },
                iconData: widget.titleIconData,
                plusAppName: 'GRADED+',
                fromGradedPlus: true,
                onTap: () {
                  Utility.scrollToTop(scrollController: scrollController);
                },
                isSuccessState: ValueNotifier<bool>(true),
                isBackOnSuccess: ValueNotifier<bool>(false),
                key: GlobalKey(),
                isBackButton: true,
                assessmentDetailPage: true,
                assessmentPage: true,
                scaffoldKey: _scaffoldKey,
                isFromResultSection:
                    null //widget.isFromHomeSection == false ? true : null,
                ),
            body: GoogleFileSearchPage(
              scrollController: scrollController,
              selectedFilterValue: widget.selectedFilterValue,
            )),
      ],
    );
  }
}
