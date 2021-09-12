import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/helper/authenticate.dart';
import 'package:flutterchat/helper/helperfunction.dart';
import 'package:flutterchat/services/database.dart';
import 'package:flutterchat/views/chatRoomsScreen.dart';
import 'package:flutterchat/widgets/widget.dart';
import 'package:flutterchat/services/auth.dart';


class Signup extends StatefulWidget {
  final Function toggle;

  const Signup(this.toggle);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  // @override 
  // void initState() {
  //   super.initState();
  //   Firebase.initializeApp().whenComplete(() {
  //     print("completed");
  //     setState(() {});
  //   });
  // }

  void signUpForNewUser() {
    //checking the validation status and updating isLoading
    if(formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      //signing up the user
      authMethods.signUpUsingEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)
      .then((value) { 
        print(value);
        print(value.userId);
      });
      
      //creating a map of user details 
      //NOTE: if collection has mixed field datatypes than dynamic type map should be created
      //NOTE: writing it here might cause the problem in userMap creation better to write before seting isLoading=true
      Map<String,String> userMap = {"name": userNameTextEditingController.text, "email": emailTextEditingController.text}; 
      //updating the database with new user
      databaseMethods.updateUserDetail(userMap);

      HelperFunctions.saveUserLoggedInSharedPreference(true);
      HelperFunctions.saveUserNameInSharePreference(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailInSharePreference(emailTextEditingController.text);

      //navigating to chatroom page
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ChatRoom()
          )
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return isLoading ? 
    Center(child: CircularProgressIndicator()) :
    Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 88,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val!.isEmpty || val.length < 3 ? "Username should be atleast three characters long" : null; 
                        },
                        controller: userNameTextEditingController,
                        cursorColor: Colors.white,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('username'),
                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val as String) ? 
                                 null : "Enter a valid email";
                        },
                        controller: emailTextEditingController,
                        cursorColor: Colors.white,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('email'),
                      ),
                      TextFormField(
                        validator: (val){
                          return val!.length < 6 ? "Password should be atleast six characters long" : null; 
                        },
                        obscureText: true,
                        controller: passwordTextEditingController,
                        cursorColor: Colors.white,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: (){
                    signUpForNewUser();
                    print("Signup clicked");
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
                        'Sign Up',
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
                    'Sign Up with Google',
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
                    Text("Already have an account? ", style: mediumTextStyle()),
                    InkWell(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                      padding:  EdgeInsets.symmetric(vertical: 10),
                      child: Text('Signin now', style: TextStyle(
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