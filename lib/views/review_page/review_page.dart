// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  List<XFile>? imageUrl = [];

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
                    var images = await picker.pickMultiImage();
                    setState(() {
                      imageUrl = images;
                    });
                  },
                  child: Text('Add Photo', style: TextStyle(fontSize: 20))),
              ElevatedButton(
                onPressed: () async {
                  await FirestoreHelper.addReview(
                    widget.hillObject!.hillID,
                    _reviewTextController.text,
                    imageUrl!,
                    _rating,
                    userID,
                    await FirestoreHelper.getNameForUserId(userID),
                  );

                  final snackBar = SnackBar(content: Text('Review Added'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              children: imageUrl!.map((XFile file) {
                return Image.file(File(file.path));
              }).toList(),
            ),
            SizedBox(
              height: 80,
            ),
          ],
        )));
  }
}
