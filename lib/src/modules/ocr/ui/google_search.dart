import 'package:Soc/src/modules/ocr/ui/google_file_search.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:flutter/material.dart';

class GoogleSearchWidget extends StatefulWidget {
  const GoogleSearchWidget({Key? key}) : super(key: key);

  @override
  State<GoogleSearchWidget> createState() => _GoogleSearchState();
}

class _GoogleSearchState extends State<GoogleSearchWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

//Separating appbar and body to stop the profile reload on keyboard appearing
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
                isSuccessState: ValueNotifier<bool>(true),
                isbackOnSuccess: ValueNotifier<bool>(false),
                key: GlobalKey(),
                isBackButton: true,
                assessmentDetailPage: true,
                assessmentPage: true,
                scaffoldKey: _scaffoldKey,
                isFromResultSection:
                    null //widget.isFromHomeSection == false ? true : null,
                ),
            body: GoogleFileSearchPage()),
      ],
    );
  }
}
