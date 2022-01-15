import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:invert_colors/invert_colors.dart';

class CustomIconWidget extends StatelessWidget {
  late final String? iconUrl;
  CustomIconWidget({Key? key, @required this.iconUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
          child: iconUrl!.contains('Icons+Noun+Project') ||
                  iconUrl!.contains('the-noun-project-icons') ||
                  iconUrl!.contains('Staff') ||
                  iconUrl!.contains('default_icon')
              ? Globals.darkTheme == true
                  ? InvertColors(
                      child: cachedNetworkImage(),
                    )
                  : cachedNetworkImage()
              : cachedNetworkImage()),
    );
  }

  Widget cachedNetworkImage() {
    return CachedNetworkImage(
        imageUrl: iconUrl!,
        height: Globals.deviceType == "phone"
            ? AppTheme.kIconSize
            : AppTheme.kTabIconSize,
        width: Globals.deviceType == "phone"
            ? AppTheme.kIconSize
            : AppTheme.kTabIconSize,
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
              imageUrl:
                  "https://solved-consulting-images.s3.us-east-2.amazonaws.com/Miscellaneous/default_icon.png",
              height: Globals.deviceType == "phone"
                  ? AppTheme.kIconSize
                  : AppTheme.kTabIconSize,
              width: Globals.deviceType == "phone"
                  ? AppTheme.kIconSize
                  : AppTheme.kTabIconSize,
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
            ));
  }
}

// black to white

// colorFilter: ColorFilter.matrix([
//               -1,  0,  0, 0, 255,
//               0, -1,  0, 0, 255,
//               0,  0, -1, 0, 255,
//               0,  0,  0, 1,   0,
//             ]),