import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:uuid/uuid.dart';

class PlusUtility {
/*------------------------------------------------------------------------------------------------*/
/*------------------------------------updateUserLogsSessionId-------------------------------------*/
/*------------------------------------------------------------------------------------------------*/

  static updateUserLogsSessionId() async {
    int myTimeStamp = DateTime.now().microsecondsSinceEpoch; //To TimeStamp
    //----------------------------------------------------
    Uuid uuid = Uuid();
    String generatedUuid = uuid.v5(Uuid.NAMESPACE_URL,
        "${Globals.teacherEmailId}_${myTimeStamp.toString()}");
    //----------------------------------------------------
    Globals.sessionId = generatedUuid;
  }

/*------------------------------------------------------------------------------------------------*/
/*------------------------------------------updateLogs--------------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static bool updateLogs(
      {required String activityId,
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

/*------------------------------------------------------------------------------------------------*/
/*------------------------------------sdhfirgoirhgoreghreighr-------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
}
