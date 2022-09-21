
import 'dart:io';

import 'package:chat_up/model/messageModel.dart';
import 'package:chat_up/screens/inbox/cameraView.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:chat_up/utils/myWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  ScrollController _scrollController = ScrollController();

   String imgPath = "";
   String imgExt = "";
  
      File? readyUploadImage;
      bool hasImg = false;
      getImageGallery() {
         ImagePicker().pickImage(source: ImageSource.gallery).then((selectedImage) {
          if (selectedImage == null) return;

          readyUploadImage = File(selectedImage.path);
          print(readyUploadImage!.path);
          setState(() {
            imgPath = readyUploadImage!.path;
            imgExt = imgPath.split(".").last;
            hasImg = true;
      });

          
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=> CameraViewPage(imgPath: imgPath, onSendImage:onSendImage)
          ));
    });

  }

      getImageCamera() {
         ImagePicker().pickImage(source: ImageSource.camera).then((selectedImage) {
          if (selectedImage == null) return;

          readyUploadImage = File(selectedImage.path);
          print(readyUploadImage!.path);
          setState(() {
            imgPath = readyUploadImage!.path;
            imgExt = imgPath.split(".").last;
            hasImg = true;
      });

          Navigator.push(context, MaterialPageRoute(
              builder: (context)=> CameraViewPage(imgPath: imgPath, onSendImage: onSendImage)
            ));
    });

    
  }
      



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
            setMessage(
              "destination",
               msg["message"],
               msg["message"]); //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> check this place later
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent, 
                duration:Duration(milliseconds: 300),
                curve: Curves.easeOut );
      });
      
      }
    
    
    ); 

    print(socket.connected); // this piece of code helps check if your client side socket is connected 
                              // to the server or not. It returns a bool value

    
  }

  void sendMessage(String message, int sourceId, targetId, String imagePath){

        // The send message function adds the messages to the list and also sends them through the socket
        // on calling the sendMessage method, the setMessage function sets the type of the message to be 
        // Source before saving in the list
        setMessage("source", message, imagePath);
        // I first of all send through the event name message before sending an object that actually had the message
        socket.emit("message", {"message": message,"sourceId":sourceId, "targetId":targetId, "imagePath": imagePath});
  }


  // Forces all the messages to take 
  void setMessage(String type, String message, String imagePath ){

      MessageModel messagesModel = MessageModel(
        message: message,
        type: type,
        imagePath:imagePath,
        time: DateTime.now().toString().substring(10, 16));
      setState(() {
        messages.add(messagesModel);
      });
  }

    void onSendImage(String imgPath, String message) async{
       print("Hey there , it is working $imgPath and the message is: $message");
       var request = http.MultipartRequest('Post',Uri.parse("https://chatup-node-deploy.herokuapp.com/sendImage/addImage"));

            // The field name is the key value that we used when we were writing the end point
           request.files.add(await http.MultipartFile.fromPath('img', imgPath));
           request.headers.addAll({
            "Content-type":"multipart/form-data"
           });

           http.StreamedResponse response = await request.send();
           print(response.statusCode);
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
                    
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: messages.length+1,
                    itemBuilder: (context,index){

                       if(index == messages.length){

                            return Container(
                              height: 70,
                            );
                       }

                       if(messages[index].type == "source"){

                        return MyWidgets().ownMessageCard(context: context, message: messages[index].message);
                       }

                       else{

                          return MyWidgets().replyCard(context: context, message: messages[index].message);
                       }

                       
                    },
                    
                    
                  ),

                  // child: ListView(
                  //   children: [
                  //     MyWidgets().ownPictureCard(context, imgPath),
                  //     MyWidgets().replyPictureCard(context, imgPath),
                  //   ],
                    
                  // )
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

                                sendPicture(context);
                                
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

                                    FocusScope.of(context).unfocus();
                                    _scrollController.animateTo(
                                          _scrollController.position.maxScrollExtent, 
                                          duration:Duration(milliseconds: 300),
                                          curve: Curves.easeOut );
                                    sendMessage(
                                      _controller.text,
                                      widget.sourceChat.id,
                                      widget.chatModels.id,
                                      "");
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


  sendPicture(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Send image from:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {

                    getImageCamera();
                    Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context)=> CameraViewPage(imgPath: imgPath,)
                    // ));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Constants().purple,
                        child: Icon(Icons.camera),
                      
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getImageGallery();
                    Navigator.pop(context);
                     
                    

                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Constants().purple,
                        child: Icon(Icons.image),
                      ),
                      SizedBox(height: 5),
                      Text("Gallery", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}



  
}