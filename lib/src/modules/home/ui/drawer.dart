import 'package:app/src/overrides.dart';
import 'package:app/src/services/custom_flutter_icons.dart';
import 'package:app/src/services/utility.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/icon_selector.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _navigate(item) {
      Navigator.pushNamed(context, item['path']);
    }

    Widget cardItem(item) => InkWell(
          onTap: () => _navigate(item),
          child: Container(
            margin: EdgeInsets.all(7.5),
            child: Material(
              elevation: AppTheme.kBorderRadius * 0.80,
              borderRadius: BorderRadius.circular(AppTheme.kBorderRadius),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconSelectorWidget(item['icon'], 'asset'),
                    SpacerWidget(16.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(item['title']),
                    )
                  ]),
            ),
          ),
        );

    Widget _drawerBody() {
      return Stack(children: <Widget>[
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: DrawerHeader(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 46),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      icon: Icon(CustomFlutterIcons.cross_ico, color: Theme.of(context).colorScheme.onPrimary,),
                      onPressed: () => Navigator.of(context).pop())
                ],
              ),
            ),
            decoration:
                BoxDecoration(color: Theme.of(context).appBarTheme.color),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 115.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(Overrides.drawerItems.length, (index) {
              return cardItem(Overrides.drawerItems[index]);
            }),
          ),
        ),
      ]);
    }

    return Container(
        color: Theme.of(context).scaffoldBackgroundColor, child: _drawerBody());
  }
}
