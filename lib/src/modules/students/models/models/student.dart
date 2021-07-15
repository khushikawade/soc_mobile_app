import 'records.dart';

class Student {
  int? totalSize;
  bool? done;
  List<Records>? records;

  Student({this.totalSize, this.done, this.records});

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        totalSize: json['totalSize'] as int?,
        done: json['done'] as bool?,
        records: (json['records'] as List<dynamic>?)
            ?.map((e) => Records.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'totalSize': totalSize,
        'done': done,
        'records': records?.map((e) => e.toJson()).toList(),
      };
}
