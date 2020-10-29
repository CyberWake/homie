import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Users/VK/Desktop/home_temperature/lib/auth/userAuth.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/models/provideUser.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/models/userDataModel.dart';

class UserInfoStore {
  UserDataModel _currentUserModel;
  static final CollectionReference _users =
      FirebaseFirestore.instance.collection('UsersInfoData');

  static final UserAuth _userAuth = UserAuth();

  Future<bool> createUserRecord(
      {String username = "", BuildContext context}) async {
    try {
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

  Future<UserDataModel> getUserInformation({String uid}) async {
    try {
      DocumentSnapshot ds = await _users.doc(uid).get();
      return UserDataModel.fromDocument(ds);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<DocumentSnapshot> getUserInfoStream({String uid}) {
    return _users.doc(uid).snapshots();
  }

  Future<DocumentSnapshot> getUserInfoFuture({String uid}) {
    return _users.doc(uid).get();
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
