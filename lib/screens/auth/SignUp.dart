
import 'dart:convert';

import 'package:chat_up/main.dart';
import 'package:chat_up/screens/auth/Login.dart';
import 'package:chat_up/screens/home/bottomNavBar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget{


  State<SignUp> createState()=> _SignUp();
}

class _SignUp extends State<SignUp>{

  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  int loadingState = 0;

  String httpBaseUrl = "chatup-node-deploy.herokuapp.com";

  @override 

  Widget build(BuildContext context){

        return Scaffold(

          resizeToAvoidBottomInset: false,
          body: Container(

            width: double.infinity,
            height: double.infinity,
            color: constants.purple,

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
                                              color: constants.purple
                                            ),
                          
                                            
                                            
                                            cursorColor: constants.purple,
                                            controller: fullNameController,
                                            decoration: InputDecoration(
                          
                                              // How the border looks like when you are not typing
                                              
                                              fillColor: constants.textFieldColor,
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
                              child:
                               TextField(
                                 style: TextStyle(color: constants.purple), 
                                 cursorColor: constants.purple,
                                 controller: emailController,
                                 decoration: 
                                  InputDecoration(
                                     // How the border looks like when you are not typing        
                                    fillColor: constants.textFieldColor,
                                    filled: true,
                                    enabledBorder: 
                                      OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                          
                                      // How the border looks like when you are typing
                                    focusedBorder:
                                     OutlineInputBorder(
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
                          
                                            
                                            
                                            cursorColor: constants.purple,
                                            controller: passwordController,
                                            decoration: InputDecoration(
                          
                                              // How the border looks like when you are not typing
                                              
                                              fillColor: constants.textFieldColor,
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

                    signUpUser(
                      fullname: fullNameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim()
                    );

                },

                child: Container(

                  width: MediaQuery.of(context).size.width-100,
                  height:52,
                  decoration: BoxDecoration(

                    color: constants.purple,
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
                                  color: constants.purple
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

  signUpUser({required fullname, required email,required password}) async {
    setState(() {
      loadingState = 1;
    });
    http.Client client = http.Client();
    try {
      http.Response response = await client.post(
        Uri.https(httpBaseUrl,"/auth/signup"),
        body: json.encode(
          {
            "fullname": fullname,
            "email": email,
            "password": password,
          },
        ),
        headers: {
          "Content-Type": "application/json"
        },
      );
      dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      print(decodedResponse);
      print(">>>>>>>>>> ${decodedResponse["status"]}, ${decodedResponse["msg"]}, ${decodedResponse["user"]}");
      if (decodedResponse["status"] == "ok") {
        print('>>>>>>>>>>>>>>>>>>>>>>> $decodedResponse ');

        /////////// change this place before you move forward
        getX.write(constants.GETX_TOKEN, decodedResponse["token"]);
        getX.write(constants.GETX_FULLNAME, decodedResponse["user"]["fullname"]);
        getX.write(constants.GETX_IS_LOGGED_IN, "true");
        getX.write(constants.GETX_USER_ID, decodedResponse["user"]["_id"]);
        getX.write(constants.GETX_EMAIL, decodedResponse["user"]["email"]);
        // changed this place also remember to send the image url in the response being sent back
        getX.write(constants.GETX_USER_IMAGE, decodedResponse["user"]["img"]);

        setState(() {
          loadingState = 2;
        });

        print("I got here this is after setting the loading state back to 2, immediately before the push");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context)=> BottomNavBar()
          )
        );
      } else {
        setState(() {
          loadingState = 0;
        });
      }

      print("I got here this is after the push");
    } catch (e) {
      setState(() {
        loadingState = 0;
      });
      print('>>>>>>>>>>>>>>>>>>>>>>> $e');
      return e;
    }
  }
}