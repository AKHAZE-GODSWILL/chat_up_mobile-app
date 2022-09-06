import 'package:chat_up/controller/chatController.dart';
import 'package:chat_up/model/messages.dart';
import 'package:flutter/material.dart';
import 'package:chat_up/screens/inbox/messageItem.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

TextEditingController msgInputController = TextEditingController();



class ChatScreen extends StatefulWidget{

  @override
  State<ChatScreen> createState()=> _ChatScreen();
}

class _ChatScreen extends State<ChatScreen>{

    Color purple = Color(0xFF6c5ce7);
    Color black = Color(0xFF191919);
    late IO.Socket socket;
    ChatController chatController =  ChatController();

    @override

    void initState(){

      print("before the connection happens");
      socket = IO.io('https://chatup-node-deploy.herokuapp.com/',
      
      IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build()
      );

      print("Few moments before the connection happens");
      socket.connect();
      setUpSocketListener();
      print("Exactly after the connection happens");


      super.initState();
    }


    @override 

    Widget build(BuildContext context){

      return Scaffold(

        backgroundColor: black,
        body: Container(
          child: Column(
            children: [


              Expanded(child: Obx(

                ()=>Container(
              
                  padding: EdgeInsets.all(10),
                  child: Text("Connected User ${chatController.connectedUsers}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                  ),),
                ),
              )),
              // This particular sections covers the chat areas shown between the sender and the receiver

              Expanded(flex: 9,

              child:Obx(

                ()=>ListView.builder(
                  
                  itemCount: chatController.chatMessages.length,
                  itemBuilder: (context, index){

                      var currentItem = chatController.chatMessages[index];

                      return MessageItem(

                        sentByMe: currentItem.sentByMe == socket.id,
                        message:  currentItem.message,);
                }),
              )),

              
              // This particular section covers the part where you type your message and press the send button
              Expanded(child:Container(
                padding: EdgeInsets.all(10),

                // Handles the area where you type your messages
                child: TextField(

                  style: TextStyle(
                    color: Colors.white
                  ),

                  cursorColor: purple,
                  controller: msgInputController,
                  decoration: InputDecoration(

                    // How the border looks like when you are not typing

                    enabledBorder: OutlineInputBorder(

                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)
                    ),

                    // How the border looks like when you are typing
                    focusedBorder: OutlineInputBorder(

                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)
                    ),

                    // The send icon 
                    suffixIcon: Container(

                      margin: EdgeInsets.only(right:10),
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      
                      child: IconButton(

                        // handles the action performed anytime you press the send button
                        onPressed:(){

                          sendMessage(msgInputController.text);
                          msgInputController.text = "";
                        } ,

                        icon: Icon(Icons.send, color: Colors.white,),
                      )
                    )
                  ),
                ),
              )),
            ],
          ),
        ),
      );
    }

  sendMessage(String text) {

        dynamic messageJson = {

          "message": text,
          "sentByMe": socket.id
        };
        socket.emit('message',  messageJson);
        chatController.chatMessages.add(Message.fromJson(messageJson));
  }

  void setUpSocketListener() {

    socket.on('message-receive', (data){

      print(data);
      chatController.chatMessages.add(Message.fromJson(data));
    });

    socket.on('connected-user', (data){

      print(data);
      chatController.connectedUsers.value = data;
    });
  }
}