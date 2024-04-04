import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rental_django_frontend/globals.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  int? _selectedWhatId;
  int? _selectedToWhoId;
  final TextEditingController _controller = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Update & Delete Data',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
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
                            child: Text(item['name'].toString()),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Friend Name',
                          border: OutlineInputBorder(),
                        ),
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
                            child: Text(item['name'].toString()),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Updated Data',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendUpdateRequest,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text('Update'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendUpdateRequest,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendUpdateRequest() {
    // Get the selected friend ID
    int? selectedFriendId = _selectedToWhoId;

    // Get the friend's name from the text field
    String friendName = _controller.text;

    // Create the update request payload
    Map<String, dynamic> payload = {
      'friend_id': selectedFriendId,
      'friend_name': friendName,
    };

    // Convert the payload to JSON
    String jsonPayload = jsonEncode(payload);

    // Send the update request
    String url = 'http://${Globals.ipAddress}/api/v1/friends/';
    http.put(Uri.parse(url), body: jsonPayload).then((response) {
      if (response.statusCode == 200) {
        // Update successful
        print('Update successful');
      } else {
        // Update failed
        print('Update failed');
      }
    }).catchError((error) {
      // Error occurred during update
      print('Error occurred during update: $error');
    });
  }
}
