import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Newdescription extends StatefulWidget {
  _NewdescriptionState createState() => _NewdescriptionState();
}

class _NewdescriptionState extends State<Newdescription> {
  static const double _kLabelSpacing = 20.0;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    Widget _buildNewsHeading() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Text(
                "News Headline",
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "2021/09/01 20:10:10",
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      );
    }

    Widget _buildImage() {
      return Container(
        width: MediaQuery.of(context).size.width * 100,
        height: MediaQuery.of(context).size.width * 0.25,
        child: ClipRRect(
          child: CachedNetworkImage(
            imageUrl: "https://picsum.photos/250?image=9",
            placeholder: (context, url) => CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Theme.of(context).accentColor,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    }

    Widget _buildNewsContent() {
      return Container(
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
                    width: MediaQuery.of(context).size.width * .93,
                    child: Text(
                      "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Sydney  in Virginia, looked up one of the more obscure Latinetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source",
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      maxLines: 10,
                    )),
              ],
            ),
          ],
        ),
      );
    }

    // Widget _buildNewsTimesStamp() {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Text(
    //         "2021/09/01 20:10:10",
    //         style: Theme.of(context).textTheme.subtitle1,
    //       ),
    //     ],
    //   );
    // }

    // Widget _buildNews() {
    //   return Container(
    //     width: MediaQuery.of(context).size.width * 100,
    //     // height: MediaQuery.of(context).size.width * 0.25,
    //     child: ClipRRect(
    //       child: CachedNetworkImage(
    //         imageUrl: "https://picsum.photos/250?image=9",
    //         placeholder: (context, url) => CircularProgressIndicator(
    //           strokeWidth: 2,
    //           backgroundColor: Colors.blue,
    //         ),
    //         errorWidget: (context, url, error) => Icon(Icons.error),
    //       ),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: CustomAppBarWidget(
        isnewsDescription: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            SpacerWidget(_kLabelSpacing / 2),
            _buildNewsHeading(),
            // SpacerWidget(_kLabelSpacing / 2),
            // _buildNewsTimesStamp(),
            SpacerWidget(_kLabelSpacing / 2),
            _buildNewsContent(),
          ],
        ),
      ),
    );
  }
}
