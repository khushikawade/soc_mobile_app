import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  late final String? iconUrl;
  final double? height;
  final double? width;
  final BoxFit? fitMethod;
  final bool? isOnTap;
  CustomIconWidget(
      {Key? key,
      @required this.iconUrl,
      this.height,
      this.width,
      this.fitMethod,
      this.isOnTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isOnTap == true) {
          showDialog(
              context: context,
              builder: (_) => ImagePopup(
                  imageURL: iconUrl ??
                      Globals.splashImageUrl ??
                      Globals.homeObject["App_Logo__c"]));
        }
      },
      child: ClipRRect(
        child: CachedNetworkImage(
            imageUrl: iconUrl!,
            fit: fitMethod ?? BoxFit.cover,
            height: height ??
                (Globals.deviceType == "phone"
                    ? AppTheme.kIconSize
                    : AppTheme.kTabIconSize),
            width: width != 0
                ? width
                : (Globals.deviceType == "phone"
                    ? AppTheme.kIconSize
                    : AppTheme.kTabIconSize),
            placeholder: (context, url) => Container(
                alignment: Alignment.center,
                child: ShimmerLoading(
                  isLoading: true,
                  child: Container(
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ),
                )),
            errorWidget: (context, url, error) => CachedNetworkImage(
                  imageUrl: Globals.splashImageUrl ??
                      Globals.homeObject["App_Logo__c"],
                  height: height ??
                      (Globals.deviceType == "phone"
                          ? AppTheme.kIconSize
                          : AppTheme.kTabIconSize),
                  width: width != 0
                      ? width
                      : (Globals.deviceType == "phone"
                          ? AppTheme.kIconSize
                          : AppTheme.kTabIconSize),
                  placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          height: 20,
                          width: 20,
                          color: Colors.white,
                        ),
                      )),
                )),
      ),
    );
  }
}
