// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// class ImageToText extends StatefulWidget {
//   const ImageToText({Key? key}) : super(key: key);

//   @override
//   State<ImageToText> createState() => _ImageToTextState();
// }

// List<CameraDescription>? cameras = <CameraDescription>[];
// CameraController? controller;
// Future<void>? cameravalue;

// class _ImageToTextState extends State<ImageToText> {
//   @override
//   void initState() {
//     super.initState();

//     controller = CameraController(cameras![0], ResolutionPreset.max);
//     cameravalue = controller!.initialize();
//     controller!.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image To Text'),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Center(
//           child: FutureBuilder(
//               future: cameravalue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return controller == null
//                       ? Container()
//                       : CameraPreview(controller!);
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               }),
//         ),
//       ),
//     );
//   }
// }
