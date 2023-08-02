import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:uuid/uuid.dart';

class PlusUtility {
/*------------------------------------------------------------------------------------------------*/
/*------------------------------------updateUserLogsSessionId-------------------------------------*/
/*------------------------------------------------------------------------------------------------*/

  static updateUserLogsSessionId() async {
    String timeStamp = DateTime.now().microsecondsSinceEpoch.toString();
    //----------------------------------------------------
    Uuid uuid = Uuid();
    String generatedUuid =
        await uuid.v5(Uuid.NAMESPACE_URL, Globals.userEmailId + timeStamp);
    //----------------------------------------------------
    print('generatedUuid::::: $generatedUuid');
    return generatedUuid;
  }

/*------------------------------------------------------------------------------------------------*/
/*------------------------------------------updateLogs--------------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Future<bool> updateLogs(
      {required String activityId,
      required String description,
      required String operationResult,
      String? sessionId,
      required String? activityType,
      required String? userType}) async {
    DateTime currentDateTime = DateTime.now(); //DateTime

    // instance for maintaining logs
    final OcrBloc _ocrBlocLogs = new OcrBloc();

    _ocrBlocLogs.add(LogUserActivityEvent(
        activityType: activityType,
        userType: userType,
        email: Globals.userEmailId,
        sessionId: sessionId != null && sessionId != ''
            ? sessionId
            : Globals.sessionId,
        teacherId: await OcrUtility.getTeacherId() ?? '', //contact Id
        activityId: activityId,
        accountId: Globals.appSetting.schoolNameC,
        accountType: 'Free',
        dateTime: currentDateTime.toString(),
        description: description,
        operationResult: operationResult));

    return true;
  }
}
