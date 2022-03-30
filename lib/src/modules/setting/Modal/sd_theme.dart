import 'package:hive/hive.dart';
part 'sd_theme.g.dart';

@HiveType(typeId: 7)
class Theme {
  @HiveField(0)
  int? hiveobjid;
  @HiveField(1)
  String? themeType;

  Theme(
    this.hiveobjid,
    this.themeType,
  );
}
