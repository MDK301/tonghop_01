import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../utils/routes/route_name.dart';
import '../../utils/utils.dart';
import '../services/session_manager.dart';

class ForgotPasswordController with ChangeNotifier{
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void forgotPassword(BuildContext context , String email) async {
    setLoading(true);

    try {
      auth.sendPasswordResetEmail(  email: email)
          .then((value) {


        setLoading(false);
        Navigator.pushNamed(context, RouteName.loginView);
        Utils.toastMessage("Please check your email, Master!");



      }).onError((error, stackTrace) {
        Utils.toastMessage(error.toString());
        setLoading(false);
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage(e.toString());
      print(e);
    }
  }
}