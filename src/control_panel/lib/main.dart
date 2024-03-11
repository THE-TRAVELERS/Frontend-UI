import 'package:flutter/material.dart';

import 'package:control_panel/pages/auth/view/auth.dart';

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
      home: LoginPage(),
    );
  }
}
