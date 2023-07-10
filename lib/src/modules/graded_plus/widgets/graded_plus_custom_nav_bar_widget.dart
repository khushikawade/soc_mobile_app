import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class GradedPlusCustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem>
      items; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int> onItemSelected;
  final Color backgroundColor;

  GradedPlusCustomNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Globals.deviceType == "phone" ? 60 : 70,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primaryVariant
                    .withOpacity(0.1),
                blurRadius: 5.0,
                offset: Offset(0, -8)),
          ]),
      // height: 140.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          int index = items.indexOf(item);
          return Flexible(
            child: GestureDetector(
              onTap: () {
                this.onItemSelected(index);
              },
              child: index == 2
                  ? _buildSelectedMenu(
                      item, selectedIndex == index, 50, context)
                  : _buildUnselectedMenus(
                      item, selectedIndex == index, 140, context, index),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUnselectedMenus(PersistentBottomNavBarItem item, bool isSelected,
      double height, BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      width: 120,
      height: height,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: isSelected ? 28 : 22.0,
                  color: isSelected
                      ? item.activeColorPrimary
                      : item.inactiveColorPrimary),
              child: item.icon,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                type: MaterialType.transparency,
                child: TranslationWidget(
                  shimmerHeight: 8,
                  message: item.title!,
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => FittedBox(
                    child: Text(
                      translatedMessage.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontSize: isSelected
                                ? Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .fontSize! +
                                    3
                                : null,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectedMenu(final PersistentBottomNavBarItem item,
      final bool isSelected, final double? height, BuildContext context) {
    //Managing the '+' icon visibility on keyboard appear
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: const Offset(0, -22),
          child: Center(
            child: Container(
              height: height, // Increase height for selected item
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? item.activeColorPrimary
                    : Color(0xff000000) != Theme.of(context).backgroundColor
                        ? Colors.grey.shade200
                        : Colors.grey.shade800,
                border: Border.all(color: Colors.transparent, width: 4),
                // boxShadow: navBarDecoration!.boxShadow,
              ),
              child: Container(
                width: 170,
                height: height,
                margin: const EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor, // item.activeColorPrimary,
                  border: Border.all(color: Colors.transparent, width: 5),
                  // boxShadow: navBarDecoration!.boxShadow,
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: IconTheme(
                              data: IconThemeData(
                                  size: item.iconSize,
                                  color: isSelected
                                      ? item.activeColorPrimary
                                      : item.inactiveColorPrimary),
                              child: Visibility(
                                  visible: !isKeyboardVisible,
                                  child: item.icon),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (item.title == null)
          const SizedBox.shrink()
        else
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: TranslationWidget(
                shimmerHeight: 8,
                message: item.title!,
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => FittedBox(
                  child: Text(
                    translatedMessage.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: isSelected
                              ? Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .fontSize! +
                                  3
                              : null,
                        ),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
