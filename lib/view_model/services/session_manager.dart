import 'package:firebase_auth/firebase_auth.dart';

class SessionController{


  static final SessionController _session=SessionController._internal();
  String? userIdRealtime;

  factory SessionController(){
    return _session;
  }
  SessionController._internal(){

  }
}