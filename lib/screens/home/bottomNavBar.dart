//// So the logic of this page, This page is interacting with the get controller page and
///every other page will be getting info from the controller page
///now every chat fuction will be declared in the get controller page
///and called from every other page which is the bottom nav page and the chat page
///also another way for this to work is that every fuction will be declared here
///passed to the home page then passed to the newchatpage also
///so the only thing the chat page would be doing is to be calling all these fuctions


import 'package:chat_up/controller/chatController.dart';
import 'package:chat_up/main.dart';
import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/model/messageModel.dart';
import 'package:chat_up/screens/home/findFriends.dart';
import 'package:chat_up/screens/home/homeScreen.dart';
import 'package:chat_up/screens/home/settings.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hive_flutter/adapters.dart';

class BottomNavBar extends StatefulWidget{

  const BottomNavBar({Key? key}) : super(key: key);
  State<BottomNavBar> createState()=> _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar>{

     ChatController chatController = Get.put(ChatController());
    // final _myBox = Hive.box('myBox');
    String senderID = getX.read(constants.GETX_USER_ID);
    List<ChatModel> usersList = [];
    late String receiverID;
    late IO.Socket socket;
    int current_index = 1;

    @override
    void initState() {
    print("bottom nav bar");
    connect();
    super.initState();
    }
  

  // ignore: non_constant_identifier_names
  void update_index(int value) {
    setState(() {
      current_index = value;
    });
  }


    void connect() {
    //"https://chatup-node-deploy.herokuapp.com/"
       socket = IO.io("https://chatup-node-deploy.herokuapp.com/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect":
          false // Sometimes, the code might fail to connect automatically , so you have to make it false
    });

    socket.connect(); // this piece of code connects the socket manually

    
    socket.emit("signin",senderID);
    
    // onConnect listens for msgs comming from the API
    socket.onConnect((data) {
      print("Connected");

      // This one is for when you come online for the first time
      socket.on("onlineUsers", (data) {
        // receives a list of all the people that are online and sets the local database to true
        // For all the found people 
        
        print(">>>>>>>>>These are all the data gotten from the socket ${data}");
        // List<String> keys = data.keys.toList();

        data.forEach((item){

          addOnlineStatus(item);
          print(item);
          
        });

      });

      socket.on("offlineUser",(data){
        print(data);
        removeOfflineUser(data);
      });

      socket.on("message", (msg) {
        print(msg);

        // This code puts the incoming message in a list
        // The list is structured in a model which contains type and destination
        // If it receives a message, the setMessage function sets type as destination 

        setMessage(
          msg["sourceId"], 
          "destination",
          msg["message"],
          msg["imagePath"]); 
         
        setChatModel(
          msg["sourceId"],
          msg["fullname"],
          "icons.person",
          false,
          msg['senderImage'],
          msg["message"]);
      });
    });

    // this piece of code helps check if your client side socket is connected
    // to the server or not. It returns a bool value
    print(socket.connected); 
  }


  
  // supposed to call this inside the set ChatModel
  addOnlineStatus(item){
    final chatBox = Hive.box('chats');
    
    usersList.clear();
    usersList.addAll(chatBox.values.toList().cast<ChatModel>());
      if(usersList.isNotEmpty){
        var userKey = usersList.indexWhere((element) => element.id == item['id']);
        if(userKey == -1){
          print("The if -1 block ran and you have no chat with this guy yet");

        }
        else{
          print("The else block ran. Online status set successfully");
          ChatModel onlineUser = chatBox.getAt(userKey);
          onlineUser.isOnline = true;
          chatBox.putAt(userKey, onlineUser);
        }
      }
      else{}
  }

  removeOfflineUser(data){
    final chatBox = Hive.box('chats');
    
    usersList.clear();
    usersList.addAll(chatBox.values.toList().cast<ChatModel>());
    if(usersList.isNotEmpty){
      var userKey = usersList.indexWhere((element) => element.id == data['id']);
      if(userKey == -1){
        print("The if -1 block ran and you have no chat with this guy yet");
      }
      else{
        print("The else block ran. Online status set successfully");
        ChatModel onlineUser = chatBox.getAt(userKey);
        onlineUser.isOnline = false;
        chatBox.putAt(userKey, onlineUser);
        print("Offline status set successfully");
      }
    }
    else{}

  }
  readChatsFromDB(id){
    final chatBox = Hive.box('chats');
    Iterable<ChatModel> onlineUser = chatBox.values
      .where((element) => element._id == id)
      .cast<ChatModel>();
  }

