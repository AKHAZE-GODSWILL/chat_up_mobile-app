
import 'package:chat_up/screens/auth/Login.dart';
import 'package:chat_up/screens/auth/fakeLogin.dart';
import 'package:chat_up/screens/home/bottomNavBar.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';



TextEditingController fullnameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class SignUp extends StatefulWidget{


  State<SignUp> createState()=> _SignUp();
}

class _SignUp extends State<SignUp>{


  @override 

  Widget build(BuildContext context){

        return Scaffold(

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
                  
                  top: 70,
                  bottom: 10,
                  right: 5,
                  left: 5,
                  child: Container(

                    margin: EdgeInsets.only(right: 10, left: 10),
                    width: 360,
                    height: 735,

                    decoration: BoxDecoration(
                      
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)
                ),

                    child: Column(
                      children:[

                        SizedBox(
                          height: 10
                        ),

                        Text("First time?",
                        
                          style: TextStyle(
                            fontSize:24
                         )
                        ),

                        SizedBox(
                          height: 10
                        ),

                        Text("Sign up with email",

                            style: TextStyle(
                            fontSize:14
                         )
                        ),

                        SizedBox(
                          height: 30
                        ),

                        Container(

                          
                          height: 280,
                          
                          child: Column(
                            
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          
                              Padding(
                                padding: const EdgeInsets.only(left:20, bottom: 5),
                                child: Text("Full name",
                          
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
                                              color: Colors.white
                                            ),
                          
                                            
                                            
                                            cursorColor: Constants().purple,
                                            controller: fullnameController,
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
                                              color: Colors.white
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
                                              color: Colors.white
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
                          height: 150,
                        ),

                        GestureDetector(
                
                onTap: (){

                    Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> FakeLogin()
                    ));

                },

                child: Container(

                  width: 327,
                  height:52,
                  decoration: BoxDecoration(

                    color: Constants().purple,
                    borderRadius: BorderRadius.circular(10)
                  ),

                  child: Center(child: Text("SIGN UP",
                  
                          style: TextStyle(
                            color: Colors.white
                          ))),
                )),


                SizedBox(
                          height: 20,
                        ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a user?",
                      
                              style: TextStyle(
                                color: Colors.black
                              )),

                    SizedBox(
                          width: 10,
                        ),

                    GestureDetector(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> Login()
                        ));
                      },
                      child: Text("Login",
                        
                                style: TextStyle(
                                  color: Constants().purple
                                )),
                    ),
                  ],
                )
                      ]
                    ),
                  ))
              ],
            ),
          ),
        );
  }
}