import 'dart:io';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class GoogleDriveAccess {
  static Future generateExcelSheetLocally(
      {required List<StudentAssessmentInfo> data, required String name}) async {
    try {
      var excel = Excel.createExcel();
      final sheet = excel[excel.getDefaultSheet()!];
      print(data);
      for (int row = 0; row < data.length; row++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = data[row].studentId;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = data[row].studentName;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = data[row].studentGrade;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = data[row].pointpossible;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = data[row].grade;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
            .value = data[row].className;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
            .value = data[row].className;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
            .value = data[row].subject;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
            .value = data[row].learningStandard;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row))
            .value = data[row].subLearningStandard;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: row))
            .value = data[row].scoringRubric;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: row))
            .value = data[row].customRubricImage;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: row))
            .value = data[row].assessmentImage;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: row))
            .value = data[row].questionImgUrl;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: row))
            .value = data[row].isSavedOnDashBoard;

        // if (data[row].subject == "Math" || data[row].subject == "ELA") {
        //         sheet
        //             .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
        //             .value = data[row].learningStandard;
        //         sheet
        //             .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
        //             .value = data[row].subLearningStandard;
        //       }

      }
      // sheet.updateCell(CellIndex.indexByColumnRow(rowIndex: 0), cellStyle);

      var fileBytes = excel.save();

      var directory = (await getApplicationDocumentsDirectory()).path;
      File file = File("$directory/name.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
      // });
      // }
      print("Excel file done");
      return file;
    } catch (e) {
      print(e);
    }
  }

  static Future excelToJson(String file) async {
    var bytes =  File(file).readAsBytesSync();
    var excel =  Excel.decodeBytes(bytes);
    print(excel);
    int i = 0;
    List<dynamic> keys = <dynamic>[];
    List<Map<String, dynamic>> json = <Map<String, dynamic>>[];
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]?.rows ?? []) {
        if (i == 0) {
          keys = row;
          i++;
        } else {
          Map<String, dynamic> temp = Map<String, dynamic>();
          int j = 0;
          String tk = '';
          for (var key in keys) {
            tk = key.value;
            temp[tk] = row[j].runtimeType != null
                ? (row[j].runtimeType == String)
                    ? "\u201C" + row[j] != null
                        ? row[j].value
                        : '' + "\u201D"
                    : row[j] != null
                        ? row[j].value
                        : ''
                : '';
            j++;
          }
          json.add(temp);
        }
      }
    }
    List<StudentAssessmentInfo> _list = json
        .map<StudentAssessmentInfo>((i) => StudentAssessmentInfo.fromJson(i))
        .toList();

    return _list;
  }

  static Future<bool> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        return true;
      }
    } catch (e) {
      print(e);
      throw (e);
      // Error in getting access to the file.
    }
    return false;
  }
}
