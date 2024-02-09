// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'your_task_model.dart'; // Replace with the actual model for your tasks
// // import 'your_task_data_box.dart'; // Replace with the actual Box class for task data
// // import 'your_add_edit_task_screen.dart'; // Replace with the actual AddEditTaskScreen
// //
// // class YourWidget extends StatefulWidget {
// //   @override
// //   _YourWidgetState createState() => _YourWidgetState();
// // }
// //
// // class _YourWidgetState extends State<YourWidget> {
// //   List<Timer?> timers = [];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ValueListenableBuilder<Box<Task>>(
// //       valueListenable: Boxes.taskDetails().listenable(),
// //       builder: (context, items, child) {
// //         List<int> keysSetting = items.keys.cast<int>().toList();
// //         List<Task> tempList = [];
// //
// //         keysSetting.forEach(
// //               (element) {
// //             Task? taskData = items.get(element);
// //
// //             // Sample filter conditions, modify as per your requirements
// //             if (taskController.filterText.value == 'All Tasks') {
// //               tempList.add(taskData!);
// //             }
// //             if (taskController.filterText.value == 'Done') {
// //               if (taskData?.done == true) {
// //                 tempList.add(taskData!);
// //               }
// //             }
// //             if (taskController.filterText.value == 'Pending') {
// //               if (taskData?.done == false) {
// //                 tempList.add(taskData!);
// //               }
// //             }
// //           },
// //         );
// //
// //         return ListView.builder(
// //           itemCount: tempList.length,
// //           itemBuilder: (context, index) {
// //             final task = tempList[index];
// //             String timerString = task.dueDate;
// //             List<String> timerParts = timerString.split(':');
// //             int minutes = int.parse(timerParts[0]);
// //             int seconds = int.parse(timerParts[1]);
// //
// //             while (timers.length <= index) {
// //               timers.add(null);
// //             }
// //
// //             return YourTaskDataWidget(
// //               task: task,
// //               title: task.title,
// //               description: task.description,
// //               onEdit: () async {
// //                 showModalBottomSheet(
// //                   enableDrag: true,
// //                   context: context,
// //                   builder: (context) {
// //                     return YourAddEditTaskScreen(
// //                       isEdit: true,
// //                       taskData: task,
// //                       index: index,
// //                     );
// //                   },
// //                 ).whenComplete(() => fetchTasks());
// //               },
// //               done: task.done,
// //               onDone: () {
// //                 taskController.updateTaskStatusValue(
// //                     task.done == false ? true : false, index, task);
// //                 setState(() {});
// //               },
// //               onDelete: () {
// //                 taskController.removeTask(index);
// //                 CustomSnackBar.showSuccess('Task Deleted Successfully');
// //               },
// //               dueDate: task.dueDate,
// //               timerButton: () {},
// //               timeValue: '$minutes:${seconds.toString().padLeft(2, '0')}',
// //               iconTimer: Row(
// //                 children: [
// //                   Text('$minutes:${seconds.toString().padLeft(2, '0')}'),
// //                   IconButton(
// //                     onPressed: () {
// //                       print("called automatically");
// //
// //                       timers[index]?.cancel();
// //
// //                       timers[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
// //                         if (minutes > 0 || seconds > 0) {
// //                           setState(() {
// //                             if (seconds == 0) {
// //                               minutes--;
// //                               seconds = 59;
// //                             } else {
// //                               seconds--;
// //                             }
// //                           });
// //
// //                           Boxes.taskDetails().putAt(
// //                             index,
// //                             Task(
// //                               title: task.title,
// //                               description: task.description,
// //                               createDate: task.createDate,
// //                               id: task.dueDate,
// //                               timerOn: true,
// //                               done: task.done,
// //                               dueDate: '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
// //                             ),
// //                           );
// //                         } else {
// //                           timer.cancel();
// //                         }
// //                       });
// //                     },
// //                     icon: Icon(Icons.play_arrow,
// //                         color: task.timerOn == false ? Colors.red : Colors.black),
// //                   ),
// //                   IconButton(
// //                     onPressed: () {
// //                       timers[index]?.cancel();
// //
// //                       Boxes.taskDetails().putAt(
// //                         index,
// //                         Task(
// //                           title: task.title,
// //                           description: task.description,
// //                           createDate: task.createDate,
// //                           id: task.dueDate,
// //                           timerOn: false,
// //                           done: task.done,
// //                           dueDate: '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
// //                         ),
// //                       );
// //                     },
// //                     icon: Icon(Icons.stop,
// //                         color: task.timerOn == true ? Colors.red : Colors.black),
// //                   ),
// //                 ],
// //               ),
// //               createDate: task.createDate,
// //               index: index,
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// // }
// //
// class YourTaskDataWidget extends StatelessWidget {
//   // Add properties as needed based on your TaskData widget
//   final Task task;
//   final String title;
//   final String description;
//   final VoidCallback onEdit;
//   final bool done;
//   final VoidCallback onDone;
//   final VoidCallback onDelete;
//   final String dueDate;
//   final VoidCallback timerButton;
//   final String timeValue;
//   final Widget iconTimer;
//   final String createDate;
//   final int index;
// //
//   YourTaskDataWidget({
//     required this.task,
//     required this.title,
//     required this.description,
//     required this.onEdit,
//     required this.done,
//     required this.onDone,
//     required this.onDelete,
//     required this.dueDate,
//     required this.timerButton,
//     required this.timeValue,
//     required this.iconTimer,
//     required this.createDate,
//     required this.index,
//   });
// //
//   @override
//   Widget build(BuildContext context) {
//     // Implement your UI for the TaskData widget
//     return Container(
//       // Your widget implementation here
//     );
//   }
// }
// //
// class YourAddEditTaskScreen extends StatelessWidget {
//   // Implement your AddEditTaskScreen widget
// }
// //
// // Your other classes and imports
