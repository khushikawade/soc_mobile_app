// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslationModalAdapter extends TypeAdapter<TranslationModal> {
  @override
  final int typeId = 25;

  @override
  TranslationModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslationModal(
      toLanguageCode: fields[0] as String?,
      originalText: fields[1] as String?,
      translatedText: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TranslationModal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.toLanguageCode)
      ..writeByte(1)
      ..write(obj.originalText)
      ..writeByte(2)
      ..write(obj.translatedText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
