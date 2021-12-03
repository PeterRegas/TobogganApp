import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'model/hill.dart';
import 'model/review.dart';

class FirestoreHelper {
  static Future<String> getNameForUserId(String userID) async {
    var result = await FirebaseFirestore.instance
        .collection("user_data")
        .doc(userID)
        .get();
    return result.data()!["name"];
  }

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
      int rating = doc["rating"];
      String reviewerID = doc["reviewerID"];
      String reviewerName = doc["reviewerName"];

      // load photos
      List<dynamic> photoPaths = doc["photos"];
      List<Image> photos = [];
      for (var photoPath in photoPaths) {
        Image? photo = await FirestoreHelper._getImageFromReference(photoPath);
        if (photo != null) {
          photos.add(photo);
        }
      }

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
      int rating = doc["rating"];
      String reviewerName = doc["reviewerName"];

      // load photos
      List<dynamic> photoPaths = doc["photos"];
      List<Image> photos = [];
      for (var photoPath in photoPaths) {
        Image? photo = await FirestoreHelper._getImageFromReference(photoPath);
        if (photo != null) {
          photos.add(photo);
        }
      }

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
      String featuredPhotoPath = doc["featuredPhoto"];
      Image featuredPhoto =
          (await FirestoreHelper._getImageFromReference(featuredPhotoPath))!;
      String address = doc["address"];
      String information = doc["information"];
      GeoPoint geopoint = doc["geopoint"];
      List<Review> reviews = await FirestoreHelper.getReviewsForHill(hillID);

      // add hill to list of hills
      Hill hill = Hill(hillID, name, featuredPhoto, address, information,
          LatLng(geopoint.latitude, geopoint.longitude), reviews);
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
    String featuredPhotoPath = doc["featuredPhoto"];
    Image featuredPhoto =
        (await FirestoreHelper._getImageFromReference(featuredPhotoPath))!;
    String address = doc["address"];
    String information = doc["information"];
    GeoPoint geopoint = doc["geopoint"];
    List<Review> reviews = await FirestoreHelper.getReviewsForHill(hillID);

    return Hill(hillID, name, featuredPhoto, address, information,
        LatLng(geopoint.latitude, geopoint.longitude), reviews);
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

  static Future<void> addHill(String name, XFile featuredPhoto, String address,
      String information, GeoPoint geoPoint) async {
    CollectionReference hills = FirebaseFirestore.instance.collection('hills');

    // add new hill, featuredPhoto blank at first
    var doc = await hills.add({
      "name": name,
      "featuredPhoto": "",
      "address": address,
      "information": information,
      "geopoint": geoPoint,
    });

    // upload featured photo
    var photoPath =
        await FirestoreHelper._uploadHillFeaturedPhoto(featuredPhoto, doc.id);

    // update featured photo path for hill in database
    await hills.doc(doc.id).update({"featuredPhoto": photoPath});
  }

  static Future<void> addReview(
      String hillID,
      String reviewText,
      List<XFile> photos,
      int rating,
      String reviewerID,
      String reviewerName) async {
    CollectionReference reviews =
        FirebaseFirestore.instance.collection('reviews');

    // upload review photos
    List<String> photoPaths = [];
    for (var photo in photos) {
      var photoPath =
          await FirestoreHelper._uploadReviewPhoto(photo, hillID, reviewerID);
      // if upload was successful, save path in review
      if (photoPath != null) {
        photoPaths.add(photoPath);
      }
    }

    await reviews.add({
      "hill": hillID,
      "reviewText": reviewText,
      "photos": photoPaths,
      "rating": rating,
      "reviewerID": reviewerID,
      "reviewerName": reviewerName
    });
  }

  static Future<Image?> _getImageFromReference(String ref) async {
    String downloadURL = "";

    try {
      downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(ref)
          .getDownloadURL();
    } on FirebaseException {
      return null;
    }

    return Image.network(downloadURL);
  }

  static Future<String?> _uploadReviewPhoto(
      XFile photo, String hillID, String reviewerID) async {
    File file = File(photo.path);

    String photoName =
        "$hillID-$reviewerID-${DateTime.now().millisecondsSinceEpoch}";

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('review_photos/$photoName.png')
          .putFile(file);
      return "review_photos/$photoName.png";
    } on FirebaseException catch (e) {
      // return null if there was an error trying to upload file
      print("Error trying to upload review photo $photoName");
      return null;
    }
  }

  static Future<String?> _uploadHillFeaturedPhoto(
      XFile photo, String hillID) async {
    File file = File(photo.path);

    String photoName = hillID;

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('hill_featured_photos/$photoName.png')
          .putFile(file);
      return "hill_featured_photos/$photoName.png";
    } on FirebaseException catch (e) {
      // return null if there was an error trying to upload file
      print("Error trying to upload featured photo for hill $hillID");
      return null;
    }
  }
}
