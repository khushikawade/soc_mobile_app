import 'dart:convert';
import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class GoogleOcr extends StatefulWidget {
  const GoogleOcr({Key? key}) : super(key: key);

  @override
  State<GoogleOcr> createState() => _GoogleOcrState();
}

class _GoogleOcrState extends State<GoogleOcr> {
  OcrBloc _bloc = OcrBloc();
  bool isLoading = true;
  bool isLoading2 = true;
  File? myImagePath;
  String pathOfImage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          appBarTitle: 'OCR',
          isSearch: true,
          isShare: false,
          language: Globals.selectedLanguage,
          isCenterIcon: false,
          ishtmlpage: false,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
        ),
        body: Stack(
          children: [
            BlocBuilder<OcrBloc, OcrState>(
                bloc: _bloc,
                builder: (context, state) {
                  return Container();
                  // return widget here based on BlocA's state
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<OcrBloc, OcrState>(
                    bloc: _bloc, // provide the local bloc instance
                    builder: (context, state) {
                      if (state is OcrLoading) {
                        return CircularProgressIndicator(
                          color: Colors.white,
                        );
                      } else if (state is FetchTextFromImageSuccess) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'OSIS :',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(state.schoolId!,style: TextStyle(fontSize: 18),),
                              Text('Result :',style: TextStyle(fontSize: 18),),
                              Text(state.grade!,style: TextStyle(fontSize: 18),),
                            ],
                          ),
                          // color: Colors.teal,
                          // child:
                          //  isLoaded
                          //     ? Image.file(
                          //         myImagePath,
                          //         fit: BoxFit.fill,
                          //       )
                          //     : Center(child: Text("This is image section ")),
                        );
                      }
                      return Container();
                    }),
                InkWell(
                  onTap: () {
                    _showbottomSheet(context);
                  },
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: isLoading2
                        ? Center(child: Icon(Icons.camera))
                        : Image.file(
                            myImagePath!,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void getGallaryImage() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    final bytes = File(image!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    setState(() {
      myImagePath = File(image.path);
      isLoading2 = false;
      pathOfImage = image.path.toString();
    });

    if (myImagePath != null) {
      _bloc.add(FetchTextFromImage(base64: img64));
    }
    // reconizeText(pathOfImage);
  }

  void _showbottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )),
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              children: [
                Row(
                  children: [
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: Text(
                    //     "Profile Photo",
                    //     style: TextStyle(
                    //         fontSize: 18, fontWeight: FontWeight.bold),
                    //     //style: AppTheme.bottomSheetStyle,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            getCameraImage();
                          },
                          child: Icon(
                            Icons.camera,
                            // color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            getGallaryImage();
                          },
                          child: Icon(
                            Icons.phone_android,
                            // color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          // style: AppTheme.userEmailStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void getCameraImage() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
    final bytes = File(image!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);

    setState(() {
      myImagePath = File(image.path);
      isLoading2 = false;
      pathOfImage = image.path.toString();
    });
    if (myImagePath != null) {
      _bloc.add(FetchTextFromImage(base64: img64));
    }
    // reconizeText(pathOfImage);
  }
}
