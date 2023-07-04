import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

// class PBISPlusActionInteractionModal {
//   String title;
//   Color color;
//   IconData iconData;

//   PBISPlusActionInteractionModal({
//     required this.title,
//     required this.color,
//     required this.iconData,
//   });

//   static List<PBISPlusActionInteractionModal> PBISPlusActionInteractionIcons = [
//     PBISPlusActionInteractionModal(
//       iconData: IconData(0xe87e,
//           fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//       color: Colors.red,
//       title: 'Engaged',
//     ),
//     PBISPlusActionInteractionModal(
//       iconData: IconData(0xe87f,
//           fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//       color: Colors.blue,
//       title: 'Nice Work',
//     ),
//     PBISPlusActionInteractionModal(
//       iconData: IconData(0xe880,
//           fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//       color: Colors.green,
//       title: 'Helpful',
//     ),
//   ];
// }

class PBISPlusActionInteractionModalNew {
  String imagePath;
  String title;
  Color color;
  PBISPlusActionInteractionModalNew({
    required this.imagePath,
    required this.title,
    required this.color,
  });

  static List<PBISPlusActionInteractionModalNew>
      PBISPlusActionInteractionIconsNew = [
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/Engaged.svg",
      title: 'Engaged',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/Helpful.svg",
      title: 'Nice Work',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/nice_work.svg",
      title: 'Helpful',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/participation.svg",
      title: 'Participation',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/collaboration.svg",
      title: 'Collaboration',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/listening.svg",
      title: 'Listening',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/courteous.svg",
      title: 'Courteous',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/responsible.svg",
      title: 'Responsible',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/punctual.svg",
      title: 'Punctual',
      color: Colors.red,
    ),
  ];
}

class PBISPlusSkillsModalLocal {
  String id;
  String activeStatusC;
  String iconUrlC;
  String name;
  String sortOrderC;
  String counter;
  PBISPlusSkillsModalLocal({
    required this.id,
    required this.activeStatusC,
    required this.iconUrlC,
    required this.name,
    required this.sortOrderC,
    required this.counter,
  });

  // static List<PBISPlusGenericBehaviorModal> PBISPlusSkillLocalModallist = [
  //   PBISPlusGenericBehaviorModal(
  //     id: "0",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/Engaged.svg",
  //     name: 'Engaged',
  //     sortOrderC: "0",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  //   PBISPlusGenericBehaviorModal(
  //     id: "1",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/Helpful.svg",
  //     name: 'Nice Work',
  //     sortOrderC: "1",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),

  //   PBISPlusGenericBehaviorModal(
  //     id: "2",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/add_icon.svg",
  //     name: 'Add Skill',
  //     sortOrderC: "2",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  //   PBISPlusGenericBehaviorModal(
  //     id: "3",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/add_icon.svg",
  //     name: 'Add Skill',
  //     sortOrderC: "3",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  //   PBISPlusGenericBehaviorModal(
  //     id: "4",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/add_icon.svg",
  //     name: 'Add Skill',
  //     sortOrderC: "4",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  //   PBISPlusGenericBehaviorModal(
  //     id: "5",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/add_icon.svg",
  //     name: 'Add Skill',
  //     sortOrderC: "5",
  //     counter: 0,
  //     behaviorId: "0",
  // ),

  // PBISPlusSkillsModalLocal(
  //   id: "2",
  //   activeStatusC: "Show",
  //   iconUrlC: "assets/Pbis_plus/nice_work.svg",
  //   name: 'Helpful',
  //   sortOrderC: "2",
  //   counter: 0,
  // ),
  // PBISPlusSkillsModalLocal(
  //   id: "3",
  //   activeStatusC: "Show",
  //   iconUrlC: "assets/Pbis_plus/participation.svg",
  //   name: 'Participation',
  //   sortOrderC: "3",
  //   counter: 0,
  // ),
  // PBISPlusSkillsModalLocal(
  //   id: "4",
  //   activeStatusC: "Show",
  //   iconUrlC: "assets/Pbis_plus/collaboration.svg",
  //   name: 'Collaboration',
  //   sortOrderC: "4",
  //   counter: 0,
  // ),
  // PBISPlusSkillsModalLocal(
  //   id: "5",
  //   activeStatusC: "Show",
  //   iconUrlC: "assets/Pbis_plus/listening.svg",
  //   name: 'Listening',
  //   sortOrderC: "5",
  //   counter: 0,
  // ),
  // ];
  // static List<PBISPlusGenericBehaviorModal> PBISPlusSkillLocalBehaviorlist = [
  //   PBISPlusGenericBehaviorModal(
  //     id: "0",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/Engaged.svg",
  //     name: 'Engaged',
  //     sortOrderC: "0",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  //   PBISPlusGenericBehaviorModal(
  //     id: "1",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/Helpful.svg",
  //     name: 'Nice Work',
  //     sortOrderC: "1",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  //   PBISPlusGenericBehaviorModal(
  //     id: "2",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/nice_work.svg",
  //     name: 'Helpful',
  //     sortOrderC: "2",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  //   PBISPlusGenericBehaviorModal(
  //     id: "3",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/participation.svg",
  //     name: 'Participation',
  //     sortOrderC: "3",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  //   PBISPlusGenericBehaviorModal(
  //     id: "4",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/collaboration.svg",
  //     name: 'Collaboration',
  //     sortOrderC: "4",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  //   PBISPlusGenericBehaviorModal(
  //     id: "5",
  //     activeStatusC: "Show",
  //     iconUrlC: "assets/Pbis_plus/listening.svg",
  //     name: 'Listening',
  //     sortOrderC: "5",
  //     counter: 0,
  //     behaviorId: "0",
  //   ),
  // ];
}

