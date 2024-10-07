import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../utils/routes/route_name.dart';
import '../../utils/utils.dart';
import '../services/session_manager.dart';

class LoginController with ChangeNotifier{
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void login(BuildContext context , String email, String password) async {
    setLoading(true);

    try {
      auth.signInWithEmailAndPassword(  email: email, password: password)
          .then((value) {

        SessionController().userIdRealtime=value.user!.uid.toString();

        setLoading(false);
        Navigator.pushNamed(context, RouteName.dashboardScreen);



      }).onError((error, stackTrace) {
        print('1');
        Utils.toastMessage(error.toString());
        setLoading(false);
      });
    } catch (e) {
      print('2');
      setLoading(false);
      Utils.toastMessage(e.toString());
      print(e);
    }
  }
}