import 'package:flutter/material.dart';
import '../styles/theme.dart';

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget({Key? key, required this.controller, required this.onSaved})
      : super(key: key);
  final TextEditingController controller;
  final onSaved;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  // Widget textFormField(
  //     {required TextEditingController controller, required onSaved}) {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      textAlign: TextAlign.start,
      style: Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
      controller: widget.controller,
      cursorColor: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xffFFFFFF)
          : Color(0xff000000), //Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.kButtonColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme
                .kButtonColor, // Theme.of(context).colorScheme.primaryVariant,
          ),
        ),
        contentPadding: EdgeInsets.only(top: 10, bottom: 10),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.kButtonColor,
          ),
        ),
      ),
      onChanged: widget.onSaved,
    );
  }
}
