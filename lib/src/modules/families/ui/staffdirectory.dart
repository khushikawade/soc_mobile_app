import 'dart:ui';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffDirectory extends StatefulWidget {
  var obj;
  StaffDirectory({Key? key, required this.obj}) : super(key: key);

  @override
  _StaffDirectoryState createState() => _StaffDirectoryState();
}

class _StaffDirectoryState extends State<StaffDirectory> {
  static const double _kLabelSpacing = 16.0;
  var _controller = TextEditingController();
  FamilyBloc _bloc = FamilyBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(SDevent());
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

  Widget _buildSearchbar() {
    return SizedBox(
        height: 50,
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
            color: AppTheme.kFieldbackgroundColor,
            child: TextFormField(
              controller: _controller,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Search School App',
                contentPadding: EdgeInsets.symmetric(
                  vertical: _kLabelSpacing / 2,
                ),
                filled: true,
                fillColor: AppTheme.kBackgroundColor,
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  const IconData(0xe805,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: AppTheme.kprefixIconColor,
                ),
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: AppTheme.kIconColor,
                    size: 18,
                  ),
                ),
              ),
            )));
  }

  Widget contactItem(obj, index) {
    return InkWell(
        onTap: () {},
        child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 1.5),
            padding: EdgeInsets.symmetric(
                horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 1.5),
            decoration: BoxDecoration(
              border: (index % 2 == 0)
                  ? Border.all(color: AppTheme.ListColor2)
                  : Border.all(color: Theme.of(context).backgroundColor),
              borderRadius: BorderRadius.circular(0.0),
              color: (index % 2 == 0)
                  ? AppTheme.ListColor2
                  : Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  obj.imageUrlC != null && obj.imageUrlC.length > 0
                      ? CachedNetworkImage(
                          imageUrl: obj.imageUrlC,
                          fit: BoxFit.fill,
                          width: 60,
                          height: 60,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Theme.of(context).accentColor,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      : Container(
                          child: Image.asset(
                          'assets/images/address.png',
                          fit: BoxFit.fill,
                          height: 60,
                          width: 60,
                        )),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  Expanded(
                      child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text("Title:",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  )),
                          HorzitalSpacerWidget(_kLabelSpacing / 2),
                          obj.titleC != null && obj.titleC.length > 0
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * .70,
                                  child: Text(obj.titleC,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontWeight: FontWeight.w400)))
                              : Container(),
                        ],
                      ),
                      SpacerWidget(_kLabelSpacing / 2),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  "Description",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                ),
                                HorzitalSpacerWidget(_kLabelSpacing / 2),
                                obj.descriptionC != null &&
                                        obj.descriptionC.length > 0
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .70,
                                        child: Text(obj.descriptionC,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400)))
                                    : Text("")
                              ],
                            ),
                            SpacerWidget(_kLabelSpacing * 2),
                          ]),
                      InkWell(
                        onTap: () {
                          obj.emailC != null
                              ? _launch('mailto:"${obj.emailC}"')
                              : print("he");
                        },
                        child: Row(
                          children: [
                            Text("Email",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            HorzitalSpacerWidget(_kLabelSpacing / 2),
                            obj.emailC != null && obj.emailC.length > 0
                                ? Icon(
                                    Icons.email,
                                    size: 20,
                                  )
                                : Text("")
                          ],
                        ),
                      ),
                      SpacerWidget(_kLabelSpacing / 2),
                      InkWell(
                        onTap: () {
                          obj.phoneC != null
                              ? _launch("tel:" + obj.phoneC)
                              : print("he");
                        },
                        child: Row(
                          children: <Widget>[
                            Text("Phone",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            HorzitalSpacerWidget(_kLabelSpacing / 2),
                            obj.phoneC != null && obj.phoneC.length > 0
                                ? Icon(
                                    Icons.local_phone,
                                    size: 20,
                                  )
                                : Text("")
                          ],
                        ),
                      ),
                    ],
                  ))
                ])));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isnewsDescription: false,
        // title: "Staff directory", //  widget.obj.toString(),
        isnewsSearchPage: false,
      ),
      body: SingleChildScrollView(
          child: SafeArea(
              child: BlocBuilder<FamilyBloc, FamilyState>(
                  bloc: _bloc,
                  builder: (BuildContext contxt, FamilyState state) {
                    if (state is FamilyInitial || state is FamilyLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).accentColor,
                      ));
                    } else if (state is SDDataSucess) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.obj!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return contactItem(state.obj![index], index);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }))),
    );
  }
}
