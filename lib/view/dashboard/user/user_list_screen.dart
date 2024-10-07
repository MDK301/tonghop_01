import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../res/color.dart';
import '../../../view_model/services/session_manager.dart';
import '../../chat/chat_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: SafeArea(
          child: FirebaseAnimatedList(
        query: ref.orderByChild('uid'),
        itemBuilder: (context, snapshot, animation, index) {
          if (SessionController().userIdRealtime.toString() ==
              snapshot.child('uid').value.toString()) {
            return Container();
          } else {
            return Card(
              child: ListTile(
                onTap: () {
                  PersistentNavBarNavigator.pushDynamicScreen(
                    context,
                    screen: MaterialPageRoute(
                      builder: (context) => MessageScreen(
                        //name là tên biến bên kia còn màu xanh là tên biến trên firebase live database
                        name: snapshot.child('userName').value.toString(),
                        image: snapshot.child('profile').value.toString(),
                        email: snapshot.child('email').value.toString(),
                        reciverId: 'uid',
                      ),
                    ),
                    withNavBar: false,
                  );
                },
                leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.primaryButtonColor)),
                    child: snapshot.child('profile').value.toString() == ""
                        ? Icon(Icons.person_outline)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  snapshot.child('profile').value.toString()),
                            ),
                          )),
                title: Text(snapshot.child('userName').value.toString()),
                subtitle: Text(snapshot.child('email').value.toString()),
              ),
            );
          }
        },
      )),
    );
  }
}
