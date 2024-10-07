import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tonghop_01/view/dashboard/profile/profile.dart';
import 'package:tonghop_01/view/dashboard/user/user_list_screen.dart';

import '../../res/color.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore.collection('Users').doc(_auth.currentUser?.uid).update({
      "status": "Online",
    });
  }
  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser?.uid).update({
      "status": status,
    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }
  final controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreen() {
    return [
      SafeArea(child: Center(child: Text("Home",style: Theme.of(context).textTheme.headlineSmall,))),
      UserListScreen(),
      SafeArea(child: Text("add")),
      SafeArea(child: Text("chat")),
      ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItem() {
    return [
      //home
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.home,
          ),
          activeColorPrimary: AppColors.primaryActiveNavBarColor,
          activeColorSecondary: AppColors.secondaryActiveNavBarColor,

          inactiveIcon: Icon(
            Icons.home,
            color: Colors.grey,
          )),

      //chat
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.chat,
          ),
          activeColorPrimary: AppColors.primaryActiveNavBarColor,
          activeColorSecondary: AppColors.secondaryActiveNavBarColor,
          inactiveIcon: Icon(
            Icons.chat,
            color: Colors.grey,
          )),

      //add
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.add,
          ),
          activeColorPrimary: AppColors.primaryActiveNavBarColor,
          activeColorSecondary: AppColors.secondaryActiveNavBarColor,
          inactiveIcon: Icon(
            Icons.add,
            color: Colors.grey,
          )),

      //notification
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.notifications,
          ),
          activeColorPrimary: AppColors.primaryActiveNavBarColor,
          activeColorSecondary: AppColors.secondaryActiveNavBarColor,
          inactiveIcon: Icon(
            Icons.notifications,
            color: Colors.grey,
          )),

      //personal profile
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.person,
          ),
          activeColorPrimary: AppColors.primaryActiveNavBarColor,
          activeColorSecondary: AppColors.secondaryActiveNavBarColor,
          inactiveIcon: Icon(
            Icons.person,
            color: Colors.grey,
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreen(),
      items: _navBarItem(),
      controller: controller,
      backgroundColor: AppColors.primaryNavBarColor,
      decoration: NavBarDecoration(borderRadius: BorderRadius.circular(1)),
    );
  }
}
