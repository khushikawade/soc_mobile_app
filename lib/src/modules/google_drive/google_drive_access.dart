import 'dart:io';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class GoogleDriveAccess {
  static Future createSheet(
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
}
