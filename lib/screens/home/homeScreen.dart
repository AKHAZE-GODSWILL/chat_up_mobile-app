


import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/screens/inbox/chatScreen.dart';
import 'package:chat_up/screens/inbox/newChatScreen.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{

  const HomeScreen({Key? key, required this.chatModels, required this.sourceChat}) : super(key: key);
 final List<ChatModel> chatModels;
 final ChatModel sourceChat;
  State<HomeScreen> createState()=> _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{@override
  void initState() {
    print("");
                             print(widget.sourceChat);
    super.initState();
  }




  // List<ChatModel> chats = [
  //   ChatModel(name: "Mira Deebug", 
  //     icon: "person.svg", 
  //     isGroup: false, 
  //     time: "12:30", 
  //     currentMessage: "Hope say you don reach office"
    
  //   ),

  //   ChatModel(
  //     name: "Mr Promise", 
  //     icon: "person.svg", 
  //     isGroup: false, 
  //     time: "11:23", 
  //     currentMessage: "Push to the repo now"
    
  //   ),

  //   ChatModel(
  //     name: "Netflix Nigeria", 
  //     icon: "group.svg", 
  //     isGroup: true, 
  //     time: "4:17", 
  //     currentMessage: "Hope yall have eaten"
      
  //     ),

  //   ChatModel(
  //     name: "Emma Igbin", 
  //     icon: "person.svg", 
  //     isGroup: false, 
  //     time: "7:12", 
  //     currentMessage: "Haffa I have your done your animations"
      
  //     ),

  //     ChatModel(
  //       name: "Google for all nations", 
  //       icon: "group.svg", 
  //       isGroup: true, 
  //       time: "9:29", 
  //       currentMessage: "All your salaries are ready")


  // ];

  @override 

  Widget build(BuildContext context){

        return Scaffold(


                body: Column(
                  children: [



                    Expanded(
            child: ListView.builder(
              // controller: _scrollController,
              shrinkWrap: true,
              itemCount:  widget.chatModels.length,
              
              // usersList.length,
              
              itemBuilder: (context, index)=>Padding(
                padding: const EdgeInsets.only(left: 4, right:4, top:1, bottom:1),
                child: Container(
                  margin: EdgeInsets.all(5),
                  
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      
                      Center(
                        child: CustomCard(chatModel: widget.chatModels[index], sourceChat : widget.sourceChat)
                        )
                      
                
                      
                    ],
                  )
                ),
              ),
            ),
        ),
                  ]
                )
          
        );
  }
}

class CustomCard extends StatelessWidget{

      const CustomCard({Key? key, required this.chatModel, required this.sourceChat}) : super(key: key);
      final ChatModel chatModel;
      final ChatModel sourceChat;

      @override 
      Widget build(BuildContext context){

          return InkWell(

              onTap: (){

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NewChatScreen(chatModels: chatModel, sourceChat: sourceChat)
                    ));
              },

              child: ListTile(
                            leading: CircleAvatar(
                        
                              
                
                               backgroundColor: Constants().purple ,
                
                               child: chatModel.isGroup? Icon(Icons.people,
                          size: 24, color: Colors.black) : 
                          
                          Icon(Icons.person,
                          size: 24, color: Colors.black) ,
                        
                              // backgroundImage: NetworkImage("${usersList[index]["img_url"]}"),
                
                        
                              // child: Icon(Icons.person,
                              //     size: 24, color: Colors.black)
                            ),
                        
                            title:Text(chatModel.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),),
                        
                            subtitle: Text(chatModel.currentMessage,
                                style: TextStyle(
                            color: Constants().unReadGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                                ),),
                        
                            trailing: Column(
                              children: [
                                Text(chatModel.time,
                                style:TextStyle(
                            color: Constants().unReadGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                                ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                                ,
                                CircleAvatar(
                                
                                                  radius:10,
                                                  backgroundColor: Constants().unReadGrey ,
                                
                                                  child: Text("1", style: TextStyle(
                                                    color: Color(0xFF001A83)
                                                  ))
                                  ),
                              ],
                            )
                            ) ,
          );

      }
}