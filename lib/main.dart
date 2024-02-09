import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todo_hive/Core/Constants/colors.dart';
import 'package:todo_hive/Core/hive/data/hive_data_store.dart';
import 'package:todo_hive/Core/controller/login_controller.dart';
import 'package:todo_hive/Core/controller/signup_controller.dart';
 import 'package:todo_hive/Core/controller/task_controller.dart';
 import 'package:todo_hive/view/Screens/Authentication/login_screen.dart';
import 'package:todo_hive/view/Screens/task_screens/tasks_screen.dart';
import 'package:todo_hive/view/Screens/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
 import 'Core/services/local_notification.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


int? initScreen;
SharedPreferences? prefs;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setHiveData();

  tz.initializeTimeZones();
  await requestNotificationPermission();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);


  Get.put(LoginController());
  Get.put(SignUpController());
  Get.put(TaskController());
  prefs = await SharedPreferences.getInstance();
  initScreen = (prefs?.getInt("initScreen"));
  prefs?.setInt("initScreen", 1);
  LocalNotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
  return GetMaterialApp(
    title: 'ToDo app',
    theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'MyFont',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
            centerTitle: true, foregroundColor: kWhite, toolbarHeight: 70),
        scaffoldBackgroundColor: kBGColor),
    initialRoute: initScreen == 0 || initScreen == null ? "/" : "home",
    routes: {
      '/': (context) => const MyIntroductionScreen(),
      'home': (context) => const SplashScreen()/*FirebaseAuth.instance.currentUser == null
          ? const LoginScreen()
          : const TasksScreen()*/
    },
    debugShowCheckedModeBanner: false,
  );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
   Future.delayed(const Duration(seconds: 3),
         () {
     return   FirebaseAuth.instance.currentUser == null
         ? Get.off(()=>const LoginScreen())
         : Get.off(()=>const TasksScreen());
         });

  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}


