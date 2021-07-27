import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Newdescription extends StatefulWidget {
  var obj;
  String date;
  Newdescription({Key? key, required this.obj, required this.date})
      : super(key: key);

  _NewdescriptionState createState() => _NewdescriptionState();
}

class _NewdescriptionState extends State<Newdescription> {
  static const double _kLabelSpacing = 20.0;

  _launchURL(obj) async {
    // print(obj);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InAppUrlLauncer(
                  title: widget.obj.headings["en"].toString(),
                  url: obj,
                )));
  }

  Widget _buildNewsDescription() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.width * 0.5,
          child: ClipRRect(
            child: widget.obj.image != null && widget.obj.image != ""
                ? CachedNetworkImage(
                    imageUrl: widget.obj.image,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => CircularProgressIndicator(
                      strokeWidth: 2,
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                : Container(
                    alignment: Alignment.center,
                    child:
                        Image(image: AssetImage("assets/images/appicon.png")),
                  ),
          ),
        ),
        SpacerWidget(_kLabelSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.obj.headings != "" &&
                        widget.obj.headings != null &&
                        widget.obj.headings.length > 0
                    ? widget.obj.headings["en"].toString()
                    : widget.obj.contents["en"].toString().split(" ")[0] +
                        " " +
                        widget.obj.contents["en"].toString().split(" ")[1] +
                        "...",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Text(
              widget.date,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
        Container(
          child: Wrap(
            children: [
              Text(
                widget.obj.contents["en"].toString(),
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        SpacerWidget(_kLabelSpacing),
        GestureDetector(
          onTap: () {
            _launchURL(widget.obj.url);
          },
          child: widget.obj.url != null
              ? Wrap(
                  children: [
                    Text(
                      widget.obj.url.toString(),
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                )
              : Container(),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 1.5),
        child: _buildNewsDescription(),
      ),
    );
  }
}
