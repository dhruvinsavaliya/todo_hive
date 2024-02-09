import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_hive/Core/Constants/colors.dart';
import 'package:todo_hive/Core/controller/task_controller.dart';
import 'package:todo_hive/view/custom_widgets/custom_buttons.dart';
import 'package:todo_hive/view/custom_widgets/custom_snackbars.dart';
import 'package:todo_hive/view/custom_widgets/custom_textfield.dart';

class AddEditTaskScreen extends StatefulWidget {
  bool isEdit;
  var taskData;
  int? index;
  AddEditTaskScreen({Key? key, this.isEdit = false, this.taskData, this.index})
      : super(key: key);

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final taskController = Get.find<TaskController>();
  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      titleController.text = widget.taskData.title;
      descriptionController.text = widget.taskData.description;
      taskController.selectedDueDate.value = widget.taskData.dueDate;
    } else {
      taskController.selectedMinutes.value = 05;
      taskController.selectedSeconds.value = 00;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close),
              color: Colors.black)
        ],
        title: Text(
          widget.isEdit == true ? 'Edit Task Screen' : 'Add Task Screen',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/add.png',
                  height: 80,
                ),
              ),
              CustomTextField(
                prefixIcon: const Icon(
                  Icons.title,
                  color: kPrimaryColor,
                ),
                controller: titleController,
                hintText: 'Title',
              ),
              const SizedBox(height: 15),
              CustomTextField(
                prefixIcon: const Icon(
                  Icons.description,
                  color: kPrimaryColor,
                ),
                controller: descriptionController,
                hintText: 'Description...',
              ),
              const SizedBox(height: 20),
              const Text("Task Time"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Minutes:'),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        value: taskController.selectedMinutes.value,
                        onChanged: (int? value) {
                          setState(() {
                            taskController.selectedMinutes.value = value!;
                          });
                        },
                        items: List.generate(6, (index) => index)
                            .map((int value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Seconds:'),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        value: taskController.selectedSeconds.value,
                        onChanged: (int? value) {
                          setState(() {
                            taskController.selectedSeconds.value = value!;
                          });
                        },
                        items: List.generate(61, (index) => index)
                            .map((int value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MyButtonLong(
                  name: widget.isEdit == true ? "Edit Task" : 'Add Task',
                  onTap: () {
                    if (titleController.text.isEmpty) {
                      return CustomSnackBar.showError('Please provide title');
                    }
                    widget.isEdit
                        ? taskController.editTask(widget.index,titleController.text,
                            descriptionController.text, widget.taskData.id)
                        : taskController.addTask(
                            titleController.text, descriptionController.text);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
