import 'package:flutter/material.dart';
import 'package:health_note/db/db_helper.dart';
import 'package:health_note/providers/exercise_provider.dart';
import 'package:health_note/providers/group_exercise_provider.dart';
import 'package:health_note/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'providers/main_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().database;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MainProvider()),
      ChangeNotifierProvider(create: (_) => GroupExerciseProvider()),
      ChangeNotifierProvider(create: (_) => ExerciseProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: MainScreen(),
    );
  }
}
