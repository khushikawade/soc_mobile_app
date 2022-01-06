import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class NoInternetErrorWidget extends StatelessWidget {
  var connected;
  bool? issplashscreen = false;
  VoidCallback? onRefresh;

  NoInternetErrorWidget(
      {Key? key,
      @required this.connected,
      @required this.issplashscreen,
      this.onRefresh})
      : super(key: key);

  Widget build(BuildContext context) {
    return _buildNetworkerror(connected, context);
  }

  Widget _buildNetworkerror(connected, BuildContext context) {
    return Stack(children: [
      onRefresh != null
          ? Container()
          : Positioned(
              height: Globals.deviceType == "phone" ? 22.0 : 35,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${connected ? 'ONLINE' : 'OFFLINE'}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  Globals.deviceType == "phone" ? 16.0 : 24.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          HorzitalSpacerWidget(16),
                          connected
                              ? Container(
                                  height: 0,
                                )
                              : SizedBox(
                                  height: Globals.deviceType == "phone"
                                      ? 12.0
                                      : 20.0,
                                  width: Globals.deviceType == "phone"
                                      ? 12.0
                                      : 20.0,
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
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  Strings.noIntenetIconPath,
                  fit: BoxFit.cover,
                )),
            SpacerWidget(12),
            Text("No Internet", style: Theme.of(context).textTheme.bodyText1!),
            onRefresh != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: AppTheme.kBodyPadding * 2),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blueGrey),
                            onPressed: onRefresh,
                            child: Row(
                              children: [
                                Icon(Icons.refresh, color: Colors.white70),
                                SpacerWidget(AppTheme.kBodyPadding * 2),
                                Text('Retry',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 18))
                              ],
                            )),
                      )
                    ],
                  )
                : Container()
          ]),
    ]);
  }
}
