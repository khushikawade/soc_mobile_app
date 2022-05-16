import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  static const double _KVertcalSpace = 60.0;
  int indexColor = 2;
  @override
  void initState() {
    // TODO: implement initState
    Globals.isbottomNavbar = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: successScreen()),
    );
  }

  Widget failureScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  SpacerWidget(_KVertcalSpace / 5),
        highlightText(
            text: 'Scan Failure',
            theme: Theme.of(context).textTheme.headline6!),
        SpacerWidget(_KVertcalSpace / 3),
        highlightText(
            text: 'Student Name',
            theme: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .primaryVariant
                    .withOpacity(0.3))),
        textFormField(controller: nameController, onSaved: (String value) {}),
        SpacerWidget(_KVertcalSpace / 2),
        highlightText(
            text: 'Student Id',
            theme: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .primaryVariant
                    .withOpacity(0.3))),
        textFormField(controller: idController, onSaved: (String value) {}),
        SpacerWidget(_KVertcalSpace / 2),
        Center(
          child: highlightText(
              text: 'Points Earned',
              theme: Theme.of(context).textTheme.headline3!),
        ),
        SpacerWidget(_KVertcalSpace / 4),
        Center(child: smallButton()),
        SpacerWidget(_KVertcalSpace / 2),
        Center(child: previewWidget()),
        SpacerWidget(_KVertcalSpace / 2),
      ],
    );
  }

  Widget successScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          //  SpacerWidget(_KVertcalSpace / 5),
          highlightText(
              text: 'Student Name',
              theme: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          textFormField(controller: nameController, onSaved: (String value) {}),
          SpacerWidget(_KVertcalSpace / 2),
          highlightText(
              text: 'Student Id',
              theme: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          textFormField(controller: idController, onSaved: (String value) {}),
          SpacerWidget(_KVertcalSpace / 2),
          highlightText(
              text: 'Points Earned',
              theme: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          SpacerWidget(_KVertcalSpace / 4),
          smallButton(),
          SpacerWidget(_KVertcalSpace / 2),
          previewWidget(),
          SpacerWidget(_KVertcalSpace / 2),
          highlightText(
              text: 'All Good', theme: Theme.of(context).textTheme.headline6!),
        ],
      ),
    );
  }

  Widget previewWidget() {
    return Container(
      color: Colors.green,
      height: MediaQuery.of(context).size.height * 0.38,
      width: MediaQuery.of(context).size.width * 0.58,
    );
  }

  Widget highlightText({required String text, required theme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        // maxLines: 2,
        //overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
        style: theme,
      ),
    );
  }

  Widget smallButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      // height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: Globals.pointsEarnedList
            .map<Widget>((element) =>
                pointsButton(Globals.pointsEarnedList.indexOf(element)))
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
          duration: Duration(microseconds: 100),
          padding: EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: indexColor == index + 1
                ? AppTheme.kSelectedColor
                : Colors.grey,
                // Theme.of(context)
                //     .colorScheme
                //     .background.withOpacity(0.2), // indexColor == index + 1 ? AppTheme.kSelectedColor : null,

            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border.all(
                    color: indexColor == index + 1
                ? AppTheme.kSelectedColor
                : Colors.grey,),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TranslationWidget(
                message: '$index',
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.headline1!.copyWith(color:indexColor == index + 1
                ? AppTheme.kSelectedColor
                : Colors.grey ),
                ),
              )),
        ));
  }

  Widget textFormField(
      {required TextEditingController controller, required onSaved}) {
    return TextFormField(
      //
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline6,
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        fillColor: Theme.of(context).backgroundColor,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color:
                  Colors.green // Theme.of(context).colorScheme.primaryVariant,
              ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3),
          ),
        ),
      ),
      onChanged: onSaved,
    );
  }
}
