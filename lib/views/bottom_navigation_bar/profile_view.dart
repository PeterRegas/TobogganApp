import 'package:flutter/material.dart';

import 'profile_navigation/profile_bookmarks_view.dart';
import 'profile_navigation/profile_photos_view.dart';
import 'profile_navigation/profile_reviews_view.dart';

class ProfileView extends StatefulWidget {
  final String _name;
  final int _numOfReviews;
  final int _numOfPhotos;

  const ProfileView(this._name, this._numOfReviews, this._numOfPhotos,
      {Key? key})
      : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
                    Text(widget._name,
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
            Text("${widget._numOfReviews} reviews",
                style: const TextStyle(fontSize: 16)),
            SizedBox(
                child: Container(
                  child: Text("|", style: TextStyle(color: Colors.grey[600])),
                  alignment: Alignment.center,
                ),
                width: 20),
            Text("${widget._numOfPhotos} photos",
                style: const TextStyle(fontSize: 16))
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
