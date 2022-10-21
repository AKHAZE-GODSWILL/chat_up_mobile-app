import 'dart:convert';
import 'dart:io';

import 'package:chat_up/main.dart';
import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/model/messageModel.dart';
import 'package:chat_up/screens/inbox/cameraView.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
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
      {Key? key, required this.receiverName, required this.receiverID})
      : super(key: key);
  final String receiverName;
  final String receiverID;
  State<NewChatScreen> createState() => _NewChatScreen();
}

class _NewChatScreen extends State<NewChatScreen> {
  String senderID = getX.read(constants.GETX_USER_ID);
  bool show = false;
  late IO.Socket socket;
  FocusNode focusNode = FocusNode();
  List<MessageModel> messages = [];
  List<ChatModel> usersList = [];
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
    readChats();
    super.initState();
    connect();
  }

  readMsgs() {
    final messageBox = Hive.box('messages');
    messages.addAll(messageBox.values
        .toList()
        .where((element) => element.conversationId == widget.receiverID)
        .cast<MessageModel>());
    print(messages);
  }

  readChats() {
    final chatBox = Hive.box('chats');
    usersList.addAll(chatBox.values.toList().cast<ChatModel>());
  }

  void connect() {
    //https://chatup-node-deploy.herokuapp.com/
    socket =
        IO.io("https://chatup-node-deploy.herokuapp.com/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect":
          false // Sometimes, the code might fail to connect automatically , so you have to make it false
    });

    socket.connect(); // this piece of code connects the socket manually

    // Always emit after the connection
    socket.emit("signin",
        senderID); // This piece of code is used to send a message from the front end to the backend
    // You have to create an event first and then a message in this case ,
    // the event is /test and the message is hello world
    // after creating the event, youn have to go to the backend and listen for the event

    // prints connected if the connection is successful
    // onConnect listens for msgs comming from the API
    socket.onConnect((data) {
      print("Connected");

      socket.on("message", (msg) {
        print(msg);

        // This code puts the incoming message in a list
        // The list is structured in a model which contains type and destination
        // If it receives a message, the setMessage function sets type as destination

        setMessage(widget.receiverID, "destination", msg["message"],
            msg["imagePath"]); //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> check this place later

        setChatModel(widget.receiverID, widget.receiverName, "icons.person",
            false, msg["message"]);

        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });

    print(socket
        .connected); // this piece of code helps check if your client side socket is connected
    // to the server or not. It returns a bool value
  }

  void sendMessage(String message, sourceId, targetId, String imagePath) {
    // The send message function adds the messages to the list and also sends them through the socket
    // on calling the sendMessage method, the setMessage function sets the type of the message to be
    // Source before saving in the list
    setMessage(widget.receiverID, "source", message, imagePath);
    // I first of all send through the event name message before sending an object that actually had the message
    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
      "imagePath": imagePath
    });
    setChatModel(
        widget.receiverID, widget.receiverName, "icons.person", false, message);
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

    setState(() {
      messages.add(messagesModel);
      // adding the message to the local database
      addMsg(messagesModel);
    });
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

    // I first of all send through the event name message before sending an object that actually had the message
    socket.emit("message", {
      "message": message,
      "sourceId": senderID,
      "targetId": widget.receiverID,
      "imagePath": data['path']
    });
  }

  addMsg(MessageModel message) {
    final messageBox = Hive.box('messages');
    messageBox.add(message);
  }

  setChatModel(id, name, icon, isGroup, currentMessage) {
    ChatModel chatModel = ChatModel(
        id: id,
        name: name,
        icon: icon,
        isGroup: isGroup,
        time: DateTime.now().toString().substring(10, 16),
        currentMessage: currentMessage);
    addChat(chatModel);
  }

  addChat(ChatModel chat) {
    final chatBox = Hive.box('chats');
    // chatBox.add(chat);
    usersList.addAll(chatBox.values.toList().cast<ChatModel>());
    print("this is userList>>>>>>>> ${usersList}");

    usersList.indexWhere((element) => element.id == widget.receiverID);
    if (usersList.indexWhere((element) => element.id == widget.receiverID) ==
        -1) {
      usersList.add(chat);
      chatBox.add(chat);
      print("The if block ran");
    } else {
      // usersList[usersList.indexWhere((element) => element.id == widget.receiverID)] = chat;
      chatBox.deleteAt(
          usersList.indexWhere((element) => element.id == widget.receiverID));
      chatBox.add(chat);
      // chatBox.clear();
      // chatBox.addAll(usersList);
      print("The else block ran");
    }
    // usersList[usersList.indexWhere((element) => element.id == widget.receiverID)] = chat;
    print(
        "this is after the finding and the updating userList>>>>>>>> ${usersList[0].currentMessage}");
    // chatBox.addAll(usersList);
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
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    return Container(
                      height: 70,
                    );
                  }

                  if (messages[index].type == "source") {
                    if (messages[index].imagePath.isNotEmpty) {
                      return MyWidgets().ownPictureCard(context,
                          messages[index].imagePath, messages[index].message);
                    }

                    return MyWidgets().ownMessageCard(
                        context: context, message: messages[index].message);
                  } else {
                    if (messages[index].imagePath.isNotEmpty) {
                      return MyWidgets().replyPictureCard(context,
                          messages[index].imagePath, messages[index].message);
                    }

                    return MyWidgets().replyCard(
                        context: context, message: messages[index].message);
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
