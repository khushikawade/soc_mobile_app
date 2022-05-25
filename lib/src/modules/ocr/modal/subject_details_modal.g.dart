// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_details_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectDetailListAdapter extends TypeAdapter<SubjectDetailList> {
  @override
  final int typeId = 19;

  @override
  SubjectDetailList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectDetailList(
      descriptionC: fields[0] as String?,
      lastModifiedById: fields[1] as String?,
      ownerId: fields[2] as String?,
      name: fields[3] as String?,
      domainCodeC: fields[4] as String?,
      subjectC: fields[5] as String?,
      titleC: fields[6] as String?,
      id: fields[7] as String?,
      gradeC: fields[8] as String?,
      domainNameC: fields[9] as String?,
      subDomainC: fields[10] as String?,
      subSubDomainC: fields[11] as String?,
      standardAndDescriptionC: fields[12] as String?,
      subjectNameC: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectDetailList obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.descriptionC)
      ..writeByte(1)
      ..write(obj.lastModifiedById)
      ..writeByte(2)
      ..write(obj.ownerId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.domainCodeC)
      ..writeByte(5)
      ..write(obj.subjectC)
      ..writeByte(6)
      ..write(obj.titleC)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.gradeC)
      ..writeByte(9)
      ..write(obj.domainNameC)
      ..writeByte(10)
      ..write(obj.subDomainC)
      ..writeByte(11)
      ..write(obj.subSubDomainC)
      ..writeByte(12)
      ..write(obj.standardAndDescriptionC)
      ..writeByte(13)
      ..write(obj.subjectNameC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectDetailListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
