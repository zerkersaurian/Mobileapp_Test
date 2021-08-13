import 'package:flutter/material.dart';
import 'class/LastTime.dart';
import 'myPage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LastTimeAdapter());
  await Hive.openBox<LastTime>('data');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LastTime Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Mylist(),
    );
  }
}
