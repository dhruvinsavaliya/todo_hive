import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'task_model.g.dart';

@HiveType(typeId: 10)
class Task {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final bool done;
  @HiveField(3)
  final String dueDate;
  @HiveField(4)
  DateTime? createDate;
  // Timestamp? createDate;
  @HiveField(5)
  final String description;

  @HiveField(6)
  bool timerOn;

  // late Duration duration; // Represents the total duration
  // late Stopwatch stopwatch;

  Task(
      {this.title="",
      this.description="",
      this.id="",
      this.done=false,
      this.dueDate="",
      this.createDate,
      this.timerOn = false,
      });

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        title = snapshot['title'],
        done = snapshot['done'],
        dueDate = snapshot['due'],
        createDate = snapshot['create_at'],
        description = snapshot['description'],
        timerOn = snapshot['timer_on'];
}
