import 'package:Soc/src/modules/ocr/modal/ocr_modal.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'ocr_event.dart';
part 'ocr_state.dart';

class OcrBloc extends Bloc<OcrEvent, OcrState> {
  OcrBloc() : super(OcrInitial());
  final DbServices _dbServices = DbServices();
  // final HiveDbServices _localDbService = HiveDbServices();
  OcrState get initialState => OcrInitial();

  @override
  Stream<OcrState> mapEventToState(
    OcrEvent event,
  ) async* {
    if (event is FetchTextFromImage) {
      String? schoolIdNew;
      String? grade;
      yield OcrLoading();
      List data = await fatchDetails(base64: event.base64);
      for (var i = 0; i < data.length; i++) {
        if (data[i]['description'].toString().length == 9) {
          schoolIdNew = data[i]['description'];
        }
      }
      grade = data[data.length - 1]['description'];
      print(data);
      yield FetchTextFromImageSuccess(schoolId: schoolIdNew ?? '', grade: grade ?? '');
      try {} catch (e) {}
    }
  }

  Future fatchDetails({required String base64}) async {
    try {
      final ResponseModel response = await _dbServices.postapi(
          Uri.encodeFull('https://1e71-111-118-246-106.in.ngrok.io'),
          body: {'data': '$base64'},
          isGoogleApi: true

          // headers: {
          //   'Content-Type': 'application/json',
          //   'authorization': 'Bearer AIzaSyA309Qitrqstm3l207XVUQ0Yw5K_qgozag'
          // }
          );

      if (response.statusCode == 200) {
        // List<FullTextAnnotation> _list = response.data['text']['responses'][0]
        //     .map<FullTextAnnotation>((i) => FullTextAnnotation.fromJson(i))
        //     .toList();

        print(response.data['text']['responses'][0]['textAnnotations']);
        print(
            '------------------------------------test111111-----------------------------------');
        List text = response.data['text']['responses'][0]['textAnnotations'];

        // _list.removeWhere((CustomSetting element) => element.status == 'Hide');
        // _list.sort((a, b) => a.sortOrderC!.compareTo(b.sortOrderC!));
        // if (_list.length > 6) {
        //   _list.removeRange(6, _list.length);
        // }
        // Globals.customSetting = _list;
        // // To take the backup for all the sections.
        // _backupAppData();
        // return _list;
        return text;
      }
    } catch (e) {
      print(
          '------------------------------------test-----------------------------------');
      print(e);
    }
  }
}
