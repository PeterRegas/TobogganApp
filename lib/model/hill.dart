import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
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

    return sum / reviews.length;
  }

  List<Image> get photos {
    List<Image> photos = [];
    // fetches allthe photos from all reviews
    for (Review review in reviews) {
      photos.addAll(review.photos);
    }
    return photos;
  }

  Hill(this.hillID, this.name, this.featuredPhoto, this.address,
      this.information, this.geopoint, this.reviews);
}
