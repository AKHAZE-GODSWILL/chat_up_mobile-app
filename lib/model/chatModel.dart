import 'package:chat_up/model/messageModel.dart';
import 'package:hive/hive.dart';

part 'chatModel.g.dart';

      @HiveType(typeId: 1)
      class ChatModel{
        
        @HiveField(0)
        String id;

        @HiveField(1)
        String name;

        @HiveField(2)
        String icon;

        @HiveField(3)
        bool isGroup;

        @HiveField(4)
        String time;

        @HiveField(5)
        String currentMessage;

        
        

        ChatModel({
                   required this.id,
                   required this.name,
                   required this.icon,
                   required this.isGroup,
                   required this.time,
                   required this.currentMessage,});
      }