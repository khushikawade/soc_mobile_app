import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';

class PBISCircularProfileName extends StatefulWidget {
  final String? firstLetter;
  final String? lastLetter;
  final double? profilePictureSize;
  PBISCircularProfileName(
      {Key? key, this.firstLetter, this.lastLetter, this.profilePictureSize});
  @override
  State<PBISCircularProfileName> createState() =>
      _PBISCircularProfileNameState();
}

class _PBISCircularProfileNameState extends State<PBISCircularProfileName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        radius: widget.profilePictureSize,
        backgroundColor: Color(0xff000000) == Theme.of(context).backgroundColor
            ? Color(0xffF7F8F9)
            : Color(0xff111C20),
        child: Utility.textWidget(
          maxLines: 2,
          text: widget.firstLetter!.toUpperCase() +
              widget.lastLetter!.toUpperCase(),
          context: context,
          textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                color: Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Color(0xffF7F8F9)
                    : Color(0xff111C20),
              ),
        ),
      ),
    );
  }
}
