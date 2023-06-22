// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_student_notes_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusStudentNotesAdapter extends TypeAdapter<PBISPlusStudentNotes> {
  @override
  final int typeId = 45;

  @override
  PBISPlusStudentNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusStudentNotes(
      studentName: fields[0] as String?,
      iconUrlC: fields[1] as String?,
      notesComments: fields[2] as String?,
      date: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusStudentNotes obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.studentName)
      ..writeByte(1)
      ..write(obj.iconUrlC)
      ..writeByte(2)
      ..write(obj.notesComments)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusStudentNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
