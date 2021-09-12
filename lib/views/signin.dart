import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/helper/authenticate.dart';
import 'package:flutterchat/helper/helperfunction.dart';
import 'package:flutterchat/services/database.dart';
import 'package:flutterchat/views/chatRoomsScreen.dart';
import 'package:flutterchat/views/signup.dart';
import 'package:flutterchat/widgets/widget.dart';
import 'package:flutterchat/services/auth.dart';


class Signin extends StatefulWidget {
  Function toggle;
  Signin(this.toggle);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {



  bool isAuthenticated = true;
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot? userNameQuerySnapShot;

  void signInForRegisteredUser(){
    setState(() {
      isLoading = true;
    });
    HelperFunctions.saveUserEmailInSharePreference(emailTextEditingController.text);
    authMethods.signInUsingEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)
    .then((value) {
      print(value);
      if(value != null){
        setState(() {
          isAuthenticated = true;
        });
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
          userNameQuerySnapShot = val;
          HelperFunctions.saveUserNameInSharePreference(userNameQuerySnapShot!.docs[0].get("name"));
          }
        );
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ChatRoom()
        )
      );
      }else{
        setState(() {
          isAuthenticated = false;
          isLoading = false;
        });
      }
    });
  }

  void forgotPassword(){
    setState(() {
      isLoading = true;
    });
    authMethods.resetPassword(emailTextEditingController.text)
    .then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ?
       Center(child: CircularProgressIndicator()) :
       SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 88,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                !isAuthenticated? 
                AlertDialog(
                  title: Text("Invalid Email or Password"),
                  backgroundColor: Colors.red,
                  titleTextStyle: TextStyle(color: Colors.white70),
                ):
                SizedBox(),
                TextField(
                  controller: emailTextEditingController,
                  cursorColor: Colors.white,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration('email'),
                ),
                TextField(
                  obscureText: true,
                  controller: passwordTextEditingController,
                  cursorColor: Colors.white,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration('password'),
                ),
                //adding some vertical space
                SizedBox(height: 8),
                //implementing forgot password (row widget can also be used)
                GestureDetector(
                  onTap: (){
                    forgotPassword();
                    print("forgot password clicked");
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(  
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
                      child: Text('Forgot Password?', style: simpleTextStyle()),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: (){
                    signInForRegisteredUser();
                    print("Signing is clicked");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff763b96),
                          const Color(0xffbc53f5)
                        ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 16
                        ),
                      ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(
                    'Sign In with Google',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17
                    ),
                    ),
                ),
                SizedBox(height: 16),
                //if we use richtext then we wont be able to provide clickable subpart
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account? ", style: mediumTextStyle()),
                    InkWell(
                      onTap: (){
                          widget.toggle();
                      },
                      child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('Register now', style: TextStyle(
                        color: Colors.white, 
                        fontSize: 17,
                        decoration: TextDecoration.underline
                        )
                      ),
                      )
                    ),
                  ],
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}