class PBISPlusStudentNotesLocal {
  static List<PBISStudentNotes> notes = [
    PBISStudentNotes(
        date: "25/05/2023",
        id: 123,
        notes:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at nisi lorem. Donec augue eros, molestie a risus quis, consectetur eleifend leo. Cras sit amet nibh tincidunt, pellentesque massa vel, finibus",
        schoolAppC: "1221",
        studentEmail: "ashwin@gmail.com,",
        studentName: "adldl",
        teacherC: "121454",
        time: "10:30 Pm",
        weekday: "Monday")
  ];

  // static List<PBISPlusStudentList> PBISPlusLocalStudentNoteslist = [
  //   PBISPlusStudentList(
  //     names: StudentName(familyName: "Emma Davis"),
  //     iconUrlC: "assets/Pbis_plus/Engaged.svg",
  //     studentId: "123",
  //     notes: notes,
  //   ),
  //   PBISPlusStudentList(
  //     names: StudentName(familyName: "Vicky Jackson"),
  //     iconUrlC: "assets/Pbis_plus/Engaged.svg",
  //   ),
  //   PBISPlusStudentList(
  //     names: StudentName(familyName: "Buttler Damian"),
  //     iconUrlC: "assets/Pbis_plus/Engaged.svg",
  //     notes: notes,
  //   ),
  // ];
}

class PBISPlusDataTableModal {
  String title;
  Color color;
  IconData iconData;
  PBISPlusDataTableModal(
      {required this.title, required this.color, required this.iconData});

  static List<PBISPlusDataTableModal> PBISPlusDataTableHeadingRaw = [
    PBISPlusDataTableModal(
        iconData: IconData(0xe87e,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.transparent,
        title: 'Date'),
    PBISPlusDataTableModal(
        iconData: IconData(0xe87e,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.red,
        title: 'Engaged'),
    PBISPlusDataTableModal(
        iconData: IconData(0xe87f,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.blue,
        title: 'Nice Work'),
    PBISPlusDataTableModal(
        iconData: IconData(0xe880,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.green,
        title: 'Helpful'),
    PBISPlusDataTableModal(
        iconData: IconData(0xe880,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.transparent,
        title: 'Total')
  ];
}

class PBISPlusDataTableModalNew {
  String imagePath;
  Color color;
  String title;
  PBISPlusDataTableModalNew(
      {required this.imagePath, required this.color, required this.title});

  static List<PBISPlusDataTableModalNew> PBISPlusDataTableHeadingRawNew = [
    PBISPlusDataTableModalNew(
        imagePath: "", color: Colors.transparent, title: 'Date'),
    PBISPlusDataTableModalNew(
      imagePath: "assets/Pbis_plus/Engaged.svg",
      title: 'Engaged',
      color: Colors.red,
    ),
    PBISPlusDataTableModalNew(
      imagePath: "assets/Pbis_plus/Helpful.svg",
      title: 'Nice Work',
      color: Colors.red,
    ),
    PBISPlusDataTableModalNew(
      imagePath: "assets/Pbis_plus/nice_work.svg",
      title: 'Helpful',
      color: Colors.red,
    ),
    PBISPlusDataTableModalNew(
      imagePath: "assets/Pbis_plus/participation.svg",
      title: 'Participation',
      color: Colors.red,
    ),
    PBISPlusDataTableModalNew(
      imagePath: "assets/Pbis_plus/collaboration.svg",
      title: 'Collaboration',
      color: Colors.red,
    ),
    PBISPlusDataTableModalNew(
      imagePath: "assets/Pbis_plus/listening.svg",
      title: 'Listening',
      color: Colors.red,
    ),
    PBISPlusDataTableModalNew(
        imagePath: "", color: Colors.transparent, title: 'Total')
  ];
}
