import 'package:Soc/src/overrides.dart';

class CustomContentModal {
  String? title;
  String? msgBody;
  String? imgURL;
  CustomContentModal(
      {required this.title, required this.msgBody, required this.imgURL});

  static List<CustomContentModal> onboardingPagesList = [
    CustomContentModal(
        title: 'STEP 1',
        msgBody:
            'Assign students a one-question Assignment and have them complete it on any paper handout (blank, notebook, graph, etc.).',
        imgURL: 'assets/images/onboarding_image1.jpg'),
    CustomContentModal(
        title: 'STEP 2',
        msgBody: Overrides.STANDALONE_GRADED_APP == true
            ? 'Ensure students write their name and google classroom email id anywhere on the Assignment paper handout. '
            : 'Ensure students write their name and 9-digit NYCDOE student ID number anywhere on the Assignment paper handout. ',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image2_individual.png'
            : 'assets/images/onboarding_image2.png'),
    CustomContentModal(
        title: 'STEP 3',
        msgBody:
            'Grade student’s work directly on their paper handout using the selected rubric scale. Be sure to circle the score directly on the student work.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image3_individual.png'
            : 'assets/images/onboarding_image3.png'),
    CustomContentModal(
        title: 'STEP 4',
        msgBody:
            'Use the GRADED+ "Scan Assignment" feature to take a picture of each student\'s paper. Scans are saved to the Cloud, not your local device.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image4_individual.png'
            : 'assets/images/onboarding_image4.png'),
    CustomContentModal(
        title: 'STEP 5',
        msgBody: Overrides.STANDALONE_GRADED_APP == true
            ? 'The GRADED+ image recognition software auto captures the student email ID, name and your circled score. Results and image scans are automatically saved in your Google Drive in a Google Sheet.'
            : 'The GRADED+ image recognition software auto captures the student ID, name and your circled score. Results and image scans are automatically saved in your Google Drive in a Google Sheet.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image5_individual.png'
            : 'assets/images/onboarding_image5.png')
  ];
}