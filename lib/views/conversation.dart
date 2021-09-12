import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/helper/constants.dart';
import 'package:flutterchat/services/database.dart';
import 'package:flutterchat/widgets/widget.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  const Conversation({required this.chatRoomId});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingController = new TextEditingController();
  Stream? messageStream;

Widget chatMessageList(){
  //using stream builder to retrieve data in realtime 
  return StreamBuilder(
    stream: messageStream,
    builder: (BuildContext context, AsyncSnapshot snapshot){
      if(!snapshot.hasData){
        return ListView();
      }else{
        print(snapshot.data);
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return MessageTile(
            message: snapshot.data.docs[index]["message"],
            isSendbyMe: snapshot.data.docs[index]["sendby"] == Constants.myName
          );
        });;
      }
      
      
      
 
    }
    );
}

sendMessage(){
  //can check messagecontroller is not empty
  Map<String, dynamic> messageMap = {
    "message": messageEditingController.text,
    "sendby": Constants.myName,
    "time": DateTime.now().microsecondsSinceEpoch
  };
  databaseMethods.uploadConversationMessages(widget.chatRoomId, messageMap);
  messageEditingController.text = "";
}

@override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
      setState(() {
        messageStream = val;
        print(messageStream);
      });
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, "") != "" ?
                          Text(widget.chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, "")):
                          Text(Constants.myName)),
      body: Stack(
        children: [
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: Colors.white,
              child:Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageEditingController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message ..."
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Image.asset("assets/images/send.png", height: 20, color: Colors.black,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                          colors: [
                                const Color(0xff9b54e3),
                                const Color(0xffbc53f5)
                              ]
                        )
                      ),
                      ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendbyMe;
  const MessageTile({required this.message, required this.isSendbyMe});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.only(left: isSendbyMe? 0 : 24, right: isSendbyMe? 24: 0),
        width: MediaQuery.of(context).size.width,
        alignment: isSendbyMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isSendbyMe? Colors.purple: Colors.white,
            borderRadius: isSendbyMe? BorderRadius.only(
              topRight: Radius.circular(23),
              topLeft: Radius.circular(23),
              bottomLeft: Radius.circular(23)
            ):
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
            )
        ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            message, 
            style: TextStyle(
              color: isSendbyMe? Colors.white: Colors.black,
              fontSize: 17
              )
            ),
        ),
    );
  }
}