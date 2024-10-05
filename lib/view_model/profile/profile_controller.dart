import 'dart:io';

//bắt buộc phải có thuvien này
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../res/color.dart';
import '../../res/component/input_text_field.dart';
import '../../utils/utils.dart';
import '../services/session_manager.dart';

class ProfileController with ChangeNotifier {
  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();

  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final picker = ImagePicker();

  XFile? _image;

  XFile? get image => _image;

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  void pickerImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(
                      Icons.camera,
                      color: AppColors.primaryIconColor,
                    ),
                    title: Text("Camera"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      pickGalleryImage(context);
                    },
                    leading: Icon(
                      Icons.image,
                      color: AppColors.primaryIconColor,
                    ),
                    title: Text("Gallery"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void uploadImage(BuildContext context) async {
    setLoading(true);
    try {
      // Tạo tham chiếu Firebase Storage đến vị trí lưu ảnh
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref('/profileImage/${SessionController().userId}');

      // Upload file ảnh
      firebase_storage.UploadTask uploadTask =
          storageRef.putFile(File(image!.path).absolute);

      // Chờ upload hoàn tất
      await uploadTask;

      // Lấy đường dẫn URL của ảnh đã upload
      final String newUrl = await storageRef.getDownloadURL();

      // Cập nhật URL mới vào Firebase Realtime Database
      await ref.child(SessionController().userId.toString()).update({
        'profile': newUrl,
      });

      // Thông báo thành công
      Utils.toastMessage('Profile updated successfully');
      setLoading(false);
      _image = null;
    } catch (error) {
      // Xử lý lỗi nếu xảy ra
      Utils.toastMessage('Error: ${error.toString()}');
      setLoading(false);
    }
  }

  Future<void> showUserNameDialogAlert(
      BuildContext context, String name) async {
    nameController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Update username')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InputTextField(
                      myController: nameController,
                      focusNode: nameFocusNode,
                      onFiledSubmittedValue: (value) {},
                      onValidator: (value) {},
                      keyBoardType: TextInputType.text,
                      hint: 'Enter name',
                      obscureText: false)
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel ',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: AppColors.alertColor),
                  )),
              TextButton(
                  onPressed: () {
                    ref.child(SessionController().userId.toString()).update({
                      'userName': nameController.text.toString()
                    }).then((value) {
                      nameController.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: Text('OK',
                      style: Theme.of(context).textTheme.labelMedium)),
            ],
          );
        });
  }
  Future<void> showPhoneDialogAlert(
      BuildContext context, String phone) async {
    phoneController.text = phone;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Update phone number')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InputTextField(
                      myController: phoneController,
                      focusNode: phoneFocusNode,
                      onFiledSubmittedValue: (value) {},
                      onValidator: (value) {},
                      keyBoardType: TextInputType.phone,
                      hint: 'Enter phone number',
                      obscureText: false)
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel ',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: AppColors.alertColor),
                  )),
              TextButton(
                  onPressed: () {
                    ref.child(SessionController().userId.toString()).update({
                      'phone': phoneController.text.toString()
                    }).then((value) {
                      phoneController.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: Text('OK',
                      style: Theme.of(context).textTheme.labelMedium)),
            ],
          );
        });
  }
}
