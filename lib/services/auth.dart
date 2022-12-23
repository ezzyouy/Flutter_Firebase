import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthService{

  final FirebaseAuth _auth=FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  UserE? _userFromFirebaseUser(User? user){
    return user != null ? UserE(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserE?> get user{
    return _auth.authStateChanges()
        //.map((User? user)=>_userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }
// sign an anon
  Future signInAnon() async{
    try{
      UserCredential result= await _auth.signInAnonymously();
      User? user= result.user;
      return _userFromFirebaseUser(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in with email and password
  Future signinWithEmailAndPassword( String email, String password) async{
    try{
      UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user= result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
//register with email & password
  Future registerWithEmailAndPassword( String email, String password) async{
    try{
      UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user= result.user;

      //create a new documents for the user with the uid
      await DatabaseService(uid: user?.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign out
Future SignOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      return null;
    }
}

}