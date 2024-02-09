import 'package:flutter/material.dart';
import 'package:todo_hive/view/custom_widgets/timer_screen.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatefulWidget {
  var data;
  String duration;
  TaskDetailsScreen({super.key, this.data, this.duration = "0:0"});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Row(
              children: [
                BackButton(),
                Text(
                  "Task Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Name : ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text("${widget.data.title}"),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Description : ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text("${widget.data.description}"),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Created at : ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(DateFormat('dd-MM-yyyy').format(widget.data.createDate/*.toDate()*/).toString()),
                    ],
                  ),
                  Text(
                    "${widget.data.id}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Due time : ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      // Text(DateFormat('dd-MM-yyyy').format(widget.data.dueDate.toDate()).toString()),
                      // Text(widget.data.dueDate.toString()),
                      ReversedTimer(
                        durationString: widget.data.dueDate,
                        showControls: true,
                        documentKey: widget.data.id,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Status : ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(widget.data.done == false ? "Pending" : "Done"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
