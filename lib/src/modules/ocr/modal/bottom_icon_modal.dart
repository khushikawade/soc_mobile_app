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

  static List<BottomIcon> bottomIconModalList = [
    BottomIcon(
      title: 'Share',
      svgPath: 'assets/images/ocr_result_section_bottom_button_icons/Share.svg',
    ),
    BottomIcon(
      title: 'Drive',
      svgPath: 'assets/images/ocr_result_section_bottom_button_icons/Drive.svg',
    ),
    BottomIcon(
      title: 'History',
      svgPath:
          'assets/images/ocr_result_section_bottom_button_icons/History.svg',
    ),
    BottomIcon(
      title: 'Dashboard',
      svgPath: 'assets/images/ocr_result_section_bottom_button_icons/Share.svg',
    ),
    BottomIcon(
      title: 'Slide',
      svgPath: 'assets/images/ocr_result_section_bottom_button_icons/Slide.svg',
    ),
  ];
}
