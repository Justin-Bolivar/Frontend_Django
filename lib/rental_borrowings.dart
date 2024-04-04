import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rental_django_frontend/globals.dart';

class BorrowingPage extends StatefulWidget {
  const BorrowingPage({super.key});

  @override
  _BorrowingPageState createState() => _BorrowingPageState();
}

class _BorrowingPageState extends State<BorrowingPage> {
  int? _selectedWhatId;
  int? _selectedToWhoId;
  DateTime? _returnedDate;

  Future<List<Map<String, dynamic>>> fetchItems() async {
    String url = 'http://${Globals.ipAddress}/api/v1/belongings/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> items = [];
      for (var item in data) {
        items.add({'id': item['id'], 'name': item['name']});
      }
      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<Map<String, dynamic>>> fetchFriends() async {
    String url = 'http://${Globals.ipAddress}/api/v1/friends/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> friends = [];
      for (var item in data) {
        friends.add({'id': item['id'], 'name': item['name']});
      }
      return friends;
    } else {
      throw Exception('Failed to load friends');
    }
  }

  void _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime?) onDateSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(pickedDate),
      );

      if (pickedTime != null) {
        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDateSelected(selectedDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF332d41),
        appBar: AppBar(
          title: const Text(
            'Borrowed Form',
            style: TextStyle(color: Color(0xFFd2c0ff)),
          ),
          backgroundColor: const Color(0xFF332d41),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchFriends(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<int>(
                        value: _selectedToWhoId,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedToWhoId = newValue;
                          });
                        },
                        items: snapshot.data!.map<DropdownMenuItem<int>>(
                            (Map<String, dynamic> item) {
                          return DropdownMenuItem<int>(
                            value: item['id'],
                            child: Text(
                              item['name'].toString(),
                              style: const TextStyle(color: Color(0xFFd2c0ff)),
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF1e192b),
                          labelText: 'Friends Name',
                          labelStyle: TextStyle(color: Color(0xFFd2c0ff)),
                          border: OutlineInputBorder(),
                        ),
                        dropdownColor: const Color(0xFF1e192b),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 30),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<int>(
                        value: _selectedWhatId,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedWhatId = newValue;
                          });
                        },
                        items: snapshot.data!.map<DropdownMenuItem<int>>(
                            (Map<String, dynamic> item) {
                          return DropdownMenuItem<int>(
                            value: item['id'],
                            child: Text(
                              item['name'].toString(),
                              style: const TextStyle(color: Color(0xFFd2c0ff)),
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF1e192b),
                          labelText: 'Item Name',
                          labelStyle: TextStyle(color: Color(0xFFd2c0ff)),
                          border: OutlineInputBorder(),
                        ),
                        dropdownColor: const Color(0xFF1e192b),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () =>
                    _selectDate(context, _returnedDate, (DateTime? date) {
                  setState(() {
                    _returnedDate = date;
                  });
                }),
                child: AbsorbPointer(
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      style: const TextStyle(color: Color(0xFFd2c0ff)),
                      controller: TextEditingController(
                          text: _returnedDate != null
                              ? DateFormat('yyyy-MM-ddTHH:mm:ss')
                                  .format(_returnedDate!)
                              : ''),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF1e192b),
                        labelText: 'Return Date & Time',
                        labelStyle: TextStyle(color: Color(0xFFd2c0ff)),
                        border: OutlineInputBorder(),
                      ),
                    ),
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
      ),
    );
  }

  Future<void> _sendPostRequest() async {
    String url = 'http://${Globals.ipAddress}/api/v1/borrowings/';
    final int whatId = _selectedWhatId ?? 0;
    final int toWhoId = _selectedToWhoId ?? 0;

    final String? returned = _returnedDate != null
        ? _returnedDate!.toUtc().toIso8601String().split('.')[0] + 'Z'
        : null;

    final String body = jsonEncode({
      'what': whatId,
      'to_who': toWhoId,
      'returned': returned,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        }, // Ensure the Content-Type is set
        body: body,
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to send POST request');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
