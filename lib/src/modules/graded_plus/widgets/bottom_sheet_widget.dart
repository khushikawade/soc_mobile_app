import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/graded_plus/modal/RubricPdfModal.dart';
import 'package:Soc/src/modules/graded_plus/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/graded_plus_camera_screen.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../widgets/textfield_widget.dart';

class BottomSheetWidget extends StatefulWidget {
  BottomSheetWidget(
      {Key? key,
      this.update,
      required this.title,
      required this.isImageField,
      required this.textFieldTitleOne,
      this.textFieldTitleTwo,
      this.sheetHeight,
      required this.isSubjectScreen,
      this.onTap,
      this.valueChanged,
      this.section,
      this.rubricPdfModalList,
      this.tileOnTap,
      this.submitButton})
      : super(key: key);
  // final bool? isMcqSheet;
  // final bool? selectedAnswer;
  final ValueChanged<bool>? update;
  final bool? isImageField;
  final String? title;
  final String? textFieldTitleOne;
  final String? textFieldTitleTwo;
  final double? sheetHeight;
  final bool? isSubjectScreen;
  final VoidCallback? onTap;
  final ValueChanged? valueChanged;
  var section;
  final List<RubricPdfModal>? rubricPdfModalList;
  final Function(dynamic)? tileOnTap;
  var submitButton;
  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final studentNameController = TextEditingController();
  final textFieldController2 = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  // final formKey = new GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final GoogleDriveBloc _googleBloc = new GoogleDriveBloc();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets / 1.5,
      controller: ModalScrollController.of(context),
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
                color: AppTheme.kButtonColor,
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
                        )),
              ),
            ),
            if (widget.section == 'PDF section')
              Expanded(
                  child: rubricPdfListBuilder(
                      pdfInfoList: widget.rubricPdfModalList!))
            else if (widget.section == 'MCQ Assessment')
              _selectSection()
            else
              Form(
                key: _formKey,
                child: Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Utility.textWidget(
                            context: context,
                            text: widget.textFieldTitleOne!,
                            textTheme:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Color(0xff000000) ==
                                              Theme.of(context).backgroundColor
                                          ? Color(0xffFFFFFF)
                                          : Color(0xff000000),
                                    )),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFieldWidget(
                            msg: "Field is required",
                            controller: studentNameController,
                            onSaved: (String value) {}),
                      ),
                      widget.textFieldTitleTwo != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
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
                                    child: TextFieldWidget(
                                        msg: "Field is required",
                                        controller: textFieldController2,
                                        onSaved: (String value) {}),
                                  ),
                                ])
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                    ],
                  ),
                ),
              ),
            if (widget.submitButton == true)
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                margin: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                    ? EdgeInsets.only(bottom: 100)
                    : null,
                child: FloatingActionButton.extended(
                    backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (widget.isSubjectScreen!) {
                          widget.valueChanged!(studentNameController);
                          Utility.updateLogs(
                              activityType: 'GRADED+',
                              activityId: '21',
                              description: 'Teacher added custom subject ',
                              operationResult: 'Success');
                        } else {
                          // TODO submit

                          //print("calling submit");
                          if (imageFile != null) {
                            // String imgExtension = imageFile!.path.substring(
                            //     imageFile!.path.lastIndexOf(".") + 1);
                            //print('Image Extension : $imgExtension');
                            List<int> imageBytes = imageFile!.readAsBytesSync();
                            String imageB64 = base64Encode(imageBytes);

                            RubricScoreList.scoringList.add(CustomRubricModal(
                                name: studentNameController.text,
                                score: textFieldController2.text,
                                imgBase64: imageB64,
                                filePath: imageFile!.path.toString(),
                                customOrStandardRubic: "Custom"));
                            // Globals.scoringRubric =
                            //     '${studentNameController.text} ${textFieldController2.text}';
                            //print("calling get img url");
                            _googleBloc.add(ImageToAwsBucket(
                                customRubricModal:
                                    RubricScoreList.scoringList.last,
                                getImageUrl: false));
                          } else {
                            //print("save score and name on local db");
                            Utility.updateLogs(
                                activityType: 'GRADED+',
                                activityId: '21',
                                description: 'Teacher added custom rubric ',
                                operationResult: 'Success');
                            RubricScoreList.scoringList.add(CustomRubricModal(
                                name: studentNameController.text,
                                score: textFieldController2.text,
                                customOrStandardRubic: "Custom"));
                          }

                          widget.update!(true);

                          Navigator.pop(
                            context,
                          );
                        }
                      }
                    },
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
    File? photo = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GradedPlusCameraScreen(
                isMcqSheet: false,
                selectedAnswer: '',
                isFromHistoryAssessmentScanMore: false,
                onlyForPicture: true,
                isScanMore: false,
                pointPossible: '',
                isFlashOn: ValueNotifier<bool>(false),
              )),
    );

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

  rubricPdfListBuilder({required List<RubricPdfModal> pdfInfoList}) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 35),
      children: pdfInfoList
          .map<Widget>((i) => rubricListTile(
                i,
                context,
              ))
          .toList(),
    );
  }

  Widget rubricListTile(
    RubricPdfModal i,
    BuildContext context,
  ) =>
      Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
              widget.tileOnTap!(i);
            },
            leading: Icon(
              Icons.picture_as_pdf_outlined,
              color: AppTheme.kButtonColor,
            ),
            title: Utility.textWidget(
                context: context,
                text: i.titleC ?? 'no title',
                textTheme:
                    Theme.of(context).textTheme.headlineMedium!.copyWith()),
          ),
          divider(context)
        ],
      );

  Widget divider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 0.5,
      decoration: BoxDecoration(color: Color(0xffD9D6D5)),
    );
  }

  Widget _selectSection() {
    return Column(children: [
      selectionWidget(title: 'Standard Assignment', icon: Icons.check_outlined),
      selectionWidget(
          title: 'Multiple choice Assignment', icon: Icons.checklist),
    ]);
  }

  Widget selectionWidget({required String title, required IconData icon}) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.pop(context);
            widget.tileOnTap!(title);
          },
          leading: Icon(
            icon,
            color: AppTheme.kButtonColor,
          ),
          title: Utility.textWidget(
              context: context,
              text: title,
              textTheme: Theme.of(context).textTheme.headlineMedium!),
        ),
        divider(context)
      ],
    );
  }
}
