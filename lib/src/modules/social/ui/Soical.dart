import 'dart:ui';
import 'package:Soc/src/modules/families/Submodule/event/ui/eventdescition.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
import 'package:Soc/src/modules/social/modal/models/item.dart';
import 'package:Soc/src/modules/social/modal/socialmodal.dart';
import 'package:Soc/src/modules/social/ui/socialeventdescription.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SocialPage extends StatefulWidget {
  SocialPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 48.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Item>? obj;
  SocialBloc bloc = SocialBloc();

  void initState() {
    super.initState();
    bloc.add(SocialPageEvent());
  }

//Style

  static const _kListTextStyle = TextStyle(
      fontFamily: "Roboto",
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Color(0xff2D3F98));

  static const _kListDateStyle = TextStyle(
      fontFamily: "Roboto Regular", fontSize: 13, color: Color(0xff2D3F98));

  Widget _buildlist(int index) {
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
        vertical: _kLabelSpacing / 2,
      ),
      color: (index % 2 == 0)
          ? Theme.of(context).backgroundColor
          : AppTheme.kListBackgroundColor2,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EventDescription()));
        },
        child: Row(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  width: _kIconSize * 1.4,
                  height: _kIconSize * 1.5,
                  child: Container(
                      //     child:
                      //      ClipRRect(
                      //         child: Image.network(
                      //   'https://picsum.photos/250?image=9',
                      //   fit: BoxFit.fill,
                      // ))
                      ),
                ),
              ],
            ),
            SizedBox(
              width: _kLabelSpacing / 2,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.69,
                          child:
                              // obj != null
                              //     ? Text(obj![0].tittle)
                              // :
                              Text(
                            "Check out these book suggestions for your summer reading !",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: _kListTextStyle,
                          )),
                    ],
                  ),
                  SizedBox(height: _kLabelSpacing / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          // width: MediaQuery.of(context).size.width * 0.40,
                          child: Text(
                        "${currentDate}",
                        style: _kListDateStyle,
                      )),
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Widget makeList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return _buildlist(index);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, SocialState state) {
              if (state is DataGettedSuccessfully) {
                return state.obj != null
                    ? Container(
                        child: Column(
                          children: [makeList()],
                        ),
                      )
                    : Center(
                        child: Text("No Data found"),
                      );
              } else if (state is Loading) {
                return Center();
              } else {
                return Container();
              }
            }),
        BlocListener<SocialBloc, SocialState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is DataGettedSuccessfully) {
              // obj = state.obj;
            }

            if (state is Errorinloading) {
              if (state.err != null && state.err != "") {
                Utility.showSnackBar(
                    _scaffoldKey, "Unable to load the data", context);
              }
            }
          },
          child: Container(),
        ),
      ]),
    );
  }
}
