import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todo_hive/Core/enums/task_sorting.dart';
import 'package:todo_hive/Core/hive/boxes/boxes.dart';
import 'package:todo_hive/main.dart';
import 'package:todo_hive/view/Screens/Authentication/login_screen.dart';
import 'package:todo_hive/view/custom_widgets/custom_snackbars.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Models/task_model.dart';
import '../enums/task_filter.dart';

class TaskController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;

  RxString username = ''.obs;
  RxString selectedTaskTimer = ''.obs;
  late Rx<Stream<List<Task>>> _taskStream;
  TaskFilter currentFilter = TaskFilter.all;
  RxString filterText = 'All Tasks'.obs;
  bool doneStatus = false;

  TaskSortOption currentOption = TaskSortOption.none;

  Stream<List<Task>> get taskStream => _taskStream.value;
  Rx<Duration?> selectedDue = const Duration().obs;
  RxString selectedDueDate ="".obs;
  Rx<TimeOfDay?> selectedTime = TimeOfDay.now().obs;
  RxInt selectedMinutes = 05.obs;
  RxInt selectedSeconds = 00.obs;


  final controller = TextEditingController();
  RxString searchController = "".obs;

  TaskController() {
    getUserName();
    fetchTasks();
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 5),
    );

    if (pickedTime != null) {
      // todo.duration = Duration(
      selectedDue.value = Duration(
        hours: pickedTime.hour,
        minutes: pickedTime.minute,
      );
    }
  }

  Future<void> addTask(String title, String description) async {
    ProgressDialog dialog = ProgressDialog(Get.context!,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      final taskBox = Boxes.taskDetails();
      Task newTask = Task(
        title: title,
        createDate: DateTime.now(),
        description: description,
        done: false,
        dueDate:  "${selectedMinutes.value}:${selectedSeconds.value}",
        id: user!.uid,
        timerOn: false
      );

      taskBox.add(newTask);
      update();

      dialog.dismiss();
      Get.back();
      CustomSnackBar.showSuccess('Task Added Successfully');
    } catch (e) {
      CustomSnackBar.showError('Error adding task: $e');
      dialog.dismiss();
      rethrow;
    }
  }

  Future<void> editTask(int? index, String title, String description,String docId) async {
    ProgressDialog dialog = ProgressDialog(Get.context!,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      final taskBox = Boxes.taskDetails();
      Task newTask = Task(
        title: title,
        createDate: DateTime.now(),
        description: description,
        done: false,
        dueDate:  "${selectedMinutes.value}:${selectedSeconds.value}",
        id: user!.uid,
        timerOn: false
      );

      taskBox.putAt(index!,newTask);
      update();
      dialog.dismiss();
      Get.back();
      CustomSnackBar.showSuccess('Task Edited Successfully');
    } catch (e) {
      CustomSnackBar.showError('Error Editing task: $e');
      dialog.dismiss();
      rethrow;
    }
  }
  Future<void> removeTask(int? index) async {
    ProgressDialog dialog = ProgressDialog(Get.context!,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      final taskBox = Boxes.taskDetails();

      taskBox.deleteAt(index!);
      update();
      dialog.dismiss();
      Get.back();
      CustomSnackBar.showSuccess('Task Edited Successfully');
    } catch (e) {
      CustomSnackBar.showError('Error Editing task: $e');
      dialog.dismiss();
      rethrow;
    }
  }
  Future<void> updateTaskStatusValue(bool status, index,data) async {
    try {
      final taskBox = Boxes.taskDetails();
      Task newTask = Task(
        title: data.title,
        createDate: data.createDate,
        description: data.description ?? '',
        done: status,
        dueDate: data.dueDate,
        id: data.id,
      );

      taskBox.putAt(index!,newTask);
      scheduleNotification( status == true ?"Task moved to done":"Task moved to pending",data.title);
    } catch (e) {
      CustomSnackBar.showError('Error adding task: $e');
      rethrow;
    }
  }

  Future<void> updateTimerValue(String time,String docId) async {
    try {
      await firestore.collection('tasks').doc(docId).update({
        'due': time,
      });
    } catch (e) {
      CustomSnackBar.showError('Error Updating task timer: $e');
      rethrow;
    }
  }


  DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  void updateTaskStatus(String taskId, bool newStatus) {
    firestore
        .collection('tasks')
        .doc(taskId)
        .update({'done': newStatus}).then((value) {
    }).catchError((error) {
    });
  }

  // Future<void>  selectDate() async {
  //   final initialDate = selectedDueDate.value ?? DateTime.now();
  //   final pickedDate = await showDatePicker(
  //     context: Get.context!,
  //     initialDate: initialDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //   if (pickedDate != null) {
  //     selectedDueDate.value = pickedDate;
  //   }
  // }

  // Future<void> selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: selectedTime.value!,
  //   );
  //   if (picked != null && picked != selectedTime.value) {
  //     selectedTime.value = picked;
  //   }
  // }

  // Future<void> selectDateTime(BuildContext context) async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDueDate.value,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null) {
  //     TimeOfDay? pickedTime = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.fromDateTime(selectedDueDate.value!),
  //     );
  //     if (pickedTime != null) {
  //       selectedDueDate.value = DateTime(
  //           picked.year,
  //           picked.month,
  //           picked.day,
  //           pickedTime.hour,
  //           pickedTime.minute,
  //         );
  //     }
  //   }
  // }

  Future<void> getUserName() async {
    try {
      final user = this.user;
      if (user != null) {
        final DocumentSnapshot snapshot =
        await firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final name = data['name'];
          username.value = name;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateUsername(String newUsername) {
    username.value = newUsername;
  }

  void updateUserData() {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final userDoc = userCollection.doc(user?.uid);

    userDoc.update({'name': username.value}).then((_) {
      CustomSnackBar.showSuccess('Profile Update Successfully');
    }).catchError((error) {
      CustomSnackBar.showError('Error updating user data: $error');
    });
  }

  void logout() async {
    try {
      await auth.signOut();
      CustomSnackBar.showSuccess('Logout successfully');
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      rethrow;
    }
  }

  void fetchTasks() {
    Query query = firestore.collection('tasks');
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      query = query.where('uid', isEqualTo: currentUserUid);
    } else {
      return;
    }
    switch (currentFilter) {
      case TaskFilter.done:
        query = firestore
            .collection('tasks')
            .where('done', isEqualTo: true)
            .where('uid', isEqualTo: currentUserUid);
        break;
      case TaskFilter.pending:
        query = firestore
            .collection('tasks')
            .where('done', isEqualTo: false)
            .where('uid', isEqualTo: currentUserUid);
        break;
      default:
    }
    query = firestore.collection('tasks').orderBy('create_at');

    _taskStream = Rx(query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList()));
  }

  void updateFilter(TaskFilter newFilter) {
    if (currentFilter != newFilter) {
      currentFilter = newFilter;
      fetchTasks();
    }
  }

  void updateSortOption(TaskSortOption sortOption) {
    if (currentOption != sortOption) {
      currentOption = sortOption;
      fetchTasks();
    }
  }



  Future<void> scheduleNotification(msg,taskTitle) async {
    await flutterLocalNotificationsPlugin.cancel(0);
    // DateTime now = DateTime.now();
    // DateTime scheduledTime = now.add(const Duration(seconds: 2));
    //
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   0,
    //   'Reminder',
    //   'Wake Up',
    //   // tz.TZDateTime.from(chosenDate, tz.local),
    //   tz.TZDateTime.from(
    //       // DateTime.now(),
    //       tz.TZDateTime.local(
    //         scheduledTime.year,
    //         scheduledTime.month,
    //         scheduledTime.day,
    //         scheduledTime.hour,
    //         scheduledTime.minute,
    //         scheduledTime.second,
    //       ),
    //       tz.local),
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'your_channel_id',
    //       'your_channel_name',
    //       importance: Importance.max,
    //       priority: Priority.high,
    //       ticker: 'Your notification ticker text',
    //     ),
    //   ),
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //   UILocalNotificationDateInterpretation.absoluteTime,
    // );


    return await flutterLocalNotificationsPlugin.show(
        0, msg,taskTitle,  const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        // priority: Priority.high,
        // ticker: 'Your notification ticker text',
      ),
    ),);

  }



  }


Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (status != PermissionStatus.granted) {
    throw Exception('Notification permission not granted!');
  }}