import 'dart:convert';
import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/ui/create_assessment.dart';
import 'package:Soc/src/modules/ocr/ui/success.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

List<CameraDescription> cameras = [];

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  CameraController? controller;
  bool _isCameraInitialized = false;
  bool isflashOff = true;
  bool flash = false;
  FlashMode? _currentFlashMode;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    Globals.iscameraPopup
        ? WidgetsBinding.instance!
            .addPostFrameCallback((_) => _showStartDialog())
        : null;
    // Hide the status bar
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Utility.setLocked();
    onNewCameraSelected(cameras[0]);
    super.initState();
  }

  @override
  void dispose() {
    Utility.setFree();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 50
                  : 60,
          leading: IconButton(
              onPressed: () async {
                setState(() {
                  flash = !flash;
                  isflashOff = !isflashOff;
                });
                await controller!
                    .setFlashMode(flash ? FlashMode.torch : FlashMode.off);
              },
              icon: Icon(
                isflashOff == true ? Icons.flash_off : Icons.flash_on,
                color: Colors.white,
                size: 30,
              )),
          actions: [
            Container(
                padding: EdgeInsets.only(right: 5),
                child: IconButton(
                  onPressed: () {
                    Globals.studentInfo!.length > 0
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAssessment()),
                          )
                        : Utility.showSnackBar(
                            _scaffoldKey,
                            "No Assessment Found! Scan Assessment Before Moving Forword",
                            context,
                            null);
                  },
                  icon: Icon(
                    IconData(0xe877,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: AppTheme.kButtonColor,
                    size: 30,
                  ),
                )),
          ],
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        body: _isCameraInitialized
            ? Stack(children: [
                controller!.buildPreview(),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    color: Colors.black,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.15
                        : MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border:
                                  Border.all(color: Colors.white, width: 5)),
                          padding: EdgeInsets.all(3),
                          child: InkWell(
                            onTap: () async {
                              HapticFeedback.vibrate();
                              XFile? rawImage = await takePicture();
                              File imageFile = File(rawImage!.path);
                              final bytes =
                                  File(rawImage.path).readAsBytesSync();
                              String img64 = base64Encode(bytes);

                              //  File imageFile = File(rawImage!.path);

                              int currentUnix =
                                  DateTime.now().millisecondsSinceEpoch;
                              final directory =
                                  await getApplicationDocumentsDirectory();
                              String fileFormat =
                                  imageFile.path.split('.').last;

                              await imageFile.copy(
                                '${directory.path}/$currentUnix.$fileFormat',
                              );
                              await controller!.setFlashMode(FlashMode.off);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SuccessScreen(
                                          img64: img64,
                                          imgPath: imageFile,
                                        )),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                )
              ])
            : Container(),
      ),
    );
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();
    // _currentFlashMode = controller!.value.flashMode;
    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<void> _showStartDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: TranslationWidget(
              message: "Images are stored in the Cloud, not on your device",
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) {
                return Text(translatedMessage.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold));
              }),
          titleTextStyle: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.black),
          actions: [
            Container(
              height: 1,
              width: MediaQuery.of(context).size.height,
              color: Colors.grey.withOpacity(0.2),
            ),
            Center(
              child: TextButton(
                child: TranslationWidget(
                    message: "ok ",
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return Text(translatedMessage.toString(),
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: AppTheme.kButtonColor,
                                  ));
                    }),
                onPressed: () {
                  Globals.iscameraPopup = false;
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 16,
        );
      },
    );
  }
}
