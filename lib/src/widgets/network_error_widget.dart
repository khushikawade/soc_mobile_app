import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoInternetErrorWidget extends StatelessWidget {
  var connected;
  bool? issplashscreen = false;

  NoInternetErrorWidget({
    Key? key,
    @required this.connected,
    @required this.issplashscreen,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return _buildNetworkerror(connected);
  }

  Widget _buildNetworkerror(connected) {
    return Stack(children: [
      Positioned(
        height: 30.0,
        left: 0.0,
        right: 0.0,
        top: issplashscreen == true ? 30 : 0,
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
        ErrorMessageWidget(
          msg: "No Internet",
          isnetworkerror: true,
          icondata: 0xe81c,
        ),
      ]),
    ]);
  }
}
