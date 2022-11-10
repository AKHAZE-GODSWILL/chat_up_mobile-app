
import 'dart:io';

import 'package:chat_up/main.dart';
import 'package:chat_up/screens/home/stories/sendStories.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/adapters.dart';

class AddStories extends StatefulWidget{

  const AddStories({Key? key, required this.sendStoriesToSocket}) : super(key: key);
  final sendStoriesToSocket;
  State<AddStories> createState()=> _AddStories();
}

class _AddStories extends State<AddStories>{
    int current_index = 0;

    @override
    void initState() {
    print("add stories nav bar");
    super.initState();
    }
  

  // ignore: non_constant_identifier_names
  void update_index(int value) {
    setState(() {
      current_index = value;
    });
  }


  @override 

  Widget build(BuildContext context){


        List screens = [
    // HomePage(response: widget.response),
    CallCamera(sendStoriesToSocket: widget.sendStoriesToSocket),
    CallGallery(sendStoriesToSocket: widget.sendStoriesToSocket),
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
              icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.black,
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
              activeIcon: Column(
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
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.black,
                          child: Icon(Icons.image),
                        ),
                        SizedBox(height: 5),
                        Text("Gallery",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      ],
                    ),
              activeIcon: Column(
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


              label: '',
            ),
            
          ]),
          
        );
  }

}


class CallCamera extends StatefulWidget{

  CallCamera({Key? key, required this.sendStoriesToSocket}) : super(key: key);
  final sendStoriesToSocket;
  State<CallCamera> createState()=> _CallCamera();
}

class _CallCamera extends State<CallCamera>{
    File? readyUploadImage;
    String imgPath = "";
    String imgExt = "";
    bool hasImg = false;

  @override
  initState(){
    print("The init state of the call camera screen works");
    getImageCamera();
    super.initState();
  }

  @override 

  Widget build(BuildContext context){

        return Scaffold(
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
                  SendStories(imagePath: imgPath, sendStoriesToSocket: widget.sendStoriesToSocket,)));
    });
  }
}


class CallGallery extends StatefulWidget{

  CallGallery({Key? key, required this.sendStoriesToSocket}) : super(key: key);
  final sendStoriesToSocket;
  State<CallGallery> createState()=> _CallGallery();
}

class _CallGallery extends State<CallGallery>{
    File? readyUploadImage;
    String imgPath = "";
    String imgExt = "";
    bool hasImg = false;

  @override
  initState(){
    super.initState();
    getImageGallery();
  }

  @override 

  Widget build(BuildContext context){

        return Scaffold();
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
                  SendStories(imagePath: imgPath, sendStoriesToSocket: widget.sendStoriesToSocket)));
    });
  }
}