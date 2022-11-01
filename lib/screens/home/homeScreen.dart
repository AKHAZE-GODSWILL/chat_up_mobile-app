
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_up/main.dart';
import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/screens/inbox/newChatScreen.dart';
import 'package:chat_up/screens/inbox/stories.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:chat_up/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget{

  const HomeScreen({Key? key, required this.sendMessageToSocket}) : super(key: key);
  final Function sendMessageToSocket;
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
            backgroundColor: Colors.white,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: Text("Chats",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black)),
                    actions: [
            IconButton(onPressed: (){},
             icon: Icon(
              Icons.chat,
              size: 27,
              color: Colors.grey,
             )),

             IconButton(onPressed: (){},
             icon: Icon(
              Icons.list,
              size: 27,
              color: Colors.grey,
             )),]
                  ),
                  body: Column(
                    
                     children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 16,
                          top: 10,
                          bottom:40
                          
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  // ChatModel oneUser = chatsBox.getAt(0);
                                  return index == 0? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: (){},
                                      child: Container(

                                      width: 52,
                                      height: 52,
                                      child: Center(
                                        child: Container(
                                                           
                                          
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                           color: Colors.grey ,
                                           borderRadius: BorderRadius.circular(15)
                                        ),
                                                               
                                        child:Icon(Icons.add,
                                                  size: 24, color: Colors.black) ,
                                                           
                                          // backgroundImage: NetworkImage("${usersList[index]["img_url"]}"),
                                                   
                                                           
                                          // child: Icon(Icons.person,
                                          //     size: 24, color: Colors.black)
                                        ),
                                      ),
                                    ),
                                    ),
                                  ):Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: ((context) => Stories(storyItems: stories))
                                          )
                                        );
                                      },
                                      child: Container(

                                      width: 52,
                                      height: 52,
                                      child: Center(
                                        child: Container(
                                                           
                                          
                                        width: 48,
                                        height: 48,
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
                                      ),
                                    ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

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
                              Center(
                                child: CustomChatCard(
                                  user: chat,
                                  isGroup: isGroup,
                                  sendMessageToSocket: widget.sendMessageToSocket
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

      const CustomChatCard({Key? key,required this.user, required this.isGroup, required this.sendMessageToSocket}) : super(key: key);
      final Function sendMessageToSocket;
      final ChatModel user;
      final bool isGroup;

      @override 
      Widget build(BuildContext context){

          return InkWell(

              onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NewChatScreen( receiverID: user.id, receiverName: user.name, receiverImage: user.img,sendMessageToSocket: sendMessageToSocket)
                    ));
              },

              child: ListTile(
                            leading: Container(

                              width: 52,
                              height: 52,
                              child: Stack(
                                children:[
                                   Center(
                                     child: Container(
                                                        
                                  
                                     width: 48,
                                     height: 48,
                                     decoration: BoxDecoration(
                                        color: Constants().purple ,
                                        borderRadius: BorderRadius.circular(15)
                                     ),
                                                            
                                     child: user.img== "" ? Icon(Icons.person,
                                                          size: 24, color: Colors.white)  : 
                                                          
                                        CachedNetworkImage(
                                          imageUrl: user.img,
                                          imageBuilder: (context, imageProvider) => Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              image: DecorationImage(
                                                image: imageProvider, fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          ) ,
                                                        
                                ),
                                   ),

                               user.isOnline? Positioned(
                                  top: 0,
                                  right:0,
                                  child: CircleAvatar(
                                    radius: 7.3,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                ): SizedBox()
                                ]
                              ),
                            ),
                        
                            title:Text(user.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),),
                        
                            subtitle: 
                            Text(user.currentMessage,
                                style: TextStyle(
                            color: user.seen == true? constants.readGrey: constants.unRead ,
                            fontWeight: user.seen == true?FontWeight.w400: FontWeight.w700,
                            fontSize: 13,
                                ),),
                        
                            trailing: Column(
                              children: [

                                Text(user.time,
                                style:TextStyle(
                            color: constants.unRead,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                                ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                                ,
                                user.seen == false?
                                CircleAvatar(
                                  radius:10,
                                  backgroundColor: constants.unRead ,
                                  child: Text("${user.unReadMsgCount}", 
                                    style: TextStyle(color: Colors.white)
                                  )
                                ):SizedBox(),
                              ],
                            )
                            ) ,
          );

      }
}