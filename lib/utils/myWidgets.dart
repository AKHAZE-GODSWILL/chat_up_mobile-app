

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_up/screens/home/bottomNavBar.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletons/skeletons.dart';

import '../main.dart';

class MyWidgets {

  appBar(
      {required BuildContext ctx, required String title, bool toHome = false}) {
    return AppBar(
      toolbarHeight: 45,
      elevation: 0.5,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(ctx).pop();
          // toHome? Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => const BottomNavBar())) : Navigator.pop(ctx);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ),
      ),
      backgroundColor: Colors.white,
      title: Container(
        
        margin: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right:20.0),
          child: IconButton(onPressed: (){

            
          },
               icon: Icon(
                Icons.waving_hand,
                size: 27,
                color: Colors.grey,
               )),
        ),
      ],
      // centerTitle: true,
    );
  }

  dialog(
      {required BuildContext ctx,
      required String title,
      required String content,
      required String firstAction,
      required String secondAction,
      required screen}) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: Constants().purple,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: Text(
                firstAction,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                secondAction,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => screen));
              },
            )
          ],
        );
      },
    );
  }

  dynamic showToast({required String message}){
      //ios uses uiAlertView, similar to those error dialogs i used in login/register
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message)
    //   )
    // );
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.TOP);
  }

  dynamic showCustomWaveToast(BuildContext context, String userImage, String userName){
    showToastWidget(
      Container(
        
       
        height: 100,
        width: MediaQuery.of(context).size.width-40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.black.withOpacity(0.4),
        ),
        child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                                                        
                                    margin: EdgeInsets.only(
                                      top: 5,
                                      left: 40),
                                     width: 48,
                                     height: 48,
                                     decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15)
                                     ),
                                                            
                                     child: userImage== "" ? Icon(Icons.person,
                                                          size: 24, color: Colors.white)  : 
                                                          
                                        CachedNetworkImage(
                                          imageUrl: userImage,
                                          imageBuilder: (context, imageProvider) => Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              image: DecorationImage(
                                                image: imageProvider, fit: BoxFit.cover),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          ) ,
                  
                                          
                                                        
                                ),
                  
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 5),
                                    Container(
                                      width: 120,
                                      height: 20,
                                      child: Text(userName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white
                                        )
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: 120,
                                      height: 20,
                                      child: Center(
                                        child: Text("Waved at you",


                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white
                                          )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(

                width: 90,
                height:70,
              
                child: Lottie.network("https://assets3.lottiefiles.com/private_files/lf30_ergur6xz.json"),
            ),
              )
                        ],
                      ),
      ),
    context: context,
    position: StyledToastPosition.top,
    animation: StyledToastAnimation.scale,
    curve: Curves.bounceOut,
    animDuration: Duration(milliseconds: 1500),
    duration: Duration(seconds:7));
  }

  Widget buildCachedImage(String url,
      {double height = 100,
      // width = double.maxFinite,
      double width = 100,
      BoxFit fit = BoxFit.cover}) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, url) => SkeletonItem(
        child: SkeletonAvatar(
            style: SkeletonAvatarStyle(width: height, height: width)),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget ownMessageCard({context, message}){

      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: ConstrainedBox(constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width-45,
            
          ),
          
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16),
               topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                 bottomRight:Radius.circular(0) ),),
            color: Constants().purple,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 45, right: 10, top: 10, bottom: 25),
                  child: Text(message.message, 
                  
                  style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                    )),
                ),
              Positioned(
                bottom: 4,
                right: 5,
                child: Row(
                  
                  children: [
                    
                      
                      Text("${message.time}",
              
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                    )
                      ),
              
                      SizedBox(width: 4,),
                      Text("Read",
                      
                      
                          style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                    )),
              
                     SizedBox(width: 4,),
              
                            
                  ],
                ),
              )
              ],
            ),
          ),),
        ),
      );

  }

  Widget replyCard({context, message}){

      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: ConstrainedBox(constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width-45,
            
          ),
          
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16),
               topRight: Radius.circular(16),
                bottomLeft: Radius.circular(0),
                 bottomRight:Radius.circular(16) ),),
            color: Colors.white,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 45, top: 10, bottom: 25),
                  child: Text("${message.message}", 
                  
                  style: TextStyle(
                                color: Constants().purple,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                    )),
                ),
              Positioned(
                bottom: 4,
                left: 10,
                child: Row(
                  
                  children: [
                    
                      
                      Text("${message.time}",
              
                            style: TextStyle(
                                color: Constants().purple,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                    )
                      ),
              
                      // SizedBox(width: 4,),
                      // Text("Read",
                      
                      
                      //     style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 10,
                      //               )),
              
                     SizedBox(width: 4,),
              
                            
                  ],
                ),
              )
              ],
            ),
          ),),
        ),
      );

  }

  Widget ownPictureCard(context, imgPath, message){

      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: Container(
            constraints: BoxConstraints(
              minHeight: 150,
              maxWidth: 230
            ),
            // width: MediaQuery.of(context).size.width/1.4,
            decoration: BoxDecoration(
              color: constants.purple,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Column(
              
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: 150,
                    maxHeight: 200,
                    minWidth: 230,
                    maxWidth: 230
                    ),
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                          File(imgPath),
                          fit: BoxFit.cover),),
            
            ),
                
                
            
                message != null? Text("${message.message}",
                    style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                                )
                ): SizedBox(),
              ],

              // Card(
                  
              //     margin: EdgeInsets.all(3),
              //     shape: RoundedRectangleBorder(
              //       borderRadius:BorderRadius.circular(16)
              //     ),
              //     child: Image.file(
              //       File(imgPath),
              //       fit: BoxFit.fill),
              //   ),
            ),
          ),
        ),
      );
  }


  Widget replyPictureCard(context, imgPath,message ){

      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: Container(
            constraints: BoxConstraints(
              minHeight: 150,
              maxWidth: 230
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Column(
              
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: 150,
                    maxHeight: 200,
                    minWidth: 230,
                    maxWidth: 230
                    ),
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: imgPath,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 180.0,
                      height: 180.0,
                      decoration: BoxDecoration(
                        
                        image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
            
            ),
                
                
            
                message != null? Text("${message.message}",
                    style: TextStyle(
                            color: constants.purple,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                                )
                ): SizedBox(),
              ],

            
            ),
          ),
        ),
      );
  }
}

// Column(
//                 children: [
//                   Image.network(
//                     "https://chatup-node-deploy.herokuapp.com/uploads/$imgPath",
//                     fit: BoxFit.cover),
//                     message != null? Text("$message"): SizedBox(),
//                 ],
//               ),