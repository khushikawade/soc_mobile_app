import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/mapwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static const double _kLabelSpacing = 16.0;
  static const double _kboxheight = 60.0;
  static const double _kboxwidth = 300.0;
  static const double _kboxborderwidth = 0.75;

  //Style
  // static const _kheadingStyle = TextStyle(
  //     fontFamily: "Roboto Bold",
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //     color: Color(0xff2D3F98));

  // static const _kheading2Style = TextStyle(
  //     fontFamily: "Roboto Bold",
  //     fontWeight: FontWeight.w400,
  //     fontSize: 14,
  //     color: Color(0xff171717));
  // static const _ktextStyle = TextStyle(
  //   fontFamily: "Roboto Medium",
  //   fontSize: 14,
  //   fontWeight: FontWeight.w500,
  //   color: Color(0xff2D3F98),
  // );

  // static const maptextStyle = TextStyle(
  //   fontFamily: "Roboto Bold",
  //   fontWeight: FontWeight.bold,
  //   fontSize: 12,
  //   color: Color(0xff0B84FF),
  // );

  // static const maptext2Style = TextStyle(
  //   fontFamily: "Roboto Bold",
  //   fontWeight: FontWeight.bold,
  //   fontSize: 12,
  //   color: Color(0xffFF5656),
  // );
  // static const maptext3Style = TextStyle(
  //   fontFamily: "Roboto Bold",
  //   fontWeight: FontWeight.bold,
  //   fontSize: 12,
  //   color: Color(0xffFF9608),
  // );
  // static const maptext4Style = TextStyle(
  //   fontFamily: "Roboto Bold",
  //   fontWeight: FontWeight.bold,
  //   fontSize: 12,
  //   color: Color(0xff368FFF),
  // );

  //TOP SECTION START
  Widget _buildIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Image.asset(
          'assets/images/address.png',
          fit: BoxFit.fill,
          height: 160,
          width: MediaQuery.of(context).size.width * 1,
        )),
      ],
    );
  }

  Widget tittleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "PS 456 Bronx Bears",
            style: Theme.of(context).textTheme.headline2,
          )
        ],
      ),
    );
  }

  Widget _buildMapWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Container(
        height: _kboxheight * 2.5,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            border: Border.all(
              width: _kboxborderwidth,
              color: AppTheme.kTxtfieldBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: _buildmap(),
      ),
    );
  }

  Widget _buildmap() {
    return Container(
      margin: EdgeInsets.only(
          top: _kLabelSpacing / 3,
          bottom: _kLabelSpacing / 1.5,
          right: _kLabelSpacing / 3,
          left: _kLabelSpacing / 3),
      decoration: BoxDecoration(
          color: AppTheme.kmapBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: _kboxheight * 2,
            child: MapSample(),
          )
        ],
      ),
    );
  }

  Widget _buildPhoneWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            border: Border.all(
              width: _kboxborderwidth,
              color: AppTheme.kTxtfieldBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: _buildphone(),
      ),
    );
  }

  Widget _buildaddressWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            border: Border.all(
              width: _kboxborderwidth,
              color: AppTheme.kTxtfieldBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: _buildaddress(),
      ),
    );
  }

  Widget _buildaddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Address:",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Color(0xff171717)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * .60,
                  child: Text(
                    "123 Morningside Dr, New york,NY 10027, USA",
                    style: Theme.of(context).textTheme.bodyText2,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textAlign: TextAlign.start,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildphone() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        children: [
          Text(
            "Phone:",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Color(0xff171717)),
          ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Text(
            "(212) 222-0473",
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }

// BUTTOM SECTION END
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(),
          SpacerWidget(_kLabelSpacing),
          tittleWidget(),
          SpacerWidget(_kLabelSpacing / 1.5),
          _buildMapWidget(),
          _buildaddressWidget(),
          SpacerWidget(_kLabelSpacing / 1.25),
          _buildPhoneWidget()
        ],
      )),
    );
  }
}
