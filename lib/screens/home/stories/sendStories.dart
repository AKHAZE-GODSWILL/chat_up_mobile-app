import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chat_up/main.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';

class SendStories extends StatefulWidget{

  SendStories ({Key? key, required this.imagePath, required this.sendStoriesToSocket}) : super(key: key);
  final imagePath;
  final sendStoriesToSocket;
  State<SendStories > createState()=> _SendStories ();
}

class _SendStories  extends State<SendStories >{

  late String senderName;
  late String senderImage;
  late String senderID;


  @override
  initState(){
    senderName = getX.read(constants.GETX_FULLNAME);
    senderImage = getX.read(constants.GETX_USER_IMAGE);
    senderID = getX.read(constants.GETX_USER_ID);
    super.initState();
  }

  @override 

  Widget build(BuildContext context){

        return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          // actions: [
          //   IconButton(onPressed: (){},
          //    icon: Icon(
          //     Icons.crop_rotate,
          //     size: 27,
          //    )),

          //    IconButton(onPressed: (){},
          //    icon: Icon(
          //     Icons.emoji_emotions_outlined,
          //     size: 27,
          //    )),

          //    IconButton(onPressed: (){},
          //    icon: Icon(
          //     Icons.title,
          //     size: 27,
          //    )),

          //    IconButton(onPressed: (){},
          //    icon: Icon(
          //     Icons.edit,
          //     size: 27,
          //    )),
          // ],
        ),

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-350,
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.cover
                  )
                ),
              ),

              SizedBox(height: 50,),
               Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(15),
                        color: constants.purple
                        )
                      ,
                      child: InkWell(
                        hoverColor: Colors.white,
                        onTap: (){
                          sendStories(widget.imagePath, context);
                        },
                        child: Center(
                          child: Text("Select",
                            style: TextStyle(
                              color: Colors.white
                            ),)),
                      ),
                    ),
            ],
          )
        ),
      );
  }

      void sendStories(String imgPath, BuildContext context) async {
    print("Hey there , it is working $imgPath ");

    

    // >>>>>>>>>>>>>>work on the back end, test the cloudinary before you send in the working end point
    var request = http.MultipartRequest(
        'Post',
        Uri.parse(
            "https://chatup-node-deploy.herokuapp.com/posts/uploadImage"));

    // The field name is the key value that we used when we were writing the end point
    request.fields['token'] = getX.read(constants.GETX_TOKEN);
    request.files.add(await http.MultipartFile.fromPath('image', imgPath));
    request.headers.addAll({"Content-type": "multipart/form-data"});

    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = await json.decode(httpResponse.body);
    print(data["img_url"]);
    // updateUserImage;
    Navigator.pop(context);
    print(response.statusCode);

    // setting the models before sending them through the socket
    Map<dynamic,dynamic> userModel= {
      "name": senderName,
      "profileImage": senderImage,
      "id": senderID
    };


    Map<dynamic, dynamic> storyModel = {
      "url": data["img_url"],
      "media": "MediaType.image",
      "user": {
        "name": senderName,
        "profileImage": senderImage,
        "id": senderID
      },
      "duration": 7
    };

    print("send stories to socket is about to get called");
    widget.sendStoriesToSocket(
      userModel,
      storyModel
    );
    print("send stories to socket was called successfully");


  }

}

