import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firstLetterUpperCase.dart';
import '../styles/theme.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final onSaved;
  final String? msg;
  final String? hintText;

  TextFieldWidget(
      {Key? key,
      required this.controller,
      required this.onSaved,
      required this.msg,
      this.hintText})
      : super(key: key);
  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (text) {
        if (text == null || text.isEmpty) {
          return widget.msg;
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      inputFormatters: <TextInputFormatter>[
        //To capitalize first letter of the textfield
        UpperCaseTextFormatter()
      ],

      autofocus: false,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.bold,
          ),
      controller: widget.controller,
      cursorColor: //Theme.of(context).colorScheme.primaryVariant,
          Color(0xff000000) == Theme.of(context).backgroundColor
              ? Color(0xffFFFFFF)
              : Color(
                  0xff000000), //Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        hintText: widget.hintText ?? '',
        hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
            color: Color(0xff000000) == Theme.of(context).backgroundColor
                ? Colors.white.withOpacity(0.5)
                : Colors.black.withOpacity(0.5)),
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
