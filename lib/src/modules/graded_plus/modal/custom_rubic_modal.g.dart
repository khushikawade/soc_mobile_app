// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_rubic_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomRubricModalAdapter extends TypeAdapter<CustomRubricModal> {
  @override
  final int typeId = 20;

  @override
  CustomRubricModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomRubricModal(
      name: fields[0] as String?,
      score: fields[1] as String?,
      imgBase64: fields[2] as String?,
      imgUrl: fields[3] as String?,
      customOrStandardRubic: fields[4] as String?,
      filePath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomRubricModal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.imgBase64)
      ..writeByte(3)
      ..write(obj.imgUrl)
      ..writeByte(4)
      ..write(obj.customOrStandardRubic)
      ..writeByte(5)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomRubricModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
