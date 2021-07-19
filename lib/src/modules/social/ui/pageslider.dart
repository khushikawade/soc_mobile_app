import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SamplePage extends StatefulWidget {
  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  List<Widget> _samplePages = [
    Center(
      child: Text("1"),
    ),
  ];
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  int pageindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Demo'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: PageView.builder(
              controller: _controller,
              itemCount: 10,
              onPageChanged: (index) {
                pageindex = index;
                setState(() {});
                print(pageindex);
              },
              itemBuilder: (BuildContext context, int index) {
                return _samplePages[index % _samplePages.length];
              },
            ),
          ),
          // Container(
          //   color: Colors.lightBlueAccent,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: <Widget>[
          //       FlatButton(
          //         child: Text('Prev'),
          //         onPressed: () {
          //           _controller.previousPage(
          //               duration: _kDuration, curve: _kCurve);
          //         },
          //       ),
          //       FlatButton(
          //         child: Text('Next'),
          //         onPressed: () {
          //           _controller.nextPage(duration: _kDuration, curve: _kCurve);
          //         },
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
