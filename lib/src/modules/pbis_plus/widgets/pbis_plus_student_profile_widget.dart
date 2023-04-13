import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PBISCommonProfileWidget extends StatelessWidget {
  const PBISCommonProfileWidget({
    Key? key,
    required this.profilePictureSize,
    required this.imageUrl,
  }) : super(key: key);

  final double profilePictureSize;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: profilePictureSize,
        backgroundImage: imageProvider,
      ),
      imageUrl: imageUrl!,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          // padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 0.5,
            ),
          ),
          child: CircleAvatar(
            radius: profilePictureSize,
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.person,
              // size: profilePictureSize,
              color: Colors.grey[300]!,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
