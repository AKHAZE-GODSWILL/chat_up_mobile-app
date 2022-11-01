// In this page, the set message is setting the message to the array in the get controller
// and obs is used there so that a new message enters the array,the UI rebuilds
// so, the array needs to be cleaned or initialized to empty when we want to chat with a new user
// so, the read message from database, messages are read to 
// the array at the get controller page


import 'dart:convert';
import 'dart:io';

import 'package:chat_up/controller/chatController.dart';
import 'package:chat_up/main.dart';
import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/model/messageModel.dart';
import 'package:chat_up/screens/inbox/cameraView.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:chat_up/utils/myWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Need to figure out how to set different width and height for different widgets in different sizes of screen
// the app must be responsive as possible, also I need to stop everything from shifting up when the on screen
// keyboard comes on
// Also, i need to be able to set the sent and not sent message, to know if your message went through

TextEditingController _controller = new TextEditingController();

class NewChatScreen extends StatefulWidget {
  const NewChatScreen(
      {Key? key, required this.receiverName, required this.receiverID, required this.receiverImage, required this.sendMessageToSocket})
      : super(key: key);
  final String receiverName;
  final String receiverID;
  final String receiverImage;
  final Function sendMessageToSocket;
  State<NewChatScreen> createState() => _NewChatScreen();
}

class _NewChatScreen extends State<NewChatScreen> {
   final ChatController chatController = Get.put(ChatController());

