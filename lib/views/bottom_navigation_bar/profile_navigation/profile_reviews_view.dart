import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobogganapp/firestore_helper.dart';
import 'package:tobogganapp/model/review.dart';
import 'package:tobogganapp/views/bottom_navigation_bar/profile_navigation/profile_photos_view.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({Key? key}) : super(key: key);

  @override
  _ReviewViewState createState() => _ReviewViewState();
}

//Updated version will use

class _ReviewViewState extends State<ReviewView> {
  var currentUser = FirebaseAuth.instance.currentUser;
  bool _loaded = false;
  List<Review> reviewList = [];

  getReviewList() async {
    var reviews = await FirestoreHelper.getReviewsForUser(currentUser!.uid);
    setState(() {
      _loaded = true;
      reviewList = reviews;
    });
  }

  @override
  void initState() {
    getReviewList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
        backgroundColor: Colors.blue,
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reviewList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
                  child: Column(
                    children: [
                      reviewList[index].photos[0],
                      ListTile(
                        title: Text(reviewList[index].hillID),
                        subtitle:
                            Text("Rating: ${reviewList[index].rating}/5.0"),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        child: Text(reviewList[index].reviewText),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                        child: Text(
                          "Written by ${reviewList[index].reviewerName}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
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
