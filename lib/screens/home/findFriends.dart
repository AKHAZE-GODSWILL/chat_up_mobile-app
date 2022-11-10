
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_up/screens/inbox/newChatScreen.dart';
import 'package:chat_up/utils/api_requests.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FindFriends extends StatefulWidget{

  const FindFriends({Key? key, required this.sendMessageToSocket}) : super(key: key);
  final Function sendMessageToSocket;
  State<FindFriends> createState()=> _FindFriends();
}

class _FindFriends extends State<FindFriends>{

  TextEditingController searchController = TextEditingController();
  List<dynamic> usersList = [];
  bool isSearching = false;
  bool isGroup = false;
  int loadingState = 0;
  //loading state 0 is loading
  //loading state 1 is success
  //loading state 2 is no data found
  //loading state 3 is network error
  //loading state 4 is some error occured
  //loading state 5 is server error
  
  @override
  void initState() {

    loadUsersFromLocalDataBase();
    print("init state is runnig. After the load users from local data base");
    loadUsersFromServer();
    print("Load users from the server ran successfully");
    // the endpoint to update this current databasew
    // with new users will come here and it will be
    // asynchronous
    super.initState();
  }

  loadUsersFromLocalDataBase() {
    usersList.clear();
    print("We are in the loading users from database method");
    final contactBox =  Hive.box('contacts');
    
    
    var contacts = contactBox.toMap().values.toList();
    print('local database data is${contactBox.values.toList()}');
    if(contacts.isEmpty){   
      setState((){
        
        loadingState = 2;
      });
    }
    else{
      print("The else statement in the loadusers from database ran and I cleared the list here ");
      setState((){
        loadingState = 1;
        usersList = contacts;
       });
    }
    
  }

    void loadUsersFromServer() {

    viewAllUsers().then((response) {
      if (response['msg'] == "success") {
       
       print(">>>>>>>>>>>>> The server response comes in here ${response['allUsers']}");     
        print('>>>>>>>>>>>>>>> ${response['allUsers'].length}');

        addContacts(response['allUsers']);
          setState(() {
            
            usersList.clear();
            usersList.addAll(response['allUsers']);
            loadingState = 1;
          });

        loadUsersFromLocalDataBase;
        
      } else {
        loadingState = 4;
      }

      setState(() {});
    }).catchError((e) {
      /////////////////////////////////////////////////////////////////////////
      if (e is SocketException) {
        
        print("The network error block ran instead in the catch error block");
        loadingState = 3;
      } else {
        usersList.clear();
        loadingState = 4;
      }
    });
  }

   addContacts(List contacts) async{
    final contactBox = Hive.box('contacts');
    contactBox.clear().then((value) {
      for(var d in contacts){
      contactBox.add(d);
    }
    });
    
  }

  // The method used to search through the database for local data
  searchContacts(query){
    final contactBox = Hive.box('contacts');
    usersList.clear();
    isSearching = false;
    print(contactBox.values);
    query.isNotEmpty? setState((){
      usersList.addAll(contactBox.values
        .where((c){
          return c['fullname']
            .toLowerCase()
            .contains(query);

          }
        )
      );

      print(usersList);
    })
    :
    (){};
  }

  @override 

  Widget build(BuildContext context){

        return Scaffold(
           appBar:AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            backgroundColor: Colors.white,
            title:Column(
              children: [
                SizedBox(height:30),
                Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.grey[300],

                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            setState(() {
                              isSearching = true;
                            });

                            searchContacts(searchController.text.toLowerCase().trim());
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: isSearching
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: CircularProgressIndicator(),
                                )
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    searchController.clear();
                                    usersList.clear();
                                    loadUsersFromLocalDataBase();  
                                  },
                                ),

                          // contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                          hintText: "Search fullname",
                          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height:30),
              ],
            ),),
          body: buildBody()
          
        );
  }

  // this build body method is responsible for changing the Ui of the app based on the data available

  Widget buildBody(){
    if(loadingState == 0){
      return Center(child: CircularProgressIndicator());
    }
    else if(loadingState == 2){
      return Center(child: Text("No Contacts found"));
    }
    else if(loadingState == 3){
      return Center(child: Text("Something went wrong with your connection. Try again"));
    }
    else if(loadingState == 4){
      return Center(child: Text("Some error occured. Try again"));
    }
    else if(loadingState == 5){
      return Center(child: Text("Something went wrong with the server. Try again"));
    }
    else if(loadingState == 1){
      return  Column(
            children: [
                Expanded(
                  child: ListView.builder(
                  // controller: _scrollController,
                    shrinkWrap: true,
                    itemCount:  usersList.length,
                    // usersList.length, 
                    itemBuilder: (context, index)=>Padding(
                      padding: const EdgeInsets.only(left: 4, right:4, top:1, bottom:1),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [                 
                            // Debug this place later abeg............. or this code go crash
                            Center(child: CustomCard(users: usersList[index], isGroup: isGroup, sendMessageToSocket: widget.sendMessageToSocket))  
                          ],
                        )
                      ),
                    ),
                  ),
                ),
            ]
           );
    }
    else{
      return SizedBox();
    }
  }
}

class CustomCard extends StatelessWidget{

      const CustomCard({Key? key,required this.users, required this.isGroup, required this.sendMessageToSocket}) : super(key: key);
      final Map<dynamic,dynamic> users;
      final bool isGroup;
      final Function sendMessageToSocket;

      @override 
      Widget build(BuildContext context){

          return InkWell(

              onTap: (){

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NewChatScreen( receiverID: users['_id'], receiverName: users['fullname'], receiverImage: users['img'],sendMessageToSocket: sendMessageToSocket)
                    ));
              },

              child: ListTile(
                            leading: Container(

                              child: Stack(
                                children:[
                                   Container(
                                                      
                                  
                                   width: 48,
                                   height: 48,
                                   decoration: BoxDecoration(
                                      color: Constants().purple ,
                                      borderRadius: BorderRadius.circular(15)
                                   ),
                                                          
                                   child: users['img']== "" ? Icon(Icons.person,
                                                        size: 24, color: Colors.white)  : 
                                                        
                                          CachedNetworkImage(
                                          imageUrl: users['img'],
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

                            
                                ]
                              ),
                            ),
                        
                            title:Text(users['fullname'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),),
                      
                            ) ,
          );

      }
}