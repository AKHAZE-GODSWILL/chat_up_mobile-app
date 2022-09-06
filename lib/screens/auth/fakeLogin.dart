


import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/screens/home/bottomNavBar.dart';
import 'package:chat_up/screens/home/homeScreen.dart';
import 'package:chat_up/screens/inbox/newChatScreen.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';

class FakeLogin extends StatefulWidget{


  State<FakeLogin> createState()=> _FakeLogin();
}

class _FakeLogin extends State<FakeLogin>{


  @override 

  Widget build(BuildContext context){

        ChatModel sourceChat;
        List<ChatModel> chatModels = [
    ChatModel(
      id:1,
      name: "Mira Deebug", 
      icon: "person.svg", 
      isGroup: false, 
      time: "12:30", 
      currentMessage: "Hope say you don reach office"
    
    ),

    ChatModel(
      id:2,
      name: "Mr Promise", 
      icon: "person.svg", 
      isGroup: false, 
      time: "11:23", 
      currentMessage: "Push to the repo now"
    
    ),

    // ChatModel(
    //   name: "Netflix Nigeria", 
    //   icon: "group.svg", 
    //   isGroup: true, 
    //   time: "4:17", 
    //   currentMessage: "Hope yall have eaten"
      
      // ),

    ChatModel(
      id:3,
      name: "Emma Igbin", 
      icon: "person.svg", 
      isGroup: false, 
      time: "7:12", 
      currentMessage: "Haffa I have your done your animations"
      
      ),

    ChatModel(
      id:4,
      name: "Joana", 
      icon: "person.svg", 
      isGroup: false, 
      time: "7:12", 
      currentMessage: "I can work on an e commerce server application now"
      
      ),

      // ChatModel(
      //   name: "Google for all nations", 
      //   icon: "group.svg", 
      //   isGroup: true, 
      //   time: "9:29", 
      //   currentMessage: "All your salaries are ready")


  ];
        return Scaffold(
          body: ListView.builder(
              // controller: _scrollController,
              shrinkWrap: true,
              itemCount:  chatModels.length,
              
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
                        child: InkWell(
                          
                          onTap: (){


                            // This piece of code removes the model of the owner of the account and puts it 
                            // in a source list
                             sourceChat = chatModels.removeAt(index);
                             Navigator.pushReplacement(context,MaterialPageRoute(
                              builder: (context)=> BottomNavBar(chatModels: chatModels, sourceChat: sourceChat
                              )
                             ));

                             print("fake Login screen");
                             print(sourceChat);

                          },
                          child: ButtonCard(chatModel: chatModels[index].name, ))
                        )
                      
                
                      
                    ],
                  )
                ),
              ),
            ),
        );
  }
}


class ButtonCard extends StatelessWidget{

      const ButtonCard({Key? key, required this.chatModel}) : super(key: key);
      final String chatModel;

      @override 
      Widget build(BuildContext context){

          return ListTile(
                        leading: CircleAvatar(
                    
                          
            
                           backgroundColor: Constants().purple ,
             
                           child: Icon(Icons.person,
                      size: 24, color: Colors.black) ,
                    
                          // backgroundImage: NetworkImage("${usersList[index]["img_url"]}"),
            
                    
                          // child: Icon(Icons.person,
                          //     size: 24, color: Colors.black)
                        ),
                    
                        title:Text(chatModel,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),),
                    
                        // subtitle: Text(chatModel.currentMessage,
                        //     style: TextStyle(
                        // color: Constants().unReadGrey,
                        // fontWeight: FontWeight.w400,
                        // fontSize: 13,
                        //     ),),
                    
                        
                        );

      }
}