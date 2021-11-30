import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'views/bottom_navigation_bar/hills_list_view.dart';
import 'views/bottom_navigation_bar/hills_map_view.dart';
import 'views/bottom_navigation_bar/profile_view.dart';
import 'views/login_page/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  bool _loggedIn = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      print("Connected to Firebase");
      setState(() {
        _initialized = true;
        // determine if the user is logged in already
        if (FirebaseAuth.instance.currentUser != null) {
          _loggedIn = true;
        }
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return MaterialApp(
        title: 'TobogganApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Container(
            child: const Center(child: Text("Error connecting to Firebase")),
            color: Colors.white),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return MaterialApp(
          title: 'TobogganApp',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Container(
              child: const Center(child: CircularProgressIndicator()),
              color: Colors.white));
    }

    return MaterialApp(
      title: 'TobogganApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _loggedIn ? MyHomePage() : const LoginPage(),
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
                onPressed: () async {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
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
