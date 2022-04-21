import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageToText extends StatefulWidget {
  const ImageToText({Key? key}) : super(key: key);

  @override
  State<ImageToText> createState() => _ImageToTextState();
}

List<CameraDescription>? cameras = <CameraDescription>[];
CameraController? controller;
Future<void>? cameravalue;

class _ImageToTextState extends State<ImageToText> {
  String pathOfImage = '';
  String finalText = ' ';
  bool isLoaded = false;
  late File myImagePath;
  @override
  void initState() {
    super.initState();

    // controller = CameraController(cameras![0], ResolutionPreset.max);
    // cameravalue = controller!.initialize();
    // controller!.initialize().then((_) {
    //   if (!mounted) {
    //     return;
    //   }
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: Colors.teal,
              child: isLoaded
                  ? Image.file(
                      myImagePath,
                      fit: BoxFit.fill,
                    )
                  : Text("This is image section "),
            ),
            Center(
                child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    getImage();

                    // Future.delayed(Duration(seconds: 15), () {
                    //   reconizeText(pathOfImage);
                    // });
                  },
                  child: Text(
                    "gallary Image",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    getCameraImage();

                    // Future.delayed(Duration(seconds: 15), () {
                    //   reconizeText(pathOfImage);
                    // });
                  },
                  child: Text(
                    "Camera Image",
                  ),
                ),
              ],
            )),
            Text(
              finalText != null ? finalText : "This is my text",
            ),
          ],
        ),
      ),
    );
  }

  // image pickup from gallary
  void getImage() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      myImagePath = File(image!.path);
      isLoaded = true;
      pathOfImage = image.path.toString();
    });
    reconizeText(pathOfImage);
  }

  void getCameraImage() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      myImagePath = File(image!.path);
      isLoaded = true;
      pathOfImage = image.path.toString();
    });
    reconizeText(pathOfImage);
  }

  // Function for recongnising text
  Future<void> reconizeText(path) async {
    try {
      finalText = '';
      final inputImage = InputImage.fromFilePath(path);
      final textDetector = GoogleMlKit.vision.textDetectorV2();
      //.vision.textDetector();
      final RecognisedText _recognisedText =
          await textDetector.processImage(inputImage);
      for (TextBlock block in _recognisedText.blocks) {
        for (TextLine textLine in block.lines) {
          for (TextElement textElement in textLine.elements) {
            setState(() {
              finalText = finalText + " " + textElement.text;
            });
          }
          finalText = finalText + '\n';
        }
      }
    } catch (e) {}
  }

  
}
