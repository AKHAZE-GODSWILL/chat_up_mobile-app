
import 'package:chat_up/model/messageModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:chat_up/utils/myWidgets.dart';
import 'package:flutter/material.dart';

TextEditingController _controller = new TextEditingController();
class NewChatScreen extends StatefulWidget{

  const NewChatScreen({Key? key, required this.chatModels, required this.sourceChat}) : super(key: key);
  final ChatModel sourceChat;
  final ChatModel chatModels;
  State<NewChatScreen> createState()=> _NewChatScreen();
}

class _NewChatScreen extends State<NewChatScreen>{

  bool show = false;
  late IO.Socket socket;
  FocusNode focusNode = FocusNode();
  List<MessageModel> messages = [];


  @override
  void initState() {
    
    super.initState();
    connect();
    focusNode.addListener(() {

      if(focusNode.hasFocus){

          setState(() {
            show = false;
          });

      }
    });
  }



  void connect(){

    print(widget.sourceChat);
    
    socket = IO.io("https://chatup-node-deploy.herokuapp.com/", <String, dynamic>{

      "transports":["websocket"],
      "autoConnect": false       // Sometimes, the code might fail to connect automatically , so you have to make it false
    });

    socket.connect(); // this piece of code connects the socket manually 

    // Always emit after the connection
    socket.emit("signin", widget.sourceChat.id); // This piece of code is used to send a message from the front end to the backend
                                        // You have to create an event first and then a message in this case ,
                                        // the event is /test and the message is hello world
                                        // after creating the event, youn have to go to the backend and listen for the event

    
    // prints connected if the connection is successful
    // onConnect listens for msgs comming from the API
    socket.onConnect((data) {
      
      print("Connected");

      socket.on("message", (msg){

            print(msg);

            // This code puts the incoming message in a list
            // The list is structured in a model which contains type and destination
            // If it receives a message, the setMessage function sets type as destination
            setMessage("destination",msg["message"]);
      });
      
      }
    
    
    ); 

    print(socket.connected); // this piece of code helps check if your client side socket is connected 
                              // to the server or not. It returns a bool value

    
  }

  void sendMessage(String message, int sourceId, targetId){

        // The send message function adds the messages to the list and also sends them through the socket
        // on calling the sendMessage method, the setMessage function sets the type of the message to be 
        // Source before saving in the list
        setMessage("source", message);
        // I first of all send through the event name message before sending an object that actually had the message
        socket.emit("message", {"message": message,"sourceId":sourceId, "targetId":targetId});
  }


  void setMessage(String type, String message ){

      MessageModel messagesModel = MessageModel(message: message, type: type);
      setState(() {
        messages.add(messagesModel);
      });
  }

  @override 

  Widget build(BuildContext context){

        return Scaffold(

          appBar: MyWidgets().appBar(ctx: context, title: widget.chatModels.name),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context,index){

                       if(messages[index].type == "source"){

                        return MyWidgets().ownMessageCard(context: context, message: messages[index].message);
                       }

                       else{

                          return MyWidgets().replyCard(context: context, message: messages[index].message);
                       }

                       
                    },
                    
                    
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          children: [

                            IconButton(

                              // handles the action performed anytime you press the send button
                              onPressed:(){

                                // sendMessage(msgInputController.text);
                                // msgInputController.text = "";
                              } ,

                              icon: Icon(Icons.add, color: Constants().purple,),
                            ),
                            
                            Container(
                              
                              width: MediaQuery.of(context).size.width-100,
                              height: 50,
                              child: Card(

                                
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                child: TextField(
                                  controller: _controller,
                                  focusNode: focusNode,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    border:InputBorder.none,
                                    hintText: "Type a message",
                                    
                                    
                                  ),
                                ))),

                            IconButton(

                              // handles the action performed anytime you press the send button
                              onPressed:(){

                                if(_controller.text != ""){

                                    sendMessage(_controller.text, widget.sourceChat.id, widget.chatModels.id);
                                    _controller.text = "";
                                }
                              } ,

                              icon: Icon(Icons.send, color: Constants().purple,),
                            )
                          ]
                        ),

                        SizedBox(
                            height: 20,
                           )
                      ],
                    ),
                  )
                ),

                
              ],

              
            ),
          ),
        );
  }

  
}