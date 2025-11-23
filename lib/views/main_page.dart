import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'home_view.dart';
import 'my_absen_view.dart';
import 'my_profil_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const Color greenColor = Color(0xFF4CAF50); // Green color
  static const Color whiteColor = Colors.white;

  static final List<Widget> _widgetOptions = <Widget>[
    Container(color: whiteColor, child: const HomeView(title: 'DHE')), // Reuse existing HomeView
    Container(color: whiteColor, child: const MyAbsenView()),
    Container(color: whiteColor, child: const MyProfilView()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handler for logout button
  void _handleLogout() {
    // Add logout logic here, e.g. Navigator.pushReplacement to login screen
    // For now, just print to console
    print('Logout tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          'DHE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: _selectedIndex == 2
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _handleLogout,
                  tooltip: 'Logout',
                  color: Colors.green,
                )
              ]
            : null,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: whiteColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: greenColor,
        unselectedItemColor: Colors.grey,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            selectedColor: greenColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.calendar_today),
            title: const Text('My Absen'),
            selectedColor: greenColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('My Profil'),
            selectedColor: greenColor,
          ),
        ],
      ),
    );
  }
}
