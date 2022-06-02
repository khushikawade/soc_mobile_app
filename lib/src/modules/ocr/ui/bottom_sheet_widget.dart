import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../widgets/textfield_widget.dart';

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

  // String dropdownValue = "One";
  // final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets / 1.5,
      controller: ModalScrollController.of(context),
      child: Container(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? MediaQuery.of(context).size.height * 0.82
            : MediaQuery.of(context).size.height *
                0.60, //MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListView(
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  icon: Icon(
                    Icons.clear,
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
                        text: 'Scoring Rubic',
                        textTheme:
                            Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Color(0xff000000) !=
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
              ],
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
              child: TextFieldWidget(
                  controller: nameController, onSaved: (String value) {}),
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
              child: TextFieldWidget(
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
            SpacerWidget(5),
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
                      border: Border.all(width: 2, color: Colors.grey.shade200),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  // color: Colors.grey.shade200,

                  height: 115,
                  width: MediaQuery.of(context).size.width,
                  child: imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.contain,
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
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: FloatingActionButton.extended(
                  backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                            customScoreController.text.isNotEmpty
                        // &&
                        // imageFile != null
                        ) {
                      Globals.scoringList.add(CustomRubicModal(
                          name: nameController.text,
                          score: customScoreController.text,
                          img: imageFile != null ? imageFile!.path : ''));
                      widget.update(true);
                      Navigator.pop(context);
                    } else {
                      print("error");
                    }
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
