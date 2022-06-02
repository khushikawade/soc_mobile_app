import 'dart:convert';
import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BottomSheetWidget extends StatefulWidget {
  BottomSheetWidget({Key? key, required this.update}) : super(key: key);
  final ValueChanged<bool> update;

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final nameController = TextEditingController();
  final customScoreController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  // final formKey = new GlobalKey<FormState>();

  final _formKey = GlobalKey<FormState>();

  // void _saveForm() {
  //   final isValid = _form.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  // }

  final GoogleDriveBloc _googleBloc = new GoogleDriveBloc();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets / 1.5,
      controller: ModalScrollController.of(context),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide.none),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Utility.textWidget(
                        context: context,
                        text: 'Scoring Rubic ',
                        textTheme: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Utility.textWidget(
                    context: context,
                    text: 'Score Name ',
                    textTheme: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.black)),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: textFormField(
                    msg: "Add Name Please",
                    controller: nameController,
                    onSaved: (String value) {}),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Utility.textWidget(
                    context: context,
                    text: 'Custom Score',
                    textTheme: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.black)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: textFormField(
                    msg: "Add Score Please",
                    controller: customScoreController,
                    onSaved: (String value) {}),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Utility.textWidget(
                    context: context,
                    text: 'Add Image',
                    textTheme: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.black)),
              ),
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
                        border:
                            Border.all(width: 2, color: Colors.grey.shade200),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    // color: Colors.grey.shade200,

                    height: 115,
                    width: MediaQuery.of(context).size.width,
                    child: imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : Container(
                            child: Center(
                              child: Icon(
                                Icons.add_a_photo,
                                color: AppTheme.kButtonColor.withOpacity(1.0),
                              ),
                            ),
                          ),

                    //  imageFile != null
                    //     ? Image.file(
                    //         imageFile!,
                    //         fit: BoxFit.fitWidth,
                    //       )
                    //     : Container(
                    //         child: Center(
                    //           child: Icon(Icons.add_a_photo),
                    //         ),
                    //       ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: FloatingActionButton.extended(
                    backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // TODO submit

                        if (imageFile != null) {
                          List<int> imageBytes = imageFile!.readAsBytesSync();
                          String imageB64 = base64Encode(imageBytes);

                          Globals.scoringList.add(CustomRubicModal(
                              name: nameController.text,
                              score: customScoreController.text,
                              imgBase64: imageB64,
                              customOrStandardRubic: "Custom"));

                          _googleBloc.add(ImageToAwsBucked(
                              imgBase64: Globals.scoringList.last.imgBase64));
                        } else {
                          Globals.scoringList.add(CustomRubicModal(
                              name: nameController.text,
                              score: customScoreController.text,
                              customOrStandardRubic: "Custom"));
                        }

                        widget.update(true);
                        Navigator.pop(
                          context,
                        );
                      }

                      // if (nameController.text.isNotEmpty &&
                      //     customScoreController.text.isNotEmpty) {
                      //   List<int> imageBytes;
                      //   if (imageFile != null) {
                      //     imageBytes = imageFile!.readAsBytesSync();
                      //     String imageB64 = base64Encode(imageBytes);
                      //     print("image64 is recived --------->$imageB64");
                      //     Globals.scoringList.add(CustomRubicModal(
                      //         name: nameController.text,
                      //         score: customScoreController.text,
                      //         imgBase64: imageB64,
                      //         customOrStandardRubic: "Custom"));

                      //     _googleBloc.add(ImageToAwsBucked(
                      //         imgBase64: Globals.scoringList.last.imgBase64));
                      //   } else {
                      //     Globals.scoringList.add(CustomRubicModal(
                      //         name: nameController.text,
                      //         score: customScoreController.text,
                      //         customOrStandardRubic: "Custom"));
                      //   }

                      //   widget.update(true);
                      //   Navigator.pop(
                      //     context,
                      //   );
                      // } else {
                      //   print("error");
                      // }
                    },
                    label: Row(
                      children: [
                        Utility.textWidget(
                            text: 'Submit',
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    color: Theme.of(context).backgroundColor)),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFormField(
      {required TextEditingController controller,
      required onSaved,
      required String? msg}) {
    return TextFormField(
      validator: (text) {
        if (text == null || text.isEmpty) {
          return msg;
        }
        return null;
      },
      autofocus: false,
      //
      textAlign: TextAlign.start,
      style: Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primaryVariant,
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
      onChanged: onSaved,
    );
  }

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
  // void _showbottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20.0),
  //         topRight: Radius.circular(20.0),
  //       )),
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height / 5,
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   SizedBox(
  //                     width: 20,
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: Text(
  //                       "Picture",
  //                       style: Theme.of(context).textTheme.subtitle1!.copyWith(
  //                           fontWeight: FontWeight.bold, color: Colors.black),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Row(
  //                 children: [
  //                   SizedBox(
  //                     width: 20.0,
  //                   ),
  //                   Column(
  //                     children: [
  //                       InkWell(
  //                         onTap: () {
  //                           _cameraImage(context);
  //                         },
  //                         child: CircleAvatar(
  //                           backgroundColor:
  //                               AppTheme.kButtonColor.withOpacity(1.0),
  //                           radius: 35,
  //                           child: Icon(
  //                             Icons.camera,
  //                             color: Colors.white,
  //                             size: 30,
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 5.0,
  //                       ),
  //                       Text(
  //                         "Camera",
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .subtitle1!
  //                             .copyWith(
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.black),
  //                         // style: AppTheme.userEmailStyle,
  //                       )
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     width: 20.0,
  //                   ),
  //                   Column(
  //                     children: [
  //                       InkWell(
  //                         onTap: () {
  //                           _imgFromGallery(context);
  //                         },
  //                         child: CircleAvatar(
  //                           backgroundColor:
  //                               AppTheme.kButtonColor.withOpacity(1.0),
  //                           radius: 35,
  //                           child: Icon(
  //                             Icons.phone_android,
  //                             color: Colors.white,
  //                             size: 30,
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 5.0,
  //                       ),
  //                       Text(
  //                         "Gallery",
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .subtitle1!
  //                             .copyWith(
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.black),
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

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
}
