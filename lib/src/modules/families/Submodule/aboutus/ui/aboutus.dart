import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class AboutusPage extends StatefulWidget {
  @override
  _AboutusPageState createState() => _AboutusPageState();
}

class _AboutusPageState extends State<AboutusPage> {
  static const double _kLabelSpacing = 20.0;

  // static const _kheadingStyle = TextStyle(
  //   fontFamily: "Roboto Bold",
  //   fontWeight: FontWeight.bold,
  //   fontSize: 16,
  //   color: Color(0xff2D3F98),
  //   height: 1.2,
  // );

  // static const _kTextStyle = TextStyle(
  //   fontFamily: "Roboto Regular",
  //   fontSize: 14,
  //   color: Color(0xff2D3F98),
  //   height: 1.5,
  // );

  Widget _buildimage() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 100,
      height: MediaQuery.of(context).size.width / 3,
      child: Image.asset(
        'assets/images/aboutus.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildContent1() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Vision Statment",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * .88,
                  child: Text(
                    "It is a long established fact that a reader will be by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that",
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent2() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Mission Statment",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * .88,
                  child: Text(
                    "It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent3() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Core Belief Statments",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * .88,
                  child: Text(
                    "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Sydney  in Virginia, looked up one of the more obscure Latinetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source",
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildimage(),
              SpacerWidget(_kLabelSpacing),
              _buildContent1(),
              SpacerWidget(_kLabelSpacing),
              _buildContent2(),
              SpacerWidget(_kLabelSpacing),
              _buildContent3(),
            ],
          ),
        ),
      ),
    );
  }
}
