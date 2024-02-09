// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart';
// import 'package:todo_hive/view/Screens/task_screens/task_detail_screen.dart';
// import 'package:todo_hive/Core/Constants/colors.dart';
//
// class TaskData extends StatefulWidget {
//   final dynamic task;
//   final String title;
//   final bool done;
//   final String dueDate;
//   final int index;
//   final dynamic createDate;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final VoidCallback onDone;
//   final String description;
//
//   TaskData({
//     Key? key,
//     required this.task,
//     required this.title,
//     required this.description,
//     required this.onEdit,
//     required this.index,
//     required this.done,
//     required this.onDone,
//     required this.onDelete,
//     required this.dueDate,
//     required this.createDate,
//   }) : super(key: key);
//
//   @override
//   _TaskDataState createState() => _TaskDataState();
// }
//
// class _TaskDataState extends State<TaskData> {
//   late Timer? _timer;
//   late String timeValue;
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   void startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (widget.done) {
//         // Stop the timer if the task is marked as done
//         timer.cancel();
//       } else {
//         // Update the time value here
//         updateTimeValue();
//       }
//     });
//   }
//
//   void updateTimeValue() {
//     // Implement your logic to update the time value
//     // For example, you can parse the due date and calculate the remaining time
//     // Update the state using setState if needed
//     setState(() {
//       // Example: Format the remaining time as "mm:ss"
//       timeValue = calculateRemainingTime();
//     });
//   }
//
//   String calculateRemainingTime() {
//     // Implement your logic to calculate the remaining time
//     // For example, you can use the current time and due date to calculate the difference
//     // Return the formatted time as a string
//     // Placeholder implementation:
//     return "00:00";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Get.to(() => TaskDetailsScreen(data: widget.task));
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5),
//         decoration: BoxDecoration(
//           color: kWhite,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: Get.width * 0.65,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         decoration: widget.done ? TextDecoration.lineThrough : null,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       widget.description,
//                       style: TextStyle(
//                         decoration: widget.done ? TextDecoration.lineThrough : null,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Create: ${DateFormat('dd-MM-yyyy').format(widget.createDate).toString()}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 5),
//                     Row(
//                       children: [
//                         const Text(
//                           'Due: ',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Row(
//                           children: [
//                             Text(timeValue),
//                             IconButton(onPressed: () => widget.timerButton(), icon: widget.iconTimer),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 children: [
//                   IconButton(
//                     color: kPrimaryColor,
//                     onPressed: widget.onDone,
//                     icon: Icon(widget.done ? Icons.check_box : Icons.check_box_outline_blank),
//                   ),
//                   IconButton(
//                     color: kPrimaryColor,
//                     onPressed: widget.onEdit,
//                     icon: const Icon(
//                       Icons.edit,
//                       color: Colors.red,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: widget.onDelete,
//                     icon: const Icon(
//                       Icons.delete_forever,
//                       color: Colors.red,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       if (_timer?.isActive == true) {
//                         _timer?.cancel();
//                       } else {
//                         startTimer();
//                       }
//                     },
//                     icon: const Icon(Icons.play_arrow),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
