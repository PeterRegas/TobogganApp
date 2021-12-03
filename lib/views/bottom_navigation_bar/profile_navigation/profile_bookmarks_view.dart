import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobogganapp/firestore_helper.dart';
import 'package:tobogganapp/model/hill.dart';

class BookmarkView extends StatefulWidget {
  const BookmarkView({Key? key}) : super(key: key);

  @override
  _BookmarkViewState createState() => _BookmarkViewState();
}

class _BookmarkViewState extends State<BookmarkView> {
  var currentUser = FirebaseAuth.instance.currentUser;
  List<Hill> bookmarkList = [];

  getBookmarkList() async {
    bookmarkList = await FirestoreHelper.getBookmarksForUser(currentUser!.uid);
  }

  @override
  void initState() {
    setState(() {
      getBookmarkList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: bookmarkList.length,
        itemBuilder: (BuildContext context, int index) {
          final userData = bookmarkList[index].name;
          return Container(
            padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
            child: Column(
              children: [
                ListTile(
                  title: Text(userData.toString()),
                  onTap: () {},
                ),
                const Divider(
                  thickness: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
