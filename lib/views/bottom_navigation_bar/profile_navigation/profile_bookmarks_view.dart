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
  bool _loaded = false;
  List<Hill> bookmarkList = [];

  getBookmarkList() async {
    var bookmarks = await FirestoreHelper.getBookmarksForUser(currentUser!.uid);
    setState(() {
      _loaded = true;
      bookmarkList = bookmarks;
    });
  }

  @override
  void initState() {
    getBookmarkList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        backgroundColor: Colors.blue,
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookmarkList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(bookmarkList[index].name.toString()),
                        subtitle:
                            Text(bookmarkList[index].information.toString()),
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
