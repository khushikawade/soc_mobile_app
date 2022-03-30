import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomIconWidget extends StatefulWidget {
  late final String? iconUrl;
  CustomIconWidget({Key? key, @required this.iconUrl}) : super(key: key);

  @override
  State<CustomIconWidget> createState() => _CustomIconWidgetState();
}

class _CustomIconWidgetState extends State<CustomIconWidget> {
  @override
  void initState() {
    super.initState();
    var brightness = SchedulerBinding.instance!.window.platformBrightness;

    if (brightness == Brightness.dark) {
      Globals.themeType = 'Dark';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(child: cachedNetworkImage()),
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
