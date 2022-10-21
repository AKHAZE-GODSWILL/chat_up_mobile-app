

import 'package:chat_up/screens/home/findFriends.dart';
import 'package:chat_up/screens/home/homeScreen.dart';
import 'package:chat_up/screens/home/settings.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class BottomNavBar extends StatefulWidget{

  const BottomNavBar({Key? key}) : super(key: key);
  State<BottomNavBar> createState()=> _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar>{

    // final _myBox = Hive.box('myBox');

    @override
    void initState() {
    print("bottom nav bar");
    super.initState();
    }
    
    //code to read data into the database
    void readData(){
      
    }
    
    //code to write data into the database
    void writeData(){

    }
    //Code to delete data from the database
    void deleteData(){

    }
    int current_index = 1;
  

  // ignore: non_constant_identifier_names
  void update_index(int value) {
    setState(() {
      current_index = value;
    });
  }


  


  @override 

  Widget build(BuildContext context){


        List screens = [
    // HomePage(response: widget.response),
    FindFriends(),
    HomeScreen(),
    Settings(),
  ];

        return Scaffold(

            body: screens[current_index],

            bottomNavigationBar: BottomNavigationBar(
          enableFeedback: false,
          iconSize: 17,
          backgroundColor: Colors.grey.shade200,
          type: BottomNavigationBarType.fixed,
          currentIndex: current_index,
          onTap: update_index,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: const TextStyle(
            overflow: TextOverflow.visible,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          showUnselectedLabels: true,
          selectedItemColor: Colors.green,
          selectedLabelStyle: const TextStyle(
            overflow: TextOverflow.visible,
            fontSize: 10,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 7, top: 6),
                child: Icon(
                  Icons.people,
                  size: 24,
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 3),
                child: Icon(
                  Icons.people,
                  size: 24,
                  color: Constants().purple,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 7, top: 6),

                // Reminder to update the texts and how they look like
                child: Text("chats")
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 3),
                child: Text("chats",
                
                style: TextStyle(
                            color: Constants().purple
                          )),
              ),


              label: '',
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 7, top: 6),
                child: Text("...")
                
                // Icon(Icons.history_outlined,
                //     size: 24, color: Color.fromRGBO(0, 0, 0, 0.5)),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 3),
                child: Text("...",
                
                    style: TextStyle(
                            color: Constants().purple
                          )
                )
                
                // CircleAvatar(
                //     minRadius: 15,
                //     backgroundColor: Constants().primaryColor,
                //     child: Icon(Icons.history,
                //         size: 24, color: Constants().primaryBackgroundColor)),
              ),


              label: '',
            ),
            
          ]),
          
        );
  }
}