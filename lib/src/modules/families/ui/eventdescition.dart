import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/modal/calendar_list.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EventDescription extends StatefulWidget {
  var obj;
  bool? isbuttomsheet;
  EventDescription({Key? key, required this.obj, required this.isbuttomsheet})
      : super(key: key);

  @override
  _EventDescriptionState createState() => _EventDescriptionState();
}

class _EventDescriptionState extends State<EventDescription> {
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 95.0;

  static const _kbuttonTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: "Roboto Regular",
      fontSize: 12,
      color: AppTheme.kFontColor1);

  Widget _buildItem(CalendarList list) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _kPadding),
      child: Column(
        children: [
          SpacerWidget(_kPadding / 2),
          Text(
            list.titleC!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          ),
          SpacerWidget(_kPadding / 4),
          divider(),
          SpacerWidget(_kPadding / 2),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              Utility.convertDateFormat(list.startDate!) +
                  " - " +
                  Utility.convertDateFormat(list.endDate!),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SpacerWidget(_kPadding / 2),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              list.description ?? "",
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
            ),
          ),
          SpacerWidget(_kPadding / 2),
          list.inviteLink != null ? _buildEventLink(list) : Container(),
          SpacerWidget(_kPadding / 2),
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
        list.inviteLink!,
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(decoration: TextDecoration.underline),
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

  Widget buttomButtonsWidget(CalendarList list) {
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
                    child: Text(
                      "Share",
                      style: _kbuttonTextStyle,
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
              child: Text("Save event", style: _kbuttonTextStyle),
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
        body: ListView(children: [
          Container(
            color: AppTheme.kListBackgroundColor2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildItem(widget.obj),
                buttomButtonsWidget(widget.obj)
              ],
            ),
          ),
        ]),
        bottomNavigationBar: widget.isbuttomsheet! && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }
}
