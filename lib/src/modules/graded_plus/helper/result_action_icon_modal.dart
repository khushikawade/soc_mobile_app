class ResultSummaryIcons {
  String? title;
  String? svgPath;

  ResultSummaryIcons({
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
  static List<ResultSummaryIcons> resultSummaryIconsModalList = [
    ResultSummaryIcons(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
    // ResultSummaryIcons(
    //   title: 'Drive',
    //   svgPath: 'assets/ocr_result_section_bottom_button_icons/Drive.svg',
    // ),
    ResultSummaryIcons(
      title: 'Sheet',
      svgPath: 'assets/images/google_sheet.svg',
    ),
    ResultSummaryIcons(
      title: 'Slides',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Slide.svg',
    ),
    // ResultSummaryIcons(
    //   title: 'History',
    //   svgPath: 'assets/ocr_result_section_bottom_button_icons/History.svg',
    // ),
    ResultSummaryIcons(
      title: 'Dashboard',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Dashboard.svg',
    ),
  ];

  static List<ResultSummaryIcons> historyResultSummaryIconsModalList = [
    ResultSummaryIcons(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
    // ResultSummaryIcons(
    //   title: 'Drive',
    //   svgPath: 'assets/ocr_result_section_bottom_button_icons/Drive.svg',
    // ),
    ResultSummaryIcons(
      title: 'Sheet',
      svgPath: 'assets/images/google_sheet.svg',
    ),
    ResultSummaryIcons(
      title: 'Slides',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Slide.svg',
    ),
    ResultSummaryIcons(
      title: 'Dashboard',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Dashboard.svg',
    ),
  ];

//result summary screen action buttons
  static List<ResultSummaryIcons> standAloneResultSummaryIconsModalList = [
    // ResultSummaryIcons(
    //   title: 'History',
    //   svgPath: 'assets/ocr_result_section_bottom_button_icons/History.svg',
    // ),
    // ResultSummaryIcons(
    //   title: 'Drive',
    //   svgPath: 'assets/ocr_result_section_bottom_button_icons/Drive.svg',
    // ),
    ResultSummaryIcons(
      title: 'Class',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Classroom.svg',
    ),
    ResultSummaryIcons(
      title: 'Sheet',
      svgPath: 'assets/images/google_sheet.svg',
    ),
    ResultSummaryIcons(
      title: 'Slides',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Slide.svg',
    ),
    ResultSummaryIcons(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
  ];

  static List<ResultSummaryIcons> standAloneHistoryResultSummaryIconsModalList =
      [
    // ResultSummaryIcons(
    //   title: 'Drive',
    //   svgPath: 'assets/ocr_result_section_bottom_button_icons/Drive.svg',
    // ),
    ResultSummaryIcons(
      title: 'Class',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Classroom.svg',
    ),
    ResultSummaryIcons(
      title: 'Sheet',
      svgPath: 'assets/images/google_sheet.svg',
    ),
    ResultSummaryIcons(
      title: 'Slides',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Slide.svg',
    ),
    ResultSummaryIcons(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
  ];
}
