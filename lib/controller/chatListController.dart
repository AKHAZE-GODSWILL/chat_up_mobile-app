
import 'package:chat_up/model/chatModel.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController{

  List <ChatModel>usersList = <ChatModel>[];
  
  void showChatsFromDB ({required allChats}){
    this.usersList.clear();
    this.usersList.addAll(allChats);
    this.usersList = this.usersList.reversed.toList();
    Future.delayed(Duration(milliseconds: 20),(){update();});
  }

  void updateIncomingChats({required ChatModel newChat, required id}){

    print("update chats running successfully");

    if(usersList.isNotEmpty){

    print("if user list in the get controller not empty ran>>>>>>>>");

      var userKey = usersList.indexWhere((element) => element.id == id);
    if (userKey == -1) {

      print(" get controller ... if user list == -1 ran>>>>>>>>");
      newChat.unReadMsgCount = 1;
      newChat.isOnline = true;
      usersList.insert(0,newChat);
      Future.delayed(Duration(milliseconds: 20),(){update();});
      print("The if block ran in the get controller");

    } else {

      print(" The user key is >>>>>>>>${userKey} in the get controller");
      print(" else user list == -1 ran in the get controller>>>>>>>>");
      int count = usersList[userKey].unReadMsgCount;
      newChat.unReadMsgCount = count;
      newChat.isOnline = true;
      usersList.removeAt(userKey);
      usersList.insert(0,newChat);
      Future.delayed(Duration(milliseconds: 20),(){update();});
      print("The else block ran in the get controller");

    }

   }

   else{
      print(" the else user list is not empty ran ran in the get controller>>>>>>>>");
      newChat.unReadMsgCount = 1;
      newChat.isOnline = true;
      usersList.insert(0,newChat);
      Future.delayed(Duration(milliseconds: 20),(){update();});
    }

  }

  void updateSeenChats({required ChatModel newChat, required id}){

    // print("update chats running successfully");

    if(usersList.isNotEmpty){

    // print("if user list in the get controller not empty ran>>>>>>>>");

      var userKey = usersList.indexWhere((element) => element.id == id);
    if (userKey == -1) {}
    
    else {

      // print(" The user key is >>>>>>>>${userKey} in the get controller");
      // print(" else user list == -1 ran in the get controller>>>>>>>>");
      usersList[userKey].unReadMsgCount = 0;
      usersList[userKey].seen = true;
      Future.delayed(Duration(milliseconds: 20),(){update();});
      print("The else block ran in the get controller");

    }

   }

   else{}

  }

  addOnlineStatus(item){

      if(usersList.isNotEmpty){
        var userKey = usersList.indexWhere((element) => element.id == item['id']);
        if(userKey == -1){
          print("The if -1 block ran and you have no chat with this guy yet");

        }
        else{
          print("The else block ran. Online status set successfully");
          // ChatModel onlineUser = chatBox.getAt(userKey);
          // onlineUser.isOnline = true;
          // chatBox.putAt(userKey, onlineUser);
          usersList[userKey].isOnline = true;
          Future.delayed(Duration(milliseconds: 20),(){update();});
        }
      }
      else{}
  }


    removeOfflineUser(data){


    if(usersList.isNotEmpty){
      var userKey = usersList.indexWhere((element) => element.id == data['id']);
      if(userKey == -1){
        print("The if -1 block ran and you have no chat with this guy yet");
      }
      else{
        print("The else block ran. Online status set successfully");
        // ChatModel onlineUser = chatBox.getAt(userKey);
        // onlineUser.isOnline = false;
        // chatBox.putAt(userKey, onlineUser);
        usersList[userKey].isOnline = false;
        print("Offline status set successfully");
        Future.delayed(Duration(milliseconds: 20),(){update();});
      }
    }
    else{}

  }
}