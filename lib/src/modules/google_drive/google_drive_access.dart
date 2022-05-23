import 'dart:io';
import 'package:Soc/src/modules/google_drive/model/sheet.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class GoogleDriveAccess {
  static Future createSheet(
      {required List<ExcelSheet> data, required String name}) async {
    try {
      var excel = Excel.createExcel();
      final sheet = excel[excel.getDefaultSheet()!];
      print(data);
      for (int row = 0; row < data.length; row++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = data[row].id;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = data[row].name;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = data[row].pointsEarned;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = data[row].pointsPossible;
      }
      // sheet.updateCell(CellIndex.indexByColumnRow(rowIndex: 0), cellStyle);

      var fileBytes = excel.save();

      var directory = (await getApplicationDocumentsDirectory()).path;
      File file = File("$directory/name.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
      // });
      // }
      return file;
    } catch (e) {
      print(e);
    }
  }
}
