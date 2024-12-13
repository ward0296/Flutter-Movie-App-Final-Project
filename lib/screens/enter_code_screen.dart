import 'package:flutter/material.dart';
import '../helpers/http_helper.dart';
import 'movie_selection_screen.dart';

class EnterCodeScreen extends StatefulWidget {
  final String deviceId;

  const EnterCodeScreen({required this.deviceId, Key? key}) : super(key: key);

  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorMessage; // To display error messages when session joining fails

  Future<void> _joinSession() async {
    setState(() {
      _errorMessage = null; // Clear any previous error messages
    });

    try {
      //this will parse the entered code as an integer
      final code = int.parse(_codeController.text);
      final response = await HttpHelper.joinSession(widget.deviceId, code);

      if (response['session_id'] != null) {
        // this will navigate to the Movie Selection Screen if session ID is returned
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieSelectionScreen(
              sessionId: response['session_id'],
              deviceId: widget.deviceId,
            ),
          ),
        );
      }
    } catch (error) {
      debugPrint('Error joining session: $error');
      setState(() {
        _errorMessage = 'Invalid code or unable to join session.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Code')), //app bar title
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                labelText: 'Enter Session Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _joinSession,
              child: const Text('Join Session'),
            ),
          ],
        ),
      ),
    );
  }
}
