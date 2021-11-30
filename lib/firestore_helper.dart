import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import 'model/hill.dart';
import 'model/review.dart';

class FirestoreHelper {
  static Future<List<Review>> getReviewsForHill(String hillID) async {
    List<Review> reviews = [];

    var results = await FirebaseFirestore.instance
        .collection("reviews")
        .where("hill", isEqualTo: hillID)
        .get();

    if (results.size == 0) {
      // return empty list of reviews
      print("No reviews found for hill $hillID");
      return reviews;
    }
    // fetch resulting reviews for given hill
    for (var doc in results.docs) {
      String reviewText = doc["reviewText"];
      List<String> photos = doc["photos"];
      int rating = doc["rating"];
      String reviewerID = doc["reviewerID"];
      String reviewerName = doc["reviewerName"];

      // add review to list of reviews
      Review review =
          Review(hillID, reviewText, photos, rating, reviewerID, reviewerName);
      reviews.add(review);
    }
    return reviews;
  }

  static Future<List<Review>> getReviewsForUser(String userID) async {
    List<Review> reviews = [];

    var results = await FirebaseFirestore.instance
        .collection("reviews")
        .where("reviewerID", isEqualTo: userID)
        .get();

    if (results.size == 0) {
      // return empty list of reviews
      print("No reviews found by user $userID");
      return reviews;
    }
    // fetch resulting reviews for given hill
    for (var doc in results.docs) {
      String hillID = doc["hill"];
      String reviewText = doc["reviewText"];
      List<String> photos = doc["photos"];
      int rating = doc["rating"];
      String reviewerName = doc["reviewerName"];

      // add review to list of reviews
      Review review =
          Review(hillID, reviewText, photos, rating, userID, reviewerName);
      reviews.add(review);
    }
    return reviews;
  }

  static Future<List<Hill>> getAllHills() async {
    List<Hill> hills = [];

    var results = await FirebaseFirestore.instance.collection("hills").get();

    if (results.size == 0) {
      // return empty list of hills
      print("No hills found");
      return hills;
    }
    // fetch resulting hills
    for (var doc in results.docs) {
      String hillID = doc.id;
      String name = doc["name"];
      String featuredPhoto = doc["featuredPhoto"];
      String address = doc["address"];
      String information = doc["information"];
      GeoPoint geopoint = doc["geopoint"];
      List<Review> reviews = await FirestoreHelper.getReviewsForHill(hillID);

      // add hill to list of hills
      Hill hill = Hill(hillID, name, featuredPhoto, address, information,
          LatLng(geopoint.latitude, geopoint.longitude), reviews, []);
      hills.add(hill);
    }
    return hills;
  }

  static Future<Hill?> getHillForHillId(String hillID) async {
    var result =
        await FirebaseFirestore.instance.collection("hills").doc(hillID).get();

    // make sure the hill exists with given id
    if (!result.exists) {
      return null;
    }

    // hill exists, save data
    var doc = result.data()!;
    String name = doc["name"];
    String featuredPhoto = doc["featuredPhoto"];
    String address = doc["address"];
    String information = doc["information"];
    GeoPoint geopoint = doc["geopoint"];
    List<Review> reviews = await FirestoreHelper.getReviewsForHill(hillID);

    return Hill(hillID, name, featuredPhoto, address, information,
        LatLng(geopoint.latitude, geopoint.longitude), reviews, []);
  }

  static Future<List<Hill>> getBookmarksForUser(String userID) async {
    List<Hill> bookmarkedHills = [];

    var results = await FirebaseFirestore.instance
        .collection("user_data")
        .doc(userID)
        .get();

    if (!results.exists) {
      // return empty list of hills
      print(
          "No user_data entry found for $userID when getting their bookmarks");
      return bookmarkedHills;
    }
    // fetch bookmarks
    var bookmarks = results.data()!["bookmarks"];
    for (var hillID in bookmarks) {
      // add the bookmarked hill asuming it exists
      Hill? hill = await getHillForHillId(hillID);
      if (hill != null) {
        bookmarkedHills.add(hill);
      }
    }

    return bookmarkedHills;
  }

  static Future<void> addHill(Hill hill) async {
    CollectionReference hills = FirebaseFirestore.instance.collection('hills');
    await hills.add({
      "name": hill.name,
      "featuredPhoto": hill.featuredPhoto,
      "address": hill.address,
      "information": hill.information,
      "geopoint": GeoPoint(hill.geopoint.latitude, hill.geopoint.longitude),
    });
  }

  static Future<void> addReview(Review review) async {
    CollectionReference reviews =
        FirebaseFirestore.instance.collection('reviews');
    await reviews.add({
      "hill": review.hillID,
      "reviewText": review.reviewText,
      "photos": review.photos,
      "rating": review.rating,
      "reviewerID": review.reviewerID,
      "reviewerName": review.reviewerName
    });
  }
}
