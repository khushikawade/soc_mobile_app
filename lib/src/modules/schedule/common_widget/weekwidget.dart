import 'package:flutter/material.dart';

class WeekWidget extends StatefulWidget {
  final String title;

  final String description;
  final String titlefordate;
  final String enddatetext;

  final Color backgroundColor;

  final int totalEvents;

  final EdgeInsets padding;

  final EdgeInsets margin;

  final BorderRadius borderRadius;

  final TextStyle? titleStyle;

  final TextStyle? descriptionStyle;

  const WeekWidget({
    Key? key,
    required this.title,
    required this.titlefordate,
    required this.enddatetext,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.description = "",
    this.borderRadius = BorderRadius.zero,
    this.totalEvents = 1,
    this.backgroundColor = Colors.blue,
    this.titleStyle,
    this.descriptionStyle,
  }) : super(key: key);

  @override
  State<WeekWidget> createState() => _WeekWidgetState();
}

class _WeekWidgetState extends State<WeekWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.titlefordate.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${widget.titlefordate}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          if (widget.title.isNotEmpty)
            Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: widget.titleStyle ??
                      TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          if (widget.enddatetext.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      widget.enddatetext,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
