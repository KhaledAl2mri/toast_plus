import 'package:flutter/material.dart';
import 'package:toast_plus/toast_plus.dart'; // Import your toast_plus package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToastPlus Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToastPlus Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ToastPlus.show(
                  context,
                  message: "Success toast with custom style!",
                  type: ToastType.success,
                  textStyle: TextStyle(
                      color: Color.fromARGB(255, 98, 255, 145), fontSize: 23),
                );
              },
              child: Text('Show Success Toast'),
            ),
            ElevatedButton(
              onPressed: () {
                ToastPlus.show(
                  context,
                  message: "Danger toast with animated icon!",
                  type: ToastType.danger,
                  animatedIcon: true,
                );
              },
              child: Text('Show Danger Toast'),
            ),
            ElevatedButton(
              onPressed: () {
                ToastPlus.show(
                  context,
                  message: "Info toast at the top!",
                  type: ToastType.info,
                  position: ToastPosition.top,
                );
              },
              child: Text('Show Info Toast (Top)'),
            ),
            ElevatedButton(
              onPressed: () {
                ToastPlus.show(
                  context,
                  message: "Custom widget inside toast!",
                  type: ToastType.none,
                  customBackgroundColor: Color.fromARGB(255, 18, 16, 19),
                  borderRadius: 100.0,
                );
              },
              child: Text('Show non icon Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
