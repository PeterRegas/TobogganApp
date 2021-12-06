import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tobogganapp/firestore_helper.dart';
import 'package:tobogganapp/model/non_review_photo.dart';
import 'package:tobogganapp/model/review.dart';

class Hill {
  String hillID;
  String name;
  Image featuredPhoto;
  String address;
  String information;
  LatLng geopoint;
  List<Review> reviews;

  double get rating {
    double sum = 0.0;
    // computed from the average of all rating
    for (Review review in reviews) {
      sum = sum + review.rating;
    }

    return reviews.length > 1 ? sum / reviews.length : 0.0;
  }

  Future<List<Image>> get photos async {
    List<Image> photos = [];
    // fetches all the photos from all reviews
    for (Review review in reviews) {
      photos.addAll(review.photos);
    }
    // fetch all the non-review photos
    var nonReviewPhotos =
        await FirestoreHelper.getNonReviewPhotosForHill(hillID);
    for (NonReviewPhoto nonReviewPhoto in nonReviewPhotos) {
      photos.addAll(nonReviewPhoto.photos);
    }
    return photos;
  }

  Hill(this.hillID, this.name, this.featuredPhoto, this.address,
      this.information, this.geopoint, this.reviews);

  double distanceFrom(LatLng location) {
    var distanceInMeters = Geolocator.distanceBetween(geopoint.latitude,
        geopoint.longitude, location.latitude, location.longitude);
    // conver to km and return
    return double.parse((distanceInMeters / 1000).toStringAsFixed(1));
  }
}
