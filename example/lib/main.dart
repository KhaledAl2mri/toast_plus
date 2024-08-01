import 'package:flutter/material.dart';
import 'package:toast_plus/toast_plus.dart'; // Import your toast_plus package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToastPlus Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  void _showToast(BuildContext context, ToastType type) {
    ToastPlus.show(
      context,
      message:
          "Hello im ${type.toString().split('.').last} and this must be long text to test that",
      type: type,
      duration: const Duration(seconds: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToastPlus Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showToast(context, ToastType.success),
              child: Text('Show Success Toast'),
            ),
            ElevatedButton(
              onPressed: () => _showToast(context, ToastType.danger),
              child: Text('Show Danger Toast'),
            ),
            ElevatedButton(
              onPressed: () => _showToast(context, ToastType.info),
              child: Text('Show Info Toast'),
            ),
            ElevatedButton(
              onPressed: () => _showToast(context, ToastType.warning),
              child: Text('Show Warning Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
