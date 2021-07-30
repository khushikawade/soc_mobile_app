import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:Soc/src/widgets/mapwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContactPage extends StatefulWidget {
  final obj;
  bool isbuttomsheet;
  String appBarTitle;
  String? language;
  ContactPage(
      {Key? key,
      required this.obj,
      required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language})
      : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static const double _kLabelSpacing = 16.0;
  static const double _kboxheight = 60.0;
  UrlLauncherWidget urlobj = new UrlLauncherWidget();

  static const double _kboxborderwidth = 0.75;
  var longitude;
  var latitude;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildIcon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: widget.obj["Contact_Image__c"] != null &&
                  widget.obj["Contact_Image__c"].length > 0
              ? CachedNetworkImage(
                  imageUrl: widget.obj["Contact_Image__c"],
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    width: 5,
                    height: 5,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      backgroundColor: AppTheme.kAccentColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                  ),
                )
              : Container(
                  child: Image.asset(
                  'assets/images/appicon.png',
                  fit: BoxFit.fill,
                  height: 160,
                  width: MediaQuery.of(context).size.width * 1,
                )),
        ),
      ],
    );
  }

  Widget tittleWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        child: widget.language != null && widget.language != "English"
            ? TranslationWidget(
                message: widget.obj["Contact_Name__c"] ?? "-",
                toLanguage: widget.language,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
              )
            : Text(
                widget.obj["Contact_Name__c"] ?? "-",
                style: Theme.of(context).textTheme.headline2,
              ));
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
      child: widget.obj["Contact_Office_Location__Latitude__s"] != null &&
              widget.obj["Contact_Office_Location__Longitude__s"] != null
          ? SizedBox(
              height: _kboxheight * 2,
              child: GoogleMaps(
                latitude: widget.obj["Contact_Office_Location__Latitude__s"],
                longitude: widget.obj["Contact_Office_Location__Longitude__s"],
                // locationName: 'soc client',
              ),
            )
          : Container(),
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
          widget.language != null && widget.language != "English"
              ? TranslationWidget(
                  message: "Address:",
                  toLanguage: widget.language,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Color(0xff171717)),
                    textAlign: TextAlign.center,
                  ),
                )
              : Text(
                  "Address :",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Color(0xff171717)),
                  textAlign: TextAlign.center,
                ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          widget.obj["Contact_Address__c"] != null &&
                  widget.obj["Contact_Address__c"].length > 1
              ? Expanded(
                  child: widget.language != null && widget.language != "English"
                      ? TranslationWidget(
                          message: widget.obj["Contact_Address__c"],
                          toLanguage: widget.language,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.start,
                          ),
                        )
                      : Text(
                          widget.obj["Contact_Address__c"],
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
                        ),
                )
              : Container(
                  child: widget.language != null && widget.language != "English"
                      ? TranslationWidget(
                          message: "No address  available here",
                          toLanguage: widget.language,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                          ),
                        )
                      : Text("No address  available here")),
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
          widget.language != null && widget.language != "English"
              ? TranslationWidget(
                  message: "Phone :",
                  toLanguage: widget.language,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Color(0xff171717)),
                  ),
                )
              : Text(
                  "Phone:",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Color(0xff171717)),
                ),
          HorzitalSpacerWidget(_kLabelSpacing),
          widget.obj["Contact_Phone__c"] != null &&
                  widget.obj["Contact_Phone__c"].length > 1
              ? InkWell(
                  onTap: () {
                    if (widget.obj["Contact_Phone__c"] != null) {
                      urlobj.callurlLaucher(
                          context, "tel:" + widget.obj["Contact_Phone__c"]);
                    }
                  },
                  child: widget.language != null && widget.language != "English"
                      ? TranslationWidget(
                          message: widget.obj["Contact_Phone__c"],
                          toLanguage: widget.language,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        )
                      : Text(
                          widget.obj["Contact_Phone__c"],
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                )
              : Container(
                  child: widget.language != null && widget.language != "English"
                      ? TranslationWidget(
                          message: "No phone  available here",
                          toLanguage: widget.language,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        )
                      : Text("No phone  available here"))
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
          widget.language != null && widget.language != "English"
              ? TranslationWidget(
                  message: "Email :",
                  toLanguage: widget.language,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Color(0xff171717)),
                  ),
                )
              : Text(
                  "Email",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Color(0xff171717)),
                ),
          HorzitalSpacerWidget(_kLabelSpacing * 1.5),
          widget.obj["Contact_Email__c"] != null &&
                  widget.obj["Contact_Email__c"].length > 1
              ? InkWell(
                  onTap: () {
                    widget.obj["Contact_Email__c"] != null
                        ? urlobj.callurlLaucher(context,
                            'mailto:"${widget.obj["Contact_Email__c"]}"')
                        : print("null value");
                  },
                  child: Text(
                    widget.obj["Contact_Email__c"],
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )
              : Container(
                  child: widget.language != null && widget.language != "English"
                      ? TranslationWidget(
                          message: "No email  available here",
                          toLanguage: widget.language,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                          ),
                        )
                      : Text("No email  available here"))
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: true,
          isShare: false,
          appBarTitle: widget.appBarTitle,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          language: widget.language,
        ),
        body: ListView(children: [
          _buildIcon(),
          SpacerWidget(_kLabelSpacing),
          tittleWidget(),
          SpacerWidget(_kLabelSpacing / 1.5),
          _buildMapWidget(),
          _buildaddressWidget(),
          SpacerWidget(_kLabelSpacing / 1.25),
          _buildPhoneWidget(),
          SpacerWidget(_kLabelSpacing / 1.25),
          _buildEmailWidget(),
        ]),
        bottomNavigationBar: widget.isbuttomsheet && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }
}
