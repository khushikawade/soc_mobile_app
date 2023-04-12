import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusCustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem>
      items; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int> onItemSelected;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unSelectedColor;
  final Color iconColor;

  StudentPlusCustomNavBarWidget(
      {Key? key,
      required this.selectedIndex,
      required this.items,
      required this.onItemSelected,
      required this.backgroundColor,
      required this.selectedColor,
      required this.unSelectedColor,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      height: 140.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          int index = items.indexOf(item);
          return Flexible(
            child: GestureDetector(
              onTap: () {
                this.onItemSelected(index);
              },
              child: selectedIndex == index
                  ? _buildSelectedMenu(item, true, 140)
                  : _buildUnselectedMenus(item, false, 140),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUnselectedMenus(
      PersistentBottomNavBarItem item, bool isSelected, double height) {
    return Container(
      width: 120,
      height: height,
      color: Colors.transparent,
      //padding: EdgeInsets.only(top: height * 0.15, bottom: height * 0.15),
      //height: height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(size: 26.0, color: iconColor),
              child: item.icon,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 5.0),
          //   child: Material(
          //     type: MaterialType.transparency,
          //     child: Text(
          //       item.title ?? '',
          //       style: TextStyle(
          //           color: unSelectedColor,
          //           fontWeight: FontWeight.w400,
          //           fontSize: 12.0),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildSelectedMenu(final PersistentBottomNavBarItem item,
      final bool isSelected, final double? height) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: const Offset(0, -28),
          child: Center(
            child: Container(
              //  width: 165,
              height: height ?? 0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // item.activeColorPrimary,
                border: Border.all(color: Colors.transparent, width: 4),
                // boxShadow: navBarDecoration!.boxShadow,
              ),
              child: Container(
                width: 170,
                height: height,
                margin: const EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedColor, // item.activeColorPrimary,
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
                                  size: item.iconSize, color: iconColor),
                              child: isSelected
                                  ? item.icon
                                  : item.inactiveIcon ?? item.icon,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                type: MaterialType.transparency,
                child: FittedBox(
                    child: Text(
                  item.title!,
                  style: item.textStyle != null
                      ? (item.textStyle!.apply(
                          color: isSelected
                              ? (item.activeColorSecondary ??
                                  item.activeColorPrimary)
                              : item.inactiveColorPrimary))
                      : TextStyle(
                          color: unSelectedColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                )),
              ),
            ),
          )
      ],
    );
  }
}
