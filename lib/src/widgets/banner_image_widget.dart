import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BannerImageWidget extends StatefulWidget {
  final String imageUrl;
  final Color? bgColor;

  BannerImageWidget({required this.imageUrl, this.bgColor});
  @override
  _BannerImageWidgetState createState() => _BannerImageWidgetState();
}

class _BannerImageWidgetState extends State<BannerImageWidget> {
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight:
          Utility.displayHeight(context) * (AppTheme.kBannerHeight / 100),
      floating: false,
      // pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          // centerTitle: true,
          background: Container(
        color: widget.bgColor,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          // fit: BoxFit.fill,
          placeholder: (BuildContext context, _) => ShimmerLoading(
            isLoading: true,
            child: SizedBox(
              height: Utility.displayHeight(context) *
                  (AppTheme.kBannerHeight / 100),
              width: Utility.displayWidth(context),
            ),
          ),
        ),
      )),
    );
  }
}
