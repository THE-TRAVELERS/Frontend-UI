import 'package:control_panel/pages/auth/view/auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travelers Control Panel',
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
