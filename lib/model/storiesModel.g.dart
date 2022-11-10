// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storiesModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoriesModelAdapter extends TypeAdapter<StoriesModel> {
  @override
  final int typeId = 2;

  @override
  StoriesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoriesModel(
      url: fields[0] as String,
      media: fields[1] as String,
      user: (fields[2] as Map).cast<String, dynamic>(),
      duration: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StoriesModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.media)
      ..writeByte(2)
      ..write(obj.user)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoriesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
