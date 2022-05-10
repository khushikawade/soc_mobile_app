import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

class OpticalCharacterRecognition extends StatefulWidget {
  const OpticalCharacterRecognition({Key? key}) : super(key: key);

  @override
  State<OpticalCharacterRecognition> createState() =>
      _OpticalCharacterRecognitionPageState();
}

class _OpticalCharacterRecognitionPageState
    extends State<OpticalCharacterRecognition> {
  static const double _KVertcalSpace = 60.0;
  final assessmentController = TextEditingController();
  final classController = TextEditingController();
  int indexColor = 2;
  int scoringColor = 0;
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.80
                : MediaQuery.of(context).size.width * 0.80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                highlightText(
                  text: 'Create Assessment',
                  theme: Theme.of(context).textTheme.headline6,
                ),
                SpacerWidget(_KVertcalSpace / 5),

                Text(
                  'Nullam posuere nisl at ipsum condimentum, sit amet rhoncus leo volutpat.',
                  style: Theme.of(context).textTheme.headline3,
                ),
                SpacerWidget(_KVertcalSpace / 1.5),

                highlightText(
                    text: 'Assessment Name',
                    theme: Theme.of(context).textTheme.subtitle1),
                textFormField(
                    controller: assessmentController,
                    onSaved: (String value) {}),
                SpacerWidget(_KVertcalSpace / 5),
                highlightText(
                    text: 'Class Name',
                    theme: Theme.of(context).textTheme.subtitle1),
                textFormField(
                    controller: classController, onSaved: (String value) {}),
                     SpacerWidget(_KVertcalSpace / 3),
                    scoringButton(),
                ElevatedButton(onPressed: (){}, child: Text('Next'))    
                // smallButton(),
                // SpacerWidget(_KVertcalSpace / 2),

                // SpacerWidget(_KVertcalSpace / 4),
                // scoringButton(),
                // // SpacerWidget(_KVertcalSpace / 8),
                // cameraButton(),
              ],
            ),
          ),
        )

        );
  }

  // Widget cameraButton() {
  //   return InkWell(
  //     onTap: () {},
  //     child: CircleAvatar(
  //         maxRadius: 65,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             textwidget(
  //               text: 'Start',
  //               textTheme: Theme.of(context).textTheme.headline6!.copyWith(
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //             ),
  //             textwidget(
  //               text: 'Scanning',
  //               textTheme: Theme.of(context).textTheme.subtitle1,
  //             ),
  //             textwidget(
  //               text: 'Student',
  //               textTheme: Theme.of(context).textTheme.subtitle1,
  //             ),
  //             textwidget(
  //               text: 'Work',
  //               textTheme: Theme.of(context).textTheme.subtitle1,
  //             )
  //           ],
  //         )),
  //   );
  // }

  Widget textwidget({required String text, required dynamic textTheme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        style: textTheme,
      ),
    );
  }

  // Widget smallButton() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width * 0.75,
  //     // height: MediaQuery.of(context).size.height * 0.08,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: Globals.icons
  //           .map<Widget>(
  //               (element) => pointsButton(Globals.icons.indexOf(element)))
  //           .toList(),
  //     ),
  //   );
  // }

  // Widget pointsButton(index) {
  //   return InkWell(
  //       onTap: () {
  //         setState(() {
  //           indexColor = index + 1;
  //         });
  //       },
  //       child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
  //           decoration: BoxDecoration(
  //             color: indexColor == index + 1 ? Colors.orange : null,
  //             border: Border.all(
  //                 color: Theme.of(context).colorScheme.primaryVariant),
  //             borderRadius: BorderRadius.all(Radius.circular(15)),
  //           ),
  //           child: TranslationWidget(
  //             message: '${index + 1}',
  //             toLanguage: Globals.selectedLanguage,
  //             fromLanguage: "en",
  //             builder: (translatedMessage) => Text(
  //               translatedMessage.toString(),
  //               style: Theme.of(context).textTheme.headline1,
  //             ),
  //           )));
  // }

  Widget scoringButton() {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.35
          : MediaQuery.of(context).size.width * 0.35,
     // width: MediaQuery.of(context).size.width * 0.7,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(

              maxCrossAxisExtent: 80,
              childAspectRatio: 6 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 5),
          itemCount: Globals.classList.length,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  scoringColor = index;
                });
              },
              child: index < Globals.classList.length-1 ? 
              // Container(
                
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.black),
              //     borderRadius: BorderRadius.circular(90),
              //     color: scoringColor == index? Colors.orange: Theme.of(context).backgroundColor ,
              //   ),
              //  // 
                
              //   child: Center(
              //     child: textwidget(
              //                   text: Globals.classList[index],
              //                   textTheme: Theme.of(context).textTheme.headline2,
              //                 ),
              //   ),
              // )
              CircleAvatar(
                radius: 90,
                  backgroundColor: scoringColor == index? Colors.orange: Theme.of(context).backgroundColor ,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: scoringColor == index? Colors.orange: Theme.of(context).backgroundColor ,
                  child: textwidget(
                    text: Globals.classList[index],
                    textTheme: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ) 
              : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: scoringColor == index? Colors.orange: Theme.of(context).backgroundColor ,
                ),
                child: Center(
                  child: textwidget(
                    text: Globals.classList[index],
                    textTheme: Theme.of(context).textTheme.headline2,
                  ),
                )
              )
            );
          }),
    );
  }

  Widget highlightText({required String text, required theme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        maxLines: 2,
        //overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: theme,
      ),
    );
  }

  Widget textFormField(
      {required TextEditingController controller, required onSaved}) {
    return Container(
        child: TextFormField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        fillColor: Theme.of(context).backgroundColor,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
        ),
      ),
      onChanged: onSaved,
    ));
  }
// void getCameraImage() async {
//     ImagePicker _imagePicker = ImagePicker();
//     XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
//     final bytes = File(image!.path).readAsBytesSync();
//     String img64 = base64Encode(bytes);

//     setState(() {
//       myImagePath = File(image.path);
//       isLoading2 = false;
//       pathOfImage = image.path.toString();
//     });
//     if (myImagePath != null) {
//       _bloc.add(FetchTextFromImage(base64: img64));
//     }
//     // reconizeText(pathOfImage);
//   }

}
