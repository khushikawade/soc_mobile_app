import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:invert_colors/invert_colors.dart';

class CustomIconMode extends StatefulWidget {
  late final String? iconUrl;
  final String? darkModeIconUrl;
  CustomIconMode({Key? key, @required this.iconUrl, this.darkModeIconUrl})
      : super(key: key);

  @override
  State<CustomIconMode> createState() => _CustomIconModeState();
}

class _CustomIconModeState extends State<CustomIconMode> {
  @override
  void initState() {
    super.initState();
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    if (brightness == Brightness.dark && Globals.disableDarkMode != true) {
      Globals.themeType = 'Dark';
    } else {
      Globals.themeType = 'Light';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
          child: Globals.disableDarkMode == true
              ? cachedNetworkImage(widget.iconUrl)
              : Globals.themeType == 'Dark'
                  ? (widget.darkModeIconUrl == null ||
                          widget.darkModeIconUrl == ''
                      ? InvertColors(
                          child: cachedNetworkImage(widget.iconUrl),
                        )
                      : cachedNetworkImage(widget.darkModeIconUrl))
                  : cachedNetworkImage(widget.iconUrl)),
    );
  }

  Widget cachedNetworkImage(url) {
    return CachedNetworkImage(
        imageUrl: url,
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