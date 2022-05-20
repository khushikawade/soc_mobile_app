import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class GoogleDriveAccess {

  //TODO : Do not use syncfusion
static Future file() async {
    List<String> name = ['nikhar', 'rupesh', 'rajesh'];

    // Create a new Excel document.
    final Workbook workbook = new Workbook();
    //Accessing worksheet via index.
    Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText("Hello doc");
    // Save the document.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the workbook.
    workbook.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    File file = File(fileName);
    return file;
  }
}