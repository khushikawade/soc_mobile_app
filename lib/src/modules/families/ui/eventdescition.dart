import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/modal/calendar_list.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EventDescription extends StatefulWidget {
  final obj;
  bool? isbuttomsheet;
  String? language;
  EventDescription(
      {Key? key,
      required this.obj,
      required this.isbuttomsheet,
      required this.language})
      : super(key: key);

  @override
  _EventDescriptionState createState() => _EventDescriptionState();
}

class _EventDescriptionState extends State<EventDescription> {
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 95.0;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  // static const _kbuttonTextStyle = TextStyle(
  //     fontWeight: FontWeight.normal,
  //     fontFamily: "Roboto Regular",
  //     fontSize: 12,
  //     color: AppTheme.kFontColor1);

  Widget _buildItem(CalendarList list) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _kPadding),
      child: ListView(
        children: [
          SpacerWidget(_kPadding / 2),
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: list.titleC!,
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                  ),
                )
              : Text(
                  list.titleC ?? '-',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                ),
          SpacerWidget(_kPadding / 4),
          divider(),
          SpacerWidget(_kPadding / 2),
          Container(
            alignment: Alignment.centerLeft,
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: Utility.convertDateFormat(list.startDate!) +
                        " - " +
                        Utility.convertDateFormat(list.endDate!),
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ),
                    ),
                  )
                : Text(
                    Utility.convertDateFormat(list.startDate!) +
                        " - " +
                        Utility.convertDateFormat(list.endDate!),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.primaryVariant),
                  ),
          ),
          SpacerWidget(_kPadding / 2),
          Container(
            alignment: Alignment.centerLeft,
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: list.description ?? "",
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            fontSize: 16)),
                  )
                : Text(
                    list.description ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                  ),
          ),
          SpacerWidget(_kPadding / 2),
          list.inviteLink != null ? _buildEventLink(list) : Container(),
          SpacerWidget(_kPadding / 2),
          bottomButtonWidget(widget.obj),
        ],
      ),
    );
  }

  Widget _buildEventLink(CalendarList list) {
    return InkWell(
      onTap: () {
        UrlLauncherWidget obj = new UrlLauncherWidget();
        obj.callurlLaucher(context, list.inviteLink);
      },
      child: Text(
        list.inviteLink ?? '-',
        style: Theme.of(context).textTheme.headline4!.copyWith(
              decoration: TextDecoration.underline,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
      ),
    );
  }

  Widget divider() {
    return Container(
      height: 0.5,
      decoration: BoxDecoration(
        color: Color(0xff6c75a4),
      ),
    );
  }

  Widget bottomButtonWidget(CalendarList list) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _kPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          list.inviteLink != null
              ? SizedBox(
                  width: _KButtonSize,
                  height: _KButtonSize / 2.5,
                  child: ElevatedButton(
                    onPressed: () {
                      SharePopUp obj = new SharePopUp();
                      obj.callFunction(context, list.inviteLink!, list.titleC!);
                    },
                    child: Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English"
                        ? TranslationWidget(
                            message: "Share",
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                              translatedMessage.toString(),
                              // style: _kbuttonTextStyle,
                            ),
                          )
                        : Text(
                            "Share",
                            // style: _kbuttonTextStyle,
                          ),
                  ),
                )
              : Container(),
          SizedBox(
            width: _kPadding / 2,
          ),
          SizedBox(
            width: _KButtonSize,
            height: _KButtonSize / 2.5,
            child: ElevatedButton(
              onPressed: () {
                Add2Calendar.addEvent2Cal(
                  buildEvent(list),
                );
              },
              child: Globals.selectedLanguage != null &&
                      Globals.selectedLanguage != "English"
                  ? Expanded(
                      child: TranslationWidget(
                        message: "Save event",
                        toLanguage: Globals.selectedLanguage,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                          // style: _kbuttonTextStyle,
                        ),
                      ),
                    )
                  : Expanded(
                      child: Text(
                        "Save event ",
                        // style: _kbuttonTextStyle
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Event buildEvent(CalendarList list) {
    return Event(
      title: list.titleC!,
      description: list.description ?? "",
      startDate: DateTime.parse(list.startDate!),
      endDate: DateTime.parse(list.endDate!),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      key: refreshKey,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(children: <Widget>[
          Expanded(
            child: _buildItem(widget.obj),
          ),
        ]),
      ),
      onRefresh: refreshPage,
    ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
