import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListWidget extends StatelessWidget {
  static const double _kLabelSpacing = 17.0;
  int? index;
  Widget? listItem;
  ListWidget(this.index, this.listItem);

  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: (index! % 2 == 0)
              ? Border.all(color: Theme.of(context).colorScheme.secondary)
              : Border.all(color: Theme.of(context).backgroundColor),
          borderRadius: BorderRadius.circular(0.0),
          color: (index! % 2 == 0)
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).backgroundColor,
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _kLabelSpacing * 2, vertical: _kLabelSpacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                listItem!,
              ],
            ),
          ),
        ));
  }
}
