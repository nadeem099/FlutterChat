import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchat/model/user.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UserObj? _userFromFirebaseUser(User? user){
    return user != null ? UserObj(userId: user.uid) : null;
  }


  Future signInUsingEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = userCredential.user; 
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future signUpUsingEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = userCredential.user;
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    return await _auth.signOut();
  }
}