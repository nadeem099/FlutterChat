import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/helper/constants.dart';
import 'package:flutterchat/helper/authenticate.dart';
import 'package:flutterchat/helper/helperfunction.dart';
import 'package:flutterchat/services/auth.dart';
import 'package:flutterchat/services/database.dart';
import 'package:flutterchat/views/conversation.dart';
import 'package:flutterchat/views/search.dart';
import 'package:flutterchat/views/signin.dart';
import 'package:flutterchat/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({ Key? key }) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream? chatRoomsStream;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRoom(Constants.myName).then((val){
      setState(() {
        chatRoomsStream = val;
      });
    });
  }

  // ignore: non_constant_identifier_names
  Widget ChatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Container(
            child: Text("Here is something when data doesn't load"),
          );
        }else{
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return ChatRoomsTile(
                userName: snapshot.data.docs[index]["chatroomid"]
                .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                chatroomid: snapshot.data.docs[index]["chatroomid"],
              );
            }
          );
        }
      }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", height: 50),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut()
              .then((value) => print(value));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding:  EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.logout)
            )
          )
        ],
      ),
      body: Container(
        child: ChatRoomList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search()));
        },
        ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatroomid;
  const ChatRoomsTile({required this.userName, required this.chatroomid});

  @override
  Widget build(BuildContext context) {
    // print(userName.substring(0));
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(chatRoomId: chatroomid)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        color: Color(0xff1f0f33),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.purple
              ),
              child: Text(
                userName != "" ? "${userName.substring(0,1).toUpperCase()}" : Constants.myName.substring(0,1).toUpperCase(),
                style: mediumTextStyle(),
              ),
            ),
            SizedBox(width: 8,),
            userName != "" ?
            Text(userName, style: mediumTextStyle()) :
            Text(Constants.myName, style: mediumTextStyle())
          ]
        ),
      ),
    );
  }
}


