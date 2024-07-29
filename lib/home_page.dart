import 'package:flutter/material.dart';
import 'package:learners/home_contents.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  _home_pageState createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    home_contents(),
    Text('Dashboard'),
    Text('AI help'),
    Text('Profile Page'), // Added fourth page here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.orange[700],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_customize_sharp),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mark_unread_chat_alt_outlined),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black87,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

