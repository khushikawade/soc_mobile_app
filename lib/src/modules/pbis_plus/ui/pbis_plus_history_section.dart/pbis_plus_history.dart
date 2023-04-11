import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pibs_plus_history_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_icons.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_background_img.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PBISPlusHistory extends StatefulWidget {
  final IconData titleIconData;
  PBISPlusHistory({Key? key, required this.titleIconData}) : super(key: key);

  @override
  State<PBISPlusHistory> createState() => _PBISPlusHistoryState();
}

class _PBISPlusHistoryState extends State<PBISPlusHistory> {
  static const double _KVertcalSpace = 60.0;
  PBISPlusBloc PBISPlusBlocInstance = PBISPlusBloc();
  @override
  void initState() {
    super.initState();
    PBISPlusBlocInstance.add(GetPBISPlusHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PBISPlusUtility.pbisAppBar(context, widget.titleIconData),
          body: body(context))
    ]);
  }

  Widget body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SpacerWidget(_KVertcalSpace / 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Utility.textWidget(
            text: 'History',
            context: context,
            textTheme: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SpacerWidget(_KVertcalSpace / 3),
        SpacerWidget(_KVertcalSpace / 5),
        Expanded(
            child: BlocConsumer(
                bloc: PBISPlusBlocInstance,
                builder: (context, state) {
                  if (state is PBISPlusLoading) {
                    return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ));
                  }
                  if (state is PBISPlusHistorySuccess &&
                      (state.pbisHistoryData.isNotEmpty ?? false)) {
                    return _listBuilder(state.pbisHistoryData);
                  }

                  return NoDataFoundErrorWidget(
                      isResultNotFoundMsg: true,
                      isNews: false,
                      isEvents: false);
                },
                listener: (context, state) {})),
      ],
    );
  }

  Widget _listBuilder(List<PBISPlusHistoryModal> historyData) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 20),
      itemBuilder: (BuildContext context, int index) {
        final bool isDarkMode =
            Theme.of(context).colorScheme.background == Color(0xff000000);
        final Color evenColor =
            isDarkMode ? Color(0xff162429) : Color(0xffF7F8F9);
        final Color oddColor =
            isDarkMode ? Color(0xff111C20) : Color(0xffE9ECEE);
        return listTile(
          historyData[index],
          (index % 2 == 0) ? evenColor : oddColor,
        );
      },
      itemCount: historyData.length,
      scrollDirection: Axis.vertical,
    );
  }

  Widget listTile(PBISPlusHistoryModal obj, Color? tileColor) {
    return ListTile(
      horizontalTitleGap: 20,
      tileColor: tileColor,
      leading: Container(
        height: 30,
        width: 30,
        child: SvgPicture.asset(
          "assets/ocr_result_section_bottom_button_icons/${obj.type == "Classroom" ? 'Classroom' : 'Spreadsheet'}.svg",
        ),
      ),
      title: Utility.textWidget(
          text: obj.title ?? '',
          context: context,
          textTheme: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontWeight: FontWeight.bold)),
      subtitle: Row(
        children: [
          Utility.textWidget(
              context: context,
              textTheme: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.grey.shade500),
              text: obj.createdAt!),
          SizedBox(width: 10),
          Container(
            width: 1,
            height: 16,
            color: Colors.grey.shade500,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Utility.textWidget(
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Colors.grey.shade500),
                text: obj.classroomCourse!),
          ),
        ],
      ),
      trailing: Icon(
        PBISPlusIcons.eye1,
        color: AppTheme.kButtonColor,
      ),
      onTap: (() {}),
    );
  }
}
