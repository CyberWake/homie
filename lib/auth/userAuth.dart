import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/database/userInfoStore.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Users/VK/Desktop/home_temperature/lib/models/provideUser.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/models/userDataModel.dart';

class UserAuth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('UsersInfoData');
  static UserDataModel currentUserModel;
  UserCredential userCredential;

  Stream<User> get account {
    return _auth.authStateChanges();
  }

  User get user {
    return _auth.currentUser;
  }

  Future signInWithEmailAndPassword(
      {String email, String password, BuildContext context}) async {
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      DocumentSnapshot userSnapshot =
          await _usersCollection.doc(userCredential.user.uid).get();
      if (userSnapshot.exists) {
        UserDataModel user = UserDataModel.fromDocument(userSnapshot);
        Provider.of<CurrentUser>(context, listen: false)
            .updateCurrentUser(user);
        return "success";
      } else {
        return "No user found for this email.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      }
    } catch (e) {
      print("error : " + e.toString());
      return null;
    }
  }

  Future registerUserWithEmail(
      {String email,
      String password,
      String username,
      BuildContext context}) async {
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User logged in");
      DocumentSnapshot userRecord =
          await _usersCollection.doc(userCredential.user.uid).get();
      if (!userRecord.exists) {
        print("record not found new user");
        await UserInfoStore()
            .createUserRecord(username: username)
            .then((value) async {
          print("Started process of record creation1");
          if (value) {
            print("record provided to provider");
            userRecord =
                await _usersCollection.doc(userCredential.user.uid).get();
            currentUserModel = UserDataModel.fromDocument(userRecord);
            Provider.of<CurrentUser>(context, listen: false)
                .updateCurrentUser(currentUserModel);
          }
        });
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for this email.';
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(credential);
      DocumentSnapshot userRecord =
          await _usersCollection.doc(userCredential.user.uid).get();
      if (!userRecord.exists) {
        return "newUser";
      }
      /*UserDataModel user = UserDataModel.fromDocument(userRecord);
      Provider.of<CurrentUser>(context, listen: false).updateCurrentUser(user);*/
      return true;
    } catch (e) {
      await GoogleSignIn().signOut();
      print("google login error: " + e.toString());
      return false;
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Password reset link sent";
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<bool> signOut() async {
    try {
      /*await FacebookAuth.instance.logOut();*/
      await GoogleSignIn().signOut();
      await _auth.signOut();
      userCredential = null;
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
