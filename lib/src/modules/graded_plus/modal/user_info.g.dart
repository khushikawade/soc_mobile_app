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
      gradedPlusGoogleDriveFolderId: fields[6] as String?,
      pbisPlusGoogleDriveFolderId: fields[7] as String?,
      studentPlusGoogleDriveFolderId: fields[8] as String?,
      gradedPlusGoogleDriveFolderPathUrl: fields[9] as String?,
      userType: fields[10] as String?,
      familyToken: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInformation obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.gradedPlusGoogleDriveFolderId)
      ..writeByte(7)
      ..write(obj.pbisPlusGoogleDriveFolderId)
      ..writeByte(8)
      ..write(obj.studentPlusGoogleDriveFolderId)
      ..writeByte(9)
      ..write(obj.gradedPlusGoogleDriveFolderPathUrl)
      ..writeByte(10)
      ..write(obj.userType)
      ..writeByte(11)
      ..write(obj.familyToken);
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
