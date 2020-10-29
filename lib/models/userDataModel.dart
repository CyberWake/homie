import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String displayName;
  String email;
  String password;
  String id;
  String photoUrl;
  String username;

  UserDataModel({
    this.displayName,
    this.email,
    this.password,
    this.id,
    this.photoUrl,
    this.username,
  });

  factory UserDataModel.fromDocument(DocumentSnapshot document) {
    return UserDataModel(
      displayName: document.data()['displayName'],
      email: document.data()['email'],
      id: document.id,
      photoUrl: document.data()['photoUrl'],
      username: document.data()['username'],
    );
  }
}
