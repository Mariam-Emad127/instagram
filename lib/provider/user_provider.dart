import 'package:flutter/material.dart';
import 'package:nstagram/models/user.dart';
import 'package:nstagram/resources/storage_methods.dart';

class UserProvider with ChangeNotifier {
  final StorageMethods storageMethods = StorageMethods();
  User? _user;

  User get getUser => _user!;



  Future<void> refreshUser() async {
    User user = await storageMethods.getUserDetails();

    _user = user;

    notifyListeners();
  }
}
