import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterchat/helper/authenticate.dart';
import 'package:flutterchat/helper/helperfunction.dart';
import 'package:flutterchat/views/chatRoomsScreen.dart';
import 'package:flutterchat/views/signin.dart';
import 'package:flutterchat/views/signup.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(  
    MyApp()
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) => {
      setState((){
        isLoggedIn = value;
      })
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        // primaryColor: Color(0xff763b96),
        scaffoldBackgroundColor: Color(0xff1f0f26),
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn == null ? Container() : (isLoggedIn == true ? ChatRoom() : Authenticate())
    );
  }
}
