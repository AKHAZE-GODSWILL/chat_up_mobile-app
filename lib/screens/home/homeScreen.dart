
import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/screens/inbox/newChatScreen.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget{

  const HomeScreen({Key? key}) : super(key: key);
  State<HomeScreen> createState()=> _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  List<ChatModel> usersList = [];
  bool isGroup= false;
  Box chatsBox = Hive.box('chats');
  // Future openBox()async{
  //   chatsBox = await Hive.openBox('chats');
  // }
  @override
  void initState() {

    print('before the box has been accessed in the init state');
    readChats();
    print("after the box has been accessed in the init state");
    // final chatBox = Hive.box('chat');
    // final chatBox = Hive.box('chats');
    // usersList.addAll(chatBox.values.toList()
    // .cast<ChatModel>()
    // );
    super.initState();
  }


  @override 

  Widget build(BuildContext context){
      
        return Scaffold(
                  body: Column(
                     children: [
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: chatsBox.listenable(),
                  
                          builder: (context, Box chat, _,){
                            List<int> keys = chatsBox.keys.cast<int>().toList();
                            keys = keys.reversed.toList();
                            return ListView.builder(
                      
                    // controller: _scrollController,
                    
                    shrinkWrap: true,
                    itemCount:  keys.length, 
                     // usersList.length,
                     itemBuilder: (context, index){
                      
                      final int key = keys[index];
                      final ChatModel chat = chatsBox.get(key)!;
                      return Padding(
                      
                       padding: const EdgeInsets.only(left: 4, right:4, top:1, bottom:1),
                       child: Container(
                          margin: EdgeInsets.all(5),
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              // Debug this place later abeg............. or this code go crash
                              Center(
                                child: CustomChatCard(
                                  users: chat,
                                  isGroup: isGroup
                                )
                              )       
                            ],
                          )
                       ),
                     );}
                  );
                  },
                ),
              ),
            ]
          )
          
        );
      
  }

  readChats()async{
    final chatBox =  await Hive.box('chats');
    setState(() {
      print(chatBox.values.toList());
       usersList.addAll(chatBox.values.toList().cast<ChatModel>());
    print(">>>>>>>>> the users list is ${usersList}");
    });
   

  }
}

class CustomChatCard extends StatelessWidget{

      const CustomChatCard({Key? key,required this.users, required this.isGroup}) : super(key: key);
      final ChatModel users;
      final bool isGroup;

      @override 
      Widget build(BuildContext context){

          return InkWell(

              onTap: (){

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NewChatScreen( receiverID: users.id, receiverName: users.name)
                    ));
              },

              child: ListTile(
                            leading: Container(
                        
                              
                               width: 40,
                               height: 40,
                               decoration: BoxDecoration(
                                  color: Constants().purple ,
                                  borderRadius: BorderRadius.circular(15)
                               ),

                               child: isGroup? Icon(Icons.people,
                          size: 24, color: Colors.black) : 
                          
                          Icon(Icons.person,
                          size: 24, color: Colors.black) ,
                        
                              // backgroundImage: NetworkImage("${usersList[index]["img_url"]}"),
                
                        
                              // child: Icon(Icons.person,
                              //     size: 24, color: Colors.black)
                            ),
                        
                            title:Text(users.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),),
                        
                            subtitle: 
                            Text(users.currentMessage,
                                style: TextStyle(
                            color: Constants().unReadGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                                ),),
                        
                            trailing: Column(
                              children: [

                                Text(users.time,
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
                                  child: Text("1", 
                                    style: TextStyle(color: Color(0xFF001A83))
                                  )
                                ),
                              ],
                            )
                            ) ,
          );

      }
}