import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:invert_colors/invert_colors.dart';

class CustomIconWidget extends StatefulWidget {
  late final String? iconUrl;
  CustomIconWidget({Key? key, @required this.iconUrl}) : super(key: key);

  @override
  State<CustomIconWidget> createState() => _CustomIconWidgetState();
}

class _CustomIconWidgetState extends State<CustomIconWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var brightness = SchedulerBinding.instance!.window.platformBrightness;

    if (brightness == Brightness.dark) {
      Globals.themeType = 'Dark';
    } else {
 
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
          child: widget.iconUrl!.contains('Icons+Noun+Project') ||
                  widget.iconUrl!.contains('the-noun-project-icons') ||
                  widget.iconUrl!.contains('Staff') ||
                  widget.iconUrl!.contains('default_icon')
              ? Globals.themeType == 'Dark' 
                  ?
                  //  ColorFiltered(
                  //     colorFilter: 
                  //     ColorFilter.matrix([
                  //       -1,
                  //       0,
                  //       0,
                  //       0,
                  //       255,
                  //       0,
                  //       -1,
                  //       0,
                  //       0,
                  //       255,
                  //       0,
                  //       0,
                  //       -1,
                  //       0,
                  //       255,
                  //       0,
                  //       0,
                  //       0,
                  //       1,
                  //       0,
                  //     ]),
                  //     child: cachedNetworkImage(),
                  //   )
                  InvertColors(

                      child: cachedNetworkImage(),
                    )
                  : cachedNetworkImage()
              : cachedNetworkImage()),
    );
  }

  Widget cachedNetworkImage() {
    return CachedNetworkImage(
        imageUrl: widget.iconUrl!,
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