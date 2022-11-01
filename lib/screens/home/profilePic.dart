import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chat_up/main.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget{
    const ProfilePic({Key? key, required this.imgPath, required this.updateUserImage}) : super(key: key);

    final String imgPath;
    final Function updateUserImage;

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
                    File(imgPath),
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
                          onUpdateProfileImage(imgPath, context);
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

    void onUpdateProfileImage(String imgPath, BuildContext context) async {
    print("Hey there , it is working $imgPath ");

    

    // >>>>>>>>>>>>>>work on the back end, test the cloudinary before you send in the working end point
    var request = http.MultipartRequest(
        'Post',
        Uri.parse(
            "https://chatup-node-deploy.herokuapp.com/posts/updateProfilePic"));

    // The field name is the key value that we used when we were writing the end point
    request.fields['token'] = getX.read(constants.GETX_TOKEN);
    request.files.add(await http.MultipartFile.fromPath('image', imgPath));
    request.headers.addAll({"Content-type": "multipart/form-data"});

    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = await json.decode(httpResponse.body);
    print(data["user"]["img"]);
    getX.write(constants.GETX_USER_IMAGE, data["user"]["img"]);
    updateUserImage;
    Navigator.pop(context);
    print(response.statusCode);

  }
}