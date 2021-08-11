import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/no_internet_icon.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class NoInternetErrorWidget extends StatelessWidget {
  static const double _kIconSize = 45.0;
  var connected;

  NoInternetErrorWidget({
    Key? key,
    @required this.connected,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return _buildNetworkerror(connected);
  }

  Widget _buildNetworkerror(connected) {
    return Stack(children: [
      Positioned(
        height: 20.0,
        left: 0.0,
        right: 0.0,
        top: 0,
        child: Container(
          color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${connected ? 'ONLINE' : 'OFFLINE'}",
                      style: TextStyle(color: Colors.white),
                    ),
                    HorzitalSpacerWidget(16),
                    connected
                        ? Container(
                            height: 0,
                          )
                        : SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          child: NoInternetIconWidget(),
        ),
        SpacerWidget(12),
        Text("No internet connection")
      ]),
    ]);
  }
}
