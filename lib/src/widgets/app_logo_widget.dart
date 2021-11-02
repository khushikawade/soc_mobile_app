import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:showcaseview/showcaseview.dart';

class AppLogoWidget extends StatelessWidget {
  final double? marginLeft;
  AppLogoWidget({
    Key? key,
    required this.marginLeft,
  }) : super(key: key);

  static const double _kIconSize = 50;

 

  Widget build(BuildContext context) {
    print(Globals.homeObjet["App_Logo__c"]);
    return Container(
      padding: EdgeInsets.only(right: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: marginLeft??0),
              // color: Colors.red,
          // alignment: Alignment.centerRight,
              height:
                  Globals.deviceType == "phone" ? _kIconSize : _kIconSize * 1.2,
              width: Globals.deviceType == "phone"
                  ? _kIconSize * 1.75
                  : _kIconSize * 1.95,
              child: Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: Globals.homeObjet["App_Logo__c"],
                      placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: _kIconSize * 1.4,
                              height: _kIconSize * 1.5,
                              color: Colors.white,
                            ),
                          )),
                      errorWidget: (context, url, error) => Text("Loading...")//Icon(Icons.error),
                    ),
                  ))),
        ],
      ),
    );
  }
}
