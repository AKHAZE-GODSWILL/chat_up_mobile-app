
import 'package:chat_up/model/messageModel.dart';
import 'package:chat_up/model/messages.dart';
import 'package:get/get.dart';


class ChatController extends GetxController{

    dynamic chatMessages = <Message>[].obs;
    dynamic connectedUsers = 0.obs ;
    List messages = <MessageModel>[];
    

    // found out that its best to use the GetBuilder if you want your UI to keep rebuilding
    // For some reason, the obs does not work. It saves the data but does not rebuild
    void updateMessages ({required newMsg}){
    
    this.messages.add(newMsg);
    Future.delayed(Duration(milliseconds: 20),(){update();});
  }

  void showMsgFromDB ({required newMsg}){
    this.messages.clear();
    this.messages.addAll(newMsg);
    Future.delayed(Duration(milliseconds: 20),(){update();});
  }

    
}