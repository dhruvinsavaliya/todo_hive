// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_hive/view/Screens/task_screens/tasks_screen.dart';
import 'package:todo_hive/view/custom_widgets/custom_snackbars.dart';
import 'package:todo_hive/main.dart';
import 'package:ndialog/ndialog.dart';

class LoginController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password) async {
    ProgressDialog dialog = ProgressDialog(Get.context!,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      CustomSnackBar.showSuccess('Login successfully');
      dialog.dismiss();
      Get.offAll(() => const TasksScreen());
      fetchData(email);


    } catch (e) {
      CustomSnackBar.showError('Error signing in: $e');
      dialog.dismiss();
      rethrow;
    }
  }


  Future<void> fetchData(String valueToMatch) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: valueToMatch)
          .get();
      querySnapshot.docs.forEach((doc) {
        // Access the data for each document
        prefs?.setString("docId", doc.id.toString());

      });

    } catch (error){
    log("$error");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    ProgressDialog dialog = ProgressDialog(Get.context!,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      await auth.sendPasswordResetEmail(email: email);
      CustomSnackBar.showSuccess('Password reset email sent');
      dialog.dismiss();
    } catch (e) {
      CustomSnackBar.showError('Error sending password reset email: $e');
      dialog.dismiss();
      rethrow;
    }
  }
}
