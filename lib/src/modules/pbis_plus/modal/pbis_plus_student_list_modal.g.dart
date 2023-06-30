// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_student_list_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusStudentListAdapter extends TypeAdapter<PBISPlusStudentList> {
  @override
  final int typeId = 45;

  @override
  PBISPlusStudentList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusStudentList(
      studentId: fields[0] as String?,
      names: fields[1] as StudentName?,
      iconUrlC: fields[2] as String?,
      notes: fields[3] as PBISStudentNotes?,
      email: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusStudentList obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.names)
      ..writeByte(2)
      ..write(obj.iconUrlC)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusStudentListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudentNameAdapter extends TypeAdapter<StudentName> {
  @override
  final int typeId = 49;

  @override
  StudentName read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentName(
      givenName: fields[0] as String?,
      familyName: fields[1] as String?,
      fullName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentName obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.givenName)
      ..writeByte(1)
      ..write(obj.familyName)
      ..writeByte(2)
      ..write(obj.fullName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PBISStudentNotesAdapter extends TypeAdapter<PBISStudentNotes> {
  @override
  final int typeId = 50;

  @override
  PBISStudentNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISStudentNotes(
      id: fields[0] as int?,
      studentName: fields[1] as String?,
      studentEmail: fields[2] as String?,
      teacherC: fields[3] as String?,
      schoolAppC: fields[4] as String?,
      notes: fields[5] as String?,
      date: fields[6] as String?,
      time: fields[7] as String?,
      weekday: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PBISStudentNotes obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentName)
      ..writeByte(2)
      ..write(obj.studentEmail)
      ..writeByte(3)
      ..write(obj.teacherC)
      ..writeByte(4)
      ..write(obj.schoolAppC)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.time)
      ..writeByte(8)
      ..write(obj.weekday);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISStudentNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
