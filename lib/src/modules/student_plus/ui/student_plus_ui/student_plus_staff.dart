import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_bottomnavbar.dart';
import 'package:flutter/material.dart';

class StudentPlusStaffScreen extends StatefulWidget {
  const StudentPlusStaffScreen({Key? key}) : super(key: key);

  @override
  State<StudentPlusStaffScreen> createState() => _StudentPlusStaffScreenState();
}

class _StudentPlusStaffScreenState extends State<StudentPlusStaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: StudentPlusAppBar(
            sectionType: "Staff",
            titleIconCode: int.parse(
                StudentPlusBottomNavBar.getIconCode(sectionType: "Staff")),
            refresh: (v) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
