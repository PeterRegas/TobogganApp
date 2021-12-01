import 'package:flutter/material.dart';

class Review {
  String hillID;
  String reviewText;
  List<Image> photos;
  int rating;
  String reviewerID;
  String reviewerName;

  Review(this.hillID, this.reviewText, this.photos, this.rating,
      this.reviewerID, this.reviewerName);
}
