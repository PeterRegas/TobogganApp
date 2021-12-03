import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobogganapp/firestore_helper.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({Key? key}) : super(key: key);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  bool _loaded = false;
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
      _loaded = true;
      _userPhotos = photos;
    });
  }

//Photos are grabbed from the from the database that correspond to the user
//
//-Justin
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photos"),
        backgroundColor: Colors.blue,
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _userPhotos.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                              "Photo taken from:\n ${_userPhotos[index].keys.first}",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic))),
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
