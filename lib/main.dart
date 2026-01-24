import 'package:file_observer/screens/authenticate/initialize.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const ToastificationWrapper(
    child: MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Initialize();
  }
}