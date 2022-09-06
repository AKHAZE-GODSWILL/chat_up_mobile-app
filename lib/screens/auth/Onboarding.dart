
import 'package:chat_up/screens/auth/SignUp.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:localstorage/localstorage.dart';
import 'package:localstorage/localstorage.dart';

import '../../main.dart';

class Onboarding extends StatefulWidget{

  @override 
  State<Onboarding> createState()=> _OnboardingState ();

 
}

class _OnboardingState extends State<Onboarding> {


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
                    image: AssetImage("assets/Illustration.png"),
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


              SizedBox(
                  height:100
                ),

              
              Text("Terms and privacy policy"),


              SizedBox(
                  height:30
                ),

              GestureDetector(
                
                onTap: (){

                    Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> SignUp()
                    ));

                },

                child: Container(

                  width: 327,
                  height:52,
                  decoration: BoxDecoration(

                    color: Constants().purple,
                    borderRadius: BorderRadius.circular(30)
                  ),

                  child: Center(child: Text("Start messaging",
                  
                          style: TextStyle(
                            color: Colors.white
                          ))),
                ))

            ],
          ),
        ),
      );
    }


 
}



