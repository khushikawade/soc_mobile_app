import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  var child;
  bool? isLoading = false;

  ShimmerLoading({Key? key, @required this.child, @required this.isLoading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return isLoading!
        ? Shimmer.fromColors(
            baseColor: AppTheme.kShimmerBaseColor!,
            highlightColor: AppTheme.kShimmerHighlightColor!,
            enabled: true,
            child: child!)
        : child;
  }
}