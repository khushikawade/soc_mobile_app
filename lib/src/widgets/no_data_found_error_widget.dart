import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoDataFoundErrorWidget extends StatelessWidget {
  NoDataFoundErrorWidget({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return _buildNoDataFoundErrorMessage();
  }

  Widget _buildNoDataFoundErrorMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ErrorMessageWidget(
            msg: "No data found",
            isnetworkerror: true,
            imgPath: "assets/images/no_data_icon.svg",
          ),
        ),
      ],
    );
  }
}
