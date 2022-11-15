import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/overrides.dart';

import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../services/firstLetterUpperCase.dart';
import '../../../widgets/textfield_widget.dart';

// ignore: must_be_immutable
class EditBottomSheet extends StatefulWidget {
  EditBottomSheet(
      {Key? key,
      required this.title,
      required this.isImageField,
      required this.textFieldTitleOne,
      this.textFieldTitleTwo,
      this.textFileTitleThree,
      this.sheetHeight,
      required this.isSubjectScreen,
      this.onTap,
      this.valueChanged,
      required this.textFieldControllerOne,
      required this.textFieldControllerTwo,
      required this.textFieldControllerthree,
      required this.update})
      : super(key: key);

  final bool? isImageField;
  final String? title;
  final String? textFieldTitleOne;
  final String? textFieldTitleTwo;
  final String? textFileTitleThree;
  final double? sheetHeight;
  final bool? isSubjectScreen;
  final VoidCallback? onTap;
  final ValueChanged? valueChanged;
  final TextEditingController textFieldControllerOne;
  final TextEditingController textFieldControllerTwo;
  final TextEditingController textFieldControllerthree;
  final Function(
      {required TextEditingController name,
      required TextEditingController id,
      required TextEditingController score}) update;
  @override
  State<EditBottomSheet> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<EditBottomSheet> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  // final formKey = new GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final GoogleDriveBloc _googleBloc = new GoogleDriveBloc();
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets / 1.1,
      controller: ModalScrollController.of(context),
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        height: widget.sheetHeight != null
            ? widget.sheetHeight
            : MediaQuery.of(context).orientation == Orientation.landscape
                ? MediaQuery.of(context).size.height * 0.82
                : MediaQuery.of(context).size.height *
                    0.60, //MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Color(0xff000000) != Theme.of(context).backgroundColor
              ? Color(0xffF7F8F9)
              : Color(0xff111C20),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
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
            Container(
              height: 60,
              decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide.none),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              child: Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.symmetric(vertical: 10),
                child: Utility.textWidget(
                    context: context,
                    text: widget.title!,
                    textTheme: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color(0xffFFFFFF)
                              : Color(0xff000000),
                          fontSize: Globals.deviceType == "phone"
                              ? AppTheme.kBottomSheetTitleSize
                              : AppTheme.kBottomSheetTitleSize * 1.3,
                        )
                    // textTheme: Theme.of(context)
                    //     .textTheme
                    //     .headline3!
                    //     .copyWith(
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.bold)
                    ),
              ),
            ),
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  //   physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.textFieldTitleOne != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Utility.textWidget(
                                      context: context,
                                      text: widget.textFieldTitleOne!,
                                      textTheme: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Color(0xff000000) ==
                                                    Theme.of(context)
                                                        .backgroundColor
                                                ? Color(0xffFFFFFF)
                                                : Color(0xff000000),
                                          )),
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: _textFiled(
                                        whichContoller: 1,
                                        msg: "field is required ",
                                        controller:
                                            widget.textFieldControllerOne))
                              ])
                        : Container(),
                    widget.textFieldTitleTwo != null
                        ? Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, top: 25),
                                    child: Utility.textWidget(
                                        context: context,
                                        text: widget.textFieldTitleTwo!,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: Color(0xff000000) ==
                                                      Theme.of(context)
                                                          .backgroundColor
                                                  ? Color(0xffFFFFFF)
                                                  : Color(0xff000000),
                                            )),
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: _textFiled(
                                          whichContoller: 2,
                                          // keyboardType:
                                          //     Overrides.STANDALONE_GRADED_APP ==
                                          //             true
                                          //         ? null
                                          //         : TextInputType.number,
                                          // maxNineDigit:
                                          //     Overrides.STANDALONE_GRADED_APP ==
                                          //             true
                                          //         ? null
                                          //         : null,
                                          msg:
                                              Overrides.STANDALONE_GRADED_APP ==
                                                      true
                                                  ? 'enter a valid Email'
                                                  : "field is required",
                                          controller:
                                              widget.textFieldControllerTwo)),
                                  if (Overrides.STANDALONE_GRADED_APP == true)
                                    SizedBox(
                                      height: 20,
                                    )
                                ]),
                          )
                        : Container(),
                    SpacerWidget(20),
                    widget.textFileTitleThree != null
                        ? Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Utility.textWidget(
                                        context: context,
                                        text: widget.textFileTitleThree!,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: Color(0xff000000) ==
                                                      Theme.of(context)
                                                          .backgroundColor
                                                  ? Color(0xffFFFFFF)
                                                  : Color(0xff000000),
                                            )),
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: _textFiled(
                                          whichContoller: 3,
                                          keyboardType: TextInputType.number,
                                          maxNineDigit: 1,
                                          msg: "field is required ",
                                          controller:
                                              widget.textFieldControllerthree)),
                                ]),
                          )
                        : Container(),
                    widget.isImageField!
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Utility.textWidget(
                                      context: context,
                                      text: 'Add Image',
                                      textTheme: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Color(0xff000000) ==
                                                    Theme.of(context)
                                                        .backgroundColor
                                                ? Color(0xffFFFFFF)
                                                : Color(0xff000000),
                                          )),
                                ),
                                SpacerWidget(5),
                                // InkWell(
                                //   onTap: () {
                                //     showActionsheet(context);
                                //   },
                                //   child: Padding(
                                //     padding: EdgeInsets.symmetric(
                                //       horizontal: 20,
                                //     ),
                                //     child: textFormField(
                                //         msg: "Add Name Please",
                                //         controller: nameController,
                                //         onSaved: (String value) {}),
                                //   ),
                                // ),
                                SpacerWidget(10),
                                InkWell(
                                  onTap: () {
                                    showActionsheet(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          border: Border.all(
                                              width: 2,
                                              color: Colors.grey.shade200),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      // color: Colors.grey.shade200,

                                      height: 115,
                                      width: MediaQuery.of(context).size.width,
                                      child: imageFile != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                imageFile!,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )
                                          : Container(
                                              child: Center(
                                                child: Icon(
                                                  Icons.add_a_photo,
                                                  color: AppTheme.kButtonColor
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ])
                        : Container(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      child: FloatingActionButton.extended(
                          backgroundColor:
                              AppTheme.kButtonColor.withOpacity(1.0),
                          onPressed: () async {
                            //  dnakhfkahj
                            if (_formKey.currentState!.validate()) {
                              widget.update(
                                  name: widget.textFieldControllerOne,
                                  id: widget.textFieldControllerTwo,
                                  score: widget.textFieldControllerthree);
                            }
                          },
                          label: Row(
                            children: [
                              Utility.textWidget(
                                  text: 'Update',
                                  context: context,
                                  textTheme: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .backgroundColor)),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget textFormField(
  //     {required TextEditingController controller,
  //     required onSaved,
  //     required String? msg}) {
  //   return TextFormField(
  //     validator: (text) {
  //       if (text == null || text.isEmpty) {
  //         return msg;
  //       }
  //       return null;
  //     },
  //     autofocus: false,
  //     //
  //     textAlign: TextAlign.start,
  //     style: Theme.of(context)
  //         .textTheme
  //         .subtitle1!
  //         .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
  //     controller: controller,
  //     cursorColor: Theme.of(context).colorScheme.primaryVariant,
  //     decoration: InputDecoration(
  //       fillColor: Colors.transparent,
  //       enabledBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(
  //           color: AppTheme.kButtonColor,
  //         ),
  //       ),
  //       focusedBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(
  //           color: AppTheme
  //               .kButtonColor, // Theme.of(context).colorScheme.primaryVariant,
  //         ),
  //       ),
  //       contentPadding: EdgeInsets.only(top: 10, bottom: 10),
  //       border: UnderlineInputBorder(
  //         borderSide: BorderSide(
  //           color: AppTheme.kButtonColor,
  //         ),
  //       ),
  //     ),
  //     onChanged: onSaved,
  //   );
  // }

  // _getImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       // isImageEmpty = false;
  //       imageFile = File(image.path);
  //     });
  //   } else {
  //     //  isImageEmpty = true;
  //   }
  // }

  showActionsheet(context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text(
                "Camera",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                _cameraImage(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(
                "Gallery",
                style: TextStyle(color: Colors.blue),
              ),
              isDestructiveAction: true,
              onPressed: () {
                _imgFromGallery(context);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
  }

  Future<void> _cameraImage(BuildContext context) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);

        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }

  _imgFromGallery(BuildContext context) async {
    XFile? image = (await _picker.pickImage(
      source: ImageSource.gallery,
    ));
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget _textFiled({
    required int whichContoller,
    required String msg,
    required TextEditingController controller,
    int? maxNineDigit,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      keyboardType: keyboardType ?? null,
      maxLength: maxNineDigit ?? null,
      textInputAction: TextInputAction.next,
      inputFormatters: keyboardType == null
          ? <TextInputFormatter>[]
          : <TextInputFormatter>[
              //To capitalize first letter of the textfield
              UpperCaseTextFormatter()
            ],

      validator: (text) {
        if (text == null || text.isEmpty) {
          return msg;
        }
        //  else {
        //   if (whichContoller == 2) {
        //     if (Overrides.STANDALONE_GRADED_APP == true &&
        //         !regex.hasMatch(text)) {
        //       return msg;
        //     } else if (Overrides.STANDALONE_GRADED_APP != true &&
        //         text.length < 3) {
        //       return msg;
        //     } else {
        //       return null;
        //     }
        //   } else if (text.length != 1 && whichContoller == 3) {
        //     return msg;
        //   }
        // }

        return null;
      },

      autofocus: false,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.bold,
          ),
      controller: controller,
      cursorColor: //Theme.of(context).colorScheme.primaryVariant,
          Color(0xff000000) == Theme.of(context).backgroundColor
              ? Color(0xffFFFFFF)
              : Color(
                  0xff000000), //Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        counterStyle: TextStyle(
            color: Color(0xff000000) == Theme.of(context).backgroundColor
                ? Color(0xffFFFFFF)
                : Color(0xff000000)),
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
      onChanged: (vlaue) {},
    );
  }
}
