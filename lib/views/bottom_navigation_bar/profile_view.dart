import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

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
                  children: const [
                    CircleAvatar(
                      child: Icon(
                        Icons.account_circle,
                        size: 75,
                      ),
                      radius: 50,
                    ),
                    SizedBox(height: 10),
                    Text("Joe Smith",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Text("Oshawa, ON", style: TextStyle(color: Colors.grey))
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
                onTap: () {},
              ),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.blue, size: 30),
                title: const Text("Reviews"),
                onTap: () {},
              ),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.photo_camera,
                    color: Colors.blue, size: 30),
                title: const Text("Photos"),
                onTap: () {},
              ),
              const Divider(thickness: 1)
            ],
          ),
        )
      ],
    );
  }
}
