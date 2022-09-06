import 'package:chat_up/screens/auth/Onboarding.dart';
import 'package:chat_up/screens/inbox/chatScreen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:redux/redux.dart';
// import 'package:redux_thunk/redux_thunk.dart';



Future <void> main() async{
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  
  // final Store<ChatState> store;

  MyApp();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Chat Up',
      

      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),

      initialRoute: "onboarding",
      routes: {

        "onboarding": (BuildContext context) => Onboarding(),
        "chatScreen": (BuildContext context) => ChatScreen(),
      },
    );
  }
}

