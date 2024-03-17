import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BelongingsPage extends StatefulWidget {
  const BelongingsPage({super.key});

  @override
  _BelongingsPageState createState() => _BelongingsPageState();
}

class _BelongingsPageState extends State<BelongingsPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendPostRequest() async {
    const String url = 'http://192.168.1.9:8080/api/v1/belongings/';
    final String name = _controller.text;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'name': name},
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
      } else {
        throw Exception('Failed to send POST request');
      }
    } catch (e) {
      print('Error: $e');
    }
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
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPostRequest,
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
