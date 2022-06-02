// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_rubic_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomRubicModalAdapter extends TypeAdapter<CustomRubicModal> {
  @override
  final int typeId = 20;

  @override
  CustomRubicModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomRubicModal(
      name: fields[0] as String?,
      score: fields[1] as String?,
      imgBase64: fields[2] as String?,
      imgUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomRubicModal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.imgBase64)
      ..writeByte(3)
      ..write(obj.imgUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomRubicModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
