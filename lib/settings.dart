import 'package:flutter/material.dart';
import 'globals.dart'; // Import the globals file

class Settings extends StatelessWidget {
  Settings({super.key});
  final TextEditingController _controller = TextEditingController();

  void _changeIP() {
    Globals.ipAddress = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Belongings Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Backend IP and Port',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changeIP,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
