import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_hive/Core/Constants/local_storage.dart';
import 'package:todo_hive/Core/shared_preference/shared_preference_services.dart';
import 'package:todo_hive/view/Screens/task_screens/tasks_screen.dart';
import 'package:ndialog/ndialog.dart';

import '../../view/custom_widgets/custom_snackbars.dart';

class SignUpController extends GetxController {
  // RxBool _isPasswordVisible = false.obs;
  RxBool isPasswordVisible = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // bool get isPasswordVisible => _isPasswordVisible.value;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    ProgressDialog dialog = ProgressDialog(Get.context!,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      await storeUserData(userId: user!.uid, name: name, email: email);
      CustomSnackBar.showSuccess('SignUp Successfully');
      dialog.dismiss();
      setDataToLocalStorage(dataType: LocalStorage.stringType, prefKey: LocalStorage.email,stringData: email.toString());
      Get.offAll(() => const TasksScreen());
    } catch (e) {
      CustomSnackBar.showError('SignUp Failed!');
      dialog.dismiss();
      if (kDebugMode) {
        print('Error signing up: $e');
      }
      rethrow;
    }
  }

  Future<void> storeUserData(
      {required String userId,
        required String name,
        required String email}) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'uid': userId,
        'name': name,
      });
    } catch (e) {
      CustomSnackBar.showError('Error storing user data: $e');
      rethrow;
    }
  }
}
