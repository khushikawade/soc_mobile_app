// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class PlusAppSearchBar extends StatefulWidget {
  final String? sectionName;
  final TextEditingController controller;
  final double kLabelSpacing;
  final FocusNode focusNode;
  final void Function()? onTap;
  final void Function()? iconOnTap;
  final bool autoFocus;
  final String hintText;

  final onItemChanged;
  final bool isMainPage;

  const PlusAppSearchBar({
    Key? key,
    required this.sectionName,
    required this.hintText,
    this.onTap,
    this.onItemChanged,
    this.iconOnTap,
    required this.isMainPage,
    required this.autoFocus,
    required this.kLabelSpacing,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<PlusAppSearchBar> createState() => _PlusAppSearchBarState();
}

class _PlusAppSearchBarState extends State<PlusAppSearchBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        padding: EdgeInsets.symmetric(
            vertical: widget.kLabelSpacing / 3,
            horizontal: widget.kLabelSpacing / 3.5),
        child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.transparent,
            child: widget.isMainPage == true
                ? mainSearchBar(widget.hintText)
                : innerSearchBar(widget.hintText)),
      ),
    );
  }

  Widget mainSearchBar(String translatedMessage) {
    return TextFormField(
        enabled: widget.isMainPage,
        autofocus: widget.autoFocus,
        style: Theme.of(context).textTheme.headline5,
        focusNode: widget.focusNode,
        controller: widget.controller,
        cursorColor: Theme.of(context).colorScheme.primaryVariant,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(color: AppTheme.kButtonColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 2),
            ),
            hintStyle: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontWeight: FontWeight.w300, color: Colors.grey),
            hintText: translatedMessage.toString(),
            fillColor: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Theme.of(context).colorScheme.secondary
                : Color.fromARGB(255, 12, 20, 23),
            //Theme.of(context).colorScheme.secondary,
            suffixIcon: IconButton(
                onPressed: widget.iconOnTap,
                icon: Icon(
                    widget.controller.text == '' ||
                            widget.controller.text.isEmpty
                        ? const IconData(0xe805,
                            fontFamily: Overrides.kFontFam,
                            fontPackage: Overrides.kFontPkg)
                        : Icons.clear,
                    color: Theme.of(context).colorScheme.primaryVariant,
                    size: Globals.deviceType == "phone" ? 20 : 28)),
            prefix: SizedBox(width: 20)),
        onChanged: widget.onItemChanged);
  }

  Widget innerSearchBar(String translatedMessage) {
    return TextFormField(
        autofocus: widget.autoFocus,
        style: Theme.of(context).textTheme.headline5,
        focusNode: widget.focusNode,
        controller: widget.controller,
        cursorColor: Theme.of(context).colorScheme.primaryVariant,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(color: AppTheme.kButtonColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 2),
            ),
            hintStyle: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontWeight: FontWeight.w300, color: Colors.grey),
            hintText: translatedMessage.toString(),
            fillColor: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Theme.of(context).colorScheme.secondary
                : Color.fromARGB(255, 12, 20, 23),
            suffixIcon: IconButton(
                onPressed: widget.iconOnTap,
                icon: Icon(
                    widget.controller.text == ''
                        ? const IconData(0xe805,
                            fontFamily: Overrides.kFontFam,
                            fontPackage: Overrides.kFontPkg)
                        : Icons.clear,
                    color: Theme.of(context).colorScheme.primaryVariant,
                    size: Globals.deviceType == "phone" ? 20 : 28)),
            prefix: SizedBox(
              width: 20,
            )),
        onTap: widget.onTap,
        onChanged: widget.sectionName == 'PBIS+' ? widget.onItemChanged : null);
  }
}
