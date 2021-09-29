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
            leading: 
            CustomIconWidget(iconUrl: obj.appIconUrlC!,),
            // obj!.appIconC != null && obj!.appIconC.length > 0
            //     ? Icon(
            //         IconData(
            //           int.parse('0x${obj.appIconC!}'),
            //           fontFamily: 'FontAwesomeSolid',
            //           fontPackage: 'font_awesome_flutter',
            //         ),
            //         color: Theme.of(context).colorScheme.primary,
            //         size: Globals.deviceType == "phone" ? 18 : 26,
            //       )
            //     : Icon(
            //         IconData(
            //           0xf550,
            //           fontFamily: 'FontAwesomeSolid',
            //           fontPackage: 'font_awesome_flutter',
            //         ),
            //         color: Theme.of(context).colorScheme.primary,
            //         size: Globals.deviceType == "phone" ? 20 : 28,
            //       ),
            title: listItem!,
          ),
        ));
  }
}
