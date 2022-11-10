
import 'package:chat_up/model/chatModel.dart';
import 'package:chat_up/model/messageModel.dart';
import 'package:chat_up/model/storiesModel.dart';
import 'package:chat_up/model/storiesSenderModel.dart';
import 'package:chat_up/screens/auth/onBoarding/onBoard.dart';
import 'package:chat_up/screens/home/bottomNavBar.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:chat_up/utils/myWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;



////// Phase 1
/// I need to fix the unresponsive problem of the onBoarding screeens
/// Also need to fix the unsent messages problem and the unreceived messages problem
/// also the best way to render the chats using the timestamp gotten from the server
// should be able to implement the podcast feature and
/// the voice over feature over your own texts
/// Also implement the audio recording on your status and the content management system in the app.
/// Check the function of the streamed response and the toSubString in dart
/// Find out the reason why the print statement has not been working since, but the end point is firing
/// If there is no data, the sent image does not even display on the senders screen. I fix that bug

/// I need to work on the Text area to keep increasing anytime more texts enter
/// I need to find a way to make all the texts not enter the Home screen after some place their should be elipses
Constants constants = Constants();
final getX = GetStorage();
final myWidgets = MyWidgets();

// From my observations, I noticed that we had to call the adapters first,
// Than await all the open box operations. If not, you have errors at the very 
// moment of opening the app
Future <void> main() async{
  // final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ChatModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());
  Hive.registerAdapter(StoriesSenderModelAdapter());
  Hive.registerAdapter(StoriesModelAdapter());

  await Hive.openBox('messages');
  await Hive.openBox('contacts');
  await Hive.openBox('chats');
  await Hive.openBox('storySenders');
  await Hive.openBox('stories');
 
  await GetStorage.init();
  
  runApp( MyApp());
  
}

class MyApp extends StatelessWidget {
  
  

  MyApp();


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Chat Up',
      

      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),

//getX.read(constants.GETX_IS_LOGGED_IN) == "true" ? BottomNavBar() : MyOnboarding()
      home:getX.read(constants.GETX_IS_LOGGED_IN) == "true" ? BottomNavBar() : MyOnboarding()
    );
  }
}

