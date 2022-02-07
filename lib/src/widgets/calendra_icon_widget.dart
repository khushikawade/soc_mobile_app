import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class CalendraIconWidget extends StatelessWidget {
  final DateTime dateTime;
  CalendraIconWidget({Key? key, required this.dateTime}) : super(key: key);

  static const double _kPhoneIcon = 36.0;
  static const double _kTabletIcon = 55.0;

  @override
  Widget build(BuildContext context) {
  final String date = Utility.convertTimestampToDateFormat(dateTime, 'dd');
  final String month = Utility.convertTimestampToDateFormat(dateTime, 'MMM');
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
                month,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Theme.of(context).backgroundColor),
              ),
            )),
          ),
          Text(date)
        ],
      ),
    );
  }
}
