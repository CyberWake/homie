import 'package:flutter/material.dart';

import 'file:///C:/Users/VK/Desktop/home_temperature/lib/models/userDataModel.dart';

class CurrentUser with ChangeNotifier {
  UserDataModel currentUserData;
  updateCurrentUser(UserDataModel userData) {
    currentUserData = userData;
    print("User Logged in: ${currentUserData.id}");
    notifyListeners();
  }
}
