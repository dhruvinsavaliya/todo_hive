import 'dart:developer';
import 'dart:io';
import 'package:todo_hive/Core/Constants/hive_string.dart';
import 'package:todo_hive/Core/Models/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Directory? hiveDb;

Future setHiveData() async {
  await Hive.initFlutter();

  Directory directory = await getApplicationDocumentsDirectory();
  hiveDb = Directory('${directory.path}/chosenPath');
  await Hive.initFlutter(hiveDb!.path);


  Hive.registerAdapter(TaskAdapter());


  ///OPENING BOX

  //register screen
  await Hive.openBox<Task>(HiveString.taskDetails);
  // await Hive.openBox(HiveString.taskDetails);

  log('box created -----');
  return;
}

clearBox() async {
  hiveDb!.delete(
    recursive: true,
  );
  log('-------- box cleared');
}
