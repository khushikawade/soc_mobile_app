import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class CalendraIconWidget extends StatelessWidget {
  final dateTime;
  CalendraIconWidget({Key? key, required this.dateTime}) : super(key: key);

  static const double _kPhoneIcon = 36.0;
  static const double _kTabletIcon = 55.0;

  static const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String getDate() {
    try {
      return dateTime.runtimeType.toString() == 'DateTime'
          ? Utility.convertTimestampToDateFormat(dateTime, 'dd')
          : dateTime.toString().split('/')[1];
    } catch (e) {
      return '';
    }
  }

  String getMonth() {
    try {
      return dateTime.runtimeType.toString() == 'DateTime'
          ? Utility.convertTimestampToDateFormat(dateTime, 'MMM')
          : months[int.parse(dateTime.toString().split('/')[0]) - 1];
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          color: AppTheme.kBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      height: Globals.deviceType == 'phone' ? _kPhoneIcon : _kTabletIcon,
      //  MediaQuery.of(context).size.height * 0.043,
      width: Globals.deviceType == 'phone' ? _kPhoneIcon : _kTabletIcon,
      // MediaQuery.of(context).size.width * 0.09,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                )),
            height: Globals.deviceType == 'phone'
                ? _kPhoneIcon / 2.5
                : _kTabletIcon / 2.5,
            //MediaQuery.of(context).size.height * 0.045 / 2.8,
            width: Globals.deviceType == 'phone' ? _kPhoneIcon : _kTabletIcon,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                getMonth(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Theme.of(context).backgroundColor),
              ),
            )),
          ),
          Padding(padding: EdgeInsets.only(top: 1.7), child: Text(getDate(),style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.black),))
        ],
      ),
    );
  }
}
