import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:googleapis/cloudasset/v1.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:Soc/src/modules/social/ui/socialeventdescription.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

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
  var unescape = new HtmlUnescape();

  SocialBloc bloc = SocialBloc();

  void initState() {
    super.initState();
    bloc.add(SocialPageEvent());
  }

//Style

  // static const _kListTextStyle = TextStyle(
  //     fontFamily: "Roboto",
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //     color: Color(0xff2D3F98));

  // static const _kListDateStyle = TextStyle(
  //     fontFamily: "Roboto Regular", fontSize: 13, color: Color(0xff2D3F98));

  Widget _buildlist(obj, int index) {
    var document = parse(obj.description["__cdata"]);
    dom.Element? link = document.querySelector('img');
    String? imageLink = link != null ? link.attributes['src'] : '';

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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SocialEventDescription(
                        obj: obj,
                        index: index,
                      )));
        },
        child: Row(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                    width: _kIconSize * 1.4,
                    height: _kIconSize * 1.5,
                    child: Container(
                      child: imageLink != null && imageLink.length > 4
                          ? ClipRRect(
                              child: CachedNetworkImage(
                                imageUrl: imageLink,
                                placeholder: (context, url) => SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )
                          : Text(''),
                    )),
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
                          child: Text(
                            obj.title["__cdata"]
                                .replaceAll(new RegExp(r'[^\w\s]+'), ''),
                            // "Check out these book suggestions for your summer reading !",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline2,
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
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Text(
                            Utility.convertDate(obj.pubDate).toString(),
                            style: Theme.of(context).textTheme.subtitle1,
                          )),
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Widget makeList(obj) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: obj.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildlist(obj[index], index);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, SocialState state) {
              if (state is SocialDataSucess) {
                return state.obj != null
                    ? Container(
                        child: Column(
                          children: [makeList(state.obj)],
                        ),
                      )
                    : Center(
                        child: Text("No Data found"),
                      );
              } else if (state is Loading) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  )),
                );
              }
              if (state is Errorinloading) {
                return Text("Unable to load the data");
              } else {
                return Container();
              }
            }),
      ]),
    );
  }
}
