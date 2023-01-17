import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/services/utility.dart';

class SubjectSelectionAPIAndMethods {
  static GoogleDriveBloc _googleDriveBloc = GoogleDriveBloc();
  static OcrBloc _ocrBloc = OcrBloc();

  static Future<void> googleSlidesPreparation() async {
    if (Globals.googleSlidePresentationLink!.isEmpty) {
      _googleDriveBloc.add(GetShareLink(
          fileId: Globals.googleSlidePresentationId, slideLink: true));
    }
  }
}
