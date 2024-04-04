import 'package:flutter/material.dart';
import 'package:rental_django_frontend/rental_belongings.dart';
import 'package:rental_django_frontend/rental_borrowings.dart';
import 'package:rental_django_frontend/rental_friends.dart';
import 'package:rental_django_frontend/settings.dart';
import 'package:rental_django_frontend/update_delete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const FriendsPage(),
    const BelongingsPage(),
    const BorrowingPage(),
    const UpdatePage(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: const Color(0xFF332d41),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF332d41),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Belongings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.move_to_inbox),
              label: 'Borrowings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFd2c0ff),
          unselectedItemColor: const Color(0xFF1e192b),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
