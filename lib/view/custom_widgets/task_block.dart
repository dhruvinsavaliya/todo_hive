import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_hive/view/Screens/task_screens/task_detail_screen.dart';
import 'package:intl/intl.dart';

import '../../Core/Constants/colors.dart';

class TaskData extends StatefulWidget {
  var task;
  final String title;
  final bool done;
  final String dueDate;
  final int index;
  // final Timestamp createDate;
  final dynamic createDate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDone;
  final VoidCallback timerButton;
  final String description;
  final String timeValue;
  final Widget iconTimer;

  TaskData(
      {super.key,
      required this.task,
      required this.title,
      required this.description,
      required this.onEdit,
      required this.index,
      required this.done,
      required this.onDone,
      required this.onDelete,
      required this.dueDate,
      required this.timerButton,
      required this.iconTimer,
      required this.timeValue,
      required this.createDate});

  @override
  State<TaskData> createState() => _TaskDataState();
}

class _TaskDataState extends State<TaskData> {

  @override
  void initState() {
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => TaskDetailsScreen(data: widget.task));
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                SizedBox(
                  width: Get.width * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: widget.done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.description,
                        style: TextStyle(
                          decoration: widget.done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Create: ${DateFormat('dd-MM-yyyy').format(widget.createDate/*.toDate()*/).toString()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            'Due: ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              Text(widget.timeValue),
                              IconButton(onPressed:() =>  widget.timerButton(), icon: widget.iconTimer)
                            ],
                          ),
                          // ReversedTimer(durationString: dueDate, index: index,documentKey: task.id),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      color: kPrimaryColor,
                      onPressed: widget.onDone,
                      icon: Icon(widget.done
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                    ),
                    IconButton(
                      color: kPrimaryColor,
                        onPressed: widget.onEdit,
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.red,
                        )),
                    IconButton(
                        onPressed: widget.onDelete,
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
