
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_up/controller/chatController.dart';
import 'package:chat_up/controller/chatListController.dart';
import 'package:chat_up/main.dart';
import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/model/storiesSenderModel.dart';
import 'package:chat_up/screens/home/findFriends.dart';
import 'package:chat_up/screens/home/stories/stories.dart';
import 'package:chat_up/screens/home/stories/addStories.dart';
import 'package:chat_up/screens/inbox/newChatScreen.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget{

  const HomeScreen({Key? key, required this.sendMessageToSocket, required this.sendStoriesToSocket, required this.sendWaveToSocket}) : super(key: key);
  final Function sendMessageToSocket;
  final Function sendStoriesToSocket;
  final Function sendWaveToSocket;
  State<HomeScreen> createState()=> _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{

  ScrollController _scrollController = ScrollController();
  ChatController chatController = Get.put(ChatController());
  ChatListController chatListController = Get.put(ChatListController());

  List<ChatModel> usersList = [];
  bool isGroup= false;
  bool isFAB = false;
  Box chatsBox = Hive.box('chats');
  Box storiesSenderBox = Hive.box('storySenders');
  // Future openBox()async{
  //   chatsBox = await Hive.openBox('chats');
  // }
  @override
  void initState() {

    print('before the box has been accessed in the init state');
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        setState(() {
          isFAB = true;
        });
      }
      else{
        setState(() {
          isFAB = false;
        });
      }
    });
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                  floatingActionButton: isFAB? buildAnimatedFAB(): buildFAB(),
                  body: SingleChildScrollView(
                    controller: _scrollController,
                    physics: ScrollPhysics(),
                    child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [

                        Container(
                          height:100,
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              
                              children: [
                                SizedBox(width: 12,),

                                Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.push(context,
                                            MaterialPageRoute(builder: (context)=> AddStories(sendStoriesToSocket: widget.sendStoriesToSocket,)));
                                        },
                                        child: Container(
                                        // color: Colors.red,
                                        width: 70,
                                        height: 100,
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    //  color: Colors.blue ,
                                                    border: Border.all(
                                                      color: Color(0XFFADB5BD),
                                                      width: 2
                                                    ),
                                                     borderRadius: BorderRadius.circular(16)
                                                  ),
                                                   
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Container(
                                                                       
                                                    
                                                    width: 48,
                                                    height: 48,
                                                    decoration: BoxDecoration(
                                                       color: Color(0XFFF7F7FC) ,
                                                       borderRadius: BorderRadius.circular(16)
                                                    ),
                                                                           
                                                    child:Icon(Icons.add,
                                                              size: 24, color: Color(0XFFADB5BD)) ,
                                                    ),
                                                ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: 10,),

                                            Text("Your Story",
                                            style: TextStyle(
                                              fontSize: 10
                                            ))
                                          ],
                                        ),
                                      ),
                                      ),
                                    ),

                                ValueListenableBuilder(

                                  valueListenable: storiesSenderBox.listenable(), 
                                  builder: (context, Box storiesUser, _){
                                    List<int> keys = storiesSenderBox.keys.cast<int>().toList();
                                    keys = keys.reversed.toList();
                                    return ListView.builder(
                                      
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: keys.length,
                                      itemBuilder: (context, index) {
                                        // ChatModel oneUser = chatsBox.getAt(0);
                                        final int key = keys[index];
                                        final StoriesSenderModel storyUser = storiesSenderBox.get(key)!;
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.push(context,
                                                MaterialPageRoute(builder: ((context) => Stories(storyUserId: storyUser.id))
                                                )
                                              );
                                            },
                                            child: customStatusSender(storyUser)
                                          ),
                                        );
                                      },
                                );
                                  })

                              ],
                            ),
                          ),
                        ),
                  
                        GetBuilder<ChatListController>(
                          builder: (_){

                            return ListView.builder(
                        
                      // controller: _scrollController,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:  chatListController.usersList.length, 
                       // usersList.length,
                       itemBuilder: (context, index){
                        

                        final ChatModel chat = chatListController.usersList[index];
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
                                  sendMessageToSocket: widget.sendMessageToSocket,
                                  sendWaveToSocket: widget.sendWaveToSocket
                                )
                              )       
                            ],
                          )
                         ),
                       );}
                    );
                          })

                              ]
                            ),
                  )
          
        );
      
  }


  Widget buildAnimatedFAB(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      height: 50,
      width: 170,
      child: FloatingActionButton.extended(
        backgroundColor: constants.purple,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FindFriends(sendMessageToSocket: widget.sendMessageToSocket, sendWaveToSocket: widget.sendWaveToSocket),));
        },
        icon: Icon(
          Icons.search
        ),
        label: Center(
          child: Text("Search Friends",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12
            ),)
        )),
    );
  }

  Widget buildFAB(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      height: 50,
      width: 50,
      child: FloatingActionButton.extended(
        backgroundColor: constants.purple,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FindFriends(sendMessageToSocket: widget.sendMessageToSocket, sendWaveToSocket: widget.sendWaveToSocket),));
        },
        icon: Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Icon(Icons.search),
        ),
        label: SizedBox()),
    );
  }

  Widget customStatusSender(storyUser){
    return Container(
      // color: Colors.red,
      width: 70,
      height: 100,
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    // color: Colors.blue ,
                    border: Border.all(
                      color: Color(0XFF2C37E1),
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(16)
                  ),
                                                    
                ),

                Container(
                  margin: EdgeInsets.all(4),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey ,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child:storyUser.profileImage== "" ? Icon(
                    Icons.person,
                    size: 24, color: Colors.white)  : 
                                                          
                    CachedNetworkImage(
                      imageUrl: storyUser.profileImage,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: imageProvider, 
                            fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ) ,
                ),
              ],
            ),
          ),

          SizedBox(height: 10,),
          Text(storyUser.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10
            )
          )
        ],
      ),
    );
  }

  readChats()async{
    final chatBox =  await Hive.box('chats');

    //   print(chatBox.values.toList());
    //    usersList.addAll(chatBox.values.toList().cast<ChatModel>());
    // print(">>>>>>>>> the users list is ${usersList}");
    chatListController.usersList.clear();
    chatListController.showChatsFromDB(allChats: chatBox.values.toList().cast<ChatModel>());
   
  }
}

class CustomChatCard extends StatelessWidget{

      const CustomChatCard({Key? key,required this.user, required this.isGroup, required this.sendMessageToSocket, required this.sendWaveToSocket}) : super(key: key);
      final Function sendMessageToSocket;
      final Function sendWaveToSocket;
      final ChatModel user;
      final bool isGroup;

      @override 
      Widget build(BuildContext context){

          return InkWell(

              onTap: (){
                    print(user.isOnline);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NewChatScreen( receiverID: user.id, receiverName: user.name, receiverImage: user.img,sendMessageToSocket: sendMessageToSocket, sendWaveToSocket: sendWaveToSocket)
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
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),),
                        
                            subtitle: 
                            Text(user.currentMessage,
                                overflow: TextOverflow.ellipsis,
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