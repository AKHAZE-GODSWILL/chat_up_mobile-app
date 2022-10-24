// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatModelAdapter extends TypeAdapter<ChatModel> {
  @override
  final int typeId = 1;

  @override
  ChatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatModel(
      id: fields[0] as String,
      name: fields[1] as String,
      icon: fields[2] as String,
      img: fields[3] as String,
      isGroup: fields[4] as bool,
      time: fields[5] as String,
      currentMessage: fields[6] as String,
      unReadMsgCount: fields[7] as int,
      seen: fields[8] as bool,
      isOnline: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChatModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.img)
      ..writeByte(4)
      ..write(obj.isGroup)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.currentMessage)
      ..writeByte(7)
      ..write(obj.unReadMsgCount)
      ..writeByte(8)
      ..write(obj.seen)
      ..writeByte(9)
      ..write(obj.isOnline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
