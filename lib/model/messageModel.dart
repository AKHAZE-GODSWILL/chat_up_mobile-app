
import 'package:chat_up/model/chatModel.dart';
import 'package:hive/hive.dart';

part 'messageModel.g.dart';

@HiveType(typeId: 0)
class MessageModel{

      @HiveField(0)
      String conversationId;

      @HiveField(1)
      String type;
      @HiveField(2)
      String message;
      @HiveField(3)
      String imagePath;
      @HiveField(4)
      String time;

      

      MessageModel({required this.conversationId,required this.message , required this.type, required this.imagePath, required this.time});

}