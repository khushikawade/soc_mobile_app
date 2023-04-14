import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PBISPlusBottomSheet extends StatefulWidget {
  final double height;
  final bool content;
  final String? title;
  final EdgeInsetsGeometry? padding;
  PBISPlusBottomSheet(
      {Key? key,
      this.height = 200,
      this.title,
      this.content = true,
      this.padding});
  @override
  State<PBISPlusBottomSheet> createState() => _PBISPlusBottomSheetState();
}

class _PBISPlusBottomSheetState extends State<PBISPlusBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        padding: widget.padding ?? EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xff000000) != Theme.of(context).backgroundColor
              ? Color(0xffF7F8F9)
              : Color(0xff111C20),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        height: widget.height,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: !widget.content
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget?.title?.isNotEmpty ?? false)
                Utility.textWidget(
                    context: context,
                    text: widget.title!,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
              SpacerWidget(20),
              if (widget.content) ...[
                _listTileMenu(
                    leading: SvgPicture.asset(
                      "assets/ocr_result_section_bottom_button_icons/Classroom.svg",
                      height: 30,
                      width: 30,
                    ),
                    title: 'Classroom',
                    onTap: (() {})),
                _listTileMenu(
                    leading: SvgPicture.asset(
                      "assets/ocr_result_section_bottom_button_icons/Spreadsheet.svg",
                      height: 30,
                      width: 30,
                    ),
                    title: 'Spreadsheet',
                    onTap: (() {
                      print("ffffffffffffffffffff");
                    })),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
              ],
              _listTileMenu(
                  leading: Icon(
                    Icons.share,
                    color: Colors.grey,
                  ),
                  title: 'Share',
                  onTap: (() {})),
            ]));
  }

  ListTile _listTileMenu({Widget? leading, String? title, Function()? onTap}) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 20,
      leading: leading,
      title: Utility.textWidget(
          text: title!,
          context: context,
          textTheme: Theme.of(context).textTheme.headline3!),
      onTap: onTap,
    );
  }
}
