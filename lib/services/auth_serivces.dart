import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupie/helper/helper_function.dart';

import 'database_service.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ///login
  Future loginWithUserNameAndPassword(
      String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
         return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }
/// Register
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  /// SignOut
 Future signOut() async{
    try{
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF('');
      await HelperFunctions.saveUserNameSF('');
      await firebaseAuth.signOut();
    }catch(e){
      return null;
    }
 }
}