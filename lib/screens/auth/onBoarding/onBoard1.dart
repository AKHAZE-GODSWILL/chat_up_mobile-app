
import 'package:chat_up/screens/auth/SignUp.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class FirstOnBoard extends StatefulWidget{

  @override 
  State<FirstOnBoard> createState()=> _FirstOnBoard ();

 
}

class _FirstOnBoard extends State<FirstOnBoard> {


    @override 
    Widget build(BuildContext context){

      return Scaffold(
        backgroundColor: Colors.white,
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
                    image: AssetImage("assets/Illustration1.png"),
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
                        Text("Connect easily with",
                         style: TextStyle(
                          fontSize:24
                         )),
                        Text("your family and friends",
                        
                          style: TextStyle(
                          fontSize:24
                         )),


                        Text("over countries",
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



