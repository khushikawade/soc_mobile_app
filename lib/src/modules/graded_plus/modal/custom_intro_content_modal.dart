import 'package:Soc/src/overrides.dart';

class GradedIntroContentModal {
  String? title;
  String? msgBody;
  String? imgURL;
  GradedIntroContentModal(
      {required this.title, required this.msgBody, required this.imgURL});

  static List<GradedIntroContentModal> onboardingPagesList = [
    GradedIntroContentModal(
        title: 'STEP 1',
        msgBody:
            'Assign students a one-question Assignment and have them complete it on any paper handout (blank, notebook, graph, etc.).',
        imgURL: 'assets/images/onboarding_image1.jpg'),
    GradedIntroContentModal(
        title: 'STEP 2',
        msgBody: Overrides.STANDALONE_GRADED_APP == true
            ? 'Ensure students write their name and Google Classroom email anywhere on the Assignment paper handout. '
            : 'Ensure students write their name and 9-digit NYCDOE student Id number anywhere on the Assignment paper handout. ',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image2_individual.png'
            : 'assets/images/onboarding_image2.png'),
    GradedIntroContentModal(
        title: 'STEP 3',
        msgBody:
            'Grade student’s work directly on their paper handout using the selected rubric scale. Be sure to circle the score directly on the student work.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image3_individual.png'
            : 'assets/images/onboarding_image3.png'),
    GradedIntroContentModal(
        title: 'STEP 4',
        msgBody:
            'Use the GRADED+ "Scan Assignment" feature to take a picture of each student\'s paper. Scans are saved to the Cloud, not your local device.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image4_individual.png'
            : 'assets/images/onboarding_image4.png'),
    GradedIntroContentModal(
        title: 'STEP 5',
        msgBody: Overrides.STANDALONE_GRADED_APP == true
            ? 'The GRADED+ image recognition auto captures the student email ID, name, and your circled score. Results and image scans are automatically saved in your Google Classroom and Google Drive.'
            : 'The GRADED+ image recognition auto captures the student Id, name and your circled score. Results and image scans are automatically saved in your Google Drive in a Google Sheet.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image5_individual.png'
            : 'assets/images/onboarding_image5.png')
  ];

  static List<GradedIntroContentModal> onBoardingMainPagesInfoList = [
    GradedIntroContentModal(
        title: 'STEP 1',
        msgBody:
            'Assign students a one-question assignment and have them complete it on any paper handout (blank, notebook, graph, etc.).',
        imgURL: 'assets/images/onboarding_image1.jpg'),
    GradedIntroContentModal(
        title: 'STEP 2',
        msgBody:
            'Ensure students write their name and 9-digit NYCDOE Student ID number or email address anywhere on the assignment paper handout.',
        imgURL: 'assets/images/graded_plus_intro_step2_img.png'),
  ];

  static List<GradedIntroContentModal> onBoardingConstrutedResponseIndoList = [
    GradedIntroContentModal(
        title: 'STEP 3',
        msgBody:
            'Grade student’s work directly on their paper handout using the selected rubric scale. Be sure to circle the score directly on the student work.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image3_individual.png'
            : 'assets/images/graded_plus_intro_cr_step3_img.png'),
    GradedIntroContentModal(
        title: 'STEP 4',
        msgBody:
            'Use the GRADED+ Scan Assignment feature to take a picture of each student’s paper. Scans are saved in the Cloud, not your local device.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image4_individual.png'
            : 'assets/images/onboarding_image4.png'),
    GradedIntroContentModal(
        title: 'STEP 5',
        msgBody: Overrides.STANDALONE_GRADED_APP == true
            ? 'The GRADED+ image recognition auto captures the student email ID, name, and your circled score. Results and image scans are automatically saved in your Google Classroom and Google Drive.'
            : 'The GRADED+ image recognition auto captures the student ID or email, name, and your circled score. Results and image scans are automatically saved in your Google Drive.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image5_individual.png'
            : 'assets/images/onboarding_image5.png')
  ];
  static List<GradedIntroContentModal> onBoardingMultipleChoiceIndoList = [
    GradedIntroContentModal(
        title: 'STEP 3',
        msgBody:
            'Log into GRADED+, select Scan, and choose the correct multiple choice answer for your assignment.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image3_individual.png'
            : 'assets/images/graded_plus_intro_mcq_step3_img.png'),
    GradedIntroContentModal(
        title: 'STEP 4',
        msgBody:
            'Use the GRADED+ Scan Assignment feature to take a picture of each student’s paper. Scans are saved in the Cloud, not your local device.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image4_individual.png'
            : 'assets/images/onboarding_image4.png'),
    GradedIntroContentModal(
        title: 'STEP 5',
        msgBody: Overrides.STANDALONE_GRADED_APP == true
            ? 'The GRADED+ image recognition auto captures the student email ID, name, and your circled score. Results and image scans are automatically saved in your Google Classroom and Google Drive.'
            : 'The GRADED+ image recognition auto captures the student ID or email, name, and student selected answer choice. Results and image scans are automatically saved in your Google Drive.',
        imgURL: Overrides.STANDALONE_GRADED_APP == true
            ? 'assets/images/onboarding_image5_individual.png'
            : 'assets/images/onboarding_image5.png')
  ];
}
