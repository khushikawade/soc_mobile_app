import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/result_action_icon_modal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradedPlusResultOptionBottomSheet extends StatefulWidget {
  final String? title;
  final double? height;
  final Function({required String title}) getURlForResultSummaryIcons;
  final Function({required String title, required String url})
      resultSummaryIconsOnTap;
  final List<ResultSummaryIcons> resultSummaryIconsModalList;
  final ValueNotifier<bool> classroomUrlStatus;
  const GradedPlusResultOptionBottomSheet(
      {Key? key,
      this.title,
      this.height = 200,
      required this.getURlForResultSummaryIcons,
      required this.resultSummaryIconsOnTap,
      required this.resultSummaryIconsModalList,
      required this.classroomUrlStatus});

  @override
  State<GradedPlusResultOptionBottomSheet> createState() =>
      _GradedPlusResultOptionBottomSheetState();
}

class _GradedPlusResultOptionBottomSheetState
    extends State<GradedPlusResultOptionBottomSheet> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Color(0xff000000) != Theme.of(context).backgroundColor
              ? Color(0xffF7F8F9)
              : Color(0xff111C20),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(left: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                icon: Icon(
                  Icons.clear,
                  color: AppTheme.kButtonColor,
                  size: Globals.deviceType == "phone" ? 28 : 36,
                ),
              ),
            ),
            widget?.title?.isNotEmpty ?? false
                ? Utility.textWidget(
                    context: context,
                    text: widget.title!,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18))
                : Container(),
            ...widget.resultSummaryIconsModalList.map(
                (ResultSummaryIcons element) =>
                    _listTileMenu(element: element)),
          ],
        ));
  }

  Widget _listTileMenu({required ResultSummaryIcons element}) {
    return ValueListenableBuilder(
        valueListenable: widget.classroomUrlStatus,
        child: Container(),
        builder: (BuildContext context, bool value, Widget? child) {
          String? url =
              widget.getURlForResultSummaryIcons(title: element.title!);
          return Opacity(
            opacity:
                //((url?.isEmpty ?? true) || (url == 'NA')) ? 0.3 :
                1.0,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 20,
              leading: (element.title == "Class" &&
                      !widget.classroomUrlStatus.value)
                  ? Container(
                      padding: EdgeInsets.all(3),
                      width: Globals.deviceType == "phone" ? 28 : 50,
                      height: Globals.deviceType == "phone" ? 28 : 50,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        strokeWidth:
                            MediaQuery.of(context).size.shortestSide * 0.005,
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ))
                  : SvgPicture.asset(element.svgPath!,
                      height: 30,
                      width: 30,
                      color: element.title == "Dashboard"
                          ? Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20)
                          : null),
              title: Utility.textWidget(
                  text: element.title!,
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline3!),
              onTap: () {
                widget.resultSummaryIconsOnTap(
                    title: element.title ?? '', url: url ?? '');
                ;
              },
            ),
          );
        });
  }
}
