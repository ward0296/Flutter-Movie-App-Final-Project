import 'package:flutter/material.dart';
import 'dart:math';
import 'movie_selection_screen.dart';

class ShareCodeScreen extends StatefulWidget {
  final String deviceId;

  const ShareCodeScreen({required this.deviceId, Key? key}) : super(key: key);

  @override
  _ShareCodeScreenState createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String? _sessionCode;
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _generateCode();
  }

  void _generateCode() {
    final random = Random();
    final code = (random.nextInt(9000) + 1000).toString();
    setState(() {
      _sessionCode = code;
      _sessionId = _sessionCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Code')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_sessionCode != null)
              Column(
                children: [
                  const Text(
                    'Your Session Code:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _sessionCode!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ElevatedButton(
              onPressed: _generateCode,
              child: const Text('Generate New Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_sessionId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieSelectionScreen(
                        sessionId: _sessionId!,
                        deviceId: widget.deviceId,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Begin Movie Night'),
            ),
          ],
        ),
      ),
    );
  }
}
