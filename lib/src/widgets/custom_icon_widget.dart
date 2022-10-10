import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomIconWidget extends StatefulWidget {
  late final String? iconUrl;
  final String? darkModeIconUrl;
  // final bool? colorInvert;
  CustomIconWidget(
      {Key? key, @required this.iconUrl, @required this.darkModeIconUrl
      // , @required this.colorInvert
      })
      : super(key: key);

  @override
  State<CustomIconWidget> createState() => _CustomIconWidgetState();
}

class _CustomIconWidgetState extends State<CustomIconWidget> {
  @override
  void initState() {
    super.initState();
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    if (brightness == Brightness.dark && Globals.disableDarkMode != true) {
      Globals.themeType = 'Dark';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Overrides.STANDALONE_GRADED_APP == true
          ? EdgeInsets.only(right: MediaQuery.of(context).size.width / 8)
          : null,
      child: ClipRRect(
          child: Overrides.STANDALONE_GRADED_APP == true
              ? standAlonLogo()
              : cachedNetworkImage()),
    );
  }

  Widget cachedNetworkImage() {
    return CachedNetworkImage(
        imageUrl: Globals.disableDarkMode == true
            ? widget.iconUrl!
            : Globals.themeType == 'Dark'
                ? (widget.darkModeIconUrl == null ||
                        widget.darkModeIconUrl == ''
                    ? widget.iconUrl!
                    : widget.darkModeIconUrl!)
                : widget.iconUrl!,
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

  Widget standAlonLogo() {
    return Image.asset(
      Color(0xff000000) == Theme.of(context).backgroundColor
          ? "assets/images/graded+_light.png"
          : "assets/images/graded+_dark.png",
      height: AppTheme.kTabIconSize * 1.2,
      width: AppTheme.kTabIconSize * 1.5,
    );
  }
}
