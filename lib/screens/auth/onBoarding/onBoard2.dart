
import 'package:chat_up/screens/auth/SignUp.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class SecondOnBoard extends StatefulWidget{

  @override 
  State<SecondOnBoard> createState()=> _SecondOnBoard ();

 
}

class _SecondOnBoard extends State<SecondOnBoard> {


    @override 
    Widget build(BuildContext context){

      return Scaffold(

        body: Container(

            width: double.infinity,
            height: double.infinity,

          child: Column(

            children: [

                SizedBox(
                  height:100
                ),


                Container(
      
                    width:300,
                    height:300,

                    decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage("assets/Illustration2.png"),
                    fit: BoxFit.fitHeight
                  )
                ),
        
              ),


              SizedBox(
                  height:10
                ),


              Container(
                
                child: Column(
                    children: [
                        Text("Do realtime messaging,",
                         style: TextStyle(
                          fontSize:24
                         )),
                        Text("send photos, videos and",
                        
                          style: TextStyle(
                          fontSize:24
                         )),


                        Text("voicenotes",
                          style: TextStyle(
                          fontSize:24
                         ) ),
                      ],
              )),


              


              

              

            ],
          ),
        ),
      );
    }


 
}



