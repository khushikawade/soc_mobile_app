import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/modal/calendar_event/calendar_event_list.dart';
import 'package:Soc/src/modules/families/modal/calendar_list.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildItem(CalendarEventList list) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _kPadding),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 30.0),
        children: [
          SpacerWidget(_kPadding / 2),
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: list.summary!, // titleC!,
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2!),
                )
              : Text(list.summary ?? '-',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2!),
          SpacerWidget(_kPadding / 4),
          divider(),
          SpacerWidget(_kPadding / 2),
          Container(
            alignment: Alignment.centerLeft,
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: Utility.convertDateFormat(list.start
                                .toString()
                                .contains('dateTime')
                            ? list.start['dateTime'].toString().substring(0, 10)
                            : list.start['date'].toString().substring(0, 10)) +
                        " - " +
                        Utility.convertDateFormat(list.end
                                .toString()
                                .contains('dateTime')
                            ? list.start['dateTime'].toString().substring(0, 10)
                            : list.start['date'].toString().substring(0, 10)),
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.subtitle1!,
                    ),
                  )
                : Text(
                    Utility.convertDateFormat(list.start
                                .toString()
                                .contains('dateTime')
                            ? list.start['dateTime'].toString().substring(0, 10)
                            : list.start['date'].toString().substring(0, 10)) +
                        " - " +
                        Utility.convertDateFormat(list.end
                                .toString()
                                .contains('dateTime')
                            ? list.start['dateTime'].toString().substring(0, 10)
                            : list.start['date'].toString().substring(0, 10)),
                    style: Theme.of(context).textTheme.subtitle1!,
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
                        style: Theme.of(context).textTheme.subtitle1!),
                  )
                : Text(
                    list.description ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1!,
                  ),
          ),
          SpacerWidget(_kPadding / 2),
          list.htmlLink != null ? _buildEventLink(list) : Container(),
          SpacerWidget(_kPadding / 2),
          bottomButtonWidget(widget.obj),
        ],
      ),
    );
  }

  Widget _buildEventLink(/*CalendarEventList*/ list) {
    return InkWell(
      onTap: () {
        UrlLauncherWidget obj = new UrlLauncherWidget();
        obj.callurlLaucher(context, list.htmlLink);
      },
      child: Text(
        list.htmlLink ?? '-',
        style: Theme.of(context).textTheme.headline4!.copyWith(
              decoration: TextDecoration.underline,
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

  Widget bottomButtonWidget(/*CalendarEventList*/ list) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _kPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          list.htmlLink != null
              ? Container(
                  child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: _KButtonSize,
                    maxWidth: 150.0,
                    minHeight: 126.0,
                    maxHeight: 125.0,
                  ),

                  // width: _KButtonSize,
                  // height: _KButtonSize / 2.5,
                  child: ElevatedButton(
                    onPressed: () {
                      SharePopUp obj = new SharePopUp();
                      obj.callFunction(context, list.htmlLink!, list.titleC!);
                    },
                    child: Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English"
                        ? TranslationWidget(
                            message: "Share ",
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
                ))
              : Container(
                  height: 0,
                  width: 0,
                ),
          SizedBox(
            width: _kPadding / 2,
          ),
          Container(
            constraints: BoxConstraints(
              minWidth: _KButtonSize,
              maxWidth: _KButtonSize / 2.5,
              minHeight: _KButtonSize / 2.5,
              maxHeight: 150.0,
            ),
            // width: _KButtonSize,
            // height: _KButtonSize / 2.5,
            child: ElevatedButton(
              onPressed: () {
                Add2Calendar.addEvent2Cal(
                  buildEvent(list),
                );
              },
              child: Globals.selectedLanguage != null &&
                      Globals.selectedLanguage != "English"
                  ? TranslationWidget(
                      message: "Save event",
                      toLanguage: Globals.selectedLanguage,
                      fromLanguage: "en",
                      builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                      ),
                    )
                  : Text(
                      "Save event ",
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Event buildEvent(/*CalendarEventList*/ list) {
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
      child: Column(children: <Widget>[
        Expanded(
          child: _buildItem(widget.obj),
        ),
      ]),
      onRefresh: refreshPage,
    ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
