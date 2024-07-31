import 'package:flutter/material.dart';
import 'package:toast_plus/toast_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ToastPlus Demo'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              ToastPlus.show(
                context,
                message: 'السلام عليكم',
                position: ToastPosition.right,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                textColor: Colors.white,
                fontSize: 16.0,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                margin: EdgeInsets.all(16.0),
                borderRadius: BorderRadius.circular(8.0),
                duration: Duration(seconds: 5),
                delay: Duration(seconds: 1),
                isRTL: true,
                noClickOutside: false,
                isPopup: true,
                endTimeWidget: Text('Ends in: 5s'),
                icon: Icon(Icons.info, color: Colors.white),
                actionButton: TextButton(
                  onPressed: () {},
                  child: Text('Action', style: TextStyle(color: Colors.white)),
                ),
              );
            },
            child: Text('Show Toast'),
          ),
        ),
      ),
    );
  }
}
