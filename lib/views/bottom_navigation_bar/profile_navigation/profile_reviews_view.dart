import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tobogganapp/firestore_helper.dart';
import 'package:tobogganapp/model/hill.dart';
import 'package:tobogganapp/model/review.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({Key? key}) : super(key: key);

  @override
  _ReviewViewState createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  var currentUser = FirebaseAuth.instance.currentUser;
  bool _loaded = false;
  //List of user reviews, retrieved from the database using FirestoreHelper.getReviewsForUser
  List<Review> reviewList = [];
  List<Hill?> hillNames = [];

  @override
  void initState() {
    getReviewList();
    super.initState();
  }

  getReviewList() async {
    var reviews = await FirestoreHelper.getReviewsForUser(currentUser!.uid);
    List<Hill?> hills = [];
    for (int i = 0; i < reviews.length; i++) {
      var newHill = await FirestoreHelper.getHillForHillId(reviews[i].hillID);
      hills.add(newHill);
    }

    setState(() {
      _loaded = true;
      reviewList = reviews;
      hillNames = hills;
      //print(hillNames[0]!.name);
    });
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
                      ListTile(
                        title: Text(
                          hillNames[index]!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle:
                            starsForRating(reviewList[index].rating.toDouble()),
                        onTap: () {},
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
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600),
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

Widget starsForRating(double rating) {
  return Row(
    children: [
      Icon(Icons.star, color: rating.round() >= 1 ? Colors.amber : Colors.grey),
      Icon(Icons.star, color: rating.round() >= 2 ? Colors.amber : Colors.grey),
      Icon(Icons.star, color: rating.round() >= 3 ? Colors.amber : Colors.grey),
      Icon(Icons.star, color: rating.round() >= 4 ? Colors.amber : Colors.grey),
      Icon(Icons.star, color: rating.round() >= 5 ? Colors.amber : Colors.grey),
    ],
  );
}
