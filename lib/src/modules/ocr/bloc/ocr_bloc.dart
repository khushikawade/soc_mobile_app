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
      yield OcrLoading();
      await fatchTextFromImage();
      try {} catch (e) {}
    }
  }

  Future fatchTextFromImage() async {
    try {
      final ResponseModel response = await _dbServices.postapi(
        Uri.encodeFull(
            'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyA309Qitrqstm3l207XVUQ0Yw5K_qgozag'),
        isGoogleApi: true,
        body: {
          "requests": [
            {
              "image": {
                "source": {
                  "imageUri":
                      "https://www.mockofun.com/wp-content/uploads/2020/03/text-to-picture-generator.jpg"
                }
              },
              "features": [
                {"type": "DOCUMENT_TEXT_DETECTION"}
              ]
            }
          ]
        },

        // headers: {
        //   'Content-Type': 'application/json',
        //   'authorization': 'Bearer AIzaSyA309Qitrqstm3l207XVUQ0Yw5K_qgozag'
        // }
      );

      if (response.statusCode == 200) {
        List<Response> _list = response.data['responses']
            .map<Response>((i) => Response.fromJson(i))
            .toList();

        print(_list);
        print(
            '------------------------------------test-----------------------------------');
        // _list.removeWhere((CustomSetting element) => element.status == 'Hide');
        // _list.sort((a, b) => a.sortOrderC!.compareTo(b.sortOrderC!));
        // if (_list.length > 6) {
        //   _list.removeRange(6, _list.length);
        // }
        // Globals.customSetting = _list;
        // // To take the backup for all the sections.
        // _backupAppData();
        // return _list;
      }
    } catch (e) {
      print(
          '------------------------------------test-----------------------------------');
      print(e);
    }
  }
}
