// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_hive/Core/Constants/colors.dart';
import 'package:todo_hive/Core/Models/task_model.dart';
import 'package:todo_hive/Core/controller/task_controller.dart';
import 'package:todo_hive/Core/enums/task_sorting.dart';
import 'package:todo_hive/Core/hive/boxes/boxes.dart';
import 'package:todo_hive/Core/notification_services.dart';
import 'package:todo_hive/garb/timing.dart';
import 'package:todo_hive/main.dart';
import 'package:todo_hive/view/Screens/task_screens/add_task_screen.dart';
import 'package:todo_hive/view/custom_widgets/custom_snackbars.dart';
import 'package:todo_hive/view/custom_widgets/custom_textfield.dart';
import 'package:todo_hive/view/custom_widgets/task_block.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../Core/enums/task_filter.dart';
import '../../custom_widgets/setting_bottom_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  NotificationServices notificationServices = NotificationServices();

  final taskController = Get.find<TaskController>();

  @override
  void initState() {
    fetchTasks();
    super.initState();
    notificationServices.requestNotificationPermission();
    // notificationServices.getDeviceToken().then((value){});
    fetchTasks();
  }
  List<Timer?>? timers;

  void fetchTasks() async {
    String? docId = prefs?.getString("docId");
    taskController.user = FirebaseAuth.instance.currentUser;
    Query query = FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: docId);
    query.snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 10),
                const Text('Hello '),
                taskController.username == null
                    ? const CircularProgressIndicator()
                    : Text(
                        taskController.username.toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kBlack),
                      ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        SettingsBottomSheet(
                          username: taskController.username.toString(),
                          onUsernameChanged: (value) {
                            taskController.updateUsername(value);
                          },
                          onUpdatePressed: () {
                            taskController.updateUserData();
                            Get.back();
                          },
                          onLogoutPressed: () {
                            taskController.logout();
                            Get.back();
                          },
                        ),
                        backgroundColor: Colors.white,
                      );
                    },
                    icon: const Icon(Icons.settings)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'ToDos',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Text(
                  'Filter By',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: kBlack),
                ),
                Spacer(),
                Text(
                  'Search',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: kBlack),
                ),
              ],
            ),
            Row(
              children: [
                DropdownButton<TaskFilter>(
                  value: taskController.currentFilter,
                  onChanged: (TaskFilter? newValue) {
                    if (newValue != null) {
                      taskController.updateFilter(newValue);
                      taskController.updateSortOption(TaskSortOption.none);


                      if (newValue == TaskFilter.all) {
                        taskController.filterText.value = 'All Tasks';
                      }
                      else if (newValue == TaskFilter.done) {
                        taskController.filterText.value = 'Done';
                      }
                      else if (newValue == TaskFilter.pending) {
                        taskController.filterText.value = 'Pending';
                      }

                    }
                    // setState(() {});
                  },
                  items: TaskFilter.values.map((TaskFilter filter) {
                    String filterText = '';
                    if (filter == TaskFilter.all) {
                      filterText = 'All Tasks';
                    }
                    else if (filter == TaskFilter.done) {
                      filterText = 'Done';
                    }
                    else if (filter == TaskFilter.pending) {
                      filterText = 'Pending';
                    }
                    return DropdownMenuItem<TaskFilter>(
                      value: filter,
                      child: Text(filterText),
                    );
                  }).toList(),
                ),
                const Spacer(),
                CustomTextField(
                  width: Get.width * 0.4,
                  // readOnly: true,
                  height: 40,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: kPrimaryColor,
                  ),
                  controller: taskController.controller,
                  hintText: 'Search',
                  onChanged: (p0) {
                    taskController.searchController.value = p0;
                    // setState(() {});
                  },
                ),
              ],
            ),

            Obx(() {
              return taskController.filterText.value.isEmpty ?const SizedBox():Expanded(
                  child: ValueListenableBuilder<Box<Task>>(
                    valueListenable: Boxes.taskDetails().listenable(),
                    builder: (context, items, child) {
                      List<int> keysSetting;
                      keysSetting = items.keys.cast<int>().toList();
                      // log('setting -- $keysSetting');
                      // settingScreenController.SettingKey.value = keysSetting[i];
                      List<Task> tempList = [];
                      tempList.clear();
                      keysSetting.forEach(
                            (element) {
                          Task? taskData = items.get(element);

                          if(taskController.filterText.value == 'All Tasks'){
                            tempList.add(taskData!);
                          }
                          if(taskController.filterText.value == 'Done' ){
                            if(taskData?.done == true) {
                              tempList.add(taskData!);
                            }
                          }
                          if(taskController.filterText.value == 'Pending'){
                            if(taskData?.done == false) {
                              tempList.add(taskData!);
                            }
                          }
                        },
                      );

                      return ListView.builder(
                        itemCount: tempList.length,
                        itemBuilder: (context, index) {
                          final task = tempList[index];
                          String timerString = task.dueDate;
                          List<String> timerParts = timerString.split(':');
                          int minutes = int.parse(timerParts[0]);
                          int seconds = int.parse(timerParts[1]);

                          Timer? timerData;

                          return taskController.searchController.value.isEmpty
                              || (taskController.searchController.value.isNotEmpty && task.title.startsWith(taskController.searchController.value))
                              ? TaskData(
                            task: task,
                            title: task.title,
                            description: task.description,
                            onEdit: () async {
                              showModalBottomSheet(
                                enableDrag: true,
                                context: context,
                                builder: (context) {
                                  return AddEditTaskScreen(
                                    isEdit: true,
                                    taskData: task,
                                    index: index,
                                  );
                                },
                              ).whenComplete(() => fetchTasks());
                            },
                            done: task.done,
                            onDone: () {
                              taskController.updateTaskStatusValue(
                                  task.done == false ? true : false, index, task);
                              setState(() {});
                            },
                            onDelete: () {
                              taskController.removeTask(index);
                              CustomSnackBar.showSuccess('Task Deleted Successfully');
                            },
                            dueDate: task.dueDate,
                              timerButton:(){},

                            timeValue: '$minutes:${seconds.toString().padLeft(2, '0')}',
                            // iconTimer:   Row(
                            //   children: [
                            //     Text('$minutes:${seconds.toString().padLeft(2, '0')}'),
                            //     IconButton(onPressed:(){
                            //       print("called automatically");
                            //       timerData = Timer.periodic(const Duration(seconds: 1), (timer) {
                            //         if (minutes > 0 || seconds > 0) {
                            //           setState(() {
                            //             if (seconds == 0) {
                            //               minutes--;
                            //               seconds = 59;
                            //             } else {
                            //               seconds--;
                            //             }
                            //           });
                            //           // Update the Hive database
                            //           Boxes.taskDetails().putAt(
                            //               index,
                            //               Task(
                            //                 title: task.title,
                            //                 description: task.description,
                            //                 createDate: task.createDate,
                            //                 id: task.dueDate,
                            //                 timerOn: true,
                            //                 done: task.done,
                            //                 dueDate: '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                            //               )
                            //             // '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
                            //           );
                            //         }
                            //         else {
                            //           timer.cancel();
                            //         }
                            //       });
                            //       // setState(() {});
                            //     }, icon: Icon(  Icons.play_arrow,color: task.timerOn == false ?Colors.red:Colors.black),),
                            //     IconButton(onPressed:(){
                            //       if(timerData != null ) {
                            //         timerData?.cancel();
                            //       }
                            //       Boxes.taskDetails().putAt(
                            //           index,
                            //           Task(
                            //             title: task.title,
                            //             description: task.description,
                            //             createDate: task.createDate,
                            //             id: task.dueDate,
                            //             timerOn: false,
                            //             done: task.done,
                            //             dueDate: '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',));
                            //       // setState(() {});
                            //     },
                            //       icon: Icon( Icons.stop,color: task.timerOn == true ?Colors.red:Colors.black, ),)
                            //   ],
                            // ),
                            iconTimer:   Row(
                              children: [],
                            ),
                            createDate: task.createDate,
                            index: index,
                          )
                              : const SizedBox();
                        },
                      );
                    },
                  ),
                );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              enableDrag: true,
              context: context,
              builder: (context) {
                return AddEditTaskScreen();
              },
            ).whenComplete(() => fetchTasks());
          },
          child: const Icon(Icons.add)),
    );
    // });
  }
}


//
class TimerModel {
  int minutes;
  int seconds;

  TimerModel({required this.minutes, required this.seconds});

  int get totalSeconds => minutes * 60 + seconds;

  String get formattedTime {
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  String toString() {
    return formattedTime;
  }
}