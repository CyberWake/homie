import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:home_temperature/auth/userAuth.dart';
import 'package:home_temperature/models/provideUser.dart';
import 'package:home_temperature/models/userDataModel.dart';
import 'package:provider/provider.dart';

class UserInfoStore {
  UserDataModel _currentUserModel;
  static final CollectionReference _users =
      FirebaseFirestore.instance.collection('UsersInfoData');

  static final UserAuth _userAuth = UserAuth();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<bool> createUserRecord(
      {String username = "", BuildContext context}) async {
    try {
      String _fcmToken = await _fcm.getToken();
      print("Started process of record creation");
      DocumentSnapshot userRecord = await _users.doc(_userAuth.user.uid).get();
      if (_userAuth.user != null) {
        print("user not null");
        if (!userRecord.exists) {
          print("record not exists");
          Map<String, dynamic> userData = {
            "id": _userAuth.user.uid,
            "displayName": _userAuth.user.displayName,
            "email": _userAuth.user.email,
            "photoUrl": _userAuth.user.photoURL,
            "username": username,
            "fcmToken": _fcmToken
          };
          print("record created");
          _users.doc(_userAuth.user.uid).set(userData);
          userRecord = await _users.doc(_userAuth.user.uid).get();
        }
        print("record provided to provider");
        _currentUserModel = UserDataModel.fromDocument(userRecord);
        Provider.of<CurrentUser>(context, listen: false)
            .updateCurrentUser(_currentUserModel);
      }

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future updateToken({BuildContext context}) async {
    try {
      String _fcmToken = await _fcm.getToken();
      print("run");
      DocumentSnapshot userRecord = await _users.doc(_userAuth.user.uid).get();
      _users.doc(_userAuth.user.uid).update({'fcmToken': _fcmToken});
      userRecord = await _users.doc(_userAuth.user.uid).get();
      _currentUserModel = UserDataModel.fromDocument(userRecord);
      Provider.of<CurrentUser>(context, listen: false)
          .updateCurrentUser(_currentUserModel);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> isUsernameNew({String username}) async {
    print(username);
    try {
      QuerySnapshot read =
          await _users.where("username", isEqualTo: username).get();

      if (read.size != 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> emailExists({String email}) async {
    print(email);
    try {
      QuerySnapshot read = await _users.where("email", isEqualTo: email).get();

      if (read.size != 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  getUserInfo({String uid}) {
    try {
      return _users.doc(uid).get();
    } catch (e) {
      print("getUserInfo" + e.toString());
      return null;
    }
  }
}
