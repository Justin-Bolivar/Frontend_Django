import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rental_django_frontend/globals.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendPostRequest() async {
    String url = 'http://${Globals.ipAddress}/api/v1/friends/';
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
      backgroundColor: const Color(0xFF332d41),
      appBar: AppBar(
        title: const Text(
          'Friends Form',
          style: TextStyle(color: Color(0xFFd2c0ff)),
        ),
        backgroundColor: const Color(0xFF332d41),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Color(0xFFd2c0ff)),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF1e192b),
                  labelText: 'Friends Name',
                  labelStyle: TextStyle(color: Color(0xFFd2c0ff)),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPostRequest,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFFd2c0ff),
                backgroundColor: const Color(0xFF4f378a),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
