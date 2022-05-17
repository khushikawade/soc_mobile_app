import 'dart:convert';
import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/create_assessment.dart';
import 'package:Soc/src/modules/ocr/ui/demo_camera.dart';
import 'package:Soc/src/modules/ocr/ui/success.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:image_picker/image_picker.dart';

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
  OcrBloc _bloc = OcrBloc();
  int indexColor = 2;
  int scoringColor = 0;
  final HomeBloc _homeBloc = new HomeBloc();
  File? myImagePath;
  String pathOfImage = '';
  @override
  void initState() {
    setState(() {
      Globals.hideBottomNavbar = true;
    });
    Globals.gradeList.clear(); 
    _homeBloc.add(FetchStandardNavigationBar());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomOcrAppBarWidget(
        isBackButton: false,
      ), // https://algramo.s3.ap-south-1.amazonaws.com/SVG/Container/Fourstar.svg
      // AppBar(
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   actions: [
      //     Container(
      //       padding: EdgeInsets.only(right: 10),
      //       child: Icon(
      //         IconData(0xe874,
      //             fontFamily: Overrides.kFontFam,
      //             fontPackage: Overrides.kFontPkg),
      //         color: AppTheme.kButtonColor,
      //       ),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              highlightText(text: 'Points Possible'),
              SpacerWidget(_KVertcalSpace / 4),
              smallButton(),
              SpacerWidget(_KVertcalSpace / 2),
              highlightText(text: 'Scoring Rubric'),
              SpacerWidget(_KVertcalSpace / 4),
              scoringButton(),
              Container(
                height: 0,
                width: 0,
                child: BlocListener<HomeBloc, HomeState>(
                    bloc: _homeBloc,
                    listener: (context, state) async {
                      if (state is BottomNavigationBarSuccess) {
                        AppTheme.setDynamicTheme(Globals.appSetting, context);
                        Globals.appSetting = AppSetting.fromJson(state.obj);
                        setState(() {});
                      }
                    },
                    child: EmptyContainer()),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAssessment()),
                    );
                  },
                  icon: Icon(Icons.next_plan))
              //SpacerWidget(_KVertcalSpace * 1.6),
            ],
          ),
        ),
      ),
      floatingActionButton: cameraButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget cameraButton() {
    return
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,

        InkWell(
      onTap: () {
        getGallaryImage();
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext context) => DemoCamera()));
      },
      child: Container(
          decoration: BoxDecoration(
              color: AppTheme.kButtonColor,
              borderRadius: BorderRadius.circular(30)),
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.55
              : MediaQuery.of(context).size.height * 0.55,
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                IconData(0xe875,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: Colors.white,
              ),
              textwidget(
                  text: 'Start Scanning',
                  textTheme: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Colors.white,
                      ))
            ],
          )),
    );
  }

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

  Widget smallButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: Globals.icons
            .map<Widget>(
                (element) => pointsButton(Globals.icons.indexOf(element)))
            .toList(),
      ),
    );
  }

  Widget pointsButton(index) {
    return InkWell(
        onTap: () {
          setState(() {
            indexColor = index + 1;
          });
        },
        child: AnimatedContainer(
          padding: EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color:
                indexColor == index + 1 ? AppTheme.kSelectedColor : Colors.grey,
            // Theme.of(context)
            //     .colorScheme
            //     .background.withOpacity(0.2), // indexColor == index + 1 ? AppTheme.kSelectedColor : null,

            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          duration: Duration(microseconds: 100),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,

                //  indexColor == index + 1
                //     ? AppTheme.kSelectedColor
                //     : Theme.of(context).colorScheme.background,
                border: Border.all(
                  color: indexColor == index + 1
                      ? AppTheme.kSelectedColor
                      : Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: TranslationWidget(
                message: '${index + 1}',
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: indexColor == index + 1
                            ? AppTheme.kSelectedColor
                            : Theme.of(context).colorScheme.primaryVariant,
                      ),
                ),
              )),
        ));
  }

  Widget scoringButton() {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.45
          : MediaQuery.of(context).size.width * 0.30,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.height * 0.5,
              childAspectRatio: 6 / 3.5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          itemCount: Globals.scoringList.length,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  scoringColor = index;
                });
              },
              child: AnimatedContainer(
                padding: EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: scoringColor == index
                      ? AppTheme.kSelectedColor
                      : Colors.grey,
                  // Theme.of(context)
                  //     .colorScheme
                  //     .background.withOpacity(0.2), // indexColor == index + 1 ? AppTheme.kSelectedColor : null,

                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                duration: Duration(microseconds: 100),
                child: Container(
                  // width:Globals.scoringList.length -1 == index ? MediaQuery.of(context).size.width: null,
                  alignment: Alignment.center,
                  child: textwidget(
                    text: Globals.scoringList[index],
                    textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                        color: scoringColor == index
                            ? AppTheme.kSelectedColor
                            : Theme.of(context).colorScheme.primaryVariant),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: scoringColor == index
                            ? AppTheme.kSelectedColor
                            : Colors.grey,
                      ),
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            );
          }),
    );
  }

  Widget highlightText({required String text}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  void getGallaryImage() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    final bytes = File(image!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    setState(() {
      myImagePath = File(image.path);
      // isLoading2 = false;
      pathOfImage = image.path.toString();
    });

    if (myImagePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SuccessScreen(
                  img64: img64,
                  imgPath:myImagePath,
                )),
      );

      //_bloc.add(FetchTextFromImage(base64: img64));
    }
    // reconizeText(pathOfImage);
  }
}
