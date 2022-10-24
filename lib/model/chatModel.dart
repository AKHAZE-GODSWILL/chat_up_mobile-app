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
        String img;

        @HiveField(4)
        bool isGroup;

        @HiveField(5)
        String time;

        @HiveField(6)
        String currentMessage;

        @HiveField(7)
        int unReadMsgCount = 0;

        @HiveField(8)
        bool seen = false;

        @HiveField(9)
        bool isOnline = false;


        
        

        ChatModel({
                   required this.id,
                   required this.name,
                   required this.icon,
                   required this.img,
                   required this.isGroup,
                   required this.time,
                   required this.currentMessage,
                   required this.unReadMsgCount,
                   required this.seen,
                   required this.isOnline});
      }