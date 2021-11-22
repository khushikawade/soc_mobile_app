import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  late final String? iconUrl;
  CustomIconWidget({Key? key, @required this.iconUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        child: CachedNetworkImage(
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
                  imageUrl: Overrides.defaultIconUrl,
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
                )),
      ),
    );
  }
}