  void sendMessageToSocket(message,senderId,receiverId, fullname,dataPath, senderImage){
    socket.emit("message", {
      "message": message,
      "sourceId": senderId,
      "targetId": receiverId,
      "fullname": fullname,
      "imagePath": dataPath,
      "senderImage": senderImage
    });
  }
  
    void setMessage(String conversationId, String type, String message, String imagePath) {
      MessageModel messagesModel = MessageModel(
        conversationId: conversationId,
        message: message,
        type: type,
        imagePath: imagePath,
        time: DateTime.now().toString().substring(10, 16));

    chatController.updateMessages(newMsg: messagesModel);
    setState(() {
      addMsg(messagesModel);
    });
  }

  addMsg(MessageModel message) {
    final messageBox = Hive.box('messages');
    messageBox.add(message);
  }

  // the set chat model
  //>>>>>> Please come back here abeg make app no dey crash.. I guess there is an error somewhere here
  setChatModel(id, name, icon, isGroup, image,currentMessage) {
    ChatModel chatModel = ChatModel(
        id: id,
        name: name,
        icon: icon,
        img: image,
        isGroup: false,
        time: DateTime.now().toString().substring(10, 16),
        currentMessage: currentMessage,
        unReadMsgCount: 0,
        seen: false,
        isOnline: true
        );


    addChat(chatModel, id);
  }

  // >>>>>>>>>>>>>>>>>>>>>>Cross check this place again
    addChat(ChatModel chat, id ) {
    final chatBox = Hive.box('chats');
    
    usersList.clear();
    usersList.addAll(chatBox.values.toList().cast<ChatModel>());
    print("this is userList>>>>>>>> ${usersList}");

   if(usersList.isNotEmpty){

    print("if user list not empty ran>>>>>>>>");

      var userKey = usersList.indexWhere((element) => element.id == id);
    if (userKey == -1) {

      print(" if user list == -1 ran>>>>>>>>");
      chat.unReadMsgCount = 1;
      chatBox.add(chat);
      print("The if block ran");

    } else {

      print(" The user key is >>>>>>>>${userKey}");
      print(" The usersList unread message count is >>>>>>>>${usersList[userKey].unReadMsgCount}");
      print(" else user list == -1 ran>>>>>>>>");
      int count = ++usersList[userKey].unReadMsgCount;
      chat.unReadMsgCount = count;
      chatBox.deleteAt(userKey);
      chatBox.add(chat);
      print("The else block ran");

    }

   }
    else{
      print(" the else user list is not empty ran ran>>>>>>>>");
      chat.unReadMsgCount = 1;
      chatBox.add(chat);
    }

    print(
        "this is after the finding and the updating userList>>>>>>>> ${usersList[0].currentMessage}");
    // chatBox.addAll(usersList);
  }


  @override 

  Widget build(BuildContext context){


        List screens = [
    // HomePage(response: widget.response),
    FindFriends(sendMessageToSocket: sendMessageToSocket,),
    HomeScreen(sendMessageToSocket: sendMessageToSocket,),
    Settings(),
  ];

        return Scaffold(

            body: screens[current_index],

            bottomNavigationBar: BottomNavigationBar(
          enableFeedback: false,
          iconSize: 17,
          backgroundColor: Colors.grey.shade200,
          type: BottomNavigationBarType.fixed,
          currentIndex: current_index,
          onTap: update_index,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: const TextStyle(
            overflow: TextOverflow.visible,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          showUnselectedLabels: true,
          selectedItemColor: Colors.green,
          selectedLabelStyle: const TextStyle(
            overflow: TextOverflow.visible,
            fontSize: 10,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 7, top: 6),
                child: Icon(
                  Icons.people,
                  size: 24,
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 3),
                child: Icon(
                  Icons.people,
                  size: 24,
                  color: Constants().purple,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 7, top: 6),

                // Reminder to update the texts and how they look like
                child: Text("chats")
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 3),
                child: Text("chats",
                
                style: TextStyle(
                            color: Constants().purple
                          )),
              ),


              label: '',
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 7, top: 6),
                child: Text("...")
                
                // Icon(Icons.history_outlined,
                //     size: 24, color: Color.fromRGBO(0, 0, 0, 0.5)),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 3),
                child: Text("...",
                
                    style: TextStyle(
                            color: Constants().purple
                          )
                )
                
                // CircleAvatar(
                //     minRadius: 15,
                //     backgroundColor: Constants().primaryColor,
                //     child: Icon(Icons.history,
                //         size: 24, color: Constants().primaryBackgroundColor)),
              ),


              label: '',
            ),
            
          ]),
          
        );
  }
}