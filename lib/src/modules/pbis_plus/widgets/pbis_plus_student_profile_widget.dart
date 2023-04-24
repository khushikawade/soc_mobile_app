import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PBISCommonProfileWidget extends StatelessWidget {
  const PBISCommonProfileWidget({
    Key? key,
    required this.profilePictureSize,
    required this.imageUrl,
    required this.studentValueNotifier,
  }) : super(key: key);

  final double profilePictureSize;
  final String imageUrl;
  final ValueNotifier<ClassroomStudents> studentValueNotifier;

  @override
  Widget build(BuildContext context) {
    return studentValueNotifier.value!.profile!.photoUrl!
            .contains('default-user')
        ? Container(
            child: CircleAvatar(
              radius: profilePictureSize,
              backgroundColor:
                  Color(0xff000000) == Theme.of(context).backgroundColor
                      ? Color(0xffF7F8F9)
                      : Color(0xff111C20),
              child: Utility.textWidget(
                maxLines: 2,
                text: studentValueNotifier.value.profile!.name!.givenName!
                        .toUpperCase()
                        .substring(0, 1) +
                    studentValueNotifier.value.profile!.name!.familyName!
                        .toUpperCase()
                        .substring(0, 1),
                context: context,
                textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                      color:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                    ),
              ),
            ),
          )
        : CachedNetworkImage(
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
