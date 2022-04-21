// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sd_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SDlistAdapter extends TypeAdapter<SDlist> {
  @override
  final int typeId = 3;

  @override
  SDlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SDlist(
      designation: fields[0] as dynamic,
      imageUrlC: fields[1] as String?,
      id: fields[2] as String?,
      name: fields[3] as String?,
      descriptionC: fields[4] as dynamic,
      emailC: fields[5] as String?,
      sortOrderC: fields[6] as dynamic,
      phoneC: fields[7] as String?,
      status: fields[8] as String?,
      darkModeIconC: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SDlist obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.designation)
      ..writeByte(1)
      ..write(obj.imageUrlC)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.descriptionC)
      ..writeByte(5)
      ..write(obj.emailC)
      ..writeByte(6)
      ..write(obj.sortOrderC)
      ..writeByte(7)
      ..write(obj.phoneC)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.darkModeIconC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SDlistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
