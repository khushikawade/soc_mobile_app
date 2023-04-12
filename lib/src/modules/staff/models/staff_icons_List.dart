class StaffIconsList {
  String iconUrl;
  String iconName;
  StaffIconsList({
    required this.iconUrl,
    required this.iconName,
  });
// A (B5FFC5)
// B (FCD1CB)
// C (E6E4F9)
// D (FEE8D0)
// E (EBD2FF)
// F (B5E0FF) Optional
  static List<StaffIconsList> staffIconsList = [
    StaffIconsList(
        iconUrl: 'assets/images/landingPage_image.png', iconName: 'GRADED+'),
    StaffIconsList(iconUrl: 'assets/images/pbis+.png', iconName: 'PBIS+'),
    StaffIconsList(iconUrl: 'assets/images/student+.png', iconName: 'STUDENT+'),

    //AnswerKeyModal(title: 'F', color: Color(0xffB5E0FF)) //Optional
  ];
}
