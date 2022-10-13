
import 'package:chat_up/main.dart';
import 'package:chat_up/screens/auth/fakeLogin.dart';
import 'package:chat_up/screens/home/bottomNavBar.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Login extends StatefulWidget{


  State<Login> createState()=> _Login();
}

class _Login extends State<Login>{


  @override 

  Widget build(BuildContext context){

        return Scaffold(

          resizeToAvoidBottomInset: false,
          body: Container(

            width: double.infinity,
            height: double.infinity,
            color: Constants().purple,

            child: Stack(
              children: [

                Container(

                  width: MediaQuery.of(context).size.width,
                  height:400,
                  
                    decoration: BoxDecoration(
                    image: DecorationImage(
                  
                    image: AssetImage("assets/picBackground.png"),
                    fit: BoxFit.cover,
                    
                  )
                ),
                ),


                Positioned(
                  
                  top: 150,
                  bottom: 10,
                  right: 5,
                  left: 5,
                  child: Container(

                    margin: EdgeInsets.only(right: 10, left: 10),
                    width: 360,
                    height: 640,

                    decoration: BoxDecoration(
                      
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)
                ),

                    child: Column(
                      children:[

                        SizedBox(
                          height: 10
                        ),

                        Text("Login",
                        
                          style: TextStyle(
                            fontSize:24
                         )
                        ),

                        SizedBox(
                          height: 10
                        ),

                        Container(

                          
                          height: 280,
                          
                          child: Column(
                            
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          

                             SizedBox(
                              height: 20,
                             ),

                             Padding(
                                padding: const EdgeInsets.only(left:20, bottom: 5),
                                child: Text("Email",
                          
                            style: TextStyle(
                            fontSize:14
                                                   )
                                                  ),
                              ),
                          
                             Container(
                              height: 51,
                              margin: EdgeInsets.only(left: 20,right: 20),
                               child: TextField(
                          
                                            style: TextStyle(
                                              color: constants.purple
                                            ),
                          
                                            
                                            
                                            cursorColor: Constants().purple,
                                            controller: emailController,
                                            decoration: InputDecoration(
                          
                                              // How the border looks like when you are not typing
                                              
                                              fillColor: Constants().textFieldColor,
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                          
                                                borderSide: BorderSide(color: Colors.white),
                                                borderRadius: BorderRadius.circular(20)
                                              ),
                          
                                              // How the border looks like when you are typing
                                              focusedBorder: OutlineInputBorder(
                          
                                                borderSide: BorderSide(color: Colors.white),
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                          
                                              // The send icon 
                                              
                                            ),
                                          ),
                             ),

                             SizedBox(
                              height: 20,
                             ),

                             Padding(
                                padding: const EdgeInsets.only(left:20, bottom: 5),
                                child: Text("Password",
                          
                            style: TextStyle(
                            fontSize:14
                                                   )
                                                  ),
                              ),
                          
                             Container(
                              height: 51,
                              margin: EdgeInsets.only(left: 20,right: 20),
                               child: TextField(
                          
                                            style: TextStyle(
                                              color: constants.purple
                                            ),
                          
                                            
                                            
                                            cursorColor: Constants().purple,
                                            controller: passwordController,
                                            decoration: InputDecoration(
                          
                                              // How the border looks like when you are not typing
                                              
                                              fillColor: Constants().textFieldColor,
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                          
                                                borderSide: BorderSide(color: Colors.white),
                                                borderRadius: BorderRadius.circular(20)
                                              ),
                          
                                              // How the border looks like when you are typing
                                              focusedBorder: OutlineInputBorder(
                          
                                                borderSide: BorderSide(color: Colors.white),
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                          
                                              // The send icon 
                                              
                                            ),
                                          ),
                             ),


                             
                          
                            ],
                          )
                        ),

                        SizedBox(
                          height: 180,
                        ),

                        GestureDetector(
                
                onTap: (){

                    Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> FakeLogin()
                    ));

                },

                child: Container(

                  width: MediaQuery.of(context).size.width-100,
                  height:52,
                  decoration: BoxDecoration(

                    color: Constants().purple,
                    borderRadius: BorderRadius.circular(10)
                  ),

                  child: Center(child: Text("LOGIN",
                  
                          style: TextStyle(
                            color: Colors.white
                          ))),
                )),


                SizedBox(
                          height: 20,
                        ),

                      ]
                    ),
                  ))
              ],
            ),
          ),
        );
  }
}