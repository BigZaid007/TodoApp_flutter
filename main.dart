import 'package:flutter/material.dart';

import 'TodoScreen.dart';

void main() {

  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
        home: TodoScreen()
    );
  }
}
