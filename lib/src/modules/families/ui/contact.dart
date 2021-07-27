import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:Soc/src/widgets/mapwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  var obj;
  bool isbuttomsheet;
  ContactPage({Key? key, required this.obj, required this.isbuttomsheet})
      : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static const double _kLabelSpacing = 16.0;
  static const double _kboxheight = 60.0;
  static const double _kboxwidth = 300.0;
  static const double _kboxborderwidth = 0.75;
  var longitude;
  var latitude;
  var object;

  @override
  void initState() {
    super.initState();
    object = widget.obj;
    latitude = object["Contact_Office_Location__Latitude__s"] ?? '';
    longitude = object["Contact_Office_Location__Longitude__s"] ?? '';
  }

  void _launch(String launchThis) async {
    try {
      String url = launchThis;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print("Unable to launch $launchThis");
//        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //TOP SECTION START
  Widget _buildIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: object["Contact_Image__c"] != null &&
                  object["Contact_Image__c"].length > 0
              ? CachedNetworkImage(
                  imageUrl: object["Contact_Image__c"],
                  fit: BoxFit.fill,
                  placeholder: (context, url) => CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
              : Container(
                  child: Image.asset(
                  'assets/images/appicon.png',
                  fit: BoxFit.fill,
                  height: 160,
                  width: MediaQuery.of(context).size.width * 1,
                )),
        )
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
          object["Contact_Name__c"] != null &&
                  object["Contact_Name__c"].length > 0
              ? Text(
                  object["Contact_Name__c"],
                  style: Theme.of(context).textTheme.headline2,
                )
              : Container(child: Text("No contact details available ")),
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
          latitude != null
              ? SizedBox(
                  height: _kboxheight * 2,
                  child: GoogleMaps(
                    latitude: latitude,
                    longitude: longitude,
                    // locationName: 'soc client',
                  ),
                )
              : Container(),
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
              object["Contact_Address__c"] != null &&
                      object["Contact_Address__c"].length > 1
                  ? Container(
                      width: MediaQuery.of(context).size.width * .60,
                      child: Text(
                        object["Contact_Address__c"],
                        style: Theme.of(context).textTheme.bodyText2,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        textAlign: TextAlign.start,
                      ))
                  : Container(child: Text("No address  available here")),
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
          HorzitalSpacerWidget(_kLabelSpacing),
          object["Contact_Phone__c"] != null &&
                  object["Contact_Phone__c"].length > 1
              ? InkWell(
                  onTap: () {
                    object["Contact_Phone__c"] != null
                        ? _launch("tel:" + object["Contact_Phone__c"])
                        : print("No phone");
                  },
                  child: Text(
                    object["Contact_Phone__c"],
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )
              : Container(child: Text("No phone  available here"))
        ],
      ),
    );
  }

  Widget _buildEmailWidget() {
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
          child: _builEmail()),
    );
  }

  Widget _builEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        children: [
          Text(
            "Email",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Color(0xff171717)),
          ),
          HorzitalSpacerWidget(_kLabelSpacing * 1.5),
          object["Contact_Email__c"] != null &&
                  object["Contact_Email__c"].length > 1
              ? InkWell(
                  onTap: () {
                    object["Contact_Email__c"] != null
                        ? _launch('mailto:"${object["Contact_Email__c"]}"')
                        : print("null value");
                  },
                  child: Text(
                    object["Contact_Email__c"],
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )
              : Container(child: Text("No email  available here"))
        ],
      ),
    );
  }

// BUTTOM SECTION END
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isSearch: true,
        isShare: false,
        sharedpopBodytext: '',
        sharedpopUpheaderText: '',
      ),
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
          _buildPhoneWidget(),
          SpacerWidget(_kLabelSpacing / 1.25),
          _buildEmailWidget()
        ],
      )),
      // bottomNavigationBar: widget.isbuttomsheet && Globals.homeObjet != null
      //     ? InternalButtomNavigationBar()
      //     : null);
    );
  }
}

// CustomAppBarWidget