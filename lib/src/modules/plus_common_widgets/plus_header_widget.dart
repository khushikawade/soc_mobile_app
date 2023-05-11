import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class PlusScreenTitleWidget extends StatelessWidget {
  static const double _kLabelSpacing = 20.0;
  static final double kSymmetricPadding = 10.0;
  static final double KVerticalSpace = 60.0;
  final String text;
  const PlusScreenTitleWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacerWidget(KVerticalSpace / 4),
        Container(
          child: Utility.textWidget(
              text: text,
              context: context,
              textTheme: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.w700)),
        ),
        SpacerWidget(kSymmetricPadding),
      ],
    );
  }
}
