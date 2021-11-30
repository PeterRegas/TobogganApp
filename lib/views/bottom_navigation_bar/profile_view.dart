import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'profile_navigation/profile_bookmarks_view.dart';
import 'profile_navigation/profile_photos_view.dart';
import 'profile_navigation/profile_reviews_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _name = "not logged in...";

  @override
  void initState() {
    var currentUser = FirebaseAuth.instance.currentUser;

    // fetch the current user and update profile if they are logged in
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection("user_data")
          .doc(currentUser.uid)
          .get()
          .then((snapshot) => _name = snapshot.data()!["name"]);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 200,
                  color: Colors.blue,
                ),
                Container(
                  height: 140,
                  color: Colors.white,
                )
              ],
            ),
            Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 150),
                child: Column(
                  children: [
                    const CircleAvatar(
                      child: Icon(
                        Icons.account_circle,
                        size: 75,
                      ),
                      radius: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(_name,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    const Text("Oshawa, ON",
                        style: TextStyle(color: Colors.grey))
                  ],
                ))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("3 reviews", style: TextStyle(fontSize: 16)),
            SizedBox(
                child: Container(
                  child: Text("|", style: TextStyle(color: Colors.grey[600])),
                  alignment: Alignment.center,
                ),
                width: 20),
            const Text("4 photos", style: TextStyle(fontSize: 16))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Profile",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ListTile(
                leading: const Icon(Icons.bookmark, color: Colors.blue),
                title: const Text("Bookmarks"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const BookmarkView()));
                },
              ),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.blue, size: 30),
                title: const Text("Reviews"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReviewView()));
                },
              ),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.photo_camera,
                    color: Colors.blue, size: 30),
                title: const Text("Photos"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PhotoView()));
                },
              ),
              const Divider(thickness: 1)
            ],
          ),
        )
      ],
    );
  }
}
