class ResultSummaryIcons {
  String? title;
  String? svgPath;

  ResultSummaryIcons({
    required this.title,
    required this.svgPath,
  });

// assessment result summary
  static List<ResultSummaryIcons> resultSummaryIconsModalList = [
    ResultSummaryIcons(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
    ResultSummaryIcons(
      title: 'Sheets',
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

  static List<ResultSummaryIcons> historyResultSummaryIconsModalList = [
    ResultSummaryIcons(
      title: 'Share',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Share.svg',
    ),
    ResultSummaryIcons(
      title: 'Sheets',
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
      title: 'Sheets',
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
    ResultSummaryIcons(
      title: 'Class',
      svgPath: 'assets/ocr_result_section_bottom_button_icons/Classroom.svg',
    ),
    ResultSummaryIcons(
      title: 'Sheets',
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
