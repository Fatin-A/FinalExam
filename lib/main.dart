import 'package:flutter/material.dart';

// import 'login_screen.dart';
import 'home_screen.dart';
// import 'edit_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAP Exam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const LoginScreen(),
      home: const HomeScreen(),
      // home: const EditScreen(),
    );
  }
}
