// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInformationAdapter extends TypeAdapter<UserInformation> {
  @override
  final int typeId = 15;

  @override
  UserInformation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInformation(
      userName: fields[0] as String?,
      userEmail: fields[1] as String?,
      profilePicture: fields[2] as String?,
      authorizationToken: fields[3] as String?,
      refreshToken: fields[4] as String?,
      idToken: fields[5] as String?,
      gradedPlusGoogleDriveFolerId: fields[6] as String?,
      pbisPlusGoogleDriveFolerId: fields[7] as String?,
      studentPlusGoogleDriveFolerId: fields[8] as String?,
    )..gradedPlusGoogleDriveFolerPathUrl = fields[9] as String?;
  }

  @override
  void write(BinaryWriter writer, UserInformation obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.userEmail)
      ..writeByte(2)
      ..write(obj.profilePicture)
      ..writeByte(3)
      ..write(obj.authorizationToken)
      ..writeByte(4)
      ..write(obj.refreshToken)
      ..writeByte(5)
      ..write(obj.idToken)
      ..writeByte(6)
      ..write(obj.gradedPlusGoogleDriveFolerId)
      ..writeByte(7)
      ..write(obj.pbisPlusGoogleDriveFolerId)
      ..writeByte(8)
      ..write(obj.studentPlusGoogleDriveFolerId)
      ..writeByte(9)
      ..write(obj.gradedPlusGoogleDriveFolerPathUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInformationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
