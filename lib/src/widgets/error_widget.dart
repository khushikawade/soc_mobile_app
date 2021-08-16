import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ErrorMsgWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return _buildNetworkerror();
  }

  Widget _buildNetworkerror() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Center(
        child: ErrorMessageWidget(
          msg: "Error",
          isnetworkerror: true,
          imgPath: "assets/images/error_icon.svg",
        ),
      ),
    ]);
  }
}
