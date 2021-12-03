import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobogganapp/firestore_helper.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({Key? key}) : super(key: key);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  // List of user photos, map of hillname to image
  List<Map<String, Image>> _userPhotos = [];

  @override
  void initState() {
    fetchUserPhotos();
    super.initState();
  }

  void fetchUserPhotos() async {
    // fetch the photos for the current user
    var photos = await FirestoreHelper.getPhotosForUser(
        FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      _userPhotos = photos;
    });
  }

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
        itemCount: _userPhotos.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    child: Text(_userPhotos[index].keys.first)),
                _userPhotos[index][_userPhotos[index].keys.first]!,
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
