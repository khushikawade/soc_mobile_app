// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RubricPdfModal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RubricPdfModalAdapter extends TypeAdapter<RubricPdfModal> {
  @override
  final int typeId = 27;

  @override
  RubricPdfModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RubricPdfModal(
      id: fields[0] as String?,
      createdById: fields[1] as String?,
      name: fields[2] as String?,
      lastModifiedById: fields[3] as String?,
      ownerId: fields[4] as String?,
      rubricPdfC: fields[5] as String?,
      subjectC: fields[6] as String?,
      titleC: fields[7] as String?,
      usedInC: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RubricPdfModal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdById)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.lastModifiedById)
      ..writeByte(4)
      ..write(obj.ownerId)
      ..writeByte(5)
      ..write(obj.rubricPdfC)
      ..writeByte(6)
      ..write(obj.subjectC)
      ..writeByte(7)
      ..write(obj.titleC)
      ..writeByte(8)
      ..write(obj.usedInC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RubricPdfModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
