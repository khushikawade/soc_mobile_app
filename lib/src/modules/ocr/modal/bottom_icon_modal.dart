class BottomIcon {
  String? title;
  String? svgPath;

  BottomIcon({
    required this.title,
    required this.svgPath,
  });

  // static List ocrResultIcons = Overrides.STANDALONE_GRADED_APP == true
  //     ? [0xe873, 0xe871, 0xe803, 0xe876]
  //     : [0xe876, 0xe871, 0xe873, 0xe87a, 0xe80d];

  // static List ocrResultIconsName = Overrides.STANDALONE_GRADED_APP == true
  //     ? ["History", "Drive", "Sheet", "Share"]
  //     : ["Share", "Drive", "History", "Dashboard", "Slide"];

// assessment result summary
  static List<BottomIcon> bottomIconModalList = [
    BottomIcon(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
    // BottomIcon(
    //   title: 'Drive',
    //   svgPath: 'assets/ocr_result_section_bottom_button_icons/Drive.svg',
    // ),
    BottomIcon(
      title: 'Sheet',
      svgPath: 'assets/images/google_sheet.svg',
    ),
    BottomIcon(
      title: 'Slides',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Slide.svg',
    ),
    BottomIcon(
      title: 'History',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/History.svg',
    ),
    BottomIcon(
      title: 'Dashboard',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Dashboard.svg',
    ),
  ];

  static List<BottomIcon> historybottomIconModalList = [
    BottomIcon(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
    // BottomIcon(
    //   title: 'Drive',
    //   svgPath: 'assets/ocr_result_section_bottom_button_icons/Drive.svg',
    // ),
    BottomIcon(
      title: 'Sheet',
      svgPath: 'assets/images/google_sheet.svg',
    ),
    BottomIcon(
      title: 'Slides',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Slide.svg',
    ),
    BottomIcon(
      title: 'Dashboard',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Dashboard.svg',
    ),
  ];

//result summary screen action buttons
  static List<BottomIcon> standAloneBottomIconModalList = [
    BottomIcon(
      title: 'History',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/History.svg',
    ),
    BottomIcon(
      title: 'Drive',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Drive.svg',
    ),
    BottomIcon(
      title: 'Sheet',
      svgPath: 'assets/images/google_sheet.svg',
    ),
    BottomIcon(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
  ];

  static List<BottomIcon> standAloneHistoryBottomIconModalList = [
    BottomIcon(
      title: 'Drive',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Drive.svg',
    ),
    BottomIcon(
      title: 'Sheet',
      svgPath: 'assets/images/google_sheet.svg',
    ),
    BottomIcon(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
  ];
}
