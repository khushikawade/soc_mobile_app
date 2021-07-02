import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  final ValueChanged? onTap;
  final dynamic _user = null;
  final String? url;
  final double? radius;

  ProfilePictureWidget({Key? key, this.onTap, this.radius, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? getUrl() {
      if (url != null) return url;
      return _user["image"] != null ? _user["image"] : "";
    }

    return SizedBox(
      height: radius != null ? radius : 30,
      width: radius != null ? radius : 30,
      child: InkWell(
        onTap: () async {
          // bool result = await Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => UserAccount(
          //   uploader: widget.uploader,
          //   uploadURL: widget.uploadURL,
          //   onUploadStarted: () {
          //     setState(() {
          //       print("Uploading started ----------------------");
          //     });
          //   },
          // )));
        },
        child: Container(
            child: Center(
                child: CachedNetworkImage(
          height: radius != null ? radius : 30,
          width: radius != null ? radius : 30,
          imageUrl: getUrl()!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                radius != null ? radius! : 30,
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Text(
            "${_user['first_name'] != null ? _user['first_name'][0] : ""}",
            style: TextStyle(
                letterSpacing: 1.5,
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ))),
      ),
    );
  }
}
