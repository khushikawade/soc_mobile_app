import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BannerImageWidget extends StatefulWidget {
  final String? imageUrl;
  final Color? bgColor;
  final double? bannerHeight;
  final bool? isStaffPage;
  final Widget? staffActionWidget;
  final double? staffActionHeight;

  BannerImageWidget(
      {required this.imageUrl,
      this.bgColor,
      this.bannerHeight,
      this.isStaffPage,
      this.staffActionWidget,
      this.staffActionHeight});
  @override
  _BannerImageWidgetState createState() => _BannerImageWidgetState();
}

class _BannerImageWidgetState extends State<BannerImageWidget> {
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      // expandedHeight: Globals.deviceType == "phone"
      //     ? Utility.displayHeight(context) * (AppTheme.kBannerHeight / 100)
      //     : Utility.displayHeight(context) *
      //         (AppTheme.kBannerHeight * 1.3 / 100),
      expandedHeight: widget.bannerHeight != null && widget.bannerHeight != ''
          ? (Utility.displayHeight(context) * (widget.bannerHeight! / 100)) +
              (widget.staffActionHeight ?? 0.0)
          : (Utility.displayHeight(context) * (AppTheme.kBannerHeight / 100)) +
              (widget.staffActionHeight ?? 0.0),
      floating: false,
      // pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          // centerTitle: true,
          background: widget.isStaffPage == true
              ? Column(
                  children: [
                    if (widget.imageUrl != null && widget.imageUrl != '')
                      Container(
                          height: (Utility.displayHeight(context) *
                              (AppTheme.kBannerHeight / 100)),
                          child: bannerWidget()),
                    widget.staffActionWidget ?? Container()
                  ],
                )
              : bannerWidget()),
    );
  }

  Widget bannerWidget() {
    return Container(
      color: widget.bgColor,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl ?? '',
        // fit: BoxFit.fill,
        placeholder: (BuildContext context, _) => ShimmerLoading(
          isLoading: true,
          child: SizedBox(
            height:
                Utility.displayHeight(context) * (AppTheme.kBannerHeight / 100),
            width: Utility.displayWidth(context),
          ),
        ),
        errorWidget: (context, url, error) {
          return Container();
        },
      ),
    );
  }
}
