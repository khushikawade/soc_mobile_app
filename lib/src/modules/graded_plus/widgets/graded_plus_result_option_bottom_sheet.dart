import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/modal/result_action_icon_modal.dart';

import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradedPlusResultOptionBottomSheet extends StatefulWidget {
  final String? title;
  final double? height;
  final Function({required String title}) getURlForBottomIcons;
  final Function({required String title, required String url}) bottomIconsOnTap;
  final List<BottomIcon> bottomIconModalList;
  const GradedPlusResultOptionBottomSheet(
      {Key? key,
      required this.title,
      this.height = 200,
      required this.getURlForBottomIcons,
      required this.bottomIconsOnTap,
      required this.bottomIconModalList});

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
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(left: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(height: 20),
            ...widget.bottomIconModalList
                .map((BottomIcon element) => _listTileMenu(element: element)),
          ],
        ));
  }

  Opacity _listTileMenu({required BottomIcon element}) {
    String? url = widget.getURlForBottomIcons(title: element.title!);
    return Opacity(
      opacity: ((url?.isEmpty ?? true) || (url == 'NA')) ? 0.3 : 1.0,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 20,
        leading: SvgPicture.asset(
          element.svgPath!,
          height: 30,
          width: 30,
        ),
        title: Utility.textWidget(
            text: element.title!,
            context: context,
            textTheme: Theme.of(context).textTheme.headline3!),
        onTap: () {
          widget.bottomIconsOnTap(title: element.title ?? '', url: url ?? '');
          ;
        },
      ),
    );
  }
}
