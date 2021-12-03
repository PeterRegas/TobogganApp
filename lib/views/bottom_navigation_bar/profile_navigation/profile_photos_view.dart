import 'package:flutter/material.dart';
import 'package:tobogganapp/firestore_helper.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({Key? key}) : super(key: key);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  List<String> photoList = [
    "https://images.unsplash.com/photo-1545325343-33b85a319d90?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1470&q=80",
    "https://images.unsplash.com/photo-1545325343-33b85a319d90?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1470&q=80",
    "https://images.unsplash.com/photo-1545325343-33b85a319d90?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1470&q=80",
    "https://images.unsplash.com/photo-1545325343-33b85a319d90?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1470&q=80"
  ];

/*
getPhotoList() async {
    bookmarkList = await FirestoreHelper.getPhotosForUser(currentUser!.uid);
  }

  @override
  void initState() {
    setState(() {
      getPhotoList();
    });
    super.initState();
  }
*/
//Plans to potentially have another widget that allows for zoomed viewing of a selected photo (if future developments allow for it)
//"Sample Text" and placeholder photos will be replaced with actual photolinks from a database.
//-Justin
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photos"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: photoList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    child: const Text("Sample Text")),
                Image.network(photoList[index]),
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
