


import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_up/main.dart';
import 'package:chat_up/screens/auth/SignUp.dart';
import 'package:chat_up/screens/home/profilePic.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends StatefulWidget{


  State<Settings> createState()=> _Settings();
}

class _Settings extends State<Settings>{

  bool isLoading = false;
  String updatedImage = "";
  String imgPath = "";
  String imgExt = "";

  File? readyUploadImage;
  bool hasImg = false;
  @override
  void initState() {
    
    updatedImage = getX.read(constants.GETX_USER_IMAGE);
    super.initState();
  }
  @override 

  Widget build(BuildContext context){

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Center(
              child: Text("Edit Profile",
              style: TextStyle(
                color: Colors.black
              ),),
            )
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Center(
                  child: Container(

                              width: 180,
                              height: 180,
                              child: Stack(
                                children:[
                                   Center(
                                     child: CircleAvatar(
                                                        
                                  
                                     radius:90,
                                     backgroundColor:Colors.grey,
                                                            
                                     child: updatedImage == "" ? Icon(Icons.person,
                                         size: 100, color:Colors.white)
                                         : CachedNetworkImage(
                                          imageUrl: updatedImage,
                                          imageBuilder: (context, imageProvider) => Container(
                                            width: 180.0,
                                            height: 180.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider, fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          ) ,
                                ),
                                   ),

                               Positioned(
                                  bottom: 0,
                                  right:0,
                                  child: GestureDetector(
                                    onTap: (){
                                      sendPicture(context);
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: constants.purple,
                                         child: Icon(
                                          Icons.edit_outlined,
                                          size: 20, color: Colors.white) ,
                                      ),
                                    ),
                                  ),
                                )
                                ]
                              ),
                            ),     
                ),
                SizedBox(height: 50,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Full name",
                      style: TextStyle(
                        color: Colors.grey
                      )
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width:MediaQuery.of(context).size.width-40,
                      height: 30,
                      child: Text(getX.read(constants.GETX_FULLNAME)),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide.none,
                          left: BorderSide.none,
                          right: BorderSide.none,
                          bottom: BorderSide(
                            style: BorderStyle.solid,
                            width: 2,
                            color: Colors.grey
                          )
                        )
                      ),  ),

                    SizedBox(height: 30,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email",
                        style: TextStyle(
                          color: Colors.grey
                        )
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width:MediaQuery.of(context).size.width-40,
                        height: 30,
                        child: Text(getX.read(constants.GETX_EMAIL)),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide.none,
                            left: BorderSide.none,
                            right: BorderSide.none,
                            bottom: BorderSide(
                              style: BorderStyle.solid,
                              width: 2,
                            color: Colors.grey
                            )
                          )
                        ),  )
                    ],
                  ),

                  SizedBox(height: 30,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("password",
                        style: TextStyle(
                          color: Colors.grey
                        )
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width:MediaQuery.of(context).size.width-40,
                        height: 30,
                        child: Text("********",
                          style: TextStyle(
                            color: Colors.grey
                          ),),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide.none,
                            left: BorderSide.none,
                            right: BorderSide.none,
                            bottom: BorderSide(
                              style: BorderStyle.solid,
                              width: 2,
                            color: Colors.grey
                            )
                          )
                        ),  )
                    ],
                  ),
                    ],
                  ),

                SizedBox(height: 70,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

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
                          logOut();
                        },
                        child: Center(
                          child: isLoading== false?Text("Log out",
                            style: TextStyle(
                              color: Colors.white
                            ),)
                            
                            :CircularProgressIndicator()),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
  }

  updateLocalProfilePic(){
    setState(() {
      updatedImage = getX.read(constants.GETX_USER_IMAGE);
    });
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
                    "Choose profile pic from:",
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
                          backgroundColor: constants.purple,
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
                          backgroundColor: constants.purple,
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
                  ProfilePic(imgPath: imgPath, updateUserImage: updateLocalProfilePic,)));
    });
  }


  
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
                  ProfilePic(imgPath: imgPath, updateUserImage: updateLocalProfilePic,))); //onSendImage
    });
  }

  logOut(){
    print("Login method called successfully");
    Hive.box('messages').clear();
    Hive.box('contacts').clear();
    Hive.box('chats').clear();
    Hive.box('storySenders').clear();
    Hive.box('stories').clear();
    getX.remove(constants.GETX_FULLNAME);
    getX.remove(constants.GETX_IS_LOGGED_IN);
    getX.remove(constants.GETX_USER_ID);
    getX.remove(constants.GETX_USER_IMAGE);
    getX.remove(constants.GETX_TOKEN);

    print("Everything deleted successfully");
    Navigator.pushReplacement(context, 
    MaterialPageRoute(
      builder: (context)=> SignUp()
    ));
  }

  
}