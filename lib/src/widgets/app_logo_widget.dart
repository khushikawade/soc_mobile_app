import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  static const double _kIconSize = 50;//45.0;
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
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
    );
  }
}
