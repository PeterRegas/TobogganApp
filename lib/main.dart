import 'package:flutter/material.dart';

import 'views/bottom_navigation_bar/hills_list_view.dart';
import 'views/bottom_navigation_bar/hills_map_view.dart';
import 'views/bottom_navigation_bar/profile_view.dart';
import 'views/login_page/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _navigationBarViews = [
    const HillsMapView(),
    const HillsListView(),
    const ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TobogganApp'), actions: [
        _currentIndex < 2
            ? IconButton(onPressed: () {}, icon: const Icon(Icons.add))
            : TextButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child:
                    const Text("Logout", style: TextStyle(color: Colors.white)))
      ]),
      body: _navigationBarViews[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile")
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // hide the bottom sheet if it is showing
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        },
      ),
    );
  }
}
