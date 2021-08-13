import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListWidget extends StatelessWidget {
  static const double _kLabelSpacing = 17.0;
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
            leading: obj!.appIconC != null && obj!.appIconC.length > 0
                ? Icon(
                    IconData(
                      int.parse('0x${obj.appIconC!}'),
                      fontFamily: 'FontAwesomeSolid',
                      fontPackage: 'font_awesome_flutter',
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    size: Globals.deviceType == "phone" ? 18 : 26,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            title: listItem!,
          ),
        ));
  }
}
