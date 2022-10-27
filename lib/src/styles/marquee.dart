import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  MarqueeWidget({
    Key? key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  MarqueeWidgetState createState() => MarqueeWidgetState();
}

class MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController scrollController;
  int numberOfRounds = 0;
  @override
  void initState() {
    _controllerInitialization();
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (numberOfRounds != 0) {
      numberOfRounds = 0;
      _controllerInitialization();
      scroll(context);
    }

    return SingleChildScrollView(
      child: widget.child,
      scrollDirection: widget.direction,
      controller: scrollController,
    );
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients && numberOfRounds == 0) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: widget.animationDuration,
          curve: Curves.ease,
        );
        numberOfRounds = 1;
      }
      // await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        scrollController.jumpTo(0.0);
      }
    }
  }

  _controllerInitialization() {
    scrollController = ScrollController(initialScrollOffset: 0.0);
  }
}
