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
        appBar: AppBar(
          title: Text('Image To Text'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
            ),
            TextButton(
              onPressed: () {},
              child: Text('Pick Image'),
            ),
            Text('this is extended data')
          ],
        )
        // Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   child: Center(
        //     child: FutureBuilder(
        //         future: cameravalue,
        //         builder: (context, snapshot) {
        //           if (snapshot.connectionState == ConnectionState.done) {
        //             return controller == null
        //                 ? Container()
        //                 : CameraPreview(controller!);
        //           } else {
        //             return Center(
        //               child: CircularProgressIndicator(),
        //             );
        //           }
        //         }),
        //   ),
        // ),

        );
  }

  // image pickup from gallary
  void getImage() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      pathOfImage = image!.path;
    });
  }

  // Function for recongnising text
  Future<void> reconizeText(path) async {
    final inputImage = await InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText _recognisedText = await  textDetector.processImage(inputImage);
  }
}
