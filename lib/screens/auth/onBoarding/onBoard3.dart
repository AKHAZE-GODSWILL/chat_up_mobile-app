
import 'package:chat_up/screens/auth/SignUp.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class ThirdOnBoard extends StatefulWidget{

  @override 
  State<ThirdOnBoard> createState()=> _ThirdOnBoard ();

 
}

class _ThirdOnBoard extends State<ThirdOnBoard> {


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
                    image: AssetImage("assets/Illustration3.png"),
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
                        Text("Automatically add your",
                         style: TextStyle(
                          fontSize:24
                         )),
                        Text("contacts to ChatUp",
                        
                          style: TextStyle(
                          fontSize:24
                         )),


                        
                      ],
              )),


              


              

              

            ],
          ),
        ),
      );
    }


 
}



