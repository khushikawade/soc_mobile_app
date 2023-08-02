// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_google_presentation_detail_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentGooglePresentationDetailModalAdapter
    extends TypeAdapter<StudentGooglePresentationDetailModal> {
  @override
  final int typeId = 57;

  @override
  StudentGooglePresentationDetailModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentGooglePresentationDetailModal(
      id: fields[0] as int?,
      studentC: fields[1] as String?,
      teacherC: fields[2] as String?,
      title: fields[3] as String?,
      dBNC: fields[4] as String?,
      schoolAppC: fields[5] as String?,
      googlePresentationId: fields[6] as String?,
      googlePresentationURL: fields[7] as String?,
      createdAt: fields[8] as String?,
      updatedAt: fields[9] as String?,
      studentRecordId: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentGooglePresentationDetailModal obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentC)
      ..writeByte(2)
      ..write(obj.teacherC)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.dBNC)
      ..writeByte(5)
      ..write(obj.schoolAppC)
      ..writeByte(6)
      ..write(obj.googlePresentationId)
      ..writeByte(7)
      ..write(obj.googlePresentationURL)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.studentRecordId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentGooglePresentationDetailModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
