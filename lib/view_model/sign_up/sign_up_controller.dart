import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../utils/routes/route_name.dart';
import '../../utils/utils.dart';
import '../services/session_manager.dart';

class SignUpController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void signUp(BuildContext context,String username, String email, String password) async {
    setLoading(true);

    try {
      auth
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      ).then((value) {
        SessionController().userIdRealtime=value.user!.uid.toString();

        ref.child(value.user!.uid.toString()).set({
          'uid': value.user!.uid.toString(),
          'email': value.user!.email.toString(),
          'userName': username,
          'phone': '',
          'profile': '',

        }).then((value) {
          setLoading(false);
          Navigator.pushNamed(context, RouteName.dashboardScreen);
        }).onError((error, stackTrace) {
          setLoading(false);
          Utils.toastMessage("user created successfully");
        });
      }





      ).onError((error, stackTrace) {
        Utils.toastMessage(error.toString());
        setLoading(false);
      });
    } catch (e) {
      setLoading(false);
      print(e);
    }
  }
}
Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
        email: email, password: password))
        .user;
    if (user != null) {
      print("Account create Succesfull");
      user.updateProfile(displayName: name);
      await _firestore.collection("Users").doc(_auth.currentUser?.uid).set({
        "uid": _auth.currentUser?.uid,
        "email": email,
        "userName": name,
        "phone":"",
        "profile":"",
        "status": "Unavailable",
      });
      return user;
    } else {
      print("Account create Fail");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}