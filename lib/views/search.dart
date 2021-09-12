import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/helper/constants.dart';
import 'package:flutterchat/services/database.dart';
import 'package:flutterchat/views/chatRoomsScreen.dart';
import 'package:flutterchat/views/conversation.dart';
import 'package:flutterchat/widgets/widget.dart';

class Search extends StatefulWidget {
  const Search({ Key? key }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot? searchSnapshot;
  bool showSearchTile = false;


  void initiateSearch(){
    searchSnapshot = databaseMethods.getUserByUsername(searchTextEditingController.text)
    .then((val){
      setState(() {
        searchSnapshot = val;
        showSearchTile = true;
      });
    });
  }


  Widget searchList(){
    return !showSearchTile ?
    Container() :
    ListView.builder(
      itemCount: searchSnapshot!.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return SearchTile(
          username: searchSnapshot!.docs[index].get("name"),
          email: searchSnapshot!.docs[index].get("email"),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      controller: searchTextEditingController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "search username ...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                    )),
                    GestureDetector(
                      onTap: (){
                        initiateSearch();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff9b54e3),
                              const Color(0xffbc53f5)
                            ]
                          )
                        ),
                        padding: EdgeInsets.all(12),
                        
                        child: Image.asset("assets/images/search_white.png", 
                        color: Colors.black, 
                        )
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              searchList()
            ],
          )
        ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String email; 
  SearchTile({required this.username, required this.email});

    DatabaseMethods databaseMethods = new DatabaseMethods();


    //creating chatroom
  createChatRoomAndStartConversation(BuildContext context, String username){
    String chatRoomId = getChatRoomId(username, Constants.myName);
    List<String> users = [username, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "chatroomid" : chatRoomId,
      "users": users,
    };
    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(chatRoomId: chatRoomId,)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //TODO: need to fix overflow 
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: mediumTextStyle()),
              ],
            ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(context, username);
            },
            child: Container(
              child: Text('Message', style: mediumTextStyle(),),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(30)
              ),
            ),
          )
        ]
      ),
    );
  }
}

getChatRoomId(String a, String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }
  else{
    return "$a\_$b";
  }
}