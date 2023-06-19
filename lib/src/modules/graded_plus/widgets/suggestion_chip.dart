import 'package:flutter/material.dart';
import '../../../styles/theme.dart';

class ChipsFilter extends StatefulWidget {
  final void Function(String) selectedValue;

  ///
  /// The list of the filters
  ///
  final List<String>? filters;

  ///
  /// The default selected index starting with 0
  ///
  final int? selected;

  ChipsFilter({
    Key? key,
    this.filters,
    this.selected,
    required this.selectedValue,
  }) : super(key: key);

  @override
  _ChipsFilterState createState() => _ChipsFilterState();
}

class _ChipsFilterState extends State<ChipsFilter> {
  ///
  /// Currently selected index
  ///
  int? selectedIndex;
  bool active = false;
  @override
  void initState() {
    // When [widget.selected] is defined, check the value and set it as
    // [selectedIndex]
    if (widget.selected != null &&
        widget.selected! >= 0 &&
        widget.selected! < widget.filters!.length) {
      this.selectedIndex = widget.selected;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: this.chipBuilder,
        itemCount: widget.filters!.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  ///
  /// Build a single chip
  ///
  Widget chipBuilder(
    context,
    currentIndex,
  ) {
    String filter = widget.filters![currentIndex];
    bool isActive = this.selectedIndex == currentIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedIndex == currentIndex) {
            active = false;
            // Deselect the chip
            selectedIndex = null;
            widget.selectedValue('');
          } else {
            // Select the chip
            active = true;
            selectedIndex = currentIndex;
            widget.selectedValue(filter);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(left: currentIndex == 0 ? 0 : 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(),
          ],
          color: isActive && active
              ? AppTheme.kSelectedColor
              : Color(0xff000000) != Theme.of(context).backgroundColor
                  ? Color(0xffF7F8F9)
                  : Color(0xff111C20),
          border: Border.all(
              color:
                  isActive && active ? AppTheme.kSelectedColor : Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              filter,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 12,
                  color: isActive && active
                      ? Theme.of(context).backgroundColor
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}
