import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/services/user_profile.dart';

class PlusUtility {
  static updateUserLogsSessionId() async {
    int myTimeStamp = DateTime.now().microsecondsSinceEpoch; //To TimeStamp

    List<UserInformation> _userProfileLocalData =
        await UserGoogleProfile.getUserProfile();

    Globals.teacherEmailId = _userProfileLocalData[0].userEmail!.split('@')[0];
    Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
  }

  static bool updateLogs(
      {required String activityId,
      //  required String accountType,
      required String description,
      required String operationResult,
      String? sessionId,
      required String? activityType}) {
    DateTime currentDateTime = DateTime.now(); //DateTime
    // instance for maintaining logs
    final OcrBloc _ocrBlocLogs = new OcrBloc();
    _ocrBlocLogs.add(LogUserActivityEvent(
        activityType: activityType,
        sessionId: sessionId != null && sessionId != ''
            ? sessionId
            : Globals.sessionId,
        teacherId: Globals.teacherId,
        activityId: activityId,
        accountId: Globals.appSetting.schoolNameC,
        accountType: 'Premium',
        //Globals.isPremiumUser == true ? "Premium" : "Free",
        dateTime: currentDateTime.toString(),
        description: description,
        operationResult: operationResult));
    return true;
  }
}
