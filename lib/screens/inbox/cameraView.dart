import 'dart:io';

import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';

class CameraViewPage extends StatelessWidget{
    const CameraViewPage({Key? key, required this.imgPath, required this.onSendImage }) : super(key: key);

    final String imgPath;
    final Function onSendImage;
    static TextEditingController _controller = TextEditingController();

    @override 

    Widget build(BuildContext context){

      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(onPressed: (){},
             icon: Icon(
              Icons.crop_rotate,
              size: 27,
             )),

             IconButton(onPressed: (){},
             icon: Icon(
              Icons.emoji_emotions_outlined,
              size: 27,
             )),

             IconButton(onPressed: (){},
             icon: Icon(
              Icons.title,
              size: 27,
             )),

             IconButton(onPressed: (){},
             icon: Icon(
              Icons.edit,
              size: 27,
             )),
          ],
        ),

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-150,
                child: Image.file(
                  File(imgPath),
                  fit: BoxFit.cover
                )
              ),

              Positioned(
                bottom:0,
                child: Container(
                  color: Colors.black26,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                      ),
                    decoration: InputDecoration(
                      hintText: "Add Caption...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                      ),
                      prefixIcon: Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      suffixIcon: InkWell(
                        onTap: () => onSendImage(imgPath, _controller.text.trim()),
                        child: CircleAvatar(
                           backgroundColor: Constants().purple,
                           radius: 27,
                           child: Icon(
                            Icons.send,
                            // size: 27,
                            color: Colors.white,
                           ),
                         )
                      ),
                      border: InputBorder.none
                    )
                  ),
                ),
              )
            ],
          )
        ),
      );
    }
}