
import 'dart:io';

import 'package:chat_up/screens/inbox/newChatScreen.dart';
import 'package:chat_up/utils/api_requests.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FindFriends extends StatefulWidget{

  const FindFriends({Key? key}) : super(key: key);
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
    print("We are in the loading users from database method");
    final contactBox =  Hive.box('contacts');
    var contacts = contactBox.toMap().values.toList();
    print('local database data is${contactBox.values.toList()}');
    if(contacts.isEmpty){   
      setState((){
        loadingState = 2;
        usersList.add('empty');
      });
    }
    else{
      setState((){
        loadingState = 1;
        usersList.clear();
        usersList = contacts;
       });
    }
    
  }

    void loadUsersFromServer() {

    viewAllUsers().then((response) {
      if (response['msg'] == "success") {
       
       print(response['allUsers']);       
        print('>>>>>>>>>>>>>>> ${response['allUsers'].length}');
        addContacts(response['allUsers']);
        loadUsersFromLocalDataBase();
        
        setState(() {
          
          print('>>>>>>>>>>>>>>> my set state ran successfully... meaning the problem is not here');
          searchController.text = '';
          // clear all previous users in the local database before adding fresh sets
          //>>>>>>>>>>> change this place later. Setting it to false just for the purose of testing
        });
      } else {
        loadingState = 4;
      }

      setState(() {});
    }).catchError((e) {
      /////////////////////////////////////////////////////////////////////////
      if (e is SocketException) {
        
        print("The network error block ran instead in the catch error block");
        loadingState = 3;
        loadUsersFromLocalDataBase();
      } else {
        loadingState = 4;
      }
      // setState(() {
      //   isSearching = false;
      // });
    });
  }

  //>>>>>>>>>>>> come back to this place later abeg. I don tire
  // make sure you comeback abeg

  Future addContacts(List contacts) async{
    final contactBox = Hive.box('contacts');
    contactBox.clear();
    
    for(var d in contacts){
      contactBox.add(d);
    }
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
            elevation: 1,
            backgroundColor: Colors.white,
            title:Column(
              children: [
                SizedBox(height:13),
                Padding(
                    padding: const EdgeInsets.all(12),
                    child: Card(
                      
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: Colors.grey[100],
                      child: Container(
                        color: Colors.grey[300],
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
                            Center(child: CustomCard(users: usersList[index], isGroup: isGroup))  
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

      const CustomCard({Key? key,required this.users, required this.isGroup}) : super(key: key);
      final Map<dynamic,dynamic> users;
      final bool isGroup;

      @override 
      Widget build(BuildContext context){

          return InkWell(

              onTap: (){

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NewChatScreen( receiverID: users['_id'], receiverName: users['fullname'])
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
                        
                            title:Text(users['fullname'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),),
                      
                            ) ,
          );

      }
}