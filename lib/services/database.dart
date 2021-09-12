import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods{

  
  
  //TODO: handle exception type 'Future<dynamic>' is not a subtype of type 'QuerySnapshot<Object?>?'
  getUserByUsername(String username) async{ 
    return await FirebaseFirestore.instance.collection("users")
    .where("name", isEqualTo: username)
    .get();
  }

  getUserByUserEmail(String useremail) async{ 
    return await FirebaseFirestore.instance.collection("users")
    .where("email", isEqualTo: useremail)
    .get();
  }

  updateUserDetail(userMap){
    FirebaseFirestore.instance.collection("users")
    .add(userMap).catchError((error)=>print(error.toString()));
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatRoomId).set(chatRoomMap).catchError((err)=>print(err));
  }

  getChatRoom(String userName) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
    .where("users", arrayContains: userName)
    .snapshots();
  }

  uploadConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatRoomId)
    .collection("chats")
    .add(messageMap).catchError((err) => print(err));
  }

  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatRoomId)
    .collection("chats").orderBy("time").snapshots();
  }

}
 