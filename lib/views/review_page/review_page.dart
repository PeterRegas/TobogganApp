// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tobogganapp/views/bottom_navigation_bar/hill_details.dart';
import '/firestore_helper.dart';
import '/model/hill.dart';
import 'dart:io';

class ReviewPage extends StatelessWidget {
  Hill? hillObject;

  ReviewPage({Key? key, this.hillObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
      ),
      body: Review(hillObject: hillObject),
    );
  }
}

class Review extends StatefulWidget {
  Hill? hillObject;
  Review({Key? key, this.hillObject}) : super(key: key);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final TextEditingController _reviewTextController = TextEditingController();
  int _rating = -1;
  String userID = FirebaseAuth.instance.currentUser!.uid;
  ImagePicker picker = ImagePicker();
  List<XFile> imageUrl = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(widget.hillObject!.name,
                  style: Theme.of(context).textTheme.headline6),
              subtitle: Text(
                  widget.hillObject!.geopoint.latitude.toString() +
                      ', ' +
                      widget.hillObject!.geopoint.longitude.toString(),
                  style: Theme.of(context).textTheme.subtitle1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Rating'),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 1 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      if (_rating == 1) {
                        _rating -= 1;
                      } else {
                        _rating = 1;
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 2 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 3 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 3;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 4 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 4;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 5 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 5;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _reviewTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Add a written review',
                fillColor: Colors.grey,
                focusColor: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      var images = await picker.pickMultiImage();
                      setState(() {
                        // empty list if user opened picker but never selected any images
                        imageUrl = images ?? [];
                      });
                    } else {
                      // remove photos if user wanted to
                      bool removePhotos = await _showRemovePhotosDialog();
                      if (removePhotos) {
                        setState(() {
                          imageUrl = [];
                        });
                      }
                    }
                  },
                  child: Text(imageUrl.isEmpty ? 'Add Photos' : "Remove Photos",
                      style: TextStyle(fontSize: 20))),
              ElevatedButton(
                onPressed: () async {
                  await FirestoreHelper.addReview(
                    widget.hillObject!.hillID,
                    _reviewTextController.text,
                    imageUrl,
                    _rating,
                    userID,
                    await FirestoreHelper.getNameForUserId(userID),
                  );

                  final snackBar = SnackBar(content: Text('Review Added'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // pop current review page and show
                  var hillWithUpdatedDetails =
                      (await FirestoreHelper.getHillForHillId(
                          widget.hillObject!.hillID))!;
                  // pop to hill page
                  Navigator.of(context).pop();
                  // pop to map (or list) page
                  Navigator.of(context).pop();
                  // show hill detail again
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Hilldetails(hillWithUpdatedDetails);
                  }));
                },
                child: Text('Submit Review', style: TextStyle(fontSize: 20)),
              )
            ]),
            SizedBox(
              height: 10,
            ),
            GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1),
              children: imageUrl.map((XFile file) {
                return Image.file(File(file.path));
              }).toList(),
            ),
            SizedBox(
              height: 80,
            ),
          ],
        )));
  }

  Future<bool> _showRemovePhotosDialog() async {
    bool removePhotos = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove added photos?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Would you like to remove all photos added to this review?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Remove photos'),
              onPressed: () {
                Navigator.of(context).pop();
                removePhotos = true;
              },
            ),
            TextButton(
              child: const Text('No, keep photos'),
              onPressed: () {
                Navigator.of(context).pop();
                removePhotos = false;
              },
            ),
          ],
        );
      },
    );
    // whether user wants to remove photos
    return removePhotos;
  }
}
