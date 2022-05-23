import 'package:googleapis/monitoring/v3.dart';

class ExcelSheet {
  const ExcelSheet(
    this.id,
    this.name,
    this.pointsEarned,
    this.pointsPossible,
  );
  final String id;
  final String name;
  final String pointsEarned;
  final String pointsPossible;
}
