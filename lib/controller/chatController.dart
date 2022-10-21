import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/model/messages.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{

    dynamic chatMessages = <Message>[].obs;
    dynamic connectedUsers = 0.obs ;
    List<ChatModel> chatList = [];

    void upDateChatList ( chatList){
      this.chatList.add(chatList);
      update();
    }
    
}