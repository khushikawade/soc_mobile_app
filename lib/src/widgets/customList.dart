import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';

// ignore: must_be_immutable
class ListWidget extends StatelessWidget {
  // static const double _kLabelSpacing = 17.0;
  int? index;
  Widget? listItem;
  final obj;
  ListWidget(this.index, this.listItem, this.obj);

  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: (index! % 2 == 0)
              ? Border.all(color: Theme.of(context).colorScheme.secondary)
              : Border.all(color: Theme.of(context).colorScheme.background),
          borderRadius: BorderRadius.circular(0.0),
          color: (index! % 2 == 0)
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.background,
        ),
        child: Container(
          child: ListTile(
            leading: CustomIconWidget(
              iconUrl: obj.appIconUrlC ?? Overrides.defaultIconUrl,
            ),
            title: listItem!,
          ),
        ));
  }
}
