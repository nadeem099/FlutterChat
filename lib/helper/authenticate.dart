import 'package:flutter/material.dart';
import 'package:flutterchat/views/signin.dart';
import 'package:flutterchat/views/signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({ Key? key }) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignin = true;

  void toggleView(){
    setState(() {
      showSignin = !showSignin; 
    });
    // print(showSignin);
  }
  
  @override
  Widget build(BuildContext context) {
    if(showSignin){
      return Signin(toggleView);
    }else{
      return Signup(toggleView);
    }
  }
}