import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tonghop_01/view_model/services/session_manager.dart';

import '../../utils/routes/route_name.dart';

class Splash_Services{
  void isLogin(BuildContext context){
    FirebaseAuth auth = FirebaseAuth.instance;
final user=auth.currentUser;
if(user!=null){
  SessionController().userIdRealtime=user.uid.toString();
  Timer(const Duration(seconds:3),()=>Navigator.pushNamed(context,RouteName.dashboardScreen));

}else{
  Timer(const Duration(seconds:3),()=>Navigator.pushNamed(context,RouteName.loginView));

}

  }
}