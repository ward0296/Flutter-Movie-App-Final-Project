import 'package:flutter/material.dart';
import 'share_code_screen.dart';
import 'enter_code_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this is the welcome screen, it has two buttons, one to get a code to share and one to enter a code
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Night')),
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ShareCodeScreen(deviceId: 'device_id')),
                );
              },
              child: const Text('Get a Code to Share'), // Get a Code to Share
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const EnterCodeScreen(deviceId: 'device_id')),
                );
              },
              child: const Text('Enter a Code'),
            ),
          ],
        ),
      ),
    );
  }
}
