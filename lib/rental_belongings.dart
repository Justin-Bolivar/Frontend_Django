import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rental_django_frontend/globals.dart';

class BelongingsPage extends StatefulWidget {
  const BelongingsPage({super.key});

  @override
  _BelongingsPageState createState() => _BelongingsPageState();
}

class _BelongingsPageState extends State<BelongingsPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendPostRequest() async {
    String url = 'http://${Globals.ipAddress}/api/v1/belongings/';
    final String name = _controller.text;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'name': name},
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Item Name Succesfully Sent!',
              style: TextStyle(color: Color(0xFFd2c0ff)),
            ),
            backgroundColor: Color(0xFF4f378a),
          ),
        );
        _controller.clear();
      } else {
        throw Exception('Failed to send POST request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request failed: $e'),
          backgroundColor: const Color(0xFF7D5260),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF332d41),
      appBar: AppBar(
        title: const Text(
          'Belongings Form',
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
                  labelText: 'Item Name',
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
