// ignore_for_file: deprecated_member_use
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/circular_custom_button.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PBISPlusDeleteBehaviorPopup extends StatefulWidget {
  final Orientation? orientation;
  final BuildContext? context;
  final String? message;
  final String? title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final PBISPlusCommonBehaviorModal item;
  void Function() onDelete;
  final double constraint;
  PBISPlusDeleteBehaviorPopup({
    Key? key,
    required this.orientation,
    required this.context,
    required this.message,
    required this.title,
    required this.titleStyle,
    required this.backgroundColor,
    required this.item,
    required this.onDelete,
    required this.constraint,
  }) : super(key: key);

  @override
  State<PBISPlusDeleteBehaviorPopup> createState() =>
      _PBISPlusDeleteBehaviorPopupState();
}

class _PBISPlusDeleteBehaviorPopupState
    extends State<PBISPlusDeleteBehaviorPopup> {
  PBISPlusBloc pbisPlusClassroomBloc = PBISPlusBloc();

  @override
  void dispose() {
    super.dispose();
  }

  PBISPlusBloc pbisPlusBloc = PBISPlusBloc();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: body());
  }

  Widget body() {
    return Stack(children: <Widget>[
      Container(
          height: (widget.constraint <= 115)
              ? MediaQuery.of(context).size.height * 0.28
              : MediaQuery.of(context).size.height * 0.26,
          padding: EdgeInsets.only(left: 16, top: 54, right: 16, bottom: 16),
          margin: EdgeInsets.only(top: 54),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.kButtonColor,
                  Color(0xff000000) != Theme.of(context).backgroundColor
                      ? Color(0xffF7F8F9)
                      : Color(0xff111C20)
                ],
                stops: [0.2, 0.0],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10)
              ]),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpacerWidget(MediaQuery.of(context).size.height / 40),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Utility.textWidget(
                        context: context,
                        textAlign: TextAlign.center,
                        text: ("Are you sure you want to delete this item?"),
                        textTheme: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 16))),
                SpacerWidget(MediaQuery.of(context).size.height / 60),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomCircularButton(
                            size: Size(MediaQuery.of(context).size.width * 0.29,
                                MediaQuery.of(context).size.width / 10),
                            text: "Cancel",
                            onClick: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: AppTheme.kButtonColor,
                            isBusy: false,
                            textColor: Color(0xffF7F8F9),
                            buttonRadius: 64,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.height / 40),
                          _buildDeleteButton(false)
                        ]))
              ])),
      Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: _showDeleteIconWidget(widget.item))
    ]);
  }

  Widget _buildDeleteButton(bool isBusy) {
    return CustomCircularButton(
        borderColor: Color(0xff000000) != Theme.of(context).backgroundColor
            ? Color(0xff111C20)
            : Color(0xffF7F8F9),
        text: "Delete",
        textColor: Color(0xff000000) != Theme.of(context).backgroundColor
            ? Color(0xff111C20)
            : Color(0xffF7F8F9),
        onClick: widget.onDelete,
        backgroundColor: Color(0xff000000) != Theme.of(context).backgroundColor
            ? Color(0xffF7F8F9)
            : Color(0xff111C20),
        isBusy: isBusy,
        size: Size(MediaQuery.of(context).size.width * 0.29,
            MediaQuery.of(context).size.width / 10),
        buttonRadius: 64);
  }

  Widget _buildSelectedIcon({required PBISPlusCommonBehaviorModal item}) {
    return CachedNetworkImage(
        imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 30,
            backgroundImage: imageProvider,
            backgroundColor: Colors.transparent),
        imageUrl: item.pBISBehaviorIconURLC!,
        placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 0.5)),
                child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.person, color: Colors.grey[300]!)))),
        errorWidget: (context, url, error) => Icon(Icons.error));
  }

  Widget _showDeleteIconWidget(PBISPlusCommonBehaviorModal item) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Color(0xffF7F8F9)
                : Color(0xff111C20),
            shape: BoxShape.circle),
        child: CircleAvatar(
            radius: 42.0,
            backgroundColor: Colors.transparent,
            child: _buildSelectedIcon(item: item)));
  }
}