  String senderID = getX.read(constants.GETX_USER_ID);
  String fullname = getX.read(constants.GETX_FULLNAME);
  bool show = false;
  FocusNode focusNode = FocusNode();
  List<ChatModel> usersList = [];
  ScrollController _scrollController = ScrollController();
  String imgPath = "";
  String imgExt = "";
  String myImage = "";

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

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CameraViewPage(imgPath: imgPath, onSendImage: onSendImage)));
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

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CameraViewPage(imgPath: imgPath, onSendImage: onSendImage)));
    });
  }

  @override
  void initState() {
    readMsgs();
    myImage = getX.read(constants.GETX_USER_IMAGE);
    super.initState();
  }


  //////>>>>>>>>>>>> take note of the changes made here abeg
  readMsgs() {
    final messageBox = Hive.box('messages');
    //////>>>>>>>>>>>>>>>> the message are read into the one at the get controller. Take note of it abeg
    // chatController.messages.clear();
    // chatController.messages.addAll();
    chatController.showMsgFromDB(newMsg: messageBox.values
        .toList()
        .where((element) => element.conversationId == widget.receiverID)
        .cast<MessageModel>());
    print(chatController.messages);
  }

  void sendMessage(String message, sourceId, targetId, String imagePath){
    // The send message function adds the messages to the list and also sends them through the socket
    // on calling the sendMessage method, the setMessage function sets the type of the message to be
    // Source before saving in the list
    print(">>>>> source id is ${sourceId}");
    print(">>>>> source id is ${targetId}");
    print(">>>>> source id is ${widget.receiverID}");
    setMessage(widget.receiverID, "source", message, imagePath);

    // I first of all send through the event name message before sending an object that actually had the message
    widget.sendMessageToSocket(
      message,
      sourceId,
      targetId,
      fullname,
      "",
      myImage,
    );

    setChatModel(
        widget.receiverID, widget.receiverName, "icons.person", false,widget.receiverImage, message);
  }

  // Forces all the messages to take
  void setMessage(
      String conversationId, String type, String message, String imagePath) {
    MessageModel messagesModel = MessageModel(
        conversationId: conversationId,
        message: message,
        type: type,
        imagePath: imagePath,
        time: DateTime.now().toString().substring(10, 16));

    //////////////// >>>>>>>>>>>>>> take note to the changes made here abeg
    

      //////////// >>>> This message is set to the array at get contoller page instead
      chatController.updateMessages(newMsg: messagesModel);
      // setState(() {
      //   chatController.messages.add(messagesModel);
      // });
      print(">>>>>>>>>>>>> The getX message model that i just printed ${chatController.messages}");
      // adding the message to the local database
      addMsg(messagesModel);
    
  }

  void onSendImage(String imgPath, String message) async {
    print("Hey there , it is working $imgPath and the message is: $message");

    setMessage(widget.receiverID, "source", message, imgPath);

    var request = http.MultipartRequest(
        'Post',
        Uri.parse(
            "https://chatup-node-deploy.herokuapp.com/sendImage/addImage"));

    // The field name is the key value that we used when we were writing the end point
    request.files.add(await http.MultipartFile.fromPath('img', imgPath));
    request.headers.addAll({"Content-type": "multipart/form-data"});

    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = await json.decode(httpResponse.body);
    print(data['path']);
    print(response.statusCode);


    widget.sendMessageToSocket(
      message,
      senderID,
      widget.receiverID,
      fullname,
      data['path'],
      myImage
    );
  
  }

  addMsg(MessageModel message) { 
    final messageBox = Hive.box('messages');
    messageBox.add(message);
  }

  // I made changes to all the chat Model Schema 
  setChatModel(id, name, icon, isGroup, image,currentMessage) {
    print("The set chat model actually ran with the current message as");
    print(currentMessage);
    ChatModel chatModel = ChatModel(
        id: id,
        name: name,
        icon: icon,
        img: widget.receiverImage,
        isGroup: isGroup,
        time: DateTime.now().toString().substring(10, 16),
        currentMessage: currentMessage,
        unReadMsgCount: 0,
        seen: true,
        isOnline: false);
    addChat(chatModel);
  }

  addChat(ChatModel chat) {

    print('>>>>>>>>>>>>>>>>>>>>>>>>>add chat model ran successfully');
    // this code is written to ensure that the model coming from the "find friends" screen is ignored as it is useless
    // There is already a check to find out if a user was not present before
    

    
    


    
    final chatBox = Hive.box('chats');
    
    // This code adds all the users from the data base into an array
    usersList.clear();
    usersList.addAll(chatBox.values.toList().cast<ChatModel>());
    print(">>>>>>>>>>>>>>> the userList is ${usersList}");
       if(usersList.isNotEmpty){

        print('>>>>>>>>>>>>>>>>>>>>>>>>>the first if statement in the add chat ran to check if usersList is not empty');   
        print("this is userList>>>>>>>> ${usersList[0].currentMessage}");

          // Here, a search is done to check if a particular user is in the list and the index is saved in user key
  var userKey = usersList.indexWhere((element) => element.id == widget.receiverID);
    if (userKey == -1) {

      // if user is not found on the list , his info is freshly added to the database
      chatBox.add(chat);
      print("The if block ran");
    } else {
      // if user is found on the list, his info is updated on the database
      ChatModel chat = chatBox.getAt(userKey);
      chat.unReadMsgCount = 0;
      chat.currentMessage= chatController.messages[chatController.messages.length - 1].message;
      chat.img = widget.receiverImage;

      print(chat.img);
      chat.seen = true;

      print(">>>>>>>>>>>>> the updated model current message ${chat.currentMessage}");
      chatBox.putAt(userKey,chat);
      print("The else block ran");
    }
    print(
        "this is after the finding and the updating userList>>>>>>>> ${usersList[0].currentMessage}");
      // chatBox.addAll(usersList);


       }

        else{
        chatBox.add(chat);
        }
    
    
  }

  @override
  Widget build(BuildContext context) {
    return chatBody();
  }

  Widget chatBody() {
    return Scaffold(
      // I'll run a request in the init state to get me the names of the receiver or the person I am chatting with
      appBar: MyWidgets().appBar(ctx: context, title: widget.receiverName),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              
              // found out that its best to use the GetBuilder if you want your UI to keep rebuilding
              // For some reason, the obs does not work. It saves the data but does not rebuild
              child: GetBuilder<ChatController>(
                builder: (_){

                  // Sets the Message model on the other screen 
                  //this part ensures that I have seen the message 
                  if(chatController.messages.length != 0){

                    print("the get builder if statement ran");
                    print(">>>>>>>>>>>>> the chat controller message number is ${chatController.messages.length}");
                      setChatModel(
                    widget.receiverID, 
                    widget.receiverName,
                    "",
                    false,
                    widget.receiverImage,
                    chatController.messages[chatController.messages.length-1].message);
                  }
                  
                  // addChat(widget.user);
                  return ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: chatController.messages.length ,
                itemBuilder: (context, index) {
                  var currentItem = chatController.messages[index];

                  if (currentItem == chatController.messages.length) {
                    return Container(
                      height: 70,
                    );
                  }

                  if (currentItem.type == "source") {
                    if (currentItem.imagePath.isNotEmpty) {
                      return MyWidgets().ownPictureCard(context,
                          currentItem.imagePath, currentItem);
                    }

                    return MyWidgets().ownMessageCard(
                        context: context, message: currentItem);
                  } else {
                    if (currentItem.imagePath.isNotEmpty) {
                      return MyWidgets().replyPictureCard(context,
                          currentItem.imagePath, currentItem);
                    }

                    return MyWidgets().replyCard(
                        context: context, message:currentItem);
                  }
                },
              );
                }
              )
                
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(children: [
                        IconButton(
                          // handles the action performed anytime you press the send button
                          onPressed: () {
                            sendPicture(context);
                          },

                          icon: Icon(
                            Icons.add,
                            color: Constants().purple,
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width - 100,
                            height: 50,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                child: TextField(
                                  controller: _controller,
                                  focusNode: focusNode,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Type a message",
                                  ),
                                ))),
                        IconButton(
                          // handles the action performed anytime you press the send button
                          onPressed: () { 
                            if (_controller.text != "") {
                              FocusScope.of(context).unfocus();
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                              sendMessage(_controller.text, senderID,
                                  widget.receiverID, "");
                              _controller.text = "";
                            }
                          },

                          icon: Icon(
                            Icons.send,
                            color: Constants().purple,
                          ),
                        )
                      ]),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )),
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
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Constants().purple,
                          child: Icon(Icons.image),
                        ),
                        SizedBox(height: 5),
                        Text("Gallery",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
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
