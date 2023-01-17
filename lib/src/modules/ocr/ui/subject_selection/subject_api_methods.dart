import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/services/utility.dart';

class SubjectSelectionAPIAndMethods {
  static GoogleDriveBloc _googleDriveBloc = GoogleDriveBloc();
  static OcrBloc _ocrBloc = OcrBloc();

  static void updateDocOnDrive(
    bool? isMCQSheet,
    String? questionImageURL,
  ) async {
    _googleDriveBloc.add(
      UpdateDocOnDrive(
          isMcqSheet: isMCQSheet ?? false,
          questionImage:
              questionImageURL == '' ? 'NA' : questionImageURL ?? 'NA',
          createdAsPremium: Globals.isPremiumUser,
          assessmentName: Globals.assessmentName,
          fileId: Globals.googleExcelSheetId,
          isLoading: true,
          studentData:
              await Utility.getStudentInfoList(tableName: 'student_info')
          //list2
          //Globals.studentInfo!
          ),
    );
  }

  static Future<void> googleSlidesPreparation() async {
    if (Globals.googleSlidePresentationLink!.isEmpty) {
      _googleDriveBloc.add(GetShareLink(
          fileId: Globals.googleSlidePresentationId, slideLink: true));
    }
  }

  static fetchSubjectDetails(
      String? type,
      String? grade,
      String? selectedKeyword,
      String? stateName,
      String? subjectSelected,
      String? subjectId) {
    _ocrBloc.add(FetchSubjectDetails(
        type: type,
        grade: grade,
        // empty because no subject selected yet
        subjectId: subjectId,
        subjectSelected: subjectSelected,
        selectedKeyword: selectedKeyword,
        stateName: stateName));
  }
}
