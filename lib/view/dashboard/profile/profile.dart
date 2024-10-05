import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../../utils/routes/route_name.dart';
import '../../../view_model/profile/profile_controller.dart';
import '../../../view_model/services/session_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ref = FirebaseDatabase.instance.ref('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ChangeNotifierProvider(
        create: (_) => ProfileController(),
        child: Consumer<ProfileController>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder(
                  stream:
                  ref
                      .child(SessionController().userId.toString())
                      .onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    // print("SessionController().userId trước if:");
                    // print(SessionController().userId.toString());

                    if (snapshot.hasData) {
                      // print("SessionController().userId trong hasData:");
                      // print(SessionController().userId.toString());
                      print("snapshot.data.snapshot.value");
                      print(snapshot.data.snapshot.value);

                      if (snapshot.data.snapshot.value != null) {
                        Map<dynamic, dynamic> map =
                            snapshot.data.snapshot.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Container(
                                      height: 130,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color:
                                            AppColors.primaryTextTextColor),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(100),
                                          child: provider.image == null ?
                                          map['profile'].toString() == ""
                                              ? const Icon(Icons.person)
                                              : Image(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  map['profile']
                                                      .toString()),
                                              loadingBuilder: (context,
                                                  child, loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                    child:
                                                    CircularProgressIndicator());
                                              },
                                              errorBuilder:
                                                  (context, object, stack) {
                                                return Container(
                                                  child: Icon(
                                                    Icons.error_outline,
                                                    color: AppColors
                                                        .alertColor,
                                                  ),
                                                );
                                              }) :
                                          Stack(
                                            children: [
                                              Image.file(
                                                  File(provider.image!.path)
                                                      .absolute
                                              ),
                                              Center(
                                                child: CircularProgressIndicator(),),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    provider.pickerImage(context);
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.primaryIconColor,
                                    child: Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: (){
                                provider.showUserNameDialogAlert(context,map['userName']);
                              },
                              child: ReusbaleRow(
                                  value: map['userName'],
                                  title: 'Username',
                                  iconData: Icons.person_outline),
                            ),
                            GestureDetector(
                              onTap: (){
                                provider.showPhoneDialogAlert(context,map['phone']);
                              },
                              child: ReusbaleRow(
                                  value: map['phone'] == ''
                                      ? 'xxx-xxx-xxx'
                                      : map['phone'],
                                  title: 'Phone number',
                                  iconData: Icons.phone_outlined),
                            ),
                            ReusbaleRow(
                                value: map['email'],
                                title: 'Email',
                                iconData: Icons.email_outlined),
                            SizedBox(height: 40,),
                            IconButton(onPressed: () {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              auth.signOut().then((value) {
                                SessionController().userId = '';
                                print('logout đã hoàn thành');


                              });
                            }, icon: Icon(Icons.logout),
                            )
                          ],

                        );
                      } else {
                        // Xử lý trường hợp snapshot.data.snapshot.value là null
                        print(snapshot.connectionState);
                        print(snapshot.connectionState.toString());

                        return Center(
                            child: Text(
                              "Some thing went wrong1!",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayLarge,
                            ));
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReusbaleRow extends StatelessWidget {
  final String value, title;
  final IconData iconData;

  const ReusbaleRow({super.key,
    required this.title,
    required this.value,
    required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: Theme
                .of(context)
                .textTheme
                .titleLarge,
          ),
          trailing: Text(
            value,
            style: Theme
                .of(context)
                .textTheme
                .titleLarge,
          ),
          leading: Icon(
            iconData,
            color: AppColors.primaryIconColor,
          ),
        ),
        Divider(
          color: AppColors.dividedColor.withOpacity(0.4),
        ),
      ],
    );
  }
}
