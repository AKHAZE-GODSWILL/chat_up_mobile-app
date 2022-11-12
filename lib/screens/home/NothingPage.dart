


import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_up/main.dart';
import 'package:chat_up/screens/auth/SignUp.dart';
import 'package:chat_up/screens/home/profilePic.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class NothingPage extends StatefulWidget{


  State<NothingPage> createState()=> _NothingPage();
}

class _NothingPage extends State<NothingPage>{


  @override
  void initState() {
    
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
            
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(

                  width: MediaQuery.of(context).size.width,
                  height:400,
              
                  child: Lottie.network("https://assets4.lottiefiles.com/packages/lf20_CNKtTnfKBG.json"),
            ),
              ),
                ),

              Container(
                height: 150,
                width: MediaQuery.of(context).size.width-40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),

                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("There is nothing to see here. Go find Joy somewhere else",
                      style: TextStyle(
                        color: constants.purple,
                        fontSize: 25
                      ),
                      textAlign: TextAlign.center,),
                  ),
                ),
              )
              ]
            ),
          ),
        );
  }

  
}