import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonCachedNetworkImage extends StatelessWidget {
  String? imagePath;
  CommonCachedNetworkImage({
    Key? key,
    String? imagePath,
  }) : super(key: key) {
    this.imagePath = imagePath ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath!,
      // fit: BoxFit.contain,
      placeholder: (BuildContext context, _) => ShimmerLoading(
        isLoading: true,
        child: SizedBox(
          height:
              Utility.displayHeight(context) * (AppTheme.kBannerHeight / 100),
          width: Utility.displayWidth(context),
        ),
      ),
      errorWidget: (context, url, error) {
        return SizedBox.shrink();
      },
    );
  }
}
