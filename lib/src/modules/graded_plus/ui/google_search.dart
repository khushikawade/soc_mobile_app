import 'package:Soc/src/modules/graded_plus/ui/google_file_search.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';

class GoogleSearchWidget extends StatefulWidget {
  const GoogleSearchWidget({Key? key, required this.selectedFilterValue})
      : super(key: key);
  final String selectedFilterValue;
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
