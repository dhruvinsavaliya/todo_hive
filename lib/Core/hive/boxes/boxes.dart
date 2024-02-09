import 'package:todo_hive/Core/Constants/hive_string.dart';
import 'package:todo_hive/Core/Models/task_model.dart';
import 'package:hive/hive.dart';

class Boxes {

  static Box<Task> taskDetails() => Hive.box<Task>(HiveString.taskDetails);
  // static Box taskDetails() => Hive.box(HiveString.taskDetails);

